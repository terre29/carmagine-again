//
//  DetailPageInteractor.swift
//  Carmagine
//
//  Created by Terretino on 11/03/26.
//

import Foundation

protocol DetailPageBusinessLogic {
    func addComment()
}

protocol DetailPageDataStore {
    var picture: PictureViewModel? { get set }
    var comments: [CommentViewModel]? { get set }
}

final class DetailPageInteractor: DetailPageDataStore {
    var picture: PictureViewModel?
    var comments: [CommentViewModel]?
    var presenter: DetailPagePresentationLogic?
}

extension DetailPageInteractor: DetailPageBusinessLogic {
    func addComment() {
        let comment = CommentRandomizerUtil.shared.generateComment()
        presenter?.presentNewComment(comment: comment)
    }
}
