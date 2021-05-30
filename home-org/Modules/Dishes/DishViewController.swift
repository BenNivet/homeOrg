//
//  DishViewController.swift
//  home-org
//
//  Created by Benjamin Cante on 29/05/2021.
//

import UIKit
import MaterialComponents

class DishViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet private weak var chipsCollectionView: UICollectionView!
    
    var dish: Dish?
    var dataArray = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        initComponent()
        fillData()
    }
    
    private func initComponent() {
        titleLabel.text = dish?.name
        chipsCollectionView.register(MDCChipCollectionViewCell.self, forCellWithReuseIdentifier: "SuggestChip")
        chipsCollectionView.dataSource = self
    }
    
    private func fillData() {
        dataArray.append("Poulet")
        dataArray.append("Riz")
        dataArray.append("Poivrons")
        dataArray.append("Viande haché")
        dataArray.append("Pâtes fraiches")
        dataArray.append("Crevettes")
        dataArray.append("Avocat")
        dataArray.append("Surimi")
        dataArray.append("Taboulé")
        dataArray.append("Banane")
        dataArray.append("Nutella")
        chipsCollectionView.reloadData()
    }

}

extension DishViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SuggestChip", for: indexPath) as? MDCChipCollectionViewCell else {
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
