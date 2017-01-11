//
//  CardCollectionViewCell.swift
//  WordMatch
//
//  Created by Mookyung Kwak on 2017-01-09.
//  Copyright © 2017 Mookyung Kwak. All rights reserved.
//

import UIKit

class CardCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var word: UILabel?
    @IBOutlet weak var questionMark: UIImageView?
    
    var theWord: String? {
        didSet {
            self.word?.text = self.theWord
        }
    }
    
    var isCleared: Bool = false
    
    
    func flipCardAnimation(isForward: Bool) {
        if isForward {
            UIView.transition(with: self.contentView, duration: 0.5, options: .transitionFlipFromLeft, animations: {
                self.questionMark?.isHidden = true
                self.word?.isHidden = false
            }) { (finished) in
                
            }
        } else {
            UIView.transition(with: self.contentView, duration: 0.5, options: .transitionFlipFromLeft, animations: {
                self.questionMark?.isHidden = false
                self.word?.isHidden = true
            }) { (finished) in
                
            }
        }
    }
}
