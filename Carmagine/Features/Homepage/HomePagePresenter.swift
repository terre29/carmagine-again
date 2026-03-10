//
//  HomePagePresenter.swift
//  Carmagine
//
//  Created by Terretino on 10/03/26.
//

protocol HomePagePresentationLogic {
    func presentSuccessGetList(pictureListResponse: [PictureResponse])
    func presentNextPage(pictureListResponse: [PictureResponse])
    func presentFailedGetList()
}

final class HomePagePresenter {
    weak var viewController: HomePageDisplayLogic?
}

extension HomePagePresenter: HomePagePresentationLogic {
    func presentSuccessGetList(pictureListResponse: [PictureResponse]) {
        let viewModel = pictureListResponse.map { response in
            PictureViewModel(id: response.id, author: response.author, url: response.downloadUrl)
        }
        viewController?.displayPictureList(viewModel: viewModel)
    }

    func presentNextPage(pictureListResponse: [PictureResponse]) {
        let viewModel = pictureListResponse.map { response in
            PictureViewModel(id: response.id, author: response.author, url: response.downloadUrl)
        }
        viewController?.displayNextPage(viewModel: viewModel)
    }

    func presentFailedGetList() {

    }
}
