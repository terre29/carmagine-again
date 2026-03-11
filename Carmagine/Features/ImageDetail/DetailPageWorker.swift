//
//  DetailPageWorker.swift
//  Carmagine
//
//  Created by Terretino on 11/03/26.
//

import SwiftData
import Foundation

protocol DetailPageWorkerProtocol {
    func saveComment(for id: String, comment: CommentModel)
    func fetchComment(for id: String) -> [CommentModel]?
    func deleteComment(for id: String, uuid: UUID)
}

class DetailPageWorker: DetailPageWorkerProtocol {
    
    let dataService = SwiftDataService.shared
    
    func saveComment(for id: String, comment: CommentModel) {
        let commentModel = Comment(id: comment.id ?? UUID(), author: comment.name ?? "", body: comment.comment ?? "", date: comment.dateAdded ?? Date())
        
        let descriptor = FetchDescriptor<ImageItem>(
            predicate: #Predicate { $0.id == id }
        )
        
        let existingImage = try? dataService.context?.fetch(descriptor).first
        
        if let existingImage {
            existingImage.comments.append(commentModel)
        } else {
            let imageForSave = ImageItem(id: id)
            imageForSave.comments.append(commentModel)
            dataService.context?.insert(imageForSave)
        }
        
        try? dataService.context?.save()
    }
    
    func fetchComment(for id: String) -> [CommentModel]? {
        let descriptor = FetchDescriptor<ImageItem>(
            predicate: #Predicate { $0.id == id }
        )
        
        let imageData = try? dataService.context?.fetch(descriptor).first
        let comments = imageData?.comments.map { comment in
            CommentModel(id: comment.id, name: comment.author, comment: comment.body, dateAdded: comment.date)
        }
        return comments
    }
        
    func deleteComment(for id: String, uuid: UUID) {
        let descriptor = FetchDescriptor<ImageItem>(
            predicate: #Predicate { $0.id == id }
        )
        
        let image = try? dataService.context?.fetch(descriptor).first
        
        if let index = image?.comments.firstIndex(where: { $0.id == uuid }) {
            image?.comments.remove(at: index)
            
            try? dataService.context?.save()
        }
     
        
    }

}
