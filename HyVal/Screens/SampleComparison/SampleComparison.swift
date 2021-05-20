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
    }
    
    // MARK: - Properties
    var presenter: SampleViewPresenterProtocol!
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var viewLayer: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = true
        openPhotoCamera()
        setupView()
        presenter.setTitleFromRealm()
    }
    
    private func setupView() {
        view.bringSubviewToFront(viewLayer)
        self.navigationItem.setHidesBackButton(true, animated: false)
        title = UserDefaults.standard.string(forKey: GlobalConstants.name)
        continueButton.layer.cornerRadius = Constants.buttonRadius
        self.hideKeyboardWhenTappedAround()
        setupTextField()
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
        
        if let image = imageView.image {
            presenter.pressedContinueButton(image: image)
        } else {
            presenter.takePhoto()
        }
    }
    
    deinit {
        print("Bye: \(self) ")
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
