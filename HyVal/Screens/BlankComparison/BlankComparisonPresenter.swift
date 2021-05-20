//
//  BlankComparisonPresenter.swift
//  HyVal
//
//  Created by Egor Syrtcov on 4/29/21.
//

import UIKit

protocol BlankViewProtocol: class {
    func presentAlert()
    func presentImagePickerController(_ pickerController: UIImagePickerController)
}

protocol BlankViewPresenterProtocol: class {
    init(view: BlankViewProtocol, router: RouterProtocol)
    
    func takePhoto()
    func pushAriaCompare(photoCameraImage: UIImage)
}

final class BlankComparisonPresenter: BlankViewPresenterProtocol {
    
    private weak var view: BlankViewProtocol?
    private var router: RouterProtocol?
    
    required init(view: BlankViewProtocol, router: RouterProtocol) {
        self.view = view
        self.router = router
    }
    
    func takePhoto() {
//        let imagePicker = UIImagePickerController()
//        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
//            imagePicker.sourceType = .camera
//            imagePicker.allowsEditing = true
//            view?.presentImagePickerController(imagePicker)
//        } else {
//            view?.presentAlert()
//        }
        
        router?.showAriaCompareViewController(photoCameraImage: UIImage(named: "blank")!)
        
    }
    
    func pushAriaCompare(photoCameraImage: UIImage) {
        router?.showAriaCompareViewController(photoCameraImage: photoCameraImage)
    }
}

