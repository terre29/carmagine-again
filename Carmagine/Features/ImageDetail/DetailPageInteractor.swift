//
//  DetailPageInteractor.swift
//  Carmagine
//
//  Created by Terretino on 11/03/26.
//

import Foundation

protocol DetailPageBusinessLogic {
    func addComment()
    func fetchComment()
    func deleteComment(at index: Int)
}

protocol DetailPageDataStore {
    var picture: PictureViewModel? { get set }
    var comments: [CommentViewModel]? { get set }
}

final class DetailPageInteractor: DetailPageDataStore {
    var picture: PictureViewModel?
    var comments: [CommentViewModel]?
    var presenter: DetailPagePresentationLogic?
    var worker: DetailPageWorkerProtocol?
}

extension DetailPageInteractor: DetailPageBusinessLogic {
    func addComment() {
        let comment = CommentRandomizerUtil.shared.generateComment()
        worker?.saveComment(for: picture?.id ?? "", comment: comment)
        presenter?.presentNewComment(comment: comment)
    }
    
    func fetchComment() {
        let comments = worker?.fetchComment(for: picture?.id ?? "")
        self.comments = comments?.map({ model in
            let name = model.name ?? ""
            let words = name.split(separator: " ")
            let initials = words.map { String($0.prefix(1)).uppercased() }.joined()
            
            return CommentViewModel(id: model.id ?? UUID(), author: model.name ?? "", initials: initials, body: model.comment ?? "", date: model.dateAdded ?? Date())
        })
        presenter?.presentComments()
    }
    
    func deleteComment(at index: Int) {
        let commentToDelete = comments?[index]
        worker?.deleteComment(for: picture?.id ?? "", uuid: commentToDelete?.id ?? UUID())
        comments?.remove(at: index)
    }
}
