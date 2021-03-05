//
//  TapBar.swift
//  TasksTracker
//
//  Created by Егор on 05.03.2021.
//

import Foundation
import UIKit

class TapBar: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(named: "Background")
        
        let mainView = ViewController()
        mainView.tabBarItem = UITabBarItem(title: "Задачи", image: UIImage(systemName: "doc.plaintext"), tag: 0)
        let settingsView = SettingsViewController()
        settingsView.tabBarItem = UITabBarItem(title: "Настройки", image: UIImage(systemName: "gear"), tag: 1)
        self.viewControllers = [mainView, settingsView]
        navigationController?.isNavigationBarHidden = true
    }
}
