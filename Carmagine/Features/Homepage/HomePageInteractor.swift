//
//  HomePageInteractor.swift
//  Carmagine
//
//  Created by Terretino on 10/03/26.
//

protocol HomePageBusinessLogic {
    func getPictureList() async
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
}
