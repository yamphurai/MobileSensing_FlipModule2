import UIKit

class GraphViewController: UIViewController {

    @IBOutlet weak var userView: UIView!
    
    struct AudioConstants {
        static let AUDIO_BUFFER_SIZE = 1024 * 4
    }
    
    // Setup audio model
    let audio = AudioModel(buffer_size: AudioConstants.AUDIO_BUFFER_SIZE)
    lazy var graph: MetalGraph? = {
        return MetalGraph(userView: self.userView)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Start audio processing when the view is loaded again
        audio.startMicrophoneProcessing(withFps: 20)
        audio.play()
        
        if let graph = self.graph {
            graph.setBackgroundColor(r: 0, g: 0, b: 0, a: 1)
            
            // Add existing graphs
            graph.addGraph(withName: "fft",
                           shouldNormalizeForFFT: true,
                           numPointsInGraph: AudioConstants.AUDIO_BUFFER_SIZE / 2)
            
            graph.addGraph(withName: "time",
                           numPointsInGraph: AudioConstants.AUDIO_BUFFER_SIZE)
            
            // Add new graph with 20 points
            graph.addGraph(withName: "shortGraph",
                           numPointsInGraph: 20)

            
            graph.makeGrids() // add grids to graph
        }
        
        // Start up the audio model here, querying microphone
        audio.startMicrophoneProcessing(withFps: 20) // preferred number of FFT calculations per second
        audio.play()
        
        // Run the loop for updating the graph periodically
        Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { _ in
            self.updateGraph()
        }
    }
    
    
    // Start audio processing when view controller is loaded again
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        audio.startMicrophoneProcessing(withFps: 20)
        audio.play()
    }

    
    
    
    // Called when the view is about to disappear after processing 20 samples
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Stop audio processing when leaving this view
        audio.stop() // Assuming you have a stop method in your AudioModel
    }
    
    // Periodically update the graph with refreshed data
    func updateGraph() {
        if let graph = self.graph {
            graph.updateGraph(
                data: self.audio.fftData,
                forKey: "fft"
            )
            
            graph.updateGraph(
                data: self.audio.timeData,
                forKey: "time"
            )
            
            // Extract 20 random points from timeData
            let shortGraphData = extractRandomPoints(from: self.audio.timeData, count: 20)
            
            graph.updateGraph(
                data: shortGraphData,
                forKey: "shortGraph"
            )
        }
    }
    
    // Helper function to extract random points
    func extractRandomPoints(from array: [Float], count: Int) -> [Float] {
        guard array.count >= count else { return array }
        return Array(array.shuffled().prefix(count))
    }
}

