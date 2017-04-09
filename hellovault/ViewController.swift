//
//  ViewController.swift
//  hellovault
//
//  Created by Vichar Nuchsiri on 4/8/17.
//  Copyright © 2017 Vichar Nuchsiri. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController {
    @IBOutlet weak var emailUITextField: UITextField!
    @IBOutlet weak var logoutUIButton: UIButton!
    @IBOutlet weak var passwordUITextField: UITextField!
    @IBOutlet weak var usernameUILabel: UILabel!
    var firebase : FIRDatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        if let user = FIRAuth.auth()?.currentUser{
            print(user.providerID)
            if (user.isAnonymous){
                self.logoutUIButton.alpha = 0.0
                self.usernameUILabel.text = "Hi!"
            }
            else{
                self.logoutUIButton.alpha = 1.0
                self.usernameUILabel.text = "Hi! /\(user.email!)/"
                self.firebase.child("users/\(user.uid)/userID").setValue(user.uid)
            }

        }
        else{
            
            
            FIRAuth.auth()?.signInAnonymously(completion: { (user, error) in
                if(error != nil){
                    
                    let alertController = UIAlertController(title: "Warning", message: error?.localizedDescription, preferredStyle:.alert)
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction);
                    self.present(alertController,animated: true, completion: nil)

                }
                else{
                    self.logoutUIButton.alpha = 0.0
                    self.usernameUILabel.text = "Hi!"
                    self.firebase.child("users").child(user!.uid).setValue(["userID" : user!.uid])
                }
            })
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func createAccountUIButton(_ sender: UIButton) {
        guard let email = emailUITextField.text else {return}
        guard let password = passwordUITextField.text else {return}


        if  (email == "" || password == ""){
            let alertController = UIAlertController(title: "Warning", message: "Please enter email address and password", preferredStyle:.alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction);
            self.present(alertController,animated: true, completion: nil)
        }
        else{
            let credential = FIREmailPasswordAuthProvider.credential(withEmail: email, password: password)
            FIRAuth.auth()?.currentUser?.link(with: credential, completion: { (user, error) in
                if error == nil{
                    self.logoutUIButton.alpha = 1.0
                    self.usernameUILabel.text = FIRAuth.auth()?.currentUser?.email
                    self.emailUITextField.text = ""
                    self.passwordUITextField.text = ""
                }
                else{
                    let alertController = UIAlertController(title: "Warning", message: error?.localizedDescription, preferredStyle:.alert)
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction);
                    self.present(alertController,animated: true, completion: nil)
                    
                }
                
            })
        }
    }
    
    @IBAction func loginUIButton(_ sender: UIButton) {
        guard let email = emailUITextField.text else {return}
        guard let password = passwordUITextField.text else {return}
        if  (email == "" || password == ""){
            let alertController = UIAlertController(title: "Warning", message: "Please enter email address and password", preferredStyle:.alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction);
            self.present(alertController,animated: true, completion: nil)
        }
        else{
            FIRAuth.auth()?.signIn(withEmail: self.emailUITextField.text!, password: self.passwordUITextField.text!, completion: { (user, error) in
                
                if error == nil{
                    self.logoutUIButton.alpha = 1.0
                    self.usernameUILabel.text = FIRAuth.auth()?.currentUser?.email
                    self.emailUITextField.text = ""
                    self.passwordUITextField.text = ""
                }
                else{
                    let alertController = UIAlertController(title: "Warning", message: error?.localizedDescription, preferredStyle:.alert)
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction);
                    self.present(alertController,animated: true, completion: nil)
                    
                }

                
        })
        }
    }
    
    @IBAction func logoutUIButton(_ sender: UIButton) {
        try! FIRAuth.auth()?.signOut()
        self.usernameUILabel.text = ""
        self.emailUITextField.text = ""
        self.passwordUITextField.text = ""
        self.logoutUIButton.alpha = 0.0
    }


}

