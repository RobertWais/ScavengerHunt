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
    
    //Access to which weapon has been selected
    //0 - From MapVC
    //1 - From BattleVC
    var sender = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        setDelegates()
        
        let cancelGesture = UITapGestureRecognizer(target: self, action: #selector(cancel))
        // Do any additional setup after loading the view.
        self.view.addGestureRecognizer(cancelGesture)
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
        
        cell.configureCell(item: Item(name: "Axe", damage: Double(indexPath.row*10)))
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func setDelegates(){
        tableView.delegate = self
        tableView.dataSource = self
    }
}
