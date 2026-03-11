//
//  Comment.swift
//  Carmagine
//
//  Created by Terretino on 11/03/26.
//
import Foundation
import SwiftData


@Model
class Comment {
    var id: UUID
    var author: String
    var body: String
    var date: Date
    
    init(id: UUID, author: String, body: String, date: Date) {
        self.id = id
        self.author = author
        self.body = body
        self.date = date
    }
}

@Model
class ImageItem {
    @Attribute(.unique)
    var id: String
    var comments: [Comment] = []
    
    init(id: String) {
        self.id = id
        self.comments = comments
    }
}

