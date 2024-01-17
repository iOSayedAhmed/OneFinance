//
//  CollectionViewLayouts.swift
//  OneFinanceTask
//
//  Created by iOSAYed on 17/01/2024.
//

import Foundation
import UIKit

final class CollectionViewLayouts {
    
    static let shared = CollectionViewLayouts()
    
    
    func createCategoryCellLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/3), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = .init(top: 0, leading: 5, bottom: 0, trailing: 5)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(50))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = .init(top: 10, leading: 0, bottom: 0, trailing: 0)
       // section.boundarySupplementaryItems = [headerViewSupplmentaryView()]

        return section
    }
    
    
    
}
