//
//  Router.swift
//  HyVal
//
//  Created by Egor Syrtcov on 4/29/21.
//

import UIKit

protocol RouterMain {
    var navigationController: UINavigationController? { get set }
    var assemblyBuilder: AssemblyBuilderProtocol? { get set }
}

protocol RouterProtocol: RouterMain {
    func initialViewController()
    func showBlankViewController()
    func popToRoot()
    func showAriaCompareViewController(photoCameraImage: UIImage)
    func showSampleViewController()
    func showColorsManually(image: UIImage)
    func showResultPage()
}

class Router: RouterProtocol {
    
    var navigationController: UINavigationController?
    var assemblyBuilder: AssemblyBuilderProtocol?
    
    init(navigationController: UINavigationController, assemblyBuilder: AssemblyBuilderProtocol) {
        self.navigationController = navigationController
        self.assemblyBuilder = assemblyBuilder
    }
    
    func initialViewController() {
        if let navigationController = navigationController {
            guard let welcomeViewController = assemblyBuilder?.createWelcomeModule(router: self) else { return }
            navigationController.viewControllers = [welcomeViewController]
        }
    }
    
    func showBlankViewController() {
        if let navigationController = navigationController {
            guard let welcomeViewController = assemblyBuilder?.createBlankModule(router: self) else { return }
            navigationController.pushViewController(welcomeViewController, animated: true)
        }
    }
    
    func showAriaCompareViewController(photoCameraImage: UIImage) {
        if let navigationController = navigationController {
            guard let ariaCompareViewController = assemblyBuilder?.createAriaCompareModule(photoCameraImage: photoCameraImage, router: self) else { return }
            navigationController.pushViewController(ariaCompareViewController, animated: true)
        }
    }
    
    func showSampleViewController() {
        if let navigationController = navigationController {
            guard let sampleViewController = assemblyBuilder?.createSampleModule(router: self) else { return }
            navigationController.pushViewController(sampleViewController, animated: true)
        }
    }
    
    func showColorsManually(image: UIImage) {
        if let navigationController = navigationController {
            guard let colorsManualleViewController = assemblyBuilder?.createColorsManually(image: image, router: self) else { return }
            navigationController.pushViewController(colorsManualleViewController, animated: true)
        }
    }
    
    func showResultPage() {
        if let navigationController = navigationController {
            guard let resultViewController = assemblyBuilder?.createResult(router: self) else { return }
            navigationController.pushViewController(resultViewController, animated: true)
        }
    }
    
    func popToRoot() {
        if let navigationController = navigationController {
            navigationController.popToRootViewController(animated: true)
        }
    }
}
