//
//  RestClient.swift
//  Carmagine
//
//  Created by Terretino on 10/03/26.
//

import Alamofire
import Foundation

final class RestClient {
    static let shared = RestClient()
    
    private let session: Session
    private let baseUrl: String = "https://picsum.photos/v2"
    
    init() {
        let configuration = URLSessionConfiguration.default
        session = Session(configuration: configuration)
    }
}

extension RestClient {
    func getRequest<Response: Decodable>(
        endPoint: EndPoint,
        request: Parameters?,
        response: Response.Type
    ) async throws -> Response {
        let finalUrl = baseUrl+endPoint.rawValue
        
        return try await withCheckedThrowingContinuation { continuation in
            session.request(
                finalUrl,
                method: .get,
                parameters: request,
                encoding: URLEncoding.default,
            )
            .responseDecodable(of: Response.self) { response in
                switch response.result {
                case .success(let value):
                    continuation.resume(returning: value)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
                
            }
        }
            
    }
}
