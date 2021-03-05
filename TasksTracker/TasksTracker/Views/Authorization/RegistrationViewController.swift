//
//  RegistrationViewController.swift
//  TasksTracker
//
//  Created by Егор on 01.03.2021.
//

import UIKit
import FirebaseAuth
import Network

class RegistrationViewController: UIViewController {

    let emailTextField: UITextField = UITextField(frame: .zero)
    let passwordTextField: UITextField = UITextField(frame: .zero)
    let registrationButton: UIButton = UIButton(frame: .zero)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "Background")
        self.title = "Регистрация"
        let monitor = NWPathMonitor()
        monitor.pathUpdateHandler = { path in
            DispatchQueue.main.async {
                self.registrationButton.isEnabled = path.status == .satisfied
            }
        }
        let queue = DispatchQueue(label: "Monitor")
        monitor.start(queue: queue)
        
        configureSubviews()
        addAllSubviews()
        initConstraints()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    private func configureSubviews() {
        configureEmailTextField()
        configurePasswordTextField()
        configureRegistrationButton()
    }
    
    private func configureEmailTextField() {
        emailTextField.placeholder = "Email"
        emailTextField.textColor = UIColor(named: "Text")
        emailTextField.keyboardType = .emailAddress
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func configurePasswordTextField() {
        passwordTextField.placeholder = "Password"
        passwordTextField.textColor = UIColor(named: "Text")
        passwordTextField.isSecureTextEntry = true
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func configureRegistrationButton() {
        registrationButton.setTitle("Зарегистрироваться", for: .normal)
        registrationButton.setTitleColor(UIColor.systemBlue, for: .normal)
        registrationButton.setTitleColor(UIColor.systemGray, for: .disabled)
        registrationButton.addTarget(self, action: #selector(tryRegistrateNewUser), for: .touchUpInside)
        registrationButton.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func addAllSubviews() {
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(registrationButton)
    }
    
    private func initConstraints() {
        NSLayoutConstraint.activate([
            emailTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            emailTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            emailTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            
            passwordTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            passwordTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 20),
            
            registrationButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            registrationButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 20)
        ])
    }
    
    @objc private func tryRegistrateNewUser() {
        let email = emailTextField.text!
        let password = passwordTextField.text!
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if error != nil {
                self.showAlertWith(title: "Ошибка регистрации", message: "При попытке регистрации произошла ошибка", actionTitle: "Попробовать снова")
            }
            self.showAlertWith(title: "Успешно", message: "Регистрация прошла успешно", actionTitle: "Ok")
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    private func showAlertWith(title: String, message: String, actionTitle: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: actionTitle, style: .default, handler: nil))
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
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
