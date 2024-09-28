// Table view controller with two cells

import UIKit

class MainTableTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Main Menu"

    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }

 
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = (indexPath.row == 0) ? "OriginalGraphsCell" : "NewGraphCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        
        // If needed, set the text here too
        //cell.textLabel?.text = (indexPath.row == 0) ? "Original graphs" : "Show 20 pts graph"
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
            
        if indexPath.row == 0 {
            let viewController = storyboard.instantiateViewController(withIdentifier: "OriginalViewController")
            self.navigationController?.pushViewController(viewController, animated: true)
        } else if indexPath.row == 1 {
            let viewController = storyboard.instantiateViewController(withIdentifier: "GraphViewController")
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
  
}
