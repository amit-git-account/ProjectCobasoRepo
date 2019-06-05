//
//  ViewController.swift
//  UC-QdeQ
//
//  Created by Amit Tomar on 5/29/19.
//  Copyright © 2019 com.uc.qdeq. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    @IBOutlet weak var tableView: UITableView!
    
    var ref: DatabaseReference?
    var databaseHandle:DatabaseHandle?
    var postData = [String]()
    
    
    @IBOutlet weak var SigninSelector: UISegmentedControl!
    
    @IBOutlet weak var SigninLabel: UILabel!
    var isSignIn:Bool = true
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    @IBOutlet weak var signInButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tableView.delegate = self
        tableView.dataSource = self
        
        //set the firebase reference
        ref = Database.database().reference()
        
        //retreive the posts annd listen for changes
        databaseHandle = ref?.child("Posts").observe(.childAdded, with: { (snapshot) in

            //Code to execute when a child is added under "Posts"
            
            //take the value from the snapshot and add it to the postData array
           //nullcheck on the value before appending
            let post = snapshot.value as? String
            if let actualPost = post{
                //append data
                self.postData.append(actualPost)
                
                //reload table after new data has arrived
                self.tableView.reloadData()
            }
        })
        
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell")
        cell?.textLabel?.text = postData[indexPath.row]
        
        return cell!
    }
    
    
    
    @IBAction func signInSelectorChanged(_ sender: UISegmentedControl) {
        //Flip the boolean
        isSignIn = !isSignIn
        
        //check the bool and set the label and buttons
        if isSignIn{
            SigninLabel.text = "Sign In"
            signInButton.setTitle("Sign In", for: .normal)
        }
        else{
            SigninLabel.text = "Register"
            signInButton.setTitle("Register", for: .normal)
        }
    }
    
    
    @IBAction func signInButtonTapped(_ sender: UIButton) {
        
        //TODO: do some form validation on the email and password
        if let email = emailTextField.text, let pass = passwordTextField.text
        {
        //check if its sign in or registered
        if isSignIn{
            
            //sign in the user to firebase
            
            Auth.auth().signIn(withEmail: email, password: pass, completion: { (user, error) in
                if let u = user {
                    //User is found goto home screen
                    self.performSegue(withIdentifier: "gotoHome", sender: self)
                    
                    
                }
                else {
                    //Error, check error and show message
                }
            })
            
        }
        else{
            //register the user with firebase
            
            Auth.auth().createUser(withEmail: email, password: pass,completion: { (user, error) in
                if let u = user{
                    // user is found, go to home screen
                    self.performSegue(withIdentifier: "gotoHome", sender: self)
                }
                else {
                    // error, check error and show message
                }
            })
        }
        }
    }
    
}

