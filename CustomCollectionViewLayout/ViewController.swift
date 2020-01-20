//
//  ViewController.swift
//  CustomCollectionViewLayout
//
//  Created by Ravindra Sonkar on 20/01/20.
//  Copyright © 2020 Ravindra Sonkar. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var collectionView : UICollectionView! {
        didSet {
            collectionView.delegate = self
            collectionView.dataSource = self
        }
    }
    var numbers = [Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        for i in 1...33 {
            numbers.append(i)
        }
        let layout = collectionView.collectionViewLayout as? CustomCollectionViewLayout
        layout?.delegate = self
        // Do any additional setup after loading the view.
    }
}

extension ViewController : UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numbers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
        cell.layer.cornerRadius = cell.frame.width / 2
        cell.clipsToBounds = true
        cell.lbl.text = numbers[indexPath.row].description
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        cell.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.8, options: .curveEaseOut, animations: {
            cell.transform = .identity
        }, completion: nil)
    }
}


extension ViewController : CustomCollectionViewProtocol {
    func numberOfItemsInCollectionView() -> Int {
        return numbers.count
    }
    
    
}
class CollectionViewCell : UICollectionViewCell {
    @IBOutlet weak var lbl : UILabel!
}
