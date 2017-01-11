//
//  WordTableViewCell.swift
//  WordMatch
//
//  Created by Mookyung Kwak on 2017-01-10.
//  Copyright © 2017 Mookyung Kwak. All rights reserved.
//

import UIKit

class WordTableViewCell: UITableViewCell {
    
    @IBOutlet weak var selectedCount: UILabel?
    @IBOutlet weak var spelling: UILabel?
    @IBOutlet weak var selectableButton: UIButton?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func selectButtonTapped(sender: UIButton) {
        WordHelper.toggleSelectable(spelling: spelling!.text!)
    }
}
