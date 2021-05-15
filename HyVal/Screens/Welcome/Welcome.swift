//
//  Welcome.swift
//  HyVal
//
//  Created by Egor Syrtcov on 4/28/21.
//

import UIKit

final class Welcome: UIViewController {
    
    // MARK: - Constants
    
    private struct Constants {
        static let buttonRadius: CGFloat = 10
    }
    
    // MARK: - Properties
    var presenter: WelcomeViewPresenterProtocol!
    
    @IBOutlet private weak var textField: UITextField!
    @IBOutlet private weak var saveButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    private func setupView() {
        title = "Welcome to HyVal app!"
        setupTextField()
        self.hideKeyboardWhenTappedAround()
        saveButton.layer.cornerRadius = Constants.buttonRadius
    }
    
    private func setupTextField() {
        textField.layer.cornerRadius = 10
        textField.layer.borderColor = UIColor.black.cgColor
        textField.layer.borderWidth = 1
        textField.clipsToBounds = true
        textField.leftView = UIView(frame: CGRect(x: 20, y: 0, width: 20, height: textField.frame.height))
        textField.leftViewMode = .always
        textField.attributedPlaceholder = NSAttributedString(string: "Enter your location",
                                                             attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
        textField.delegate = self
        textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }
    
    // MARK: - Action
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        presenter.saveLocation(textField)
    }
    
    @IBAction private func saveButtonAction(_ sender: UIButton) {
        presenter.pushBlankViewController()
    }
    
    deinit {
        print("Bye: \(self) ")
    }
}

extension Welcome: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        presenter.saveLocation(textField)
        return true
    }
}

extension Welcome: WelcomeViewProtocol {
    
    func presentAlert() {
        alert(message: "", title: "Enter your location")
    }
}
