//
//  MeUIViewController.swift
//  BreastFeedingSupport
//
//  Created by CHONG W GUO on 4/10/17.
//

import Foundation
import UIKit
class MeUIViewController: UITableViewController {
    
 //   @IBOutlet weak var UITableViewOutlet: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("section: \(indexPath.section)")
       print("row: \(indexPath.row)")
       if (indexPath.section == 0 && indexPath.row == 2){
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "BFLoginViewController")
            self.present(controller, animated: true, completion: nil)
       }
    }
    
    @IBOutlet weak var logOutViewCell: UITableViewCell!
    
    

}
