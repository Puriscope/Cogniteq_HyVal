//
//  WelcomePresenter.swift
//  HyVal
//
//  Created by Egor Syrtcov on 4/29/21.
//

import UIKit

protocol WelcomeViewProtocol: class {
    func presentAlert()
}

protocol WelcomeViewPresenterProtocol: class {
    init(view: WelcomeViewProtocol, router: RouterProtocol)
    func saveLocation(_ textField: UITextField)
    func pushBlankViewController()
}

final class WelcomePresenter: WelcomeViewPresenterProtocol {
    
    private weak var view: WelcomeViewProtocol?
    private var router: RouterProtocol?
    private let realmManager: RealmManager = RealmManagerImp()
    private var textFieldLocation: String?
    
    required init(view: WelcomeViewProtocol, router: RouterProtocol) {
        self.view = view
        self.router = router
    }
    
    func saveLocation(_ textField: UITextField) {
        guard let location = textField.text else { return }
        textFieldLocation = location
    }
    
    func pushBlankViewController() {
        
        (textFieldLocation == nil) || (textFieldLocation?.isEmpty == true) ? view?.presentAlert() : router?.showBlankViewController()
        
        guard let location = textFieldLocation else { return }
        
        let locationModel = LocationModel()
        locationModel.location = location
        locationModel.sampleName = ""
        realmManager.save(location: locationModel)
    }
}
