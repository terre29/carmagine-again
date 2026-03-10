//
//  HomePageWorker.swift
//  Carmagine
//
//  Created by Terretino on 10/03/26.
//

protocol HomePageWorkerProtocol {
    func getPictureList() async throws -> [PictureResponse]
}

final class HomePageWorker: HomePageWorkerProtocol {
    
    let client = RestClient.shared
    
    func getPictureList() async throws -> [PictureResponse] {
        do {
            let response = try await client.getRequest(endPoint: .list, request: nil, response: [PictureResponse].self)
            return response
        } catch let error {
            throw error
        }
    
    }
}
