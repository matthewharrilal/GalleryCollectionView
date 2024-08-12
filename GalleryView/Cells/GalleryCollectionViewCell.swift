//
//  GalleryCollectionViewCell.swift
//  GalleryView
//
//  Created by Space Wizard on 8/9/24.
//

import Foundation
import UIKit

class GalleryCollectionViewCell: UICollectionViewCell {
    
    public var onTap: (() -> Void)? {
        didSet {
            containerView.onTap = onTap
        }
    }
            
    static var identifier: String {
        String(describing: GalleryCollectionViewCell.self)
    }
    
    private lazy var containerView: ScalableContainerView = {
        let view = ScalableContainerView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 18
        return view
    }()
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        
        guard let layoutAttributes = layoutAttributes as? GalleryCollectionViewLayoutAttributes else { return }
        containerView.backgroundColor = layoutAttributes.containerColor
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
