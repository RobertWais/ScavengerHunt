//
//  ViewController.swift
//  ScavengerBattle
//
//  Created by Robert Wais on 10/23/18.
//  Copyright © 2018 Robert Wais. All rights reserved.
//

import UIKit

class SignInVC: UIViewController {

    @IBOutlet weak var guestNameField: UITextField!
    @IBOutlet weak var startBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        setDelegate();
        startBtn.layer.borderWidth = 2.0
        startBtn.layer.borderColor = UIColor.white.cgColor
        startBtn.layer.cornerRadius = startBtn.frame.height/2
        // Do any additional setup after loading the view, typically from a nib.
    }


    @IBAction func startBtnPressed(_ sender: Any) {
        let storyboard: UIStoryboard = UIStoryboard(name: "Map", bundle: .main)
        let viewController = storyboard.instantiateViewController(withIdentifier: "MapVC") as! MapVC
        self.present(viewController, animated: true, completion: nil)
    }
    
}

extension SignInVC: UITextFieldDelegate {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func setDelegate(){
        self.guestNameField.delegate = self
    }
    
}

