

import UIKit

class MainTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = indexPath.row == 0 ? "OriginalGraphsCell" : "NewGraphCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) else {
            fatalError("Error: Unable to dequeue cell with identifier \(cellIdentifier)")
        }

        return cell
    }

    // MARK: - Navigation
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Deselect the row
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.row == 0 {
            let originalViewController = storyboard?.instantiateViewController(withIdentifier: "ViewController") as! ViewController
            navigationController?.pushViewController(originalViewController, animated: true)
        } else {
            let newGraphViewController = storyboard?.instantiateViewController(withIdentifier: "GraphViewController") as! GraphViewController
            navigationController?.pushViewController(newGraphViewController, animated: true)
        }
    }
}
