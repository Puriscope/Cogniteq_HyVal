//
//  BlankComparison.swift
//  HyVal
//
//  Created by Egor Syrtcov on 4/28/21.
//

import UIKit

final class BlankComparison: UIViewController {
    
    // MARK: - Constants
    
    private struct Constants {
        static let buttonRadius: CGFloat = 10
    }
    
    // MARK: - Properties
    var presenter: BlankViewPresenterProtocol!
    
    @IBOutlet weak var viewColor: UIView!
    @IBOutlet private weak var takePhotoButton: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    private func setupView() {
        self.navigationItem.setHidesBackButton(true, animated: false)
        title = "Blank comparison"
        takePhotoButton.layer.cornerRadius = Constants.buttonRadius
        viewColor.backgroundColor = UIColor.pink()
    }
    
    // MARK: - Action
    
    @IBAction private func takePhotoAction(_ sender: UIButton) {
        presenter.takePhoto()
    }
    
    deinit {
        print("Bye: \(self) ")
    }
}

extension BlankComparison: BlankViewProtocol {
    
    func presentAlert() {
        alert(message: "", title: "Simulator has no camera")
    }
    
    func presentImagePickerController(_ pickerController: UIImagePickerController) {
        pickerController.delegate = self
        self.present(pickerController, animated: true)
    }
}

extension BlankComparison: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else { return }
        
        presenter.pushAriaCompare(photoCameraImage: image)
    }
}
