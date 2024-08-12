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
    
    public lazy var galleryDetailsViewController = GalleryDetailsViewController()
    private var collectionViewHeightConstraint: NSLayoutConstraint!

    private lazy var collectionView: UICollectionView = {
        let layout = GalleryCollectionViewLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(GalleryCollectionViewCell.self, forCellWithReuseIdentifier: GalleryCollectionViewCell.identifier)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        return collectionView
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
        addDetailsViewController()
        
        collectionViewHeightConstraint = collectionView.heightAnchor.constraint(lessThanOrEqualToConstant: UIScreen.main.bounds.height / 1.5)
        
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionViewHeightConstraint,
            
            galleryDetailsViewController.view.topAnchor.constraint(equalTo: collectionView.bottomAnchor),
            galleryDetailsViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            galleryDetailsViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            galleryDetailsViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func addDetailsViewController() {
        addChild(galleryDetailsViewController)
        
        galleryDetailsViewController.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(galleryDetailsViewController.view)
        
        galleryDetailsViewController.didMove(toParent: self)
    }
}


extension GalleryViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        30
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GalleryCollectionViewCell.identifier, for: indexPath) as? GalleryCollectionViewCell else { return UICollectionViewCell() }
        
        if let layoutAttributes = collectionView.layoutAttributesForItem(at: indexPath) as? GalleryCollectionViewLayoutAttributes, indexPath.item == 0 {
            collectionView.backgroundColor = layoutAttributes.containerColor?.withAlphaComponent(0.2)
            galleryDetailsViewController.viewColor = layoutAttributes.containerColor?.withAlphaComponent(0.2)
        }
        
        cell.onTap = { [weak self] in
            if let layout = collectionView.collectionViewLayout as? GalleryCollectionViewLayout {
                layout.style = layout.style == .compact ? .full : .compact
                self?.galleryDetailsViewController.layoutStyle = layout.style
            }
        }
        
        return cell
    }
}
