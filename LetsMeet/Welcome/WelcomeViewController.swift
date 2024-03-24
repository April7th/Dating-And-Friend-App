//
//  ViewController.swift
//  LetsMeet
//
//  Created by Lê Duy Tân on 30/10/2023.
//

import UIKit
import ProgressHUD

class WelcomeViewController: UIViewController {
//MARK: - IB Outlets
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .dark
        setupBackgoundTouch()
    }
    
    
    
//MARK: - IBActiions
    @IBAction func forgotPasswordButtonPressed(_ sender: Any) {
        if emailTextField.text != "" {
            //reset password
        } else {
            //show error
            ProgressHUD.error("All field are required")
        }
    }
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        
        if emailTextField.text! != "" && passwordTextField.text != "" {
            FUser.loginUserWith(email: emailTextField.text!, password: passwordTextField.text!) { error, isEmailVerified in
                
                if error != nil {
                    ProgressHUD.error(error?.localizedDescription)
                } else if isEmailVerified {
                    //enter the application
                    print("Go to app")
                } else {
                    ProgressHUD.error("Please verify your email!")
                }
            }
        }
    }

//MARK: - Set up
    private func setupBackgoundTouch() {
        backgroundImageView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(backgroundTap))
        backgroundImageView.addGestureRecognizer(tapGesture)
    }

    @objc func backgroundTap() {
        dissmissKeyBoard()
    }
    
    private func dissmissKeyBoard() {
        self.view.endEditing(false)
    }
}

