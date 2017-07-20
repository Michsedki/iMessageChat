//
//  ViewController.swift
//  iMessagingChat
//
//  Created by Michael Tanious on 7/20/17.
//  Copyright © 2017 WMWiOS. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController {
    
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var loginRegisterSegmentedControl: UISegmentedControl!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
       setupButtons()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.checkLogin()
        
    }
    
    
    //MARK: - Functions
    
    // setup buttons
    func setupButtons() {
        signInButton.layer.cornerRadius = 5
        signInButton.clipsToBounds = true
        
        signUpButton.layer.cornerRadius = 5
        signUpButton.clipsToBounds = true
    }
    
    // check Login
    func checkLogin() {
        if Auth.auth().currentUser != nil {
            self.performSegue(withIdentifier: "toUsersVC", sender: self)
        }
    }
    
    
    
    
    
    
    
    //MARK: - IBActions
    
    @IBAction func loginRegisterSegmentedControlPressed(_ sender: UISegmentedControl) {
    }
    @IBAction func signInPressed(_ sender: UIButton) {
        guard let email = emailTextField.text, emailTextField.text != "", let password = passwordTextField.text, passwordTextField.text != "" else {
            print("Please provide Email and password to login")
            return
        }
        activityIndicator.startAnimating()
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if error != nil {
                print(error?.localizedDescription ?? "Error Sign in user")
                self.stopAnimating()
            } else {
                print("User loged in Successfully")
                self.checkLogin()
            }
        }
        
    }

    
    
    
    @IBAction func signUpPressed(_ sender: UIButton) {
    
        guard let name = nameTextField.text, nameTextField.text != "", let password = passwordTextField.text, passwordTextField.text != "", let email = emailTextField.text, emailTextField.text != "" else {
            
            // error message
            print("Please provide name, email and password to signup")
            return
        }
    
    // Register the user
    activityIndicator.stopAnimating()
        Auth.auth().createUser(withEmail: email, password: password) { (User: User?, error: Error?) in
            if error != nil {
                print(error?.localizedDescription ?? "Error registerng user")
                self.stopAnimating()
                
            } else {
                print("User Registered Successfully")
                self.checkLogin()
            }
            
        }
    
    
    
    
    }
    
    // Stop Animating the activity indicator
    func stopAnimating() {
        if activityIndicator.isAnimating {
            activityIndicator.stopAnimating()
        }
    }
    

}

