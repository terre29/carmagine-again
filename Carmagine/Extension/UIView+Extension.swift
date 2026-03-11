//
//  UIView+Extension.swift
//  Carmagine
//
//  Created by Terretino on 10/03/26.
//

import UIKit
import SnapKit

extension UIView {
    private static let skeletonTag = 999_999

    func showSkeleton(cornerRadius: CGFloat = 4) {
        let skeleton = UIView()
        skeleton.tag = UIView.skeletonTag
        skeleton.backgroundColor = UIColor.systemGray5
        skeleton.layer.cornerRadius = cornerRadius
        skeleton.clipsToBounds = true
        addSubview(skeleton)

        skeleton.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        let gradient = CAGradientLayer()
        gradient.colors = [
            UIColor.systemGray5.cgColor,
            UIColor.systemGray6.cgColor,
            UIColor.systemGray5.cgColor
        ]
        gradient.startPoint = CGPoint(x: 0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1, y: 0.5)
        gradient.locations = [0, 0.5, 1]
        skeleton.layer.addSublayer(gradient)

        layoutIfNeeded()
        gradient.frame = skeleton.bounds

        let animation = CABasicAnimation(keyPath: "locations")
        animation.fromValue = [-1.0, -0.5, 0.0]
        animation.toValue = [1.0, 1.5, 2.0]
        animation.duration = 1.2
        animation.repeatCount = .infinity
        gradient.add(animation, forKey: "shimmer")

        isHidden = false
    }

    func hideSkeleton() {
        subviews.filter { $0.tag == UIView.skeletonTag }.forEach { $0.removeFromSuperview() }
    }

    func dropShadow(color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1, cornerRadius: CGFloat = 0, scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offSet
        layer.shadowRadius = radius
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
}
