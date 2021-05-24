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
    func pressedContinueButton(pickerView: UIView, imageView: UIImageView)
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
    
    func pressedContinueButton(pickerView: UIView, imageView: UIImageView) {
        
        if textFieldSampleName == nil || textFieldSampleName?.isEmpty == true {
            self.view?.presentAlert()
        } else {
            guard let sampleName = textFieldSampleName else { return }
            realmManager.updateModel(sampleName: sampleName)
            
            let pickerAbsoluteFrame = pickerView.convert(pickerView.bounds, to: imageView)
            
            let im1 = imageWithView(view: imageView)
            guard let im2 = im1?.crop(rect: pickerAbsoluteFrame) else { return }
            
            applyColorDiffToPicture(image: im2)
        }
    }
    
    func imageWithView(view: UIView) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.isOpaque, 0.0)
        defer { UIGraphicsEndImageContext() }
        view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
    func applyColorDiffToPicture(image: UIImage) {
        
        guard let diffColorModelWithRealm = realmManager.getColorDiff() else { return }
        
        var targetCoefR: CGFloat = 0
        var targetCoefG: CGFloat = 0
        var targetCoefB: CGFloat = 0
        var targetCoefAlpha: CGFloat = 0
        
        guard let image = image.averageColor else { return }
        image.getRed(&targetCoefR, green: &targetCoefG, blue: &targetCoefB, alpha: &targetCoefAlpha)
        
        let resultR = targetCoefR * CGFloat(diffColorModelWithRealm.diffR)
        let resultG = targetCoefG * CGFloat(diffColorModelWithRealm.diffG)
        let resultB = targetCoefB * CGFloat(diffColorModelWithRealm.diffB)
        let resultColor = UIColor(displayP3Red: resultR, green: resultG, blue: resultB, alpha: targetCoefAlpha)
        
        router?.showColorsManually(color: resultColor)
    }
}
