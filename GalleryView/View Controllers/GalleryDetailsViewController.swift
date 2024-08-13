//
//  GalleryDetailsViewController.swift
//  GalleryView
//
//  Created by Space Wizard on 8/12/24.
//

import Foundation
import UIKit

class GalleryDetailsViewController: UIViewController {
    
    private var titleLabelCenterXConstraint: NSLayoutConstraint!
    private var titleLabelLeadingConstraint: NSLayoutConstraint!
    
    private let layout: GalleryCollectionViewLayout
    
    public lazy var viewColor: UIColor? = .white {
        didSet {
            view.backgroundColor = viewColor
        }
    }
    
    public var layoutStyle: GalleryCollectionViewLayout.Style = .compact {
        didSet {
            updateLayout(layoutStyle)
        }
    }
    
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = UIView.singleWordArray.randomElement()
        label.textColor = .white
        if let poppinsFont = UIFont(name: "Poppins-ExtraBold", size: 24) {
            label.font = poppinsFont
        } else {
            label.font = UIFont.systemFont(ofSize: 17) // Fallback if Nunito isn't available
        }
        return label
    }()
    
    init(layout: GalleryCollectionViewLayout) {
        self.layout = layout
        super.init(nibName: nil, bundle: nil)
        
        layout.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    func configure(with text: String) {
        titleLabel.text = text
    }
}

private extension GalleryDetailsViewController {
    
    func setup() {
        view.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor)
        ])
        
        defineConstraintsForFullStyle()
        defineConstraintsForCompactStyle()
        
        updateLayout(layoutStyle)
    }
    
    func defineConstraintsForCompactStyle() {
        // Define center alignment constraint for compact style
        titleLabelCenterXConstraint = titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
    }
    
    func defineConstraintsForFullStyle() {
        titleLabelLeadingConstraint = titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40)
    }
    
    func updateLayout(_ layout: GalleryCollectionViewLayout.Style) {
        titleLabelCenterXConstraint.isActive = false
        titleLabelLeadingConstraint.isActive = false
        
        // Activate the constraints based on the selected layout style
        switch layout {
        case .compact:
            titleLabelCenterXConstraint.isActive = true
        case .full:
            titleLabelLeadingConstraint.isActive = true
        }
        
        UIView.animate(withDuration: 0.25, delay: 0, options: [.curveEaseOut]) { [weak self] in
            self?.view.layoutIfNeeded()
        }
    }
}

extension GalleryDetailsViewController: GalleryCollectionViewLayoutDelegate {
    
    func layoutStyleDidUpdate(_ style: GalleryCollectionViewLayout.Style) {
        updateLayout(style)
    }
}
