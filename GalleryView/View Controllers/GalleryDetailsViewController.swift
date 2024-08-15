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
    
    private var descriptionLabelCenterXConstraint: NSLayoutConstraint!
    private var descriptionLabelLeadingConstraint: NSLayoutConstraint!
    
    private var sendButtonLeadingConstraint: NSLayoutConstraint!
    private var sendButtonTrailingConstraint: NSLayoutConstraint!
    private var sendButtonHeightConstraint: NSLayoutConstraint!
    private var sendButtonWidthConstraint: NSLayoutConstraint!
    
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
    
    private var descriptionLabel: UILabel = {
        let label = UILabel()
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = UIView.singleWordArray.randomElement()
        label.textColor = .white
        if let poppinsFont = UIFont(name: "Poppins-ExtraBold", size: 20) {
            label.font = poppinsFont
        } else {
            label.font = UIFont.systemFont(ofSize: 15) // Fallback if Nunito isn't available
        }
        return label
    }()
    
    private var salesLabel: UILabel = {
        let label = UILabel()
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Last Sale"
        label.textColor = .white
        if let poppinsFont = UIFont(name: "Poppins-ExtraBold", size: 20) {
            label.font = poppinsFont
        } else {
            label.font = UIFont.systemFont(ofSize: 15) // Fallback if Nunito isn't available
        }
        return label
    }()
    
    private var noSalesYetLabel: UILabel = {
        let label = UILabel()
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "No Sales Yet"
        label.textColor = .white
        if let poppinsFont = UIFont(name: "Poppins-Bold", size: 16) {
            label.font = poppinsFont
        } else {
            label.font = UIFont.systemFont(ofSize: 15) // Fallback if Nunito isn't available
        }
        return label
    }()
    
    private var floorPriceLabel: UILabel = {
        let label = UILabel()
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Floor Price"
        label.textColor = .white
        if let poppinsFont = UIFont(name: "Poppins-ExtraBold", size: 20) {
            label.font = poppinsFont
        } else {
            label.font = UIFont.systemFont(ofSize: 15) // Fallback if Nunito isn't available
        }
        return label
    }()
    
    private var priceAmountLabel: UILabel = {
        let label = UILabel()
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "0.21 Ether"
        label.textColor = .white
        if let poppinsFont = UIFont(name: "Poppins-Bold", size: 16) {
            label.font = poppinsFont
        } else {
            label.font = UIFont.systemFont(ofSize: 15) // Fallback if Nunito isn't available
        }
        return label
    }()
    
    private var interactiveCTAView: ScalableContainerView = {
        let view = ScalableContainerView()
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        view.configure(text: "Interactive")
        view.layer.cornerRadius = 18
        view.isScalable = false
        view.backgroundColor = .clear
        view.layer.borderColor = UIColor.white.cgColor
        view.layer.borderWidth = 2
        return view
    }()
    
    private lazy var sendButton: ScalableContainerView = {
        let view = ScalableContainerView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(hex: "F7AEF8")
        view.layer.cornerRadius = 28
        view.onTap = { [weak self] in
            self?.applyTransformationToSendButton()
        }
        return view
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
        view.addSubviews(views: titleLabel, descriptionLabel, interactiveCTAView, salesLabel, noSalesYetLabel, floorPriceLabel, priceAmountLabel, sendButton)
        
        sendButtonTrailingConstraint = sendButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30)
        sendButtonWidthConstraint = sendButton.widthAnchor.constraint(equalToConstant: 56)
        sendButtonHeightConstraint = sendButton.heightAnchor.constraint(equalToConstant: 56)
        sendButtonLeadingConstraint = sendButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 30),
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            
            interactiveCTAView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 20),
            interactiveCTAView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            interactiveCTAView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            interactiveCTAView.heightAnchor.constraint(equalToConstant: 44),
            
            salesLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 48),
            salesLabel.topAnchor.constraint(equalTo: interactiveCTAView.bottomAnchor, constant: 24),
            salesLabel.heightAnchor.constraint(equalToConstant: 28),
            
            noSalesYetLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 48),
            noSalesYetLabel.topAnchor.constraint(equalTo: salesLabel.bottomAnchor, constant: 10),
            noSalesYetLabel.heightAnchor.constraint(equalToConstant: 28),
            
            floorPriceLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -48),
            floorPriceLabel.topAnchor.constraint(equalTo: interactiveCTAView.bottomAnchor, constant: 24),
            floorPriceLabel.heightAnchor.constraint(equalToConstant: 28),
            
            priceAmountLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -48),
            priceAmountLabel.topAnchor.constraint(equalTo: floorPriceLabel.bottomAnchor, constant: 10),
            priceAmountLabel.heightAnchor.constraint(equalToConstant: 28),
            
            sendButtonTrailingConstraint,
            sendButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            sendButtonWidthConstraint,
            sendButtonHeightConstraint
        ])
        
        defineConstraintsForFullStyle()
        defineConstraintsForCompactStyle()
        
        updateLayout(layoutStyle)
    }
    
    func defineConstraintsForCompactStyle() {
        // Define center alignment constraint for compact style
        titleLabelCenterXConstraint = titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        descriptionLabelCenterXConstraint = descriptionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
    }
    
    func defineConstraintsForFullStyle() {
        titleLabelLeadingConstraint = titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40)
        descriptionLabelLeadingConstraint = descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40)
    }
    
    func updateLayout(_ layout: GalleryCollectionViewLayout.Style) {
        titleLabelCenterXConstraint.isActive = false
        titleLabelLeadingConstraint.isActive = false
        
        descriptionLabelCenterXConstraint.isActive = false
        descriptionLabelLeadingConstraint.isActive = false
        
        // Activate the constraints based on the selected layout style
        switch layout {
        case .compact:
            titleLabelCenterXConstraint.isActive = true
            descriptionLabelCenterXConstraint.isActive = true
            
            UIView.animate(withDuration: 0.25, delay: 0, options: [.curveEaseOut]) { [weak self] in
                guard let self = self else { return }
                [self.descriptionLabel, self.interactiveCTAView, self.salesLabel, self.noSalesYetLabel, self.floorPriceLabel, self.priceAmountLabel].forEach {
                    $0.alpha = 0
                    $0.isHidden = true
                }
            }
        case .full:
            titleLabelLeadingConstraint.isActive = true
            descriptionLabelLeadingConstraint.isActive = true
            
            UIView.animate(withDuration: 0.25, delay: 0, options: [.curveEaseOut]) { [weak self] in
                guard let self = self else { return }
                [self.descriptionLabel, self.interactiveCTAView, self.salesLabel, self.noSalesYetLabel, self.floorPriceLabel, self.priceAmountLabel].forEach {
                    $0.alpha = 1
                    $0.isHidden = false
                }
            }
        }
        
        UIView.animate(withDuration: 0.25, delay: 0, options: [.curveEaseOut]) { [weak self] in
            self?.view.layoutIfNeeded()
        }
    }
    
    func applyTransformationToSendButton() {
        sendButtonTrailingConstraint.constant = -24
        sendButtonWidthConstraint.isActive = false
        sendButtonLeadingConstraint.isActive = true
        sendButtonHeightConstraint.constant = 66
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1.2, options: [.curveEaseOut]) { [weak self] in
            self?.view.layoutIfNeeded()
        }
    }
}

extension GalleryDetailsViewController: GalleryCollectionViewLayoutDelegate {
    
    func layoutStyleDidUpdate(_ style: GalleryCollectionViewLayout.Style) {
        updateLayout(style)
    }
}
