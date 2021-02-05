//
//  ViewController.swift
//  FancyApp
//
//  Created by Егор on 04.02.2021.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var twitterRoundedButton: FancyButton!
    @IBOutlet weak var downloadButton: FancyButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setImageOfFancyButton(twitterRoundedButton, tintColor: .white, imageName: "twitter")
        setImageOfFancyButton(downloadButton, tintColor: .white, imageName: "cloudDownload")
    }


    private func setImageOfFancyButton(_ button: FancyButton!, tintColor: UIColor, imageName: String) {
        let buttonImage = UIImage(named: imageName)?.withRenderingMode(.alwaysTemplate)
        button.setImage(buttonImage, for: .normal)
        button.tintColor = tintColor
    }
}

