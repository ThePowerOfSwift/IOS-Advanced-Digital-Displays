//
//  CustomNewReviewTableViewCell.swift
//  test-push-app
//
//  Created by Keegan Cruickshank on 28/3/17.
//  Copyright © 2017 Keegan Cruickshank. All rights reserved.
//

import UIKit

class CustomNewReviewTableViewCell: UITableViewCell {

    @IBOutlet weak var title: UILabel!
    
    @IBOutlet weak var userEmail: UILabel!
    
    @IBOutlet weak var adDescription: UILabel!
    
    @IBOutlet weak var verified: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
