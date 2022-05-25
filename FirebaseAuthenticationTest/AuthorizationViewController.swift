//
//  AuthorizationViewController.swift
//  FirebaseAuthenticationTest
//
//  Created by Oksana Poliakova on 25.05.2022.
//

import UIKit
import FirebaseCore
import FirebaseAuth

enum AuthorizationType {
    case login
    case registration
}

class AuthorizationViewController: UIViewController {

    private var type: AuthorizationType = .registration {
        didSet {
            switch type {
            case .registration:
                registrationLabel.text = "Registration"
                nameTextField.isHidden = false
                loginButton.setTitle("Log In", for: .normal)
            case .login:
                registrationLabel.text = "Log In"
                loginLabel.isHidden = true
                nameTextField.isHidden = true
                loginButton.setTitle("Enter to your account", for: .normal)

            }
        }
    }
    
    @IBOutlet weak var loginLabel: UILabel!
    @IBOutlet weak var loginStackView: UIStackView!
    @IBOutlet weak private var registrationLabel: UILabel!
    @IBOutlet weak private var nameTextField: UITextField!
    @IBOutlet weak private var emailTextField: UITextField!
    @IBOutlet weak private var passwordTextField: UITextField!
    @IBOutlet weak private var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setDelegates()
        
    }

    @IBAction func switchToLogin(_ sender: Any) {
        type = type == .login ? .registration : .login
    }
    
    private func setDelegates() {
        nameTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    private func showAlert() {
        let alert = UIAlertController(title: "Error", message: "Fill all fields", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true)
    }
}

extension AuthorizationViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch type {
        case .registration:
            guard
                let nameText = nameTextField.text, !nameText.isEmpty,
                let emailText = emailTextField.text, !emailText.isEmpty,
                let passwordText = passwordTextField.text, !passwordText.isEmpty
            else {
                showAlert()
                return true
            }
            
            
            Auth.auth().createUser(withEmail: emailText, password: passwordText) { auth, error  in
                if error == nil {
                    if let auth = auth {
                        print(auth.user.uid)
                    }
                    
                }
                print("ATH RESULT: \(auth) ERROR: \(error)")
            }
            print("REGISTRATION")
        case .login:
            guard
                let emailText = emailTextField.text, !emailText.isEmpty,
                let passwordText = passwordTextField.text, !passwordText.isEmpty
            else {
                showAlert()
                return true
            }
            
            print("LOGIN")
        }
        return true
    }
}
