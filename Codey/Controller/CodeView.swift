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

class CodeView: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet weak var viewPlaceholder: UIView!
    @IBOutlet weak var compileButton: UIButton!
    var highlightr : Highlightr!
    var textStorage = CodeAttributedString()
    var textView : UITextView?
    var text: String = ""
    let outputData = OutputData()
    let languages = ["Java", "Python", "C++", "Swift", "C"]
    var toolBar = UIToolbar()
    var picker  = UIPickerView()
           
    override func viewDidLoad() {
        super.viewDidLoad()
       
        let defaults = UserDefaults.standard
        textStorage = CodeAttributedString()
        highlightr = textStorage.highlightr
        textStorage.highlightr.setTheme(to: defaults.string(forKey: "theme") ?? "vs")
        textStorage.language = "C++"
        
        let layoutManager = NSLayoutManager()
        self.textStorage.addLayoutManager(layoutManager)
        
        let textContainer = NSTextContainer(size: viewPlaceholder.bounds.size)
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
    
    @IBAction func YOUR_BUTTON__TAP_ACTION(_ sender: UIButton) {
        picker = UIPickerView.init()
        picker.delegate = self
        picker.backgroundColor = UIColor.white
        picker.setValue(UIColor.black, forKey: "textColor")
        picker.autoresizingMask = .flexibleWidth
        picker.contentMode = .center
        picker.frame = CGRect.init(x: 0.0, y: UIScreen.main.bounds.size.height - 300, width: UIScreen.main.bounds.size.width, height: 300)
        self.view.addSubview(picker)

        toolBar = UIToolbar.init(frame: CGRect.init(x: 0.0, y: UIScreen.main.bounds.size.height - 300, width: UIScreen.main.bounds.size.width, height: 30))
        toolBar.barStyle = .blackTranslucent
        toolBar.items = [UIBarButtonItem.init(title: "Done", style: .done, target: self, action: #selector(onDoneButtonTapped))]
        self.view.addSubview(toolBar)
    }
    
    @objc func onDoneButtonTapped() {
        toolBar.removeFromSuperview()
        picker.removeFromSuperview()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return languages.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return languages[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print(languages[row])
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
               }
    }
   
    func resultCode(){
        let codeDB = Database.database().reference().child("Result")
        
         codeDB.observe(.childAdded) { (snapshot) in
            
            let snapshotValue = snapshot.value as! Dictionary<String,String>
            let sender = snapshotValue["sender"]!
            let result = snapshotValue["result"]!
            let debugResult = snapshotValue["debugResult"]!
            
           }
    }
    var outputViewController: OutputViewController!
    
    enum OutputState {
        case collapsed
        case expanded
    }
    
    var outputVisible = false
    
    var nextState:OutputState {
           return outputVisible ? .collapsed : .expanded
       }
    
    var visualEffectView:UIVisualEffectView!
    
    var endOutputViewHeight:CGFloat = 0
    var startOutputViewHeight:CGFloat = 0
    
    var runningAnimations = [UIViewPropertyAnimator]()
    var animationProgressWhenInterrupted:CGFloat = 0
    
    func setupOutput(){
        endOutputViewHeight = viewPlaceholder.frame.height * 1.0
        startOutputViewHeight = viewPlaceholder.frame.height * 0.3
        
        visualEffectView = UIVisualEffectView()
        visualEffectView.frame = self.view.frame
        self.view.addSubview(visualEffectView)
        
        outputViewController = OutputViewController(nibName: "OutputViewController", bundle: nil)
        self.view.addSubview(outputViewController.view)
        outputViewController.view.frame = CGRect(x: 0, y: self.view.frame.height -
            startOutputViewHeight, width: self.view.bounds.width, height: endOutputViewHeight)
        outputViewController.view.clipsToBounds = true
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(CodeView.handleCardTap(recognzier:)))
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(CodeView.handleCardPan(recognizer:)))
        
        outputViewController.handleView.addGestureRecognizer(tapGestureRecognizer)
        outputViewController.handleView.addGestureRecognizer(panGestureRecognizer)
      
    }
         @objc func handleCardTap(recognzier:UITapGestureRecognizer) {
              switch recognzier.state {
              // Animate card when tap finishes
              case .ended:
                  animateTransitionIfNeeded(state: nextState, duration: 0.3)
              default:
                  break
              }
          }
        
        
         @objc func handleCardPan (recognizer:UIPanGestureRecognizer) {
               switch recognizer.state {
               case .began:
                   // Start animation if pan begins
                startInteractiveTransition(state: nextState, duration: 0.9)
                   
               case .changed:
                   // Update the translation according to the percentage completed
                   let translation = recognizer.translation(in: self.outputViewController.handleView)
                   var fractionComplete = translation.y / endOutputViewHeight
                   fractionComplete = outputVisible ? fractionComplete : -fractionComplete
                   updateInteractiveTransition(fractionCompleted: fractionComplete)
               case .ended:
                   // End animation when pan ends
                   continueInteractiveTransition()
               default:
                   break
               }
           }
        
    func animateTransitionIfNeeded (state:OutputState, duration:TimeInterval) {
           // Check if frame animator is empty
           if runningAnimations.isEmpty {
               // Create a UIViewPropertyAnimator depending on the state of the popover view
               let frameAnimator = UIViewPropertyAnimator(duration: duration, dampingRatio: 1) {
                   switch state {
                   case .expanded:
                       // If expanding set popover y to the ending height and blur background
                       self.outputViewController.view.frame.origin.y = self.view.frame.height - self.endOutputViewHeight
                       self.visualEffectView.effect = UIBlurEffect(style: .dark)
                       
                   case .collapsed:
                       // If collapsed set popover y to the starting height and remove background blur
                       self.outputViewController.view.frame.origin.y = self.view.frame.height - self.startOutputViewHeight
                       self.visualEffectView.effect = nil
                   }
               }
               
               // Complete animation frame
               frameAnimator.addCompletion { _ in
                   self.outputVisible = !self.outputVisible
                   self.runningAnimations.removeAll()
               }
               
               // Start animation
               frameAnimator.startAnimation()
               
               // Append animation to running animations
               runningAnimations.append(frameAnimator)
               
               // Create UIViewPropertyAnimator to round the popover view corners depending on the state of the popover
               let cornerRadiusAnimator = UIViewPropertyAnimator(duration: duration, curve: .linear) {
                   switch state {
                   case .expanded:
                       // If the view is expanded set the corner radius to 30
                       self.outputViewController.view.layer.cornerRadius = 30
                       
                   case .collapsed:
                       // If the view is collapsed set the corner radius to 0
                       self.outputViewController.view.layer.cornerRadius = 0
                   }
               }
               
               // Start the corner radius animation
               cornerRadiusAnimator.startAnimation()
               
               // Append animation to running animations
               runningAnimations.append(cornerRadiusAnimator)
               
           }
       }
       
       // Function to start interactive animations when view is dragged
       func startInteractiveTransition(state:OutputState, duration:TimeInterval) {
           
           // If animation is empty start new animation
           if runningAnimations.isEmpty {
               animateTransitionIfNeeded(state: state, duration: duration)
           }
           
           // For each animation in runningAnimations
           for animator in runningAnimations {
               // Pause animation and update the progress to the fraction complete percentage
               animator.pauseAnimation()
               animationProgressWhenInterrupted = animator.fractionComplete
           }
       }
       
       // Funtion to update transition when view is dragged
       func updateInteractiveTransition(fractionCompleted:CGFloat) {
           // For each animation in runningAnimations
           for animator in runningAnimations {
               // Update the fraction complete value to the current progress
               animator.fractionComplete = fractionCompleted + animationProgressWhenInterrupted
           }
       }
       
       // Function to continue an interactive transisiton
       func continueInteractiveTransition (){
           // For each animation in runningAnimations
           for animator in runningAnimations {
               // Continue the animation forwards or backwards
               animator.continueAnimation(withTimingParameters: nil, durationFactor: 0)
           }
       }

}
