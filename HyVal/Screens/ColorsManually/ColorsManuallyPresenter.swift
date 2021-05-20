//
//  ColorsManuallyPresenter.swift
//  HyVal
//
//  Created by Egor Syrtcov on 5/6/21.
//

import Foundation

import UIKit

protocol ColorsManuallyViewProtocol: class {
    func setTitle(location: LocationModel)
    func setImage(image: UIImage)
}

protocol ColorsManuallyViewPresenterProtocol: class {
    init(view: ColorsManuallyViewProtocol, router: RouterProtocol, image: UIImage)
    
    func setTitleFromRealm()
    func setColorForPicker()
    func numberOfItemsInSection() -> Int
    func getColor(index: IndexPath) -> UIColor
    func getCurrentIndexItem(_ item: Int)
    func pushResultViewController()
}

final class ColorsManuallyPresenter: ColorsManuallyViewPresenterProtocol {
    
    private weak var view: ColorsManuallyViewProtocol?
    private var router: RouterProtocol?
    private let realmManager: RealmManager = RealmManagerImp()
    private let image: UIImage
    private var currentIndexItem = Int()
    
    private let colorsBlank = [PSTColor(color: UIColor.pink(), pst: 10),
                              PSTColor(color: UIColor.pink2(), pst: 20),
                              PSTColor(color: UIColor.pink3(), pst: 30),
                              PSTColor(color: UIColor.pink4(), pst: 40),
                              PSTColor(color: UIColor.pink5(), pst: 50),
                              PSTColor(color: UIColor.pink6(), pst: 60),
                              PSTColor(color: UIColor.blue(), pst: 70),
                              PSTColor(color: UIColor.green(), pst: 80),
                              PSTColor(color: UIColor.green2(), pst: 90),
                              PSTColor(color: UIColor.green3(), pst: 100),
                              PSTColor(color: UIColor.green4(), pst: 110),
                              PSTColor(color: UIColor.green5(), pst: 120),
                              PSTColor(color: UIColor.green6(), pst: 130),
                              PSTColor(color: UIColor.green7(), pst: 140),
                              PSTColor(color: UIColor.green8(), pst: 150),
                              PSTColor(color: UIColor.green9(), pst: 160),
                              PSTColor(color: UIColor.yellow(), pst: 170),
                              PSTColor(color: UIColor.yellow2(), pst: 180),
                              PSTColor(color: UIColor.yellow3(), pst: 190)
    ]
    
    required init(view: ColorsManuallyViewProtocol, router: RouterProtocol, image: UIImage) {
        self.view = view
        self.router = router
        self.image = image
    }
    
    func setTitleFromRealm() {
        let locations = realmManager.getLocation()
        guard let location = locations.last else { return }
        view?.setTitle(location: location)
    }
    
    func setColorForPicker() {
        view?.setImage(image: image)
    }
    
    func numberOfItemsInSection() -> Int {
        return colorsBlank.count
    }
    
    func getColor(index: IndexPath) -> UIColor {
        return colorsBlank[index.item].color
    }
    
    func getCurrentIndexItem(_ item: Int) {
        currentIndexItem = item
    }
    
    func pushResultViewController() {
        realmManager.updateModel(pst: colorsBlank[currentIndexItem].pst)
        router?.showResultPage()
    }
}
