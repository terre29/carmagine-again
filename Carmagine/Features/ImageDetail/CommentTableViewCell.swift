//
//  CommentTableViewCell.swift
//  Carmagine
//
//  Created by Terretino on 11/03/26.
//

import UIKit
import SnapKit

final class CommentTableViewCell: UITableViewCell {
    lazy var avatarView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 20
        view.clipsToBounds = true
        return view
    }()

    lazy var initialsLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .bold)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()

    lazy var authorLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .bold)
        return label
    }()

    lazy var commentLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.numberOfLines = 0
        return label
    }()

    lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .gray
        return label
    }()

    lazy var contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 4
        return stackView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        applyViewCode()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupCell(model: CommentViewModel) {
        initialsLabel.text = model.initials
        avatarView.backgroundColor = .gray
        authorLabel.text = model.author
        commentLabel.text = model.body
        dateLabel.text = model.dateString
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        initialsLabel.text = nil
        authorLabel.text = nil
        commentLabel.text = nil
        dateLabel.text = nil
    }
}

extension CommentTableViewCell: ViewCodeProtocol {
    func buildViewHierarchy() {
        contentView.addSubview(avatarView)
        avatarView.addSubview(initialsLabel)
        contentView.addSubview(contentStackView)
        contentStackView.addArrangedSubview(authorLabel)
        contentStackView.addArrangedSubview(commentLabel)
        contentStackView.addArrangedSubview(dateLabel)
    }

    func setupConstraints() {
        avatarView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.top.equalToSuperview().inset(12)
            make.width.height.equalTo(40)
        }

        initialsLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }

        contentStackView.snp.makeConstraints { make in
            make.leading.equalTo(avatarView.snp.trailing).offset(12)
            make.trailing.equalToSuperview().inset(16)
            make.top.equalToSuperview().inset(12)
            make.bottom.equalToSuperview().inset(12)
        }
    }
}
