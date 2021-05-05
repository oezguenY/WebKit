//
//  TableVC.swift
//  Project4
//
//  Created by Özgün Yildiz on 05.05.21.
//

import UIKit

class TableVC: UITableViewController {
    
    var websites = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        websites = ["hackingwithswift.com", "apple.com"]

    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return websites.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "websiteCell", for: indexPath)
        cell.textLabel?.text = websites[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(identifier: "WebView") as? WebViewVC {
            vc.passedSite = websites[indexPath.row]
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
