//
//  ChatViewController.swift
//  iMessagingChat
//
//  Created by Michael Tanious on 7/20/17.
//  Copyright © 2017 WMWiOS. All rights reserved.
//

import UIKit
import Firebase


class ChatViewController: UIViewController, UITextFieldDelegate {
    
    
    //MARK: - Variables
    var toID: String?
    let fromID = Auth.auth().currentUser?.uid
    
    
    
    
    
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var navigationBar: UINavigationItem!
    @IBOutlet weak var chatTableView: UITableView!
    @IBOutlet weak var messageTextField: UITextField!
    
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        messageTextField.delegate = self
        chatTableView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hideKeyboard)))
        

        
    }

    override func viewWillAppear(_ animated: Bool) {
        setupTitle()
    }
  
    
    
    //MARK: - Function
    
    // set up view controllar tittle
    func setupTitle() {
        let ref = Database.database().reference().child("users").child(toID!)
        ref.observe(.value, with: { (snapshot) in
            // print(snapshot)
            if let userData = snapshot.value as? [String:String] {
                self.navigationBar.title = userData["name"]
            }
            
            
        }, withCancel: nil)
    }
    
    // hide Keyboard function
    func hideKeyboard() {
        self.view.endEditing(true)
    }
    
    
    // uplaod chat function
    func uploadChat() {
        
        guard messageTextField.text != "" else {
            print("Please provide message to send to user")
            return
        }
        
        // upload chat to DataBase
        let ref = Database.database().reference()
        let chatref = ref.child("chats").childByAutoId()
        let timeStamp = "\(Date().timeIntervalSince1970)"
        let messageObject: [String: String] = ["from": fromID!, "to": toID!, "message": messageTextField.text!, "timestamp": timeStamp ]
        chatref.updateChildValues(messageObject) { (error, reference) in
            if error != nil {
                //error
                print(error?.localizedDescription ?? "error uploading message to chat firebase")
            } else {
                print("Chat Uploaded successfully")
                self.messageTextField.text = ""
            }
        }
    self.messageTextField.becomeFirstResponder()
    
    
    }
    
    
    //MARK: - textField Protocol implementation
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        hideKeyboard()
        uploadChat()
        return true
    }
    
    
    
    
    
    //MARK: - IBActions
    @IBAction func sendPressed(_ sender: UIButton) {
        hideKeyboard()
        uploadChat()
    }
    

}
