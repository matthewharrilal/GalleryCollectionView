//
//  ScalableContainerView.swift
//  GalleryView
//
//  Created by Space Wizard on 8/11/24.
//

import Foundation
import UIKit

class ScalableContainerView: UIView {
    
    var isScalable: Bool = true
    
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        if let poppinsFont = UIFont(name: "Poppins-ExtraBold", size: 20) {
            label.font = poppinsFont
        } else {
            label.font = UIFont.systemFont(ofSize: 17) // Fallback if Nunito isn't available
        }
        return label
    }()
    
    var onTap: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(text: String) {
        titleLabel.text = text
    }
    
    private func setup() {
        let tapGestureRecognizer =  UITapGestureRecognizer(target: self, action: #selector(handleTap))
        addGestureRecognizer(tapGestureRecognizer)
        
        addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5)
        ])
    }
    
    @objc func handleTap() {
        onTap?()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        guard isScalable else { return }
        
        UIView.animate(withDuration: 0.25, delay: 0, options: [.curveEaseOut]) { [weak self] in
            self?.transform = CGAffineTransform(scaleX: 1.25, y: 1.25)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        
        guard isScalable else { return }
        
        UIView.animate(withDuration: 0.25, delay: 0, options: [.curveEaseOut]) { [weak self] in
            self?.transform = .identity
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        
        guard isScalable else { return }
        
        UIView.animate(withDuration: 0.25, delay: 0, options: [.curveEaseOut]) { [weak self] in
            self?.transform = .identity
        }
    }
}
