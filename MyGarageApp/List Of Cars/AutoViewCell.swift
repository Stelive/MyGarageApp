//
//  AutoViewCell.swift
//  MyGarageApp
//
//  Created by Stefano Pedroli on 27/06/17.
//  Copyright © 2017 Stefano Pedroli. All rights reserved.
//

import UIKit

class AutoViewCell: UITableViewCell {

    @IBOutlet weak var autoName: UILabel!
    @IBOutlet weak var autoModel: UILabel!
    @IBOutlet weak var imgAuto: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
   
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
