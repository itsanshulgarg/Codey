//
//  File.swift
//  Codey
//
//  Created by Anshul Garg on 01/10/19.
//  Copyright © 2019 Anshul Garg. All rights reserved.
//

import UIKit
import Firebase

class StartView : UIViewController{
    
  override func viewDidAppear(_ animated: Bool) {
      super.viewDidAppear(animated)
      if Auth.auth().currentUser != nil {
          self.performSegue(withIdentifier: "alreadyLoggedIn", sender: nil)
      }
  }
}
