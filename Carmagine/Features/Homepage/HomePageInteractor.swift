//
//  HomePageInteractor.swift
//  Carmagine
//
//  Created by Terretino on 10/03/26.
//

import Foundation
import Kingfisher
import UIKit

protocol HomePageBusinessLogic {
    func getPictureList() async
    func loadNextPage() async
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

    private var currentPage = 1
    private var isLoading = false
    private var hasMorePages = true
    private let limit = 20
    private var imagePrefetcher: ImagePrefetcher?
}

extension HomePageInteractor: HomePageBusinessLogic {
    func getPictureList() async {
        currentPage = 1
        isLoading = true
        do {
            let picture = try await worker?.getPictureList(page: currentPage, limit: limit)
            hasMorePages = (picture?.count ?? 0) >= limit
            presenter?.presentSuccessGetList(pictureListResponse: picture ?? [])
        } catch {
            presenter?.presentFailedGetList(error: error)
        }
        isLoading = false
    }

    func loadNextPage() async {
        guard !isLoading, hasMorePages else { return }
        isLoading = true
        currentPage += 1
        do {
            let picture = try await worker?.getPictureList(page: currentPage, limit: limit)
            hasMorePages = (picture?.count ?? 0) >= limit
            presenter?.presentNextPage(pictureListResponse: picture ?? [])
        } catch {
            currentPage -= 1
            presenter?.presentFailedGetList(error: error)
        }
        isLoading = false
    }
    
    func prefetchImages(at row: [Int]) {
        guard let pictureToShow else { return }
        let urls = row.compactMap { row -> URL? in
            guard row < pictureToShow.count else { return nil }
            return URL(string: pictureToShow[row].url ?? "")
        }
        let processor = DownsamplingImageProcessor(size: CGSize(width: 80, height: 80))
        let options: KingfisherOptionsInfo = [
            .processor(processor),
            .scaleFactor(UIScreen.main.scale),
            .cacheOriginalImage
        ]
        imagePrefetcher?.stop()
        imagePrefetcher = ImagePrefetcher(urls: urls, options: options)
        imagePrefetcher?.start()
    }

    func cancelPrefetchImages(at row: [Int]) {
        imagePrefetcher?.stop()
        imagePrefetcher = nil
    }
}
