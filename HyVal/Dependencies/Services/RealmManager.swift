//
//  RealmManager.swift
//  HyVal
//
//  Created by Egor Syrtcov on 5/17/21.
//

import Foundation
import RealmSwift

protocol RealmManager {
    func save(location: LocationModel)
    func save(colorDiff: ColorDiffModel)
    func getLocation() -> [LocationModel]
    func getColorDiff() -> ColorDiffModel?
    func updateModel(sampleName: String)
    func updateModel(pst: Int)
    func deleteModel(location: LocationModel)
    func deleteColorDiff()
}

class RealmManagerImp: RealmManager {
    
    fileprivate lazy var mainRealm = try!
        Realm(configuration: .defaultConfiguration)
    
    func save(location: LocationModel) {
        
        try! mainRealm.write {
            mainRealm.add(location)
        }
    }
    
    func save(colorDiff: ColorDiffModel) {
        
        try! mainRealm.write {
            mainRealm.add(colorDiff)
        }
    }
    
    func getLocation() -> [LocationModel] {
        let locations = mainRealm.objects(LocationModel.self)
        return Array(locations)
    }
    
    func getColorDiff() -> ColorDiffModel? {
        let colors = mainRealm.objects(ColorDiffModel.self)
        let color = colors.last
        return color
    }
    
    func updateModel(sampleName: String) {
        let locations = mainRealm.objects(LocationModel.self)
        
        try! mainRealm.write {
            locations.last?.setValue(sampleName, forKey: #keyPath(LocationModel.sampleName))
        }
    }
    
    func updateModel(pst: Int) {
        let locations = mainRealm.objects(LocationModel.self)
        
        try! mainRealm.write {
            locations.last?.setValue(pst, forKey: #keyPath(LocationModel.pstUnit))
        }
    }
    
    func deleteModel(location: LocationModel) {
        
        let locations = mainRealm.objects(LocationModel.self)
        
        guard let location = locations.last else { return }
        
        try! mainRealm.write {
            
            mainRealm.delete(location)
        }
    }
    
    func deleteColorDiff() {
        let diffColor = mainRealm.objects(ColorDiffModel.self)
        
        try! mainRealm.write {
            mainRealm.delete(diffColor)
        }
    }
}
