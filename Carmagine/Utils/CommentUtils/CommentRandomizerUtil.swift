//
//  CommentRandomizerUtil.swift
//  Carmagine
//
//  Created by Terretino on 11/03/26.
//

import Foundation

class CommentRandomizerUtil {
    static let shared = CommentRandomizerUtil()
    
    var firstNames: [String]?
    var lastNames: [String]?
    var nouns: [String]?
    var verbs: [String]?
    
    func generateRandomNames() -> String {
        if let firstNames, let lastNames {
            return "\(firstNames.randomElement() ?? "") \(lastNames.randomElement() ?? "")"
        } else {
            firstNames = loadWords(from: "FirstName")
            lastNames = loadWords(from: "LastName")
            return "\(firstNames?.randomElement() ?? "") \(lastNames?.randomElement() ?? "")"
        }
    }
    
    func generateRandomWords() -> String {
        let randomNumber = Int.random(in: 5...40)
        var comments: [String] = []
        
        for i in 0...randomNumber {
            if let nouns, let verbs {
                if i % 2 == 0 {
                    comments.append(nouns.randomElement() ?? "")
                } else {
                    comments.append(verbs.randomElement() ?? "")
                }
                
            } else {
                nouns = loadWords(from: "Nouns").shuffled()
                verbs = loadWords(from: "Verbs").shuffled()
                
                if i % 2 == 0 {
                    comments.append(nouns?.randomElement() ?? "")
                } else {
                    comments.append(verbs?.randomElement() ?? "")
                }
            }
        }
        
        return comments.joined(separator: " ")
    }
    
    func generateComment() -> CommentModel {
        CommentModel(id: UUID(), name: generateRandomNames(), comment: generateRandomWords(), dateAdded: Date.now)
    }
    
    private func loadWords(from file: String) -> [String] {
        guard let url = Bundle.main.url(forResource: file, withExtension: "json") else {
            return []
        }
        
        guard let data = try? Data(contentsOf: url) else {
            return []
        }
      
        guard let words = try? JSONDecoder().decode([String].self, from: data) else {
            return []
        }
        
        return words
    }
    
}

struct CommentModel {
    var id: UUID?
    var name: String?
    var comment: String?
    var dateAdded: Date?
}
