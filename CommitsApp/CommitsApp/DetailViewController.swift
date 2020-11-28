//
//  DetailViewController.swift
//  CommitsApp
//
//  Created by Егор on 28.11.2020.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var detailLabel: UILabel!
    var detailItem: Commit?
    override func viewDidLoad() {
        super.viewDidLoad()
        if let detail = detailItem{
            detailLabel.text = detail.message
        }
        // Do any additional setup after loading the view.
    }
    
    
    @objc func showAuthorCommits(){
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
