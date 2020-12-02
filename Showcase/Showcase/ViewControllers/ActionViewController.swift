//
//  ActionViewController.swift
//  Showcase
//
//  Created by Егор on 01.12.2020.
//

import UIKit

class ActionViewController: UIViewController {

    
    @IBOutlet weak var actionControl: UISegmentedControl!
    @IBOutlet weak var showmeButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        showmeButton.backgroundColor = UIColor(red: 9 / 255.0, green: 05 / 255.0, blue: 134 / 255.0, alpha: 1.0)
        showmeButton.setTitleColor(.white, for: .normal)
        showmeButton.layer.cornerRadius = 4.0
    }
    
    @IBAction func performAction(_ sender: Any) {
        if actionControl.selectedSegmentIndex == 0{
            let controller = UIAlertController(title: "This is an alert", message: "You've created an alert", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Okay", style: .default){ _ in
                controller.dismiss(animated: true, completion: nil)
            }
            controller.addAction(okAction)
            present(controller, animated: true)
        } else {
            let controller = UIAlertController(title: "This is an action sheet", message: "You've created an action sheet", preferredStyle: .actionSheet)
            let okAction = UIAlertAction(title: "Okay", style: .default){ _ in
                controller.dismiss(animated: true, completion: nil)
            }
            controller.addAction(okAction)
            present(controller, animated: true)
        }
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
