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
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func attackBtnPressed(_ sender: Any) {
    }
    
    
}
