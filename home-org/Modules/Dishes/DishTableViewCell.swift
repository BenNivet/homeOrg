//
//  DishTableViewCell.swift
//  home-org
//
//  Created by Benjamin Cante on 29/05/2021.
//

import UIKit
import MaterialComponents

class DishTableViewCell: UITableViewCell {
    
    @IBOutlet weak var card: MDCCard!
    @IBOutlet weak var dishTitle: UILabel!
    @IBOutlet private weak var chipsCollectionView: UICollectionView!
    var dataArray = [String]()

    override func awakeFromNib() {
        super.awakeFromNib()
        initComponent()
        fillData()
    }
    
    private func initComponent() {
        selectionStyle = .none
        chipsCollectionView.register(MDCChipCollectionViewCell.self, forCellWithReuseIdentifier: "DishChip")
        chipsCollectionView.dataSource = self
    }
    
    private func fillData() {
        if arc4random_uniform(2) == 0 {
            dataArray.append("Poulet")
            dataArray.append("Riz")
            dataArray.append("Poivrons")
        }
        
        if arc4random_uniform(2) == 0 {
            dataArray.append("Viande haché")
            dataArray.append("Pâtes fraiches")
        }
        
        if arc4random_uniform(2) == 0 {
            dataArray.append("Crevettes")
            dataArray.append("Avocat")
        }
        
        if arc4random_uniform(2) == 0 {
            dataArray.append("Surimi")
            dataArray.append("Taboulé")
        }
        
        if arc4random_uniform(2) == 0 {
            dataArray.append("Banane")
            dataArray.append("Nutella")
        }
        chipsCollectionView.reloadData()
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        return self
    }
}

extension DishTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DishChip", for: indexPath) as? MDCChipCollectionViewCell else {
            return UICollectionViewCell()            
        }
        
        let chipView = cell.chipView
        chipView.sizeToFit()
        chipView.titleLabel.text = dataArray[indexPath.row]
        chipView.setBackgroundColor(UIColor(named: "MainColor"), for: .normal)
        chipView.setTitleColor(UIColor.white, for: .normal)
        
        chipView.setBackgroundColor(UIColor(named: "MainColor"), for: .selected)
        chipView.setTitleColor(UIColor.white, for: .selected)
        
        return cell
    }
}
