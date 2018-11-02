//
//  UserCell.swift
//  ScavengerBattle
//
//  Created by Robert Wais on 11/1/18.
//  Copyright © 2018 Robert Wais. All rights reserved.
//

import UIKit

class UserCell: UITableViewCell {

    @IBOutlet weak var UsernameLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(name: String){
        self.UsernameLbl.text = name
    }

}
