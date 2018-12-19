//
//  ViewController.swift
//  ScavengerBattle
//
//  Created by Robert Wais on 10/23/18.
//  Copyright © 2018 Robert Wais. All rights reserved.
//

import UIKit
import FirebaseDatabase

class SignInVC: UIViewController {

    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var OpponentSelector: UISegmentedControl!
    @IBOutlet weak var guestNameField: UITextField!
    @IBOutlet weak var startBtn: UIButton!
    var ref:DatabaseReference!
    var usersWaiting = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.layer.cornerRadius = 10
        
        ref = Database.database().reference().child("Pool")
        
        
        startBtn.layer.borderWidth = 2.0
        startBtn.layer.borderColor = UIColor.white.cgColor
        startBtn.layer.cornerRadius = startBtn.frame.height/2
        setObservers()
        
        
        tableView.separatorColor = Constants.Colors.baseColor
       
        
        // Do any additional setup after loading the view, typically from a nib.
    }


    @IBAction func startBtnPressed(_ sender: Any) {
        let storyboard: UIStoryboard = UIStoryboard(name: "Map", bundle: .main)
        let viewController = storyboard.instantiateInitialViewController()!
        self.show(viewController, sender: self)
    }
    
    @IBAction func opponentSelected(_ sender: UISegmentedControl) {
        //0 - Computer
        //1 - Plyaer
        if sender.selectedSegmentIndex == 0{
            tableView.isHidden = true
            ref.child("testId").setValue(nil)
        }else if sender.selectedSegmentIndex == 1{
            tableView.isHidden = false
            let user: [String:Any] = ["testId": ["id": "1",
                                                  "username":"CurrentUser"]]
            ref.updateChildValues(user)
        }
    }
    
    //Waiting for the user.. this would have been implemented more
    //for multiplayer
    func setObservers(){
        ref.observe(DataEventType.childAdded) { (data) in
            if let user = User(snapshot: data){
                self.usersWaiting.append(user)
                self.tableView.reloadData()
            }else{
                //No Values
                print("Error")
            }
        }
        
        ref.observe(DataEventType.childRemoved) { (data) in
            //If there is a user here delete it
            if let user = User(snapshot: data){
                
                for index in 0..<self.usersWaiting.count{
                    if self.usersWaiting[index].id == user.id {
                        self.usersWaiting.remove(at: index)
                        break
                    }
                }
                self.tableView.reloadData()
            }else{
                //No Values
                print("Error")
            }
        }
    }
    
    
}

//Closing the keyboard on other touches
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

extension SignInVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "userCell") as! UserCell
        cell.configureCell(name: usersWaiting[indexPath.row].username)
        
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usersWaiting.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}

