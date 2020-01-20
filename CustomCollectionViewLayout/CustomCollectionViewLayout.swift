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
    fileprivate let numberOfColumns = 3
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
        let columnWidth = contentWidth / CGFloat(numberOfColumns)
        var xOffSet = [CGFloat]()
        
        for column in 0..<numberOfColumns {
            if column == 0 {
                xOffSet.append(0)
            }
            if column == 1 {
                xOffSet.append(2*columnWidth)
            }
            if column == 2 {
                xOffSet.append(columnWidth)
            }
        }
        var column = 0
        var yOffSet = [CGFloat] ()
        for item in 0..<collectioView.numberOfItems(inSection: 0) {
            let indexPath = IndexPath(item: item, section: 0)
            for column in 0..<numberOfColumns {
                switch column {
                case 0,1:
                    yOffSet.append(2*cellPadding)
                case 2: yOffSet.append(cellPadding + cellHeight)
                default:
                    break
                }
            }
                let height = cellPadding * 2 + cellHeight
                let frame = CGRect(x: xOffSet[column], y: yOffSet[column], width: columnWidth, height: columnWidth)
                let insetFrame = frame.insetBy(dx: cellPadding, dy: cellPadding)
                
                //Creating attributres for the layout and caching them
                let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                attributes.frame = insetFrame
                cache.append(attributes)
                print ("frame.maxY", frame.maxY)
                
                //We increase the max height of the content as we get more items
                contentHeight = max(collectioView.frame.height + 10, frame.maxY)
                yOffSet[column] = yOffSet[column] + 2*(height - cellPadding)
                let numberOfItem = delegate?.numberOfItemsInCollectionView()
                if let numberOfItems = numberOfItem, indexPath.item == numberOfItems - 1
                {
                    //In case we get to the last cell, we check the column of the cell before
                    //The last one, and based on that, we change the column
                    print ("indexPath.item: \(indexPath.item), numberOfItems: \(numberOfItems)")
                    print ("A")
                    switch column {
                    case 0,1:
                        column = 2
                    case 2:
                        column = 0
                    default:
                        return
                    }
                } else  {
                    print ("B")
                    column = column < (numberOfColumns - 1) ? (column + 1) : 0
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
