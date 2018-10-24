//
//  PowerUpCell.swift
//  ScavengerBattle
//
//  Created by Robert Wais on 10/24/18.
//  Copyright © 2018 Robert Wais. All rights reserved.
//

import UIKit

class PowerUpCell: UITableViewCell {

    @IBOutlet weak var discardButton: UIButton!
    @IBOutlet weak var damageName: UILabel!
    @IBOutlet weak var itemName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(name: String, damage: Double){
        self.itemName.text = name
        self.damageName.text = String(describing: damage)
    }

}
