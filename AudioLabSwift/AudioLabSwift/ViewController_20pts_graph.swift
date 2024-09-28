// ViewControll showing 20 pts graph


import UIKit
import Metal


// MARK: Class ViewController
class ViewController_20pts_graph: UIViewController {

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
    
    
    // Call this method after view controller has loaded its view heirarchy into the memory
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
            
            // New graph with 20 points
            graph.addGraph(withName: "NewGraphCell", numPointsInGraph: 20)

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
            
            // if graph property is not nil, update "graph_with_20pts"
            let graph_with_20pts_data = extractRandomPoints(from: self.audio.timeData, count: 20)  //take 20 random audio samples
            graph.updateGraph(
                data: graph_with_20pts_data, forKey: "NewGraphCell")
        }
        
    }
    
}

// Helper function "extractRandomPoints" to extract random samples from time-data
func extractRandomPoints(from array: [Float], count: Int) -> [Float] {
    guard array.count >= count else {return array}
    return Array(array.shuffled().prefix(count))
}

