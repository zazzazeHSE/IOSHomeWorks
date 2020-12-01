//
//  ViewController.swift
//  InTouch
//
//  Created by Егор on 29.10.2020.
//

import UIKit
import MessageUI

class ViewController: UIViewController, MFMessageComposeViewControllerDelegate, MFMailComposeViewControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    private func showDefaultAlertWithMessage(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.show(alert, sender: nil)
    }
    
    @IBAction func sendEmail(_ sender: AnyObject){
        if MFMailComposeViewController.canSendMail(){
            let mailVC = MFMailComposeViewController()
            mailVC.setSubject("My subject")
            mailVC.setToRecipients(["egor.anikeev.00@gmail.com"])
            mailVC.setMessageBody("<h1>Hello!</h1>", isHTML: true)
            mailVC.mailComposeDelegate = self
            self.present(mailVC, animated: true, completion: nil)
        }else{
            showDefaultAlertWithMessage(title: "Can't send email", message: "App does not have acces for email")
        }
    }
    
    @IBAction func sendText(_ sender: AnyObject){
        if MFMessageComposeViewController.canSendText(){
            let smsVC = MFMessageComposeViewController()
            smsVC.messageComposeDelegate = self
            smsVC.recipients = ["89634415933"]
            smsVC.body = "Hello, I'm there"
            self.present(smsVC, animated: true, completion: nil)
        }
        else{
            showDefaultAlertWithMessage(title: "Can't send text message", message: "App does not have access for text message")
        }
    }
    
    @IBAction func openWebsite(_ sender: AnyObject){
        UIApplication.shared.open(URL(string: "http://hse.ru")!, options: [:], completionHandler: nil)
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        switch result{
        case .cancelled:
            showDefaultAlertWithMessage(title: "Message canceled", message: "Somebody cancel message sending")
        case .failed:
            showDefaultAlertWithMessage(title: "Message send failed", message: "App was unable to send message")
        case .sent:
            showDefaultAlertWithMessage(title: "Success", message: "Message sent successfuly")
        }
        self.dismiss(animated: true, completion: nil)
    }

    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        switch result{
        case .cancelled:
            showDefaultAlertWithMessage(title: "Mail canceled", message: "Somebody cancel mail sending")
        case .failed:
            showDefaultAlertWithMessage(title: "Mail send failed", message: "App was unable to send mail")
        case .sent:
            showDefaultAlertWithMessage(title: "Success", message: "Mail sent successfuly")
        case .saved:
            showDefaultAlertWithMessage(title: "Saved", message: "Message was saved")
        }
        self.dismiss(animated: true, completion: nil)
    }
}

