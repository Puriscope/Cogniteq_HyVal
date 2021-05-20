//
//  SampleComparisonPresenter.swift
//  HyVal
//
//  Created by Egor Syrtcov on 5/3/21.
//

import UIKit

protocol SampleViewProtocol: class {
    
    func setTitle(_ titleRoom: String)
    func presentAlert()
    func presentImagePickerController(_ pickerController: UIImagePickerController)
    func showSpinner()
    func hideSpinner()
}

protocol SampleViewPresenterProtocol: class {
    
    init(view: SampleViewProtocol, router: RouterProtocol)
    
    func setTitleFromRealm()
    func takePhoto()
    func saveSampleName(_ textField: UITextField)
    func pressedContinueButton(image: UIImage)
}

final class SampleComparisonPresenter: SampleViewPresenterProtocol {
    
    private weak var view: SampleViewProtocol?
    private var router: RouterProtocol?
    private let realmManager: RealmManager = RealmManagerImp()
    private var location = [LocationModel]()
    private var textFieldSampleName: String?
    
    required init(view: SampleViewProtocol, router: RouterProtocol) {
        self.view = view
        self.router = router
    }
    
    func setTitleFromRealm() {
        location = realmManager.getLocation()
        guard let titleRoom = location.last?.location else { return }
        view?.setTitle(titleRoom)
    }
    
    func takePhoto() {
        let imagePicker = UIImagePickerController()
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
            imagePicker.sourceType = .camera
            imagePicker.allowsEditing = true
            view?.presentImagePickerController(imagePicker)
        } else {
            view?.presentAlert()
        }
    }
    
    func saveSampleName(_ textField: UITextField) {
        guard let sampleName = textField.text else { return }
        textFieldSampleName = sampleName
    }
    
    func pressedContinueButton(image: UIImage) {
        
        if textFieldSampleName == nil || textFieldSampleName?.isEmpty == true {
            view?.presentAlert()
        } else {
            guard let sampleName = textFieldSampleName else { return }
            realmManager.updateModel(sampleName: sampleName)
            
            applyColorDiffToPicture(image: image)
        }
    }
    
    func applyColorDiffToPicture(image: UIImage) {
        
        guard let diffColorModelWithRealm = realmManager.getColorDiff() else { return }
        
        view?.showSpinner()
        
        let diff = (diffColorModelWithRealm.diffR, diffColorModelWithRealm.diffG, diffColorModelWithRealm.diffB)
        DispatchQueue.global().async {
            print("Run on background thread")
            let newImage = ImageFilter.applyFilter(to: image, diff: diff)
            DispatchQueue.main.async { [weak self] in
                print("We finished that.")
                self?.view?.hideSpinner()
                self?.router?.showColorsManually(image: newImage!)
            }
        }
    }
}
