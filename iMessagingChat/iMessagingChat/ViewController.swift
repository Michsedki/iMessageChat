//
//  ViewController.swift
//  iMessagingChat
//
//  Created by Michael Tanious on 7/20/17.
//  Copyright © 2017 WMWiOS. All rights reserved.
//

import UIKit

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
       
    }
    
    
    //MARK: - IBActions
    
    @IBAction func loginRegisterSegmentedControlPressed(_ sender: UISegmentedControl) {
    }
    @IBAction func signInPressed(_ sender: UIButton) {
    }

    @IBAction func signUpPressed(_ sender: UIButton) {
    }
    

}

