//
//  AuthorizationViewController.swift
//  TasksTracker
//
//  Created by Егор on 01.03.2021.
//

import UIKit
import Firebase
import FirebaseAuth

class AuthorizationViewController: UIViewController {

    let signInButton: UIButton = UIButton(frame: .zero)
    let titleLabel: UILabel = UILabel(frame: .zero)
    let emailTextField: UITextField = UITextField(frame: .zero)
    let passwordTextField: UITextField = UITextField(frame: .zero)
    let registrationButton: UIButton = UIButton(frame: .zero)

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor(named: "Background")
        self.title = "Авторизация"
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        configureSubviews()
        addAllSubviews()
        initConstraints()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    private func configureSubviews() {
        configureSignInButton()
        configureTitleLabel()
        configureEmailTextField()
        configurePasswordTextField()
        configureRegistrationButton()
    }
    private func configureRegistrationButton() {
        registrationButton.setTitle("Зарегестрироваться", for: .normal)
        registrationButton.setTitleColor(.systemBlue, for: .normal)
        registrationButton.translatesAutoresizingMaskIntoConstraints = false
        registrationButton.addTarget(self, action: #selector(openRegistrationView), for: .touchUpInside)
    }
    
    private func configureEmailTextField() {
        emailTextField.textColor = UIColor(named: "Text")
        emailTextField.placeholder = "Email"
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        emailTextField.keyboardType = .emailAddress
    }
    
    private func configurePasswordTextField() {
        passwordTextField.textColor = UIColor(named: "Text")
        passwordTextField.placeholder = "Password"
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.isSecureTextEntry = true
    }
    
    private func configureTitleLabel() {
        titleLabel.text = "Авторизация"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 36)
        titleLabel.textColor = UIColor(named: "TitleText")
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func configureSignInButton() {
        signInButton.setTitle("Войти", for: .normal)
        signInButton.translatesAutoresizingMaskIntoConstraints = false
        signInButton.addTarget(self, action: #selector(trySignIn), for: .touchUpInside)
        signInButton.setTitleColor(UIColor.systemBlue, for: .normal)
    }
    
    private func addAllSubviews() {
        view.addSubview(signInButton)
        view.addSubview(titleLabel)
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(registrationButton)
    }
    
    private func initConstraints() {
        NSLayoutConstraint.activate([
            signInButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            signInButton.leadingAnchor.constraint(greaterThanOrEqualTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            signInButton.trailingAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            signInButton.topAnchor.constraint(equalTo: view.centerYAnchor, constant: 20),
            
            titleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            
            passwordTextField.bottomAnchor.constraint(equalTo: signInButton.topAnchor, constant: -20),
            passwordTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            passwordTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            passwordTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            emailTextField.bottomAnchor.constraint(equalTo: passwordTextField.topAnchor, constant: -20),
            emailTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            emailTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            emailTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            registrationButton.topAnchor.constraint(equalTo: signInButton.bottomAnchor, constant: 20),
            registrationButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor)
        ])
    }
    
    
    @objc func trySignIn() {
        let email = emailTextField.text
        let password = passwordTextField.text
        Auth.auth().signIn(withEmail: email!, password: password!) { [weak self] authResult, error in
            if error != nil {
                let alert = UIAlertController(title: "Ошибка авторизации", message: "Проверьте введенные данные и подключение к интернету", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Попробовать снова", style: .default, handler: nil))
                self?.present(alert, animated: true, completion: nil)
                return
            }
            let tapBar = TapBar()
            self!.navigationController?.pushViewController(tapBar, animated: true)
            tapBar.navigationController?.setNavigationBarHidden(true, animated: false)
        }
    }
    
    @objc func openRegistrationView() {
        navigationController?.pushViewController(RegistrationViewController(), animated: true)
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
