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
            let layout = collectionView.collectionViewLayout as? GalleryCollectionViewLayout,
            let visibleAttributes = collectionView.collectionViewLayout.layoutAttributesForElements(in: collectionView.bounds),
            let firstVisibleAttribute = visibleAttributes.first,
            let lastVisibleAttribute = visibleAttributes.last
        else { return }
        
        let visibleWidth = collectionView.bounds.width
        let offsetX = collectionView.contentOffset.x
        
        let delta = offsetX / (layout.visibleContentWidth - visibleWidth)
        
        guard
            let firstColor = (firstVisibleAttribute as? GalleryCollectionViewLayoutAttributes)?.containerColor,
            let secondColor = (lastVisibleAttribute as? GalleryCollectionViewLayoutAttributes)?.containerColor
        else { return }
        
        // Interpolate the color based on the scroll position
        let blendedColor = UIColor.blendColor(from: firstColor, to: secondColor, percentage: delta)
        collectionView.backgroundColor = blendedColor
    }
}
