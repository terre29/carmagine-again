//
//  DetailPagePresenter.swift
//  Carmagine
//
//  Created by Terretino on 11/03/26.
//

import Foundation

protocol DetailPagePresentationLogic {
    func presentNewComment(comment: CommentModel)
}

final class DetailPagePresenter {
    weak var viewController: DetailPageDisplayLogic?
}

extension DetailPagePresenter: DetailPagePresentationLogic {
    func presentNewComment(comment: CommentModel) {
        let name = comment.name ?? ""
        let words = name.split(separator: " ")
        let initials = words.map { String($0.prefix(1)).uppercased() }.joined()

        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        let dateString = formatter.localizedString(for: comment.dateAdded ?? Date(), relativeTo: Date())

        let viewModel = CommentViewModel(
            author: name,
            initials: initials,
            body: comment.comment ?? "",
            date: dateString
        )
        viewController?.displayNewComment(viewModel: viewModel)
    }
}
