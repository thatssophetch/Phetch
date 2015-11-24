//
//  GroceryTableViewCell.swift
//  Phetch
//
//  Created by y2bd on 11/19/15.
//  Copyright © 2015 phetch. All rights reserved.
//

import UIKit

class GroceryTableViewCell: UITableViewCell {

    // MARK: properties
    
    @IBOutlet weak var itemName: UILabel!
    @IBOutlet weak var itemCount: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setFrom(item:Grocery) {
        itemName.text = item.name
        itemCount.text = String(item.count)
    }

}
