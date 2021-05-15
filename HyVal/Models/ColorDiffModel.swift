//
//  ColorDiffModel.swift
//  HyVal
//
//  Created by Egor Syrtcov on 5/7/21.
//

import Foundation
import RealmSwift

@objcMembers
class ColorDiffModel: Object {
    
    dynamic var diffR = Float()
    dynamic var diffG = Float()
    dynamic var diffB = Float()
}

