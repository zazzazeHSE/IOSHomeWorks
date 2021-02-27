//
//  ShareViewController.swift
//  ShareTask
//
//  Created by Егор on 26.02.2021.
//

import UIKit
import Social

class ShareViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        sleep(2)
        self.extensionContext?.completeRequest(returningItems: [], completionHandler: nil)
    }

}
