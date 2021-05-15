//
//  AriaComparePresenter.swift
//  HyVal
//
//  Created by Egor Syrtcov on 4/29/21.
//

import UIKit

protocol AriaCompareViewProtocol: class {
    func setImage(photoCameraImage: UIImage)
    func setTitle(_ roomName: String)
}

protocol AriaCompareViewPresenterProtocol: class {
    
    init(view: AriaCompareViewProtocol,
         router: RouterProtocol,
         photoCameraImage: UIImage)
    
    func setImage()
    func drawRectangle(gesture: UIPanGestureRecognizer,
                       imageView: UIImageView,
                       pickerView: UIView) -> UIPanGestureRecognizer
    func getColorForPickerView(pickerView: UIView, imageView: UIImageView)
    func setTitleFromRealm()
}

final class AriaComparePresenter: AriaCompareViewPresenterProtocol {
    
    private weak var view: AriaCompareViewProtocol?
    private var router: RouterProtocol?
    private let photoCameraImage: UIImage
    private let hardColor = UIColor.pink() // Master colour blank
    private let realmManager: RealmManager = RealmManagerImp()
    private var location = [LocationModel]()
    
    required init(view: AriaCompareViewProtocol,
                  router: RouterProtocol,
                  photoCameraImage: UIImage) {
        
        self.view = view
        self.router = router
        self.photoCameraImage = photoCameraImage
    }
    
    func setImage() {
        view?.setImage(photoCameraImage: photoCameraImage)
    }
    
    func setTitleFromRealm() {
        location = realmManager.getLocation()
        guard let roomName = location.last?.location else { return }
        view?.setTitle(roomName)
    }
    
    func drawRectangle(gesture: UIPanGestureRecognizer,
                       imageView: UIImageView,
                       pickerView: UIView) -> UIPanGestureRecognizer {
        
        let point = gesture.location(in: imageView)
        
        let pickerHeight: CGFloat = pickerView.bounds.height
        let pickerWidth : CGFloat = pickerView.bounds.height
        
        let superBounds = CGRect(x: imageView.bounds.origin.x + pickerHeight,
                                 y: imageView.bounds.origin.y + pickerHeight,
                                 width: imageView.bounds.size.width - 2*pickerWidth,
                                 height: imageView.bounds.size.height - 2*pickerHeight)
        
        if (superBounds.contains(point)) {
            let translation = gesture.translation(in: imageView)
            gesture.view!.center = CGPoint(x: gesture.view!.center.x + translation.x,
                                           y: gesture.view!.center.y + translation.y)
        }
        return gesture
    }
    
    func getColorForPickerView(pickerView: UIView, imageView: UIImageView){
        let pickerAbsoluteFrame = pickerView.convert(pickerView.bounds, to: imageView)
        let im1 = imageWithView(view: imageView)
        let im2 = im1?.crop(rect: pickerAbsoluteFrame)
        
        var hardCoefR: CGFloat = 0
        var hardCoefG: CGFloat = 0
        var hardCoefB: CGFloat = 0
        hardColor.getRed(&hardCoefR, green: &hardCoefG, blue: &hardCoefB, alpha: nil)
        
        var targetCoefR: CGFloat = 0
        var targetCoefG: CGFloat = 0
        var targetCoefB: CGFloat = 0
        im2!.averageColor!.getRed(&targetCoefR, green: &targetCoefG, blue: &targetCoefB, alpha: nil)
        
        var diffR = hardCoefR / targetCoefR
        if diffR == 0 {
            diffR = 1
        }
        var diffG = hardCoefG / targetCoefG
        if diffG == 0 {
            diffG = 1
        }
        var diffB = hardCoefB / targetCoefB
        if diffB == 0 {
            diffB = 1
        }
        
        let colorDiff = ColorDiffModel()
        colorDiff.diffR = Float(diffR)
        colorDiff.diffG = Float(diffG)
        colorDiff.diffB = Float(diffB)
        
        realmManager.save(colorDiff: colorDiff)
        
        router?.showSampleViewController()
    }
    
    func imageWithView(view: UIView) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.isOpaque, 0.0)
        defer { UIGraphicsEndImageContext() }
        view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}
