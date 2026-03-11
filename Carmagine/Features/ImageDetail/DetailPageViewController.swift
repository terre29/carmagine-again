//
//  DetailPageViewController.swift
//  Carmagine
//
//  Created by Terretino on 11/03/26.
//

import UIKit
import SnapKit
import Kingfisher

protocol DetailPageDisplayLogic: AnyObject {

}

final class DetailPageViewController: UIViewController {
    lazy var pictureImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()

    lazy var commentTableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .singleLine
        return tableView
    }()

    var interactor: (DetailPageBusinessLogic & DetailPageDataStore)?

    override func viewDidLoad() {
        super.viewDidLoad()
        applyViewCode()
        setupNavBar()
        loadImage()
    }

    private func setupNavBar() {
        title = "Image Detail"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: nil, action: nil)
    }

    private func loadImage() {
        guard let urlString = interactor?.picture?.url,
              let url = URL(string: urlString) else { return }
        pictureImageView.kf.setImage(with: url)
    }
}

extension DetailPageViewController: DetailPageDisplayLogic {

}

extension DetailPageViewController: ViewCodeProtocol {
    func buildViewHierarchy() {
        view.addSubview(pictureImageView)
        view.addSubview(commentTableView)
    }

    func setupConstraints() {
        pictureImageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(250)
        }

        commentTableView.snp.makeConstraints { make in
            make.top.equalTo(pictureImageView.snp.bottom)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }

    func configureViews() {
        view.backgroundColor = .white
    }
}
