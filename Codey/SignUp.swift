//
//  SignUp.swift
//  Codey
//
//  Created by Anshul Garg on 01/10/19.
//  Copyright © 2019 Anshul Garg. All rights reserved.
//

import UIKit
import Firebase

class SignUpView : UIViewController{
    
    
    @IBOutlet weak var email: UITextView!
    @IBOutlet weak var password: UITextView!
    @IBOutlet weak var passwordConfirm: UITextView!
    
    @IBAction func signUpAction(_ sender: Any) {
    if password.text != passwordConfirm.text {
    let alertController = UIAlertController(title: "Password Incorrect", message: "Please re-type password", preferredStyle: .alert)
    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                
    alertController.addAction(defaultAction)
    self.present(alertController, animated: true, completion: nil)
            }
    else{
    Auth.auth().createUser(withEmail: email.text!, password: password.text!){ (user, error) in
     if error == nil {
       self.performSegue(withIdentifier: "signupToHome", sender: self)
                    }
     else{
       let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
       let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                        
        alertController.addAction(defaultAction)
        self.present(alertController, animated: true, completion: nil)
           }
                }
          }
    }
}
