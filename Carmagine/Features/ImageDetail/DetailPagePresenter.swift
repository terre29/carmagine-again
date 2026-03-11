//
//  DetailPagePresenter.swift
//  Carmagine
//
//  Created by Terretino on 11/03/26.
//

import Foundation

protocol DetailPagePresentationLogic {
    func presentNewComment(comment: CommentModel)
    func presentComments()
}

final class DetailPagePresenter {
    weak var viewController: DetailPageDisplayLogic?
}

extension DetailPagePresenter: DetailPagePresentationLogic {
    func presentNewComment(comment: CommentModel) {
        let name = comment.name ?? ""
        let words = name.split(separator: " ")
        let initials = words.map { String($0.prefix(1)).uppercased() }.joined()
        
        let viewModel = CommentViewModel(
            id: comment.id ?? UUID(),
            author: name,
            initials: initials,
            body: comment.comment ?? "",
            date: comment.dateAdded ?? Date(),
        )
        viewController?.displayNewComment(viewModel: viewModel)
    }
    
    func presentComments() {
        viewController?.displayComments()
    }
}
