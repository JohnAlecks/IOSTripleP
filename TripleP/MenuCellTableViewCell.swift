//
//  MenuCellTableViewCell.swift
//  TripleP
//
//  Created by John Whisker on 2/21/17.
//  Copyright © 2017 John Whisker. All rights reserved.
//

import UIKit

class MenuCellTableViewCell: UITableViewCell {

    
    @IBOutlet weak var indicator: UIImageView!
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var label: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
       
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
      
    }
    

}
