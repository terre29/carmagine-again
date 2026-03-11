//
//  DetailPageComposer.swift
//  Carmagine
//
//  Created by Terretino on 11/03/26.
//

import UIKit

final class DetailPageComposer {
    static func composeDetailPage(picture: PictureViewModel) -> UIViewController {
        let viewController = DetailPageViewController()
        let interactor = DetailPageInteractor()
        let presenter = DetailPagePresenter()
        let worker = DetailPageWorker()

        viewController.interactor = interactor
        viewController.title = "Image Detail"

        interactor.picture = picture
        interactor.presenter = presenter
        interactor.worker = worker

        presenter.viewController = viewController

        return viewController
    }
}
