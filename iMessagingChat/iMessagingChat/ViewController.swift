//
//  ViewController.swift
//  iMessagingChat
//
//  Created by Michael Tanious on 7/20/17.
//  Copyright © 2017 WMWiOS. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
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
        
        // Hide And Show Views according to sign in or sign up mode
        loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? enableDisable(modeLogin: true) : enableDisable(modeLogin: false)
        
        // add tap guesture recognizer to the image View to pick the profile picture
        profilePicture.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.selectProfileImage)))
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
    
    // Hide and Show Views according to sign up and sign in mode
    func enableDisable(modeLogin: Bool) {
        nameTextField.isHidden = modeLogin
        profilePicture.isHidden = modeLogin
        profilePicture.isUserInteractionEnabled = !modeLogin
        signInButton.isHidden = !modeLogin
        signUpButton.isHidden = modeLogin
    }
    
    // pick the profile picture
    func selectProfileImage () {
        // print("Profile Image Tap")
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.allowsEditing = true
        imagePickerController.delegate = self
        self.present(imagePickerController, animated: true, completion: nil)
        
    }
    
    
    // MARK: - UIImagePickerControllerDelegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let editedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            profilePicture.image = editedImage
        } else if let originalImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            profilePicture.image = originalImage
        }
        dismiss(animated: true, completion: nil)
    }
    
    
    
    //MARK: - IBActions
    
    @IBAction func loginRegisterSegmentedControlPressed(_ sender: UISegmentedControl) {
        
        // Hide And Show Views according to sign in or sign up mode
        loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? enableDisable(modeLogin: true) : enableDisable(modeLogin: false)
        
        
        
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
//                print("User Registered Successfully")
                guard let userID = User?.uid else {
                    self.stopAnimating()
                    print("Error Fetching User ID")
                    return
                }
                
                // Store Image in file Storage
                let imageName: String = "\(userID)_profile_image.jpg"
                
                let storageRef = Storage.storage().reference()
                let profileImageRef = storageRef.child("profile_images").child(imageName)
                
                let imageData: Data = UIImageJPEGRepresentation(self.profilePicture.image!, 0.4)!
                
                profileImageRef.putData(imageData, metadata: nil, completion: { (metaData, error) in
                    if error != nil {
                        // Error
                        print(error?.localizedDescription ?? "error uploading profile image")
                        self.stopAnimating()
                        return
                    } else {
                        let imageURL: String = (metaData?.downloadURL()?.absoluteString)!
                        
                        
                        // Store User Data base
                        let ref = Database.database().reference()
                        let usersRef = ref.child("users").child(userID)
                        let userObject = ["name": name, "email": email, "profile_image" : imageURL]
                        usersRef.updateChildValues(userObject, withCompletionBlock: { (error, dbreference) in
                            if error != nil {
                                // error
                                print(error?.localizedDescription ?? "error upload user info")
                                self.stopAnimating()
                                return
                            } else {
                                // registered and uplaoded data successfully
                                self.stopAnimating()
                                print("All records saved successfully")
                                self.checkLogin()
                                
                            }
                        })
                        
                        
                    }
                })
                
                
                
                
                
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

