//
//  ScalableContainerView.swift
//  GalleryView
//
//  Created by Space Wizard on 8/11/24.
//

import Foundation
import UIKit

class ScalableContainerView: UIView {
    
    var onTap: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        let tapGestureRecognizer =  UITapGestureRecognizer(target: self, action: #selector(handleTap))
        addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func handleTap() {
        onTap?()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        UIView.animate(withDuration: 0.25, delay: 0, options: [.curveEaseOut]) { [weak self] in
            self?.transform = CGAffineTransform(scaleX: 1.25, y: 1.25)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        
        UIView.animate(withDuration: 0.25, delay: 0, options: [.curveEaseOut]) { [weak self] in
            self?.transform = .identity
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        
        UIView.animate(withDuration: 0.25, delay: 0, options: [.curveEaseOut]) { [weak self] in
            self?.transform = .identity
        }
    }
}
