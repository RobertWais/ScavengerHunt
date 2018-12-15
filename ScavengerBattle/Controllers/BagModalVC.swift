//
//  BagModalVC.swift
//  ScavengerBattle
//
//  Created by Robert Wais on 10/24/18.
//  Copyright © 2018 Robert Wais. All rights reserved.
//

import UIKit

class BagModalVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    weak var delegate: SetWeaponDelegate?
    
    //Access to which weapon has been selected
    //0 - From MapVC
    //1 - From BattleVC
    var sender = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        setDelegates()
        
//        let cancelGesture = UITapGestureRecognizer(target: self, action: #selector(cancel))
//        // Do any additional setup after loading the view.
//        self.view.addGestureRecognizer(cancelGesture)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func cancel(){
        dismiss(animated: true, completion: nil)
    }
}

extension BagModalVC: UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PowerUpId") as! PowerUpCell
        
        cell.configureCell(item: Constants.Arsenal.items[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Constants.Arsenal.items.count
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //From BattleVC
        //Return item that was selected
        print("Selected")
        if sender == 1 {
            delegate?.assignWeapon(weapon: Constants.Arsenal.items[indexPath.row])
            dismiss(animated: false, completion: nil)
        }else{
            //Was from MapVC
            dismiss(animated: false, completion: nil)
        }
    }
    
    func setDelegates(){
        tableView.delegate = self
        tableView.dataSource = self
    }
}
