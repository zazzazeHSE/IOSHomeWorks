//
//  SettingsViewController.swift
//  TasksTracker
//
//  Created by Егор on 05.03.2021.
//

import UIKit
import FirebaseAuth

class SettingsViewController: UIViewController {

    var exitButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "Background")
        
        exitButton.setTitle("Выйти", for: .normal)
        exitButton.setTitleColor(.red, for: .normal)
        exitButton.addTarget(self, action: #selector(logOut), for: .touchUpInside)
        exitButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(exitButton)
        NSLayoutConstraint.activate([
            exitButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            exitButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
    
    
    @objc func logOut() {
        try? Auth.auth().signOut()
        navigationController?.popViewController(animated: true)
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
