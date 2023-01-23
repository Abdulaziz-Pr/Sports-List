//
//  playerTableViewCell.swift
//  SportsApp
//
//  Created by admin on 12/13/22.
//

import UIKit
import CoreData

class playerTableViewCell: UITableViewCell {

//MARK: - Outlets
    @IBOutlet weak var player: UILabel!
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
