//
//  AreaCompare.swift
//  HyVal
//
//  Created by Egor Syrtcov on 4/28/21.
//

import UIKit

final class AreaCompare: UIViewController {
    
    // MARK: - Constants
    
    private struct Constants {
        static let buttonRadius: CGFloat = 10
        static let borderForPickerView: CGFloat = 3
        static let colorForPickerView = UIColor.red.cgColor
    }
    
    var presenter: AriaCompareViewPresenterProtocol!
    
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var pickerView: UIView!
    @IBOutlet private weak var continueButton: UIButton!
    @IBOutlet private weak var viewForImage: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        presenter.setImage()
        presenter.setTitleFromRealm()
    }
    
    private func setup() {
        self.navigationItem.setHidesBackButton(true, animated: false)
        title = UserDefaults.standard.string(forKey: GlobalConstants.name)
        continueButton.layer.cornerRadius = Constants.buttonRadius
        
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanPressGesture))
        
        pickerView.addGestureRecognizer(gesture)
        pickerView.layer.borderWidth = Constants.borderForPickerView
        pickerView.layer.borderColor = Constants.colorForPickerView
        pickerView.backgroundColor = .clear
        imageView.addSubview(pickerView)
    }
    
    // MARK: - Action
    @IBAction private func continueButtonAction(_ sender: UIButton) {
        presenter.getColorForPickerView(pickerView: pickerView, imageView: imageView)
    }
    
    @objc private func handlePanPressGesture(_ sender: UIPanGestureRecognizer) {
        
        let translation = sender.translation(in: viewForImage)
        guard let superview = pickerView.superview else { return }
        var xOffset: CGFloat = 0
        var yOffset: CGFloat = 0
        
        if pickerView.center.x + translation.x <= pickerView.frame.width {
            xOffset = pickerView.frame.width
        } else if pickerView.center.x + translation.x > superview.frame.width - pickerView.frame.width {
            xOffset = superview.frame.width - pickerView.frame.width
        } else {
            xOffset = pickerView.center.x + translation.x
        }
        
        if pickerView.center.y + translation.y <= pickerView.frame.height {
            yOffset = pickerView.frame.height
        } else if pickerView.center.y + translation.y > superview.frame.height - pickerView.frame.height {
            yOffset = superview.frame.height - pickerView.frame.height
        } else {
            yOffset = pickerView.center.y + translation.y
        }
        
        pickerView.center = CGPoint(x: xOffset, y: yOffset)
        sender.setTranslation(.zero, in: viewForImage)
    }
    
    deinit {
        print("Bye: \(self) ")
    }
}

extension AreaCompare: AriaCompareViewProtocol {
    func setImage(photoCameraImage: UIImage) {
        imageView.image = photoCameraImage
    }
    
    func setTitle(_ roomName: String) {
        title = roomName
    }
}
