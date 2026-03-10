//
//  HomePageModel.swift
//  Carmagine
//
//  Created by Terretino on 10/03/26.
//

struct PictureViewModel {
    var id: String?
    var author: String?
    var url: String?
}

struct PictureListResponse: Decodable {
    var response: [PictureResponse]?
}

struct PictureResponse: Decodable {
    var id: String?
    var author: String?
    var width: Int?
    var height: Int?
    var url: String?
    var downloadUrl: String?
    
    enum CodingKeys: String, CodingKey {
        case id, author, width, height, url
        case downloadUrl = "download_url"
    }

}
