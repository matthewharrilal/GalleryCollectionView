//
//  GalleryViewController.swift
//
//  Created by Space Wizard on 8/9/24.
//

/* Understanding Scrolling and Animations
 Continuous Scrolling and scrollViewDidScroll:
 Multiple Calls: During a continuous scroll, scrollViewDidScroll can be called multiple times per second, depending on how quickly the user scrolls. Each call represents a new update in the scroll position.
 Scroll Events: There is no strict concept of a single “scroll event” from the perspective of the UIScrollView. Instead, it’s a series of incremental updates as the user scrolls.
 */

 /* Animation Timing:
 Deferred Animations: Animations triggered by UIView.animate are indeed scheduled to run after the current run loop iteration. However, if scrollViewDidScroll is called multiple times during a continuous scroll, each call could potentially trigger a new animation, resulting in multiple animations occurring during a single scroll. */


/* Animation Overlap: If animations are scheduled in quick succession due to multiple scrollViewDidScroll calls, they may overlap or run concurrently. This can cause the background color to change multiple times as you scroll. */
/*
 Does “One Scroll” Exist?
 Concept of a Scroll: From the perspective of scrollViewDidScroll, each call is an independent update, so there isn’t a built-in concept of “one scroll” in terms of continuous movement. The scrolling is a continuous process where multiple updates occur, and each update triggers scrollViewDidScroll.
 */

/*
 Animations During Scroll: Because animations are scheduled and can overlap, you might see multiple background color changes during a single continuous scroll. This is expected behavior unless specifically managed to only trigger animations under certain conditions. */

import UIKit

class GalleryViewController: UIViewController {

    private lazy var collectionView: UICollectionView = {
        let layout = GalleryCollectionViewLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(GalleryCollectionViewCell.self, forCellWithReuseIdentifier: GalleryCollectionViewCell.identifier)
        return collectionView
    }()
    
    var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Google"
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
        // Do any additional setup after loading the view.
        
        setup()
    }
}

private extension GalleryViewController {
    
    func setup() {
        view.addSubview(collectionView)
        view.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: titleLabel.topAnchor),
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            
            titleLabel.centerXAnchor.constraint(equalTo: collectionView.centerXAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -UIScreen.main.bounds.height / 5)
        ])
    }
}


extension GalleryViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        30
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GalleryCollectionViewCell.identifier, for: indexPath) as? GalleryCollectionViewCell else { return UICollectionViewCell() }
        
        if let layoutAttributes = collectionView.layoutAttributesForItem(at: indexPath) as? GalleryCollectionViewLayoutAttributes, indexPath.item == 0 {
            collectionView.backgroundColor = layoutAttributes.containerColor?.withAlphaComponent(0.6)
        }
        
        cell.onTap = {
            if let layout = collectionView.collectionViewLayout as? GalleryCollectionViewLayout {
                layout.style = layout.style == .compact ? .full : .compact
            }
        }
        
        return cell
    }
}
