//
//  DishTableViewCell.swift
//  home-org
//
//  Created by Benjamin Cante on 29/05/2021.
//

import UIKit
import MaterialComponents

class DishTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var card: MDCCard!
    @IBOutlet weak var dishTitle: UILabel!
    @IBOutlet private weak var chipsCollectionView: UICollectionView!
    var dish: Dish?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initComponent()
    }
    
    private func initComponent() {
        selectionStyle = .none
        chipsCollectionView.register(MDCChipCollectionViewCell.self, forCellWithReuseIdentifier: "DishChip")
        chipsCollectionView.dataSource = self
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        return self
    }
}

extension DishTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dish?.ingredients?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DishChip", for: indexPath) as? MDCChipCollectionViewCell,
              let ingredients = dish?.ingredients else {
            return UICollectionViewCell()            
        }
        
        let chipView = cell.chipView
        chipView.sizeToFit()
        chipView.titleLabel.text = ingredients[indexPath.row]
        chipView.setBackgroundColor(UIColor(named: "MainColor"), for: .normal)
        chipView.setTitleColor(UIColor.white, for: .normal)
        
        chipView.setBackgroundColor(UIColor(named: "MainColor"), for: .selected)
        chipView.setTitleColor(UIColor.white, for: .selected)
        
        return cell
    }
}
