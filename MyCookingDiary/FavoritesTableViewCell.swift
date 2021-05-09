//
//  FavoritesTableViewCell.swift
//  MyCookingDiary
//
//  Created by Nhi Cung on 5/3/21.
//  Copyright © 2021 Nhi Cung. All rights reserved.
//

import UIKit

class FavoritesTableViewCell: UITableViewCell {
  
    @IBOutlet weak var favImage: UIImageView!
    @IBOutlet weak var faveTitle: UILabel!
    @IBOutlet weak var rateFav: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
