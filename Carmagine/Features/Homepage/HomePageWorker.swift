//
//  HomePageWorker.swift
//  Carmagine
//
//  Created by Terretino on 10/03/26.
//

protocol HomePageWorkerProtocol {
    func getPictureList(page: Int, limit: Int) async throws -> [PictureResponse]
}

final class HomePageWorker: HomePageWorkerProtocol {

    let client = RestClient.shared

    func getPictureList(page: Int, limit: Int) async throws -> [PictureResponse] {
        let parameters: [String: Any] = ["page": page, "limit": limit]
        let response = try await client.getRequest(endPoint: .list, request: parameters, response: [PictureResponse].self)
        return response
    }
}
