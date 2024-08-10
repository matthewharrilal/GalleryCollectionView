//
//  GalleryCollectionViewCell.swift
//  GalleryView
//
//  Created by Space Wizard on 8/9/24.
//

import Foundation
import UIKit

class GalleryCollectionViewCell: UICollectionViewCell {
    
    private var containerColor: UIColor = UIView.colors.randomElement() ?? .blue
        
    static var identifier: String {
        String(describing: GalleryCollectionViewCell.self)
    }
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 18
        let randomColor = UIView.colors.randomElement()
        view.backgroundColor = containerColor
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension GalleryCollectionViewCell {
    
    func setup() {
        contentView.addSubview(containerView)
        
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor)
        ])
    }
}
