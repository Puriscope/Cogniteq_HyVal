//
//  ModuleBuilder.swift
//  HyVal
//
//  Created by Egor Syrtcov on 4/29/21.
//

import UIKit

protocol AssemblyBuilderProtocol {
    func createWelcomeModule(router: RouterProtocol) -> UIViewController
    func createBlankModule(router: RouterProtocol) -> UIViewController
    func createAriaCompareModule(photoCameraImage: UIImage, router: RouterProtocol) -> UIViewController
    func createSampleModule(router: RouterProtocol) -> UIViewController
    func createColorsManually(color: UIColor, router: RouterProtocol) -> UIViewController
    func createResult(router: RouterProtocol) -> UIViewController
}

class AssemblyModuleBuilder: AssemblyBuilderProtocol {
    
    func createWelcomeModule(router: RouterProtocol) -> UIViewController {
        let view = Welcome()
        let presenter = WelcomePresenter(view: view, router: router)
        view.presenter = presenter
        return view
    }
    
    func createBlankModule(router: RouterProtocol) -> UIViewController {
        let view = BlankComparison()
        let presenter = BlankComparisonPresenter(view: view, router: router)
        view.presenter = presenter
        return view
    }
    
    func createAriaCompareModule(photoCameraImage: UIImage, router: RouterProtocol) -> UIViewController {
        let view = AreaCompare()
        let presenter = AriaComparePresenter(view: view, router: router, photoCameraImage: photoCameraImage)
        view.presenter = presenter
        return view
    }
    
    func createSampleModule(router: RouterProtocol) -> UIViewController {
        let view = SampleComparison()
        let presenter = SampleComparisonPresenter(view: view, router: router)
        view.presenter = presenter
        return view
    }
    
    func createColorsManually(color: UIColor, router: RouterProtocol) -> UIViewController {
        let view = ColorsManually()
        let presenter = ColorsManuallyPresenter(view: view, router: router, color: color)
        view.presenter = presenter
        return view
    }
    
    func createResult(router: RouterProtocol) -> UIViewController {
        let view = Result()
        let presenter = ResultPresenter(view: view, router: router)
        view.presenter = presenter
        return view
    }
}
