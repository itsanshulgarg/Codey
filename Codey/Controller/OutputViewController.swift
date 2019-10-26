//
//  OutputViewController.swift
//  Codey
//
//  Created by Anshul Garg on 06/10/19.
//  Copyright © 2019 Anshul Garg. All rights reserved.
//

import UIKit

class OutputViewController: UIViewController {

    @IBOutlet weak var handleView: UIView!
    
    @IBOutlet weak var outputText: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        outputText.isEditable = false

        // Do any additional setup after loading the view.
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
