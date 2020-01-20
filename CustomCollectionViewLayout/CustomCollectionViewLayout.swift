//
//  CustomCollectionViewLayout.swift
//  CustomCollectionViewLayout
//
//  Created by Ravindra Sonkar on 20/01/20.
//  Copyright © 2020 Ravindra Sonkar. All rights reserved.
//

import Foundation
import UIKit

protocol CustomCollectionViewProtocol : class {
    func numberOfItemsInCollectionView() -> Int
}

extension CustomCollectionViewProtocol {
    func heightForContentInItem(at indexPath : IndexPath) -> Int {
        return 0
    }
}
class CustomCollectionViewLayout: UICollectionViewLayout {
    fileprivate let numberOfColoum = 3
    fileprivate let cellPadding : CGFloat = 6
    fileprivate let cellHeight : CGFloat = 150
    
    weak var delegate : CustomCollectionViewProtocol?
    //An array to cache the calculated attributes
    fileprivate	var cache = [UICollectionViewLayoutAttributes] ()
    
    fileprivate var contentHeight : CGFloat = 0
    fileprivate var contentWidth: CGFloat {
        guard let collectionView = collectionView else {return 0}
        //           let insets = collectionView.contentInset
        return collectionView.bounds.width // - (insets.left + insets.right)
    }
    
    override var collectionViewContentSize: CGSize	{
        return CGSize(width: contentWidth, height: contentHeight)
    }
    override func prepare() {
        guard cache.isEmpty == true, let collectioView = collectionView else {return}
        let coloumWidth = contentWidth / CGFloat(numberOfColoum)
        var xOffSet = [CGFloat]()
        
        for coloumn in 0..<numberOfColoum {
            if coloumn == 0 {
                xOffSet.append(0)
            }
            if coloumn == 1 {
                xOffSet.append(2*coloumWidth)
            }
            if coloumn == 2 {
                xOffSet.append(coloumWidth)
            }
        }
        var col = 0
        var yOffSet = [CGFloat] ()
        for item in 0..<collectioView.numberOfItems(inSection: 0) {
            let indexPath = IndexPath(item: item, section: 0)
            for coloumn in 0..<numberOfColoum {
                switch coloumn {
                case 0,1:
                    yOffSet.append(2*cellPadding)
                case 2: yOffSet.append(cellPadding + cellHeight)
                default:
                    break
                }
                let frame = CGRect(x: xOffSet[coloumn], y: yOffSet[coloumn], width: coloumWidth, height: coloumWidth)
                let insetFrame = frame.insetBy(dx: cellPadding, dy: cellPadding)
                let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                attributes.frame = insetFrame
                cache.append(attributes)
                contentHeight = max(collectioView.frame.height, frame.maxY)
                let height = cellPadding*2 + cellHeight
                yOffSet[coloumn] = yOffSet[coloumn] + 2*(height - cellPadding)
                let numberOfItem = delegate?.numberOfItemsInCollectionView()
                if let numberOfItems = numberOfItem, indexPath.item == numberOfItems - 1 {
                    switch coloumn {
                    case 0,1:
                        col = 2
                    case 2:
                        col = 0
                    default:
                        return
                    }
                }else {
                    col = col < (numberOfColoum - 1) ? (coloumn + 1) : 0
                }
            }
        }
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var visibleLayoutAttributes = [UICollectionViewLayoutAttributes]()
        for attribute in cache {
            if attribute.frame.intersects(rect) {
                visibleLayoutAttributes.append(attribute)
            }
        }
        return visibleLayoutAttributes
    }
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cache[indexPath.item]
    }
}
