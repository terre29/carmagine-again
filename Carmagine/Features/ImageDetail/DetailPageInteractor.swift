//
//  DetailPageInteractor.swift
//  Carmagine
//
//  Created by Terretino on 11/03/26.
//

import Foundation

protocol DetailPageBusinessLogic {

}

protocol DetailPageDataStore {
    var picture: PictureViewModel? { get set }
}

final class DetailPageInteractor: DetailPageDataStore {
    var picture: PictureViewModel?

    var presenter: DetailPagePresentationLogic?
}

extension DetailPageInteractor: DetailPageBusinessLogic {

}
