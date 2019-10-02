//
//  LoginView.swift
//  Codey
//
//  Created by Anshul Garg on 01/10/19.
//  Copyright © 2019 Anshul Garg. All rights reserved.
//

import UIKit
import Firebase

class LoginView : UIViewController{
    
    
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    
    
    @IBAction func loginAction(_ sender: Any) {
          
    Auth.auth().signIn(withEmail: email.text!, password: password.text!) { (user, error) in
       if error == nil{
         self.performSegue(withIdentifier: "loginToHome", sender: self)
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
