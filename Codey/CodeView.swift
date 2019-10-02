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

class CodeView: UIViewController {
 
    
    @IBOutlet weak var viewPlaceholder: UIView!
    var highlightr : Highlightr!
    var textStorage = CodeAttributedString()
    
    var text: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let defaults = UserDefaults.standard
        self.textStorage = CodeAttributedString()
        self.highlightr = textStorage.highlightr
    
        self.textStorage.highlightr.setTheme(to: defaults.string(forKey: "theme") ?? "vs")
        self.textStorage.language = "Python"
        let layoutManager = NSLayoutManager()
        self.textStorage.addLayoutManager(layoutManager)
        
        let textContainer = NSTextContainer(size: view.bounds.size)
        layoutManager.addTextContainer(textContainer)
        
        let textView = UITextView(frame: viewPlaceholder.bounds, textContainer: textContainer)
        textView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        textView.autocorrectionType = .no
        textView.autocapitalizationType = .none
        textView.spellCheckingType = .no
        textView.smartQuotesType = .no
        textView.smartDashesType = .no
        textView.text = self.text
        
        NotificationCenter.default.addObserver(self, selector: #selector(languageChanged), name: UserDefaults.didChangeNotification, object: nil)
        
        
        viewPlaceholder.addSubview(textView)

        
    }
   
    @objc
    func languageChanged() {
        self.textStorage.language = UserDefaults.standard.string(forKey: "language")
    }
    
   @IBAction func logOutAction(_ sender: Any) {
       do {
              try Auth.auth().signOut()
        navigationController?.popToRootViewController(animated: true)
          }
       catch let signOutError as NSError {
              print ("Error signing out: %@", signOutError)
          }
         
   }
    
    
}
