//
//  ChatViewController.swift
//  iMessagingChat
//
//  Created by Michael Tanious on 7/20/17.
//  Copyright © 2017 WMWiOS. All rights reserved.
//

import UIKit
import Firebase


class ChatViewController: UIViewController, UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate {
    
    
    //MARK: - Variables
    var toID: String?
    let fromID = Auth.auth().currentUser?.uid
    struct messageObject {
        var from: String
        var to: String
        var message: String
        var timeStamp: String
    }
    
    var messages = [messageObject]()
    
    
    
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var navigationBar: UINavigationItem!
    @IBOutlet weak var chatTableView: UITableView!
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var chatTableViewTopConstraint: NSLayoutConstraint!
    
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        messageTextField.delegate = self
        chatTableView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hideKeyboard)))
        loadMessagesData()
        
        // Set table properties
        chatTableView.delegate = self
        chatTableView.dataSource = self
        chatTableView.rowHeight = UITableViewAutomaticDimension
        chatTableView.estimatedRowHeight = 200
        chatTableView.separatorStyle = .none
        chatTableView.setNeedsLayout()
        chatTableView.layoutIfNeeded()
        

        
    }

    override func viewWillAppear(_ animated: Bool) {
        setupTitle()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: .UIKeyboardWillHide, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
        
    }
  
    
    
    //MARK: - Table View Methods
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        
        
        // calculate the width and hight for the chat bubble
        let width = ceil(rectSize(text: messages[indexPath.row].message).width) + 30
        let hight = ceil(rectSize(text: messages[indexPath.row].message).height) + 20
        
        // set up text view properties
        let textView = UITextView()
        textView.isScrollEnabled = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.layer.cornerRadius = 5
        textView.clipsToBounds = true
        
        
        
        textView.text = messages[indexPath.row].message
        textView.font = UIFont.systemFont(ofSize: 16)
        cell.addSubview(textView)
        
        // setup textview constrains
        textView.widthAnchor.constraint(equalToConstant: width).isActive = true
        textView.heightAnchor.constraint(equalToConstant: hight).isActive = true
        textView.topAnchor.constraint(equalTo: cell.topAnchor, constant: 2).isActive = true
        textView.bottomAnchor.constraint(equalTo: cell.bottomAnchor, constant: -2).isActive = true
        
        
        
        
        if messages[indexPath.row].from == fromID {
            // put the message sent by the current user on the right
            textView.rightAnchor.constraint(equalTo: cell.rightAnchor, constant: -5).isActive = true
            textView.backgroundColor = UIColor.lightGray
            
            
            
        } else {
            // put the message received by the current user on the left
            textView.leftAnchor.constraint(equalTo: cell.leftAnchor, constant: +5).isActive = true
            textView.backgroundColor = UIColor.blue
            textView.textColor = UIColor.white
            
        }
        
        
        
        
        
        
        
        
        
        
        
        
        return cell
    }
    
    
    //MARK: - Function
    
    // chat bubble drow function
    func rectSize(text: String) -> CGRect {
        let size = CGSize(width: 200, height: 500)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        let attributes = [NSFontAttributeName: UIFont.systemFont(ofSize: 16)]
        return NSString(string: text).boundingRect(with: size, options: options, attributes: attributes, context: nil)
    }
    
    
    // MARK: - Keyboard problem fix : get the keyboart out of the way of the textfield
    
    var keyboard_offset: CGFloat = 0
    
    
    func keyboardWillShow(notification: Notification) {
        let info = notification.userInfo!
        let value: AnyObject = info[UIKeyboardFrameEndUserInfoKey]! as AnyObject
        
        let newFrame = value.cgRectValue
        keyboard_offset = newFrame!.height
        
        var rect = self.view.frame
        rect.origin.y -= keyboard_offset
        
        UIView.animate(withDuration: 0.5) {
            self.view.frame = rect
            self.chatTableViewTopConstraint.constant += self.keyboard_offset
        }
        
//        print("Keyboard: \(value)")
        
    }
    
    func keyboardWillHide() {
        var rect = self.view.frame
        rect.origin.y += keyboard_offset
        UIView.animate(withDuration: 0.5) {
            self.view.frame = rect
             self.chatTableViewTopConstraint.constant -= self.keyboard_offset
        }
    }
    
    
    // Load Data Function
    func loadMessagesData() {
        messages = []
        let ref = Database.database().reference().child("chats")
        ref.observe(.childAdded, with: { (snapshot) in
            if let messageDictionary = snapshot.value as? [String : String] {
                let msg = messageObject(from: messageDictionary["from"]!, to: messageDictionary["to"]!, message: messageDictionary["message"]!, timeStamp: messageDictionary["timestamp"]!)
                
                if (msg.from == self.fromID! && msg.to == self.toID!) || (msg.from == self.toID! && msg.to == self.fromID!) {
                    self.messages.append(msg)
                    self.chatTableView.reloadData()
                    self.scrollToBottom()
                    print("Messages as of now: \(self.messages.count)")
                    
                }
            }
            
            
            
        }, withCancel: nil)
        
    }
    
    // Scroll the table view to the last message
    func scrollToBottom () {
        let indexPath : IndexPath = IndexPath(row: messages.count - 1, section: 0)
        self.chatTableView.scrollToRow(at: indexPath, at: .top, animated: true)
    }
    
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
