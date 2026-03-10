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
    
}

extension HomePageViewController: HomePageDisplayLogic {
    func displayPictureList(viewModel: [PictureViewModel]) {
        interactor?.pictureToShow = viewModel
        tableView.reloadData()
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
            make.verticalEdges.equalToSuperview().inset(16)
            make.horizontalEdges.equalToSuperview()
        }
    }

    func configureViews() {
        view.backgroundColor = .white
    }
}
