//
//  UsersTableViewController.swift
//  iMessagingChat
//
//  Created by Michael Tanious on 7/20/17.
//  Copyright © 2017 WMWiOS. All rights reserved.
//

import UIKit
import Firebase

class UsersTableViewController: UITableViewController {
    
    //MARK: - variables
    struct userObject {
        var name: String
        var imageUrl: String
        var userID: String
    }
    
    var users = [userObject]()
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.checkLogin()
    }
    
    
    //MARK: - Functions
    
    // check login function
    func checkLogin() {
        if Auth.auth().currentUser == nil {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    // load data function
    func loadData() {
        users = []
        let ref = Database.database().reference().child("users")
        ref.observe(.childAdded, with: { (snapshot) in
            // print(snapshot)
            // print(snapshot.key)
            // print(snapshot.value)
            
            
            if let userDictionary = snapshot.value as? [String: String] {
                
                let user = userObject(name:  userDictionary["name"]!, imageUrl:  userDictionary["profile_image"]!, userID:  snapshot.key)
                self.users.append(user)
                self.tableView.reloadData()
               
                
            }
//            test the observe statement
//            print("users: \(self.users.count)")
            
        }, withCancel: nil)
        
    }
    
    
    
    
    
    //MARK: - IBACtions
    
    @IBAction func signOutPressed(_ sender: UIBarButtonItem) {
        
        do {
            try Auth.auth().signOut()
            self.checkLogin()
        } catch {
            // Error
            print("Error Signing out")
        }
        
    }
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return users.count
    }
    
   
     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! UsersTableViewCell
     
     // Configure the cell...
     cell.nameLabel.text = users[indexPath.row].name
        let url = URL(string: self.users[indexPath.row].imageUrl)
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig)
        let task = session.dataTask(with: url!) { (data, urlresponse, error) in
            if  error != nil {
                // error
                print(error?.localizedDescription ?? "error download profile Images")
            } else {
                cell.profilePicture.image = UIImage(data: data!)
            }
        }
        task.resume()
        
        
     return cell
     }
    
    
   
    
   
    
   
   
    
    
     // MARK: - Navigation
     
    
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     
     }
    
    
}
