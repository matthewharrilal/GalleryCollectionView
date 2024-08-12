//
//  GalleryDetailsViewController.swift
//  GalleryView
//
//  Created by Space Wizard on 8/12/24.
//

import Foundation
import UIKit

class GalleryDetailsViewController: UIViewController {
    
    public lazy var viewColor: UIColor = .white {
        didSet {
            view.backgroundColor = viewColor
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
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
}
