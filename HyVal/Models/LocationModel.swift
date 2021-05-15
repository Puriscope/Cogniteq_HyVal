//
//  LocationModel.swift
//  HyVal
//
//  Created by Egor Syrtcov on 5/6/21.
//

import Foundation
import RealmSwift

@objcMembers
class LocationModel: Object {
    
    dynamic var location   = String()
    dynamic var sampleName = String()
    dynamic var pstUnit    = Int()
}
