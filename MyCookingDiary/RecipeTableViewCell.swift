//
//  RecipeTableViewCell.swift
//  MyCookingDiary
//
//  Created by Nhi Cung on 5/2/21.
//  Copyright © 2021 Nhi Cung. All rights reserved.
//

import UIKit

class RecipeTableViewCell: UITableViewCell {
    @IBOutlet weak var recipeImg: UIImageView!
    @IBOutlet weak var recipeTitle: UILabel!
    @IBOutlet weak var btnLike: UIButton!
    @IBOutlet weak var rateRep: UILabel!
    
    var isChecked = true
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
