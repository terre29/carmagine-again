//
//  HomePageViewController.swift
//  Carmagine
//
//  Created by Terretino on 10/03/26.
//

import UIKit
import SnapKit
import Kingfisher

protocol HomePageDisplayLogic: AnyObject {
    func displayPictureList(viewModel: [PictureViewModel])
    func displayNextPage(viewModel: [PictureViewModel])
    func displayError(message: String)
}

final class HomePageViewController: UIViewController {
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        return tableView
    }()
    
    var interactor: (HomePageBusinessLogic & HomePageDataStore)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.prefetchDataSource = self
        tableView.register(PictureListTableViewCell.self, forCellReuseIdentifier: "cell")
        applyViewCode()
        getPictureList()
    }
    
    private func getPictureList() {
        Task {
            await interactor?.getPictureList()
        }
    }
    
    private func loadMorePicture() {
        Task {
            await interactor?.loadNextPage()
        }
    }
    
}

extension HomePageViewController: HomePageDisplayLogic {
    func displayPictureList(viewModel: [PictureViewModel]) {
        interactor?.pictureToShow = viewModel
        tableView.reloadData()
    }

    func displayNextPage(viewModel: [PictureViewModel]) {
        let startIndex = interactor?.pictureToShow?.count ?? 0
        interactor?.pictureToShow?.append(contentsOf: viewModel)
        let indexPaths = (startIndex..<startIndex + viewModel.count).map { IndexPath(row: $0, section: 0) }
        tableView.insertRows(at: indexPaths, with: .none)
    }

    func displayError(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

extension HomePageViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        interactor?.pictureToShow?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? PictureListTableViewCell else { return UITableViewCell() }
        guard let picture = interactor?.pictureToShow?[indexPath.row] else { return UITableViewCell() }
        cell.setupCell(model: picture)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let picture = interactor?.pictureToShow?[indexPath.row] else { return }
        let detailVC = DetailPageComposer.composeDetailPage(picture: picture)
        navigationController?.pushViewController(detailVC, animated: true)
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let frameHeight = scrollView.frame.size.height

        guard contentHeight > 0 else { return }

        if offsetY > contentHeight - frameHeight * 3 {
           loadMorePicture()
        }
    }
}

extension HomePageViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        interactor?.prefetchImages(at: indexPaths.map({ $0.row }))
    }

    func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
        interactor?.cancelPrefetchImages(at: indexPaths.map({ $0.row }))
    }
}

extension HomePageViewController: ViewCodeProtocol {
    func buildViewHierarchy() {
        view.addSubview(tableView)
    }
    
    func setupConstraints() {
        tableView.snp.makeConstraints { make in
            make.verticalEdges.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.equalToSuperview()
        }
    }

    func configureViews() {
        view.backgroundColor = .white
    }
}
