//
//  ResultCell.swift
//  HyVal
//
//  Created by Egor Syrtcov on 5/7/21.
//

import UIKit

final class ResultCell: UITableViewCell {
    
    static let identifier = "ResultCell"
    
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var pstUnits: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
      
    }
    
    static func nib() -> UINib {
        return UINib(nibName: "ResultCell", bundle: nil)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setupLocation(location: LocationModel) {
        self.location.text = "\(location.location) \(location.sampleName)"
        self.pstUnits.text = "\(location.pstUnit) PST units"
    }
}
