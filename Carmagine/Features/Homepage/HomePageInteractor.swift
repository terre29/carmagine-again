//
//  HomePageInteractor.swift
//  Carmagine
//
//  Created by Terretino on 10/03/26.
//

import Foundation
import Kingfisher

protocol HomePageBusinessLogic {
    func getPictureList() async
    func prefetchImages(at row: [Int])
    func cancelPrefetchImages(at row: [Int])
}

protocol HomePageDataStore {
    var pictureToShow: [PictureViewModel]? { get set }
}

final class HomePageInteractor: HomePageDataStore {
    var pictureToShow: [PictureViewModel]?
    
    var presenter: HomePagePresentationLogic?
    var worker: HomePageWorkerProtocol?
}

extension HomePageInteractor: HomePageBusinessLogic {
    func getPictureList() async {
        do {
            let picture = try await worker?.getPictureList()
            presenter?.presentSuccessGetList(pictureListResponse: picture!)
        } catch let error {
            presenter?.presentFailedGetList()
        }
    }
    
    func prefetchImages(at row: [Int]) {
        guard let pictureToShow else { return }
        let urls = row.compactMap { row -> URL? in
            guard row < pictureToShow.count else { return nil }
            return URL(string: pictureToShow[row].url ?? "")
        }
        ImagePrefetcher(urls: urls).start()
    }

    func cancelPrefetchImages(at row: [Int]) {
        guard let pictureToShow else { return }
        let urls = row.compactMap { row -> URL? in
            guard row < pictureToShow.count else { return nil }
            return URL(string: pictureToShow[row].url ?? "")
        }
        urls.forEach { KingfisherManager.shared.downloader.cancel(url: $0) }
    }
}
