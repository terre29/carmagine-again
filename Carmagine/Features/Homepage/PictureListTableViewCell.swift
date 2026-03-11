//
//  PictureListTableViewCell.swift
//  Carmagine
//
//  Created by Terretino on 10/03/26.
//

import UIKit
import SnapKit
import Kingfisher

final class PictureListTableViewCell: UITableViewCell {
    lazy var baseView: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var baseStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        return stackView
    }()
    
    lazy var imageBaseView: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var image: UIImageView = {
        let image = UIImageView()
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFill
        return image
    }()
    
    lazy var authorLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        applyViewCode()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupCell(model: PictureViewModel) {
        image.showSkeleton(cornerRadius: 8)
        authorLabel.showSkeleton(cornerRadius: 4)

        if let url = URL(string: model.url ?? "") {
            let processor = DownsamplingImageProcessor(size: CGSize(width: 80, height: 80))
            image.kf.setImage(
                with: url,
                options: [
                    .processor(processor),
                    .scaleFactor(UIScreen.main.scale),
                    .cacheOriginalImage
                ]
            ) { [weak self] _ in
                self?.image.hideSkeleton()
            }
        }
        authorLabel.hideSkeleton()
        authorLabel.text = "Author: \(model.author ?? "")"
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        image.kf.cancelDownloadTask()
        image.hideSkeleton()
        image.image = nil
        authorLabel.hideSkeleton()
        authorLabel.text = nil
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        baseView.layer.shadowPath = UIBezierPath(roundedRect: baseView.bounds, cornerRadius: 8).cgPath
    }
}

extension PictureListTableViewCell: ViewCodeProtocol {
    func buildViewHierarchy() {
        contentView.addSubview(baseView)
        baseView.addSubview(baseStackView)
        baseStackView.addArrangedSubview(imageBaseView)
        imageBaseView.addSubview(image)
        baseStackView.addArrangedSubview(authorLabel)
    }
    
    func setupConstraints() {
        baseView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(16)
            make.verticalEdges.equalToSuperview().inset(8)
        }
        
        baseStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        image.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalTo(80)
            make.width.equalTo(80)
        }
    }
    
    func configureViews() {
        baseStackView.layer.cornerRadius = 8
        baseStackView.clipsToBounds = true
        baseStackView.backgroundColor = .white
        baseView.dropShadow(color: .black, opacity: 0.3, offSet: CGSize(width: 2, height: 2), radius: 3, cornerRadius: 8)
    }
    
}
