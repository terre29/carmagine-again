//
//  HomePageComposer.swift
//  Carmagine
//
//  Created by Terretino on 10/03/26.
//

import UIKit

final class HomePageComposer {
    static func composeHomePage() -> UIViewController {
        let viewController = HomePageViewController()
        let interactor = HomePageInteractor()
        let presenter = HomePagePresenter()
        let worker = HomePageWorker()
        
        viewController.interactor = interactor
        viewController.title = "Image List"
        
        interactor.worker = worker
        interactor.presenter = presenter
        
        presenter.viewController = viewController
        
        return viewController
    }
}
