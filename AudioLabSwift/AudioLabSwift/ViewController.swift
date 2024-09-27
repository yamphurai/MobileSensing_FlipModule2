//  Created by Eric Larson
//  Copyright © 2020 Eric Larson. All rights reserved.
//  Team 9: Arman Kamal, Cliff Wallace, Jeevan Rai
//  Setup audio model, process audio data from the microphone, perform FFT, and visualize initial audio & FFT data using Metal graphics


import UIKit
import Metal  //for high-performance graphics rendering and computation


// MARK: Class ViewController
class ViewController: UIViewController {

    // Outlet "userView"
    @IBOutlet weak var userView: UIView!
    
    // Structure "AudioConstants" to store buffer size of 4096 in constant "AUDIO_BUFFER_SIZE" for audio processing
    struct AudioConstants{
        static let AUDIO_BUFFER_SIZE = 1024*4
    }
    
    // Instance o AudioModel with buffer size of 4096
    let audio = AudioModel(buffer_size: AudioConstants.AUDIO_BUFFER_SIZE)
    
    // Instantiate property "graph" to return graph(s)
    lazy var graph:MetalGraph? = {
        return MetalGraph(userView: self.userView)
    }()
    
    
    // Call this method after view controller has laoded its view heirarchy into the memory
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // if graph property is not nil,
        if let graph = self.graph{
            
            graph.setBackgroundColor(r: 0, g: 0, b: 0, a: 1)  //set the background color of the graph to black with opacity of 1
            
            // add in graphs for display
            // note that we need to normalize the scale of this graph because the fft is returned in dB which has very large negative values
            // and some large positive values
            
            // Add graph "fft" to display FFT data (1/2 of buffer size) which is normalized for better visualization
            graph.addGraph(withName: "fft",
                            shouldNormalizeForFFT: true,
                            numPointsInGraph: AudioConstants.AUDIO_BUFFER_SIZE/2)
            
            // Add graph "time" to display time domain audio data (points as many as buffer size)
            graph.addGraph(withName: "time",
                numPointsInGraph: AudioConstants.AUDIO_BUFFER_SIZE)

            graph.makeGrids() // add grids to graph
        }
        
        audio.startMicrophoneProcessing(withFps: 20)  // Start audio processing from microphone at 20 Fps rate
        audio.play()    // start playing audio
        
        // Timer that fires every 0.05s to update the graph(s) periodically
        Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { _ in
            self.updateGraph()
        }
    }
    
    // MARK: method "updateGraph"
    func updateGraph(){
        
        // if graph property is not nil, update "fft" graph with latest FFT data from audio model
        if let graph = self.graph{
            graph.updateGraph(
                data: self.audio.fftData,
                forKey: "fft"
            )
            
            // if graph property is not nil, update "time" graph with latest time-domain data from audio model
            graph.updateGraph(
                data: self.audio.timeData,
                forKey: "time"
            )

        }
        
    }
    
}

