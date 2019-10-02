//
//  ViewController.swift
//  Codey
//
//  Created by Anshul Garg on 19/09/19.
//  Copyright © 2019 Anshul Garg. All rights reserved.
//

import UIKit
import Highlightr
import Firebase
import FirebaseDatabase

class CodeView: UIViewController {
 
    
    @IBOutlet weak var viewPlaceholder: UIView!
    @IBOutlet weak var compileButton: UIButton!
    var highlightr : Highlightr!
    var textStorage = CodeAttributedString()
    var textView : UITextView?
    var text: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let defaults = UserDefaults.standard
        textStorage = CodeAttributedString()
        highlightr = textStorage.highlightr
        textStorage.highlightr.setTheme(to: defaults.string(forKey: "theme") ?? "vs")
        textStorage.language = "C++"
        
        let layoutManager = NSLayoutManager()
        self.textStorage.addLayoutManager(layoutManager)
        
        let textContainer = NSTextContainer(size: view.bounds.size)
        layoutManager.addTextContainer(textContainer)
        
        self.textView = UITextView(frame: viewPlaceholder.bounds, textContainer: textContainer)
        self.textView?.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        self.textView?.autocorrectionType = .no
        self.textView?.autocapitalizationType = .none
        self.textView?.spellCheckingType = .no
        self.textView?.smartQuotesType = .no
        self.textView?.smartDashesType = .no
        self.textView?.text = text
        
        viewPlaceholder.addSubview(self.textView!)
        
       
    }
   @IBAction func compile(_ sender: Any){
    textView?.endEditing(true)
    textView?.isUserInteractionEnabled = false
    compileButton.isEnabled = false
    
    let codeDB = Database.database().reference().child("Code")
    let codeDictionary = ["sender": Auth.auth().currentUser?.email, "codeBody": textView?.text!, "language": "C++"]
    
    codeDB.childByAutoId().setValue(codeDictionary) {
               (error, reference) in
               
               if error != nil {
                   print(error!)
               }
               else {
                   print("Code sent successfully!")
               }

               self.textView?.isUserInteractionEnabled = true
               self.compileButton.isEnabled = true
               self.textView?.text = ""
           
           
           }
    
   
      }
   
    
  
   
    
}
