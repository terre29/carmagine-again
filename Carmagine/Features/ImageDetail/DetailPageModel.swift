//
//  DetailPageModel.swift
//  Carmagine
//
//  Created by Terretino on 11/03/26.
//

import UIKit

struct CommentViewModel {
    var id: UUID
    var author: String
    var initials: String
    var body: String
    var date: Date
    var dateString: String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        let dateString = formatter.localizedString(for: date, relativeTo: Date())
        return dateString
    }
}
