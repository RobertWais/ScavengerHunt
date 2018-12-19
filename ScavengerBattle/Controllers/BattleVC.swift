//
//  BattleVCViewController.swift
//  ScavengerBattle
//
//  Created by Robert Wais on 11/2/18.
//  Copyright © 2018 Robert Wais. All rights reserved.
//

import UIKit

protocol  SetWeaponDelegate: class {
    func assignWeapon(weapon: Item)
}

class BattleVC: UIViewController,SetWeaponDelegate {
    

//    //Top of View Controller
//    @IBOutlet weak var selfLbl: UILabel!
//    @IBOutlet weak var opponentLbl: UILabel!
    
    //Health Labels
    @IBOutlet weak var selfLblHealth: UILabel!
    @IBOutlet weak var opponentLblHealth: UILabel!
    @IBOutlet weak var selfHealthLblNumber: UILabel!
    
    @IBOutlet weak var damageDoneLbl: UILabel!
    @IBOutlet weak var opponentHealthLblNumber: UILabel!
    //HealthBars
    @IBOutlet weak var selfHealthView: UIView!
    @IBOutlet weak var opponentHealthView: UIView!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var attackBtn: UIButton!
    
    var actualHealthSelf: UIView?
    var actualHealthOpponent: UIView?
    
    var selfHealth: CGFloat = 0.0
    var opponentHealth: CGFloat = 0.0
    
    var playerWeapon = Item(name: "Default", damage: 0.0, criticalDamage: 0.0 )
    var move = 0
    
    var duplicates = Set<String>()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Dont let the player attack first
        attackBtn.isEnabled = false
        
        //Setting Health
        selfHealth = selfHealthView.frame.width
        opponentHealth = opponentHealthView.frame.width

        setComputer()
        setHealth()
        
        //playGame
        damageDoneLbl.text = "Computer's Turn"
        computerRound()
        // Do any additional setup after loading the view.
        
    }
    
    //Set Weapon Delegate
    func assignWeapon(weapon: Item) {
        playerWeapon = weapon
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5){
            self.lowerHealthEnemy(weapon: self.playerWeapon)
            self.updateNumbers()
            self.attackBtn.isEnabled = false
        }
    }
    
    func setComputer(){
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
        var realDamage = weapon.damage
        var num = arc4random_uniform(10)+1
        if(num == 1){
            realDamage = weapon.criticalDamage
            damageDoneLbl.text = "Critical Attack \(realDamage) damage inflicted on computer"
        }else{
            damageDoneLbl.text = "\(realDamage) damage inflicted on computer"
        }
        
        opponentHealth -= CGFloat(realDamage)
        actualHealthOpponent?.removeFromSuperview()
        if opponentHealth < 0{
            opponentHealth = 0
        }
        actualHealthOpponent = UIView(frame: CGRect(x: 0, y: 0, width: opponentHealth, height: opponentHealthView.frame.height))
        actualHealthOpponent?.backgroundColor = UIColor.red
        opponentHealthView.addSubview(actualHealthOpponent!)
        
        if self.checkHealth() != true{
            self.endGame()
            return
        }else{
            computerRound()
        }
    }
    
    func lowerHealthSelf(weapon: Item){
        //Check for critical
        var realDamage = weapon.damage
        var num = arc4random_uniform(10)+1
        if(num == 1){
            realDamage = weapon.criticalDamage
            damageDoneLbl.text = "Critical Attack: \(realDamage) damage done to you"
        }else{
            damageDoneLbl.text = "\(realDamage) damage done to you"
        }
        
        selfHealth -= CGFloat(realDamage)
        actualHealthSelf?.removeFromSuperview()
        if selfHealth < 0{
            selfHealth = 0
        }
        actualHealthSelf = UIView(frame: CGRect(x: 0, y: 0, width: selfHealth, height: selfHealthView.frame.height))
        actualHealthSelf?.backgroundColor = UIColor.red
        selfHealthView.addSubview(actualHealthSelf!)
        
        if self.checkHealth() != true{
            self.endGame()
            return
        }else{
            playerRound()
        }
    }

    @IBAction func attackBtnPressed(_ sender: Any) {
        playerMove()
    }
    
    func checkHealth() -> Bool{
        if (opponentHealth <= 0) {
            //Self wins
            return false
        }else if(selfHealth <= 0){
            //Opponent Wins
            return false
        }
        return true
    }
    func playerRound(){
        //Enable Attack Button
        attackBtn.isEnabled = true
    }
    
    func computerRound(){
        //Wait a second for computer to attack
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.computerMove()
            self.updateNumbers()
        }
        self.playerRound()

    }
    
    //First gameplay option
    func round(_ move: Int){
        if move == 0 {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.computerMove()
                if self.checkHealth() != true{
                    self.endGame()
                    return
                }else{
                    self.round(1)
                }
            }
        }else if move == 1{
            
        }
    }
    
    //TODO: Change random attacks
    func computerMove(){
        //Randomize Weapon
        //Attack the user
        var num = arc4random_uniform(3)+1;
        var stringChoice = ""
        switch num {
        case 1:
            stringChoice = "1"
        case 2:
            stringChoice = "2"
        case 3:
            stringChoice = "3"
        default:
            stringChoice = "1"
        }
        let weapon = Constants.Arsenal.totalItems[stringChoice]
        lowerHealthSelf(weapon: weapon!)
    }
    
    func playerMove(){
        //Allow player to grab weapon
        //Present Modal Controller
        let storyboard: UIStoryboard = UIStoryboard(name: "Map", bundle: .main)
        let modalVC = storyboard.instantiateViewController(withIdentifier: "BagModalVC") as! BagModalVC
        modalVC.modalPresentationStyle = .overCurrentContext
        modalVC.sender = 1
        modalVC.delegate = self
        present(modalVC, animated: true)
    }
    
    func endGame(){
        //Remove items for New Game
        Constants.Arsenal.items.removeAll(keepingCapacity: false)
        var gameResult = ""
        if (opponentHealth <= 0) {
            gameResult = "You have won!"
            damageDoneLbl.text = "You have won"
        }else{
            self.damageDoneLbl.text = "You have have lost..."
            gameResult = "You have lost..."
        }
        
        let alert = UIAlertController(title: "\(gameResult)",
                                      message: "You will now return to the main screen",
                                      preferredStyle: .alert)
        
        
        let cancel = UIAlertAction(title: "Back to main Menu", style: .destructive, handler: { (action) -> Void in
            //Re-route to main controller
            self.presentingViewController?.dismiss(animated: false, completion: nil)
        })
        alert.addAction(cancel)
        present(alert, animated: true)
    }
    
    func updateNumbers(){
        selfHealthLblNumber.text = String(describing: selfHealth)
        opponentHealthLblNumber.text = String(describing: opponentHealth)
    }
}
