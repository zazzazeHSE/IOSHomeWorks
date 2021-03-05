//
//  TaskViewController.swift
//  TasksTracker
//
//  Created by Егор on 22.02.2021.
//

import UIKit
import CoreDataFramework

class TaskViewController: UIViewController {

    var currentTask: Task?
    
    var titleTextField: UITextField = UITextField(frame: .zero)
    var descriptionTextField: UITextField = UITextField(frame: .zero)
    var datePicker: UIDatePicker = UIDatePicker(frame: .zero)
    var dismissButton: UIButton = UIButton(frame: .zero)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "Background")
        
        //titleTextField = UITextField(frame: .zero)
        titleTextField.placeholder = "Название задачи"
        titleTextField.text = currentTask?.title
        titleTextField.textColor = UIColor(named: "TitleText")
        titleTextField.translatesAutoresizingMaskIntoConstraints = false
        
        //descriptionTextField = UITextField(frame: .zero)
        descriptionTextField.placeholder = "Описание задачи"
        descriptionTextField.text = currentTask?.text
        descriptionTextField.textColor = UIColor(named: "Text")
        descriptionTextField.translatesAutoresizingMaskIntoConstraints = false
        
        //datePicker = UIDatePicker(frame: .zero)
        datePicker.calendar = .current
        datePicker.date = currentTask?.deadlineDate ?? Date()
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        
        dismissButton.frame.size = CGSize(width: 50, height: 50)
        dismissButton.translatesAutoresizingMaskIntoConstraints = false
        dismissButton.setTitleColor(.systemBlue, for: .normal)
        
        view.addSubview(titleTextField)
        view.addSubview(descriptionTextField)
        view.addSubview(datePicker)
        view.addSubview(dismissButton)
        
        initConstraints()
    }
    
    private func initConstraints() {
        NSLayoutConstraint.activate([
            titleTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            titleTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            titleTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            
            descriptionTextField.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 20),
            descriptionTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            descriptionTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            
            datePicker.topAnchor.constraint(equalTo: descriptionTextField.bottomAnchor, constant: 20),
            datePicker.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            
            dismissButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            dismissButton.topAnchor.constraint(equalTo: datePicker.bottomAnchor, constant: 20)
        ])
    }

}
