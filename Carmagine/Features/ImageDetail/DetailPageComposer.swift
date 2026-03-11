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

        viewController.interactor = interactor
        viewController.title = "Image Detail"

        interactor.picture = picture
        interactor.presenter = presenter

        presenter.viewController = viewController

        return viewController
    }
}
