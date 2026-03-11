//
//  SwiftDataService.swift
//  Carmagine
//
//  Created by Terretino on 11/03/26.
//

import SwiftData

class SwiftDataService {
    static let shared = SwiftDataService()
    
    var container: ModelContainer?
    var context: ModelContext?
    
    init() {
        do {
            container = try ModelContainer(for: ImageItem.self, Comment.self)
            if let container {
                context = ModelContext(container)
            }
        } catch let error {
            
        }
    }
}
