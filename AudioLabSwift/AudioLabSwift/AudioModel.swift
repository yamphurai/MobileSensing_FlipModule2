//  Created by Eric Larson
//  Copyright © 2020 Eric Larson. All rights reserved.


import Foundation
import Accelerate   // provides functions for digital signal processing and linear algebra operations


// Handle core audio processing by capturing audio data from mic, process to obtain time-domain & FFT data, and provide visualization of data
class AudioModel {
    
    // MARK: Properties
    private var BUFFER_SIZE:Int  //store size of audio buffer
    
    
    // these properties are for interfaceing with the API the user can access these arrays at any time and plot them if they like
    var timeData:[Float]      // array to store time-domain audio samples
    var fftData:[Float]       // array to store computed FFT data
    
    // property "samplingRate" to get audio sampling rate from the audioManager
    lazy var samplingRate:Int = {
        return Int(self.audioManager!.samplingRate)
    }()
    
    
    // Variables to keep track of audio playback state
    private var isPlaying: Bool = false
    private var isPaused: Bool = false
    
    // MARK: Public Methods
    
    // Initialize AudioModel with buffer size
    init(buffer_size:Int) {
        BUFFER_SIZE = buffer_size  // set the buffer size property
        timeData = Array.init(repeating: 0.0, count: BUFFER_SIZE)   // timeData array to store time-domain data (as many as buffer size and initially 0)
        fftData = Array.init(repeating: 0.0, count: BUFFER_SIZE/2)  // fftData array to store fft data (as many as 1/2 buffer size and initially 0)
    }
    
    // Method to start processing audio from microphone at certain fps
    func startMicrophoneProcessing(withFps:Double){
        
        // setup the microphone to copy to circualr buffer
        // if audioManager is available
        if let manager = self.audioManager{
            manager.inputBlock = self.handleMicrophone  //set inputBlock of audioManager to "handleMicrophone" method
            
            // timer to call "runEveryInterval" method at specified fps (interval = 1/fps)
            Timer.scheduledTimer(withTimeInterval: 1.0/withFps, repeats: true) { _ in
                self.runEveryInterval()
            }
        }
    }
    
    
    // If audioManager is available, call play method on audioManager to start audio playback and procesing
    func play(){
        
        // if audio is already playing, stop playback again
        if let manager = self.audioManager, !isPlaying{
            manager.play()
            isPlaying = true
            isPaused = false
        }
    }
    
    // pause the audio playback if playing and is not paused
    func pause(){
        if isPlaying && !isPaused {
            audioManager?.pause()
            isPaused = true   // set this property as paused
        }
    }
    
    // stop audio processing and release resources if playing
    func stop(){
        if isPlaying {
            stopMicrophoneProcessing()
            isPlaying = false
            isPaused = false
        }
    }

    
    //==========================================
    // MARK: Private Properties
    
    // property "audioManager" with instance of Novacaine
    private lazy var audioManager:Novocaine? = {
        return Novocaine.audioManager()
    }()
    
    // property "fftHelper" with instance of "FFTHelper" initialized with FFT size = buffer size
    private lazy var fftHelper:FFTHelper? = {
        return FFTHelper.init(fftSize: Int32(BUFFER_SIZE))
    }()
    
    // property "inputBuffer" with instance of CircularBuffer initalized with # of channels & buffer size
    private lazy var inputBuffer:CircularBuffer? = {
        return CircularBuffer.init(numChannels: Int64(self.audioManager!.numInputChannels),
                                   andBufferSize: Int64(BUFFER_SIZE))
    }()
    
    // property to stop audio processing
    private func stopMicrophoneProcessing() {
        inputBuffer = nil   // stop audio processing and release the buffer
    }
    
    
    //==========================================
    // MARK: Model Callback Methods
    
    // Method "runEveryInterval" that runs perdiodically to update audio data (timeData & fftData)
    private func runEveryInterval(){
        
        // if inputBuffer is available
        if inputBuffer != nil {
            
            // copy the latest audio samples into timeData array
            self.inputBuffer!.fetchFreshData(&timeData, withNumSamples: Int64(BUFFER_SIZE))
            
            // copy the latest computed fft data into fftData array
            fftHelper!.performForwardFFT(withData: &timeData, andCopydBMagnitudeToBuffer: &fftData)
        }
    }
    
    //==========================================
    // MARK: Audiocard Callbacks
    // Method "handleMicrophone" to handle microphone input
    private func handleMicrophone (data:Optional<UnsafeMutablePointer<Float>>, numFrames:UInt32, numChannels: UInt32) {
        self.inputBuffer?.addNewFloatData(data, withNumSamples: Int64(numFrames))  // copy samples from the microphone into circular buffer
    }
}
