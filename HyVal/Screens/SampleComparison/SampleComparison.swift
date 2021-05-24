//
//  SampleComparison.swift
//  HyVal
//
//  Created by Egor Syrtcov on 5/3/21.
//

import UIKit

class SampleComparison: UIViewController {
    
    // MARK: - Constants
    
    private struct Constants {
        static let buttonRadius: CGFloat = 10
        static let borderForPickerView: CGFloat = 3
        static let colorForPickerView = UIColor.red.cgColor
    }
    
    // MARK: - Properties
    var presenter: SampleViewPresenterProtocol!
    
    @IBOutlet weak var pickerView: UIView!
    @IBOutlet weak var viewForImage: UIView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var viewLayer: UIView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        openPhotoCamera()
        setupView()
        presenter.setTitleFromRealm()
    }
    
    private func setupView() {
        self.navigationController?.isNavigationBarHidden = true
        view.bringSubviewToFront(viewLayer)
        self.navigationItem.setHidesBackButton(true, animated: false)
        title = UserDefaults.standard.string(forKey: GlobalConstants.name)
        continueButton.layer.cornerRadius = Constants.buttonRadius
        self.hideKeyboardWhenTappedAround()
        setupTextField()
        
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanPressGesture))
        
        pickerView.addGestureRecognizer(gesture)
        pickerView.layer.borderWidth = Constants.borderForPickerView
        pickerView.layer.borderColor = Constants.colorForPickerView
        pickerView.backgroundColor = .clear
        imageView.addSubview(pickerView)
    }
    
    private func setupTextField() {
        textField.layer.cornerRadius = Constants.buttonRadius
        textField.layer.borderColor = UIColor.black.cgColor
        textField.layer.borderWidth = 1
        textField.clipsToBounds = true
        textField.leftView = UIView(frame: CGRect(x: 20, y: 0, width: 20, height: textField.frame.height))
        textField.leftViewMode = .always
        textField.attributedPlaceholder = NSAttributedString(string: "Enter sample name",
                                                             attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
        textField.delegate = self
        textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }
    
    private func openPhotoCamera() {
        presenter.takePhoto()
    }
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        presenter.saveSampleName(textField)
    }
    
    @IBAction func continueButtonAction(_ sender: UIButton) {
        
        if imageView.image != nil {
            presenter.pressedContinueButton(pickerView: pickerView, imageView: imageView)
        } else {
            presenter.takePhoto()
        }
    }
    
    deinit {
        print("Bye: \(self) ")
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
}

extension SampleComparison: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        presenter.saveSampleName(textField)
        return true
    }
}

extension SampleComparison: SampleViewProtocol {
    
    func setTitle(_ titleRoom: String) {
        title = titleRoom
    }
    
    func presentAlert() {
        alert(message: "", title: "Enter your sample name")
    }
    
    func presentImagePickerController(_ pickerController: UIImagePickerController) {
        pickerController.delegate = self
        self.present(pickerController, animated: true)
    }
    
    func showSpinner() {
        spinner.isHidden = false
    }
    
    func hideSpinner() {
        spinner.isHidden = true
    }
}

extension SampleComparison: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        picker.dismiss(animated: true, completion: nil)
        
        showBackround(viewLayer, navigationController)
        
        guard let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else { return }
        imageView.image = image
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
        showBackround(viewLayer, navigationController)
    }
    
    private func showBackround(_ view: UIView, _ navigationController: UINavigationController?) {
        view.removeFromSuperview()
        navigationController?.isNavigationBarHidden = false
    }
}
