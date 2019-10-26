//
//  SignUpView.swift
//  Codey
//
//  Created by Anshul Garg on 01/10/19.
//  Copyright © 2019 Anshul Garg. All rights reserved.
//

import UIKit
import Firebase

class SignUpView : UIViewController, UITextFieldDelegate{
    
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var passwordConfirm: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        email.delegate = self
        password.delegate = self
        passwordConfirm.delegate = self
    }
    
    @IBAction func signUpAction(_ sender: Any) {
    if password.text != passwordConfirm.text {
    let alertController = UIAlertController(title: "Password Incorrect", message: "Please re-type password", preferredStyle: .alert)
    let defaultAction = UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
    NSLog("The \"OK\" alert occured.")
    }) 
                
    alertController.addAction(defaultAction)
    self.present(alertController, animated: true, completion: nil)
            }
    else{
    Auth.auth().createUser(withEmail: email.text!, password: password.text!){ (user, error) in
     if error == nil {
       self.performSegue(withIdentifier: "signUpToHome", sender: self)
       }
    else{
        let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
        NSLog("The \"OK\" alert occured.")
        })
            alert.addAction(defaultAction)
            self.present(alert, animated: true, completion: nil)
                      }
                  }
              }
          }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {   //delegate method
        textField.resignFirstResponder()
        return true
    }
}
