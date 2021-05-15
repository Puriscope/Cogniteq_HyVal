//
//  ColorCell.swift
//  HyVal
//
//  Created by Egor Syrtcov on 5/7/21.
//

import UIKit

final class ColorCell: UICollectionViewCell {
    
    static let identifier = "ColorCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    static func nib() -> UINib {
        return UINib(nibName: "ColorCell", bundle: nil)
    }
    
    func setColor(color: UIColor) {
        backgroundColor = color
    }
}
