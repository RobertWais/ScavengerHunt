//
//  BattleVCViewController.swift
//  ScavengerBattle
//
//  Created by Robert Wais on 11/2/18.
//  Copyright © 2018 Robert Wais. All rights reserved.
//

import UIKit

protocol  SetWeapon: class {
    func assignWeapon(weapon: Item)
}

class BattleVC: UIViewController,SetWeapon {
    

    //Top of View Controller
    @IBOutlet weak var selfLbl: UILabel!
    @IBOutlet weak var opponentLbl: UILabel!
    
    //Health Labels
    @IBOutlet weak var selfLblHealth: UILabel!
    @IBOutlet weak var opponentLblHealth: UILabel!
    
    //HealthBars
    @IBOutlet weak var selfHealthView: UIView!
    @IBOutlet weak var opponentHealthView: UIView!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var attackBtn: UIButton!
    
    var actualHealthSelf: UIView?
    var actualHealthOpponent: UIView?
    
    var selfHealth: CGFloat = 0.0
    var opponentHealth: CGFloat = 0.0
    
    var playerWeapon = Item(name: "Default", damage: 0.0)
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        selfHealth = selfHealthView.frame.width
        opponentHealth = opponentHealthView.frame.width

        setComputer()
        setHealth()
        
        //playGame
        // Do any additional setup after loading the view.
    }
    
    //Set Weapon Delegate
    func assignWeapon(weapon: Item) {
        playerWeapon = weapon
    }
    
    func setComputer(){
        opponentLbl.text = "Computer"
        opponentLblHealth.text = "Computer"
    }
    
    func setHealth(){
        //Own Health
        actualHealthSelf = UIView(frame: CGRect(x: 0, y: 0, width: selfHealthView.frame.width, height: selfHealthView.frame.height))
        actualHealthSelf?.backgroundColor = UIColor.green
        selfHealthView.addSubview(actualHealthSelf!)
        
        //Opponent Health
        actualHealthOpponent = UIView(frame: CGRect(x: 0, y: 0, width: opponentHealthView.frame.width, height: opponentHealthView.frame.height))
        actualHealthOpponent?.backgroundColor = UIColor.green
        opponentHealthView.addSubview(actualHealthOpponent!)
    }
    
    func lowerHealthEnemy(weapon: Item){
        opponentHealth -= 25
        actualHealthOpponent?.removeFromSuperview()
        actualHealthOpponent = UIView(frame: CGRect(x: 0, y: 0, width: opponentHealth, height: opponentHealthView.frame.height))
        actualHealthOpponent?.backgroundColor = UIColor.red
        opponentHealthView.addSubview(actualHealthOpponent!)
        checkHealth()
    }
    
    func lowerHealthSelf(weapon: Item){
        selfHealth -= 25
        actualHealthSelf?.removeFromSuperview()
        actualHealthSelf = UIView(frame: CGRect(x: 0, y: 0, width: selfHealth, height: selfHealthView.frame.height))
        actualHealthSelf?.backgroundColor = UIColor.red
        selfHealthView.addSubview(actualHealthSelf!)
        checkHealth()
    }

    @IBAction func attackBtnPressed(_ sender: Any) {
    }
    
    func checkHealth(){
        if (opponentHealth <= 0) {
            //Self wins
            endGame(result: 0)
        }else if(selfHealth <= 0){
            //Opponent Wins
            endGame(result: 1)
        }
    }
    
    func game(){
        //0: Computer
        //1: Player
        var move = 0
        while(opponentHealth > 0 && selfHealth > 0){
            //If 0
            if move == 0 {
                computerMove()
            }else if move == 1{
                playerMove()
            }
        }
        checkHealth()
    }
    
    func computerMove(){
        //Randomize Weapon
        //Attack the user
        
        let item = Item(name: "Change", damage: 1.0)
        lowerHealthSelf(weapon: item)
    }
    
    func playerMove(){
        //Allow player to grab weapon
        //Present Modal Controller
        let modalVC = storyboard?.instantiateViewController(withIdentifier: "BagModalVC") as! BagModalVC
        modalVC.modalPresentationStyle = .overCurrentContext
        present(modalVC, animated: true,completion: nil)
        
        
        let item = Item(name: "Change", damage: 1)
        lowerHealthEnemy(weapon: item)
    }
    
    func endGame(result: Int){
        var gameResult = ""
        if result == 0 {
            gameResult = "You have won!"}
        else{
            gameResult = "You have lost..."
        }
        
        let alert = UIAlertController(title: "\(gameResult)",
                                      message: "You will now return to the main screen",
                                      preferredStyle: .alert)
        
        let cancel = UIAlertAction(title: "Back to main Menu", style: .destructive, handler: { (action) -> Void in
            //Re-route to controller
        })
        alert.addAction(cancel)
        
    }
}
