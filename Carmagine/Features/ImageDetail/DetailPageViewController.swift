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
    func displayNewComment(viewModel: CommentViewModel)
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
        commentTableView.delegate = self
        commentTableView.dataSource = self
        commentTableView.register(CommentTableViewCell.self, forCellReuseIdentifier: "commentCell")
        applyViewCode()
        setupNavBar()
        loadImage()
    }

    private func setupNavBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addCommentTapped))
    }

    private func loadImage() {
        guard let urlString = interactor?.picture?.url,
              let url = URL(string: urlString) else { return }
        pictureImageView.kf.setImage(with: url)
    }


    @objc private func addCommentTapped() {
        interactor?.addComment()
    }
}

extension DetailPageViewController: DetailPageDisplayLogic {
    func displayNewComment(viewModel: CommentViewModel) {
        if interactor?.comments == nil {
            interactor?.comments = []
        }
        interactor?.comments?.append(viewModel)
        let indexPath = IndexPath(row: (interactor?.comments?.count ?? 1) - 1, section: 0)
        commentTableView.insertRows(at: [indexPath], with: .automatic)
    }
}

extension DetailPageViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        interactor?.comments?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "commentCell", for: indexPath) as? CommentTableViewCell else { return UITableViewCell() }
        guard let comment = interactor?.comments?[indexPath.row] else { return UITableViewCell() }
        cell.setupCell(model: comment)
        cell.selectionStyle = .none
        return cell
    }
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
