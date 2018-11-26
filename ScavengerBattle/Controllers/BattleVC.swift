//
//  BattleVCViewController.swift
//  ScavengerBattle
//
//  Created by Robert Wais on 11/2/18.
//  Copyright © 2018 Robert Wais. All rights reserved.
//

import UIKit

class BattleVC: UIViewController {

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
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        selfHealth = selfHealthView.frame.width
        opponentHealth = opponentHealthView.frame.width

        setComputer()
        setHealth()
        // Do any additional setup after loading the view.
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
    
    func lowerHealthEnemy(){
        opponentHealth -= 25
        actualHealthOpponent?.removeFromSuperview()
        actualHealthOpponent = UIView(frame: CGRect(x: 0, y: 0, width: opponentHealth, height: opponentHealthView.frame.height))
        actualHealthOpponent?.backgroundColor = UIColor.red
        opponentHealthView.addSubview(actualHealthOpponent!)
        checkHealth()
    }
    
    func lowerHealthSelf(){
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
        }else if(selfHealth <= 0){
            //Opponent Wins
        }
    }
    
}
