//
//  GalleryViewController.swift
//
//  Created by Space Wizard on 8/9/24.
//

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

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setup()
    }
}

private extension GalleryViewController {
    
    func setup() {
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        ])
    }
}


extension GalleryViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GalleryCollectionViewCell.identifier, for: indexPath) as? GalleryCollectionViewCell else { return UICollectionViewCell() }
        
        return cell
    }
}

extension GalleryViewController: UICollectionViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard
            let collectionView = scrollView as? UICollectionView,
            let layout = collectionView.collectionViewLayout as? GalleryCollectionViewLayout
        else { return }
        
        // Calculate the center point of the collection view
        let centerX = collectionView.bounds.width / 2 + collectionView.contentOffset.x
        
        // Get the visible rect of the collection view
        let visibleRect = CGRect(origin: collectionView.contentOffset, size: collectionView.bounds.size)
        
        // Get the attributes for all cells in the visible rect
        guard let visibleAttributes = collectionView.collectionViewLayout.layoutAttributesForElements(in: visibleRect) else { return }
        
        // Find the attribute that is closest to the center of the collection view
        var closestAttribute: UICollectionViewLayoutAttributes?
        var minimumDistance = CGFloat.greatestFiniteMagnitude
        
        
        // As the user scrolls:
        // - The distance between the center of the cell (attribute.center.x) and
        //   the center of the viewable width (centerX) gets smaller.
        // - This smaller distance updates the `distance` variable, qualifying
        //   this cell (attribute) to be the new closest-to-center cell.
        // - Consequently, the color of the collection view background changes
        //   to match the color of this closest-to-center cell.
        for attribute in visibleAttributes {
            
            let distance = abs(attribute.center.x - centerX)
            if distance < minimumDistance {
                minimumDistance = distance
                closestAttribute = attribute
            }
        }
        
        // If a closest attribute was found, update the background color
        if let closestAttribute = closestAttribute as? GalleryCollectionViewLayoutAttributes {
            UIView.animate(withDuration: 0.25, delay: 0, options: [.curveEaseInOut]) {
                collectionView.backgroundColor = closestAttribute.containerColor?.withAlphaComponent(0.6)
            }
        }
    }
}
