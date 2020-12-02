//
//  SlideViewController.swift
//  Showcase
//
//  Created by Егор on 01.12.2020.
//

import UIKit

class SliderViewController: UIViewController, UITextFieldDelegate {

    var redColor: CGFloat = 1.0
    var greenColor: CGFloat = 1.0
    var blueColor: CGFloat = 1.0
    @IBOutlet weak var redSlider: UISlider!
    @IBOutlet weak var greenSlider: UISlider!
    @IBOutlet weak var blueSlider: UISlider!
    @IBOutlet weak var redValue: UITextField!
    @IBOutlet weak var greenValue: UITextField!
    @IBOutlet weak var blueValue: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        redValue.delegate = self
        greenValue.delegate = self
        blueValue.delegate = self
        redValue.text = String(format: "%.0f", Float(redColor * 255.0))
        greenValue.text = String(format: "%.0f", Float(greenColor*255.0))
        blueValue.text = String(format: "%.0f", Float(blueColor*255.0))
        updateColor()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func changeRed(_ sender: Any) {
        redColor = CGFloat(redSlider.value)
        redValue.text = String(format: "%.0f", Float(redColor * 255.0))
        updateColor()
    }
    
    @IBAction func changeGreen(_ sender: Any) {
        greenColor = CGFloat(greenSlider.value)
        greenValue.text = String(format: "%.0f", Float(greenColor*255.0))
        updateColor()
    }
    
    @IBAction func changeBlue(_ sender: Any) {
        blueColor = CGFloat(blueSlider.value)
        blueValue.text = String(format: "%.0f", Float(blueColor*255.0))
        updateColor()
    }
    
    func updateColor(){
        view.backgroundColor = UIColor(red: redColor, green: greenColor, blue: blueColor, alpha: 1.0)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
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
