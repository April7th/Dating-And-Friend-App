//
//  RegisterViewController.swift
//  LetsMeet
//
//  Created by Lê Duy Tân on 31/10/2023.
//

import UIKit
import ProgressHUD

class RegisterViewController: UIViewController {
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var dateOfBirthTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    @IBOutlet weak var genderSegmentedOutlet: UISegmentedControl!
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    
    @IBOutlet weak var registerOutlet: UIButton!
    
    //MARK: - Vars
    var isMale = true
    
    //MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerOutlet.setTitle("", for: .normal)
        
        overrideUserInterfaceStyle = .dark
        setupBackgoundTouch()
    }
    
    //MARK: - IBActions
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)

    }
    
    @IBAction func registerButtonPressed(_ sender: Any) {
        if isTextDataImputted() {
            if passwordTextField.text! == confirmPasswordTextField.text! {
                registerUser()
            } else {
                ProgressHUD.error("Password do not match!")
            }
            
        } else {
            ProgressHUD.error("All field are required!")
        }
    }
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func genderSegmentValueChanged(_ sender: UISegmentedControl) {
        isMale = sender.selectedSegmentIndex == 0
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
    
    private func isTextDataImputted() -> Bool {
        return usernameTextField.text != "" && emailTextField.text != "" && cityTextField.text != "" && dateOfBirthTextField.text != "" && passwordTextField.text != "" && confirmPasswordTextField.text != ""
    }
    
    //MARK: - Register User
    private func registerUser() {
        
        ProgressHUD.added()
        
        FUser.registerUserWith(email: emailTextField.text!, password: passwordTextField.text!, userName: usernameTextField.text!, city: cityTextField.text!, isMale: isMale, dateOfBirth: Date()) { error in
            
            if error == nil {
                ProgressHUD.succeed("Verification email sent!")
                self.dismiss(animated: true, completion: nil)
            } else {
                ProgressHUD.error(error!.localizedDescription)
            }
        }
    }
    
}
