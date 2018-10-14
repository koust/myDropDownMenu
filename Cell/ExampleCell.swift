//
//  ExampleCell.swift
//  myDropDownMenu
//
//  Created by Batuhan Saygili on 13.10.2018.
//  Copyright © 2018 koust. All rights reserved.
//

import UIKit

class ExampleCell: UITableViewCell {

    @IBOutlet weak var cellTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
