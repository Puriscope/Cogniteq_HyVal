//
//  ResultPresenter.swift
//  HyVal
//
//  Created by Egor Syrtcov on 5/7/21.
//

import UIKit

protocol ResultViewProtocol: class {
    func setTitle(location: LocationModel)
    func openSharedScreen(activityViewController: UIActivityViewController)
}

protocol ResultViewPresenterProtocol: class {
    init(view: ResultViewProtocol, router: RouterProtocol)
    
    func setTitleFromRealm()
    func numberOfRowsInSection() -> Int
    func getLocation(index: IndexPath) -> LocationModel
    func deleteLocation(index: IndexPath)
    func showWelcomeScreen()
    func shared()
}

final class ResultPresenter: ResultViewPresenterProtocol {
    
    private weak var view: ResultViewProtocol?
    private var router: RouterProtocol?
    private let realmManager: RealmManager = RealmManagerImp()
    private var locations = [LocationModel]()
    
    required init(view: ResultViewProtocol, router: RouterProtocol) {
        self.view = view
        self.router = router
    }
    
    func setTitleFromRealm() {
        locations = realmManager.getLocation()
        guard let location = locations.last else { return }
        view?.setTitle(location: location)
    }
    
    func numberOfRowsInSection() -> Int {
        locations = realmManager.getLocation()
        return locations.count
    }
    
    func getLocation(index: IndexPath) -> LocationModel {
        locations = realmManager.getLocation()
        return locations[index.row]
    }
    
    func deleteLocation(index: IndexPath) {
        let location = locations[index.row]
        realmManager.deleteModel(location: location)
    }
    
    func showWelcomeScreen() {
        realmManager.deleteColorDiff() // Delete from realm all ColorDiff
        router?.popToRoot()
    }
    
    func shared() {
        let imageToShare = [UIImage]()
        let activityViewController = UIActivityViewController(activityItems: imageToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view as? UIView
        
        activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook ]
        view?.openSharedScreen(activityViewController: activityViewController)
    }
}

