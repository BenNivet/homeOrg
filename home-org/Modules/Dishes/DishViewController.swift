//
//  DishViewController.swift
//  home-org
//
//  Created by Benjamin Cante on 29/05/2021.
//

import UIKit
import MaterialComponents
import CoreData

protocol DishViewControllerDelegate: AnyObject {
    func handleClose(_ needUpdate: Bool)
}

class DishViewController: UIViewController {
    
    @IBOutlet weak var dishCard: MDCCard!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet private weak var ingredientsChipsCollectionView: UICollectionView!
    @IBOutlet private weak var suggestChipsCollectionView: UICollectionView!
    weak var delegate: DishViewControllerDelegate?
    
    var needUpdate = false
    
    var dish: Dish?
    var ingredients = [Ingredient]()
    var suggestions = [Ingredient]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initComponent()
        fetchData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        delegate?.handleClose(needUpdate)
    }
    
    @objc func rename() {
        let alert = UIAlertController(title: Constants.RenameDishAlert.title, message: Constants.RenameDishAlert.subtitle, preferredStyle: .alert)
        alert.addTextField { [weak self] textField in
            textField.text = self?.dish?.name
        }
        alert.addAction(UIAlertAction(title: Constants.AddDishAlert.actionTitle, style: .default, handler: { [weak self] action in
            guard let textField =  alert.textFields?.first,
                  let name = textField.text else {
                return
            }
            do {
                try self?.updateName(name)
                self?.titleLabel.text = name
            } catch {
                print(error)
            }
        }))
        alert.addAction(UIAlertAction(title: Constants.AddDishAlert.cancelTitle, style: .cancel, handler: nil))
        
        present(alert, animated: true, completion: nil)
    }
    
    func updateName(_ name: String) throws {
        guard let dish = dish else { return }
        
        let context = CoreDataManager.shared.mainContext
        needUpdate = true
        dish.name = name
        try context.save()
    }
    
    private func initComponent() {
        dishCard.addTarget(self, action: #selector(rename), for: .touchUpInside)
        titleLabel.text = dish?.name
        ingredientsChipsCollectionView.register(MDCChipCollectionViewCell.self, forCellWithReuseIdentifier: "IngredientChip")
        ingredientsChipsCollectionView.dataSource = self
        ingredientsChipsCollectionView.delegate = self
        suggestChipsCollectionView.register(MDCChipCollectionViewCell.self, forCellWithReuseIdentifier: "SuggestChip")
        suggestChipsCollectionView.dataSource = self
        suggestChipsCollectionView.delegate = self
    }
    
    private func fetchData() {
        ingredients = fetchIngredient()
        ingredientsChipsCollectionView.reloadData()
        suggestions = fetchSuggestions()
        suggestChipsCollectionView.reloadData()
    }
    
    func fetchIngredient() -> [Ingredient] {
        let mainContext = CoreDataManager.shared.mainContext
        let fetchRequest: NSFetchRequest<Ingredient> = Ingredient.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "ANY name IN %@", dish?.ingredients ?? [])
        do {
            let results = try mainContext.fetch(fetchRequest)
            return results
        }
        catch {
            print(error)
        }
        return []
    }
    
    func fetchSuggestions() -> [Ingredient] {
        let mainContext = CoreDataManager.shared.mainContext
        let fetchRequest: NSFetchRequest<Ingredient> = Ingredient.fetchRequest()
        do {
            let results = try mainContext.fetch(fetchRequest)
            return results
        }
        catch {
            print(error)
        }
        return []
    }
    
    private func displayAddIngredientAlert() {
        let alert = UIAlertController(title: Constants.AddIngredientAlert.title, message: Constants.AddIngredientAlert.subtitle, preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = Constants.AddIngredientAlert.placeholder
        }
        alert.addAction(UIAlertAction(title: Constants.AddIngredientAlert.actionTitle, style: .default, handler: { [weak self] action in
            guard let textField =  alert.textFields?.first,
                  let name = textField.text else {
                return
            }
            do {
                try self?.createIngredient(name)
                self?.fetchData()
            } catch {
                print(error)
            }
        }))
        alert.addAction(UIAlertAction(title: Constants.AddDishAlert.cancelTitle, style: .cancel, handler: nil))
        
        present(alert, animated: true, completion: nil)
    }
    
    private func createIngredient(_ name: String) throws {
        guard let dish = dish else { return }
        
        if suggestions.compactMap({ $0.name }).contains(name) {
            dish.ingredients?.append(name)
        } else {
            let context = CoreDataManager.shared.mainContext
           
            let entity = Ingredient.entity()
            let ingredient = Ingredient(entity: entity, insertInto: context)
            ingredient.name = name
            dish.ingredients?.append(name)
            
            try context.save()
        }
        needUpdate = true
    }
    
    private func addIngredient(_ ingredient: Ingredient) throws {
        guard let dish = dish,
              let name = ingredient.name,
              !(dish.ingredients?.contains(name) ?? false) else { return }
        
        let context = CoreDataManager.shared.mainContext
        dish.ingredients?.append(name)
        ingredient.count += 1
        
        try context.save()
        needUpdate = true
    }
}

extension DishViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == ingredientsChipsCollectionView {
            return ingredients.count + 1
        } else if collectionView == suggestChipsCollectionView {
            return suggestions.count
        }
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var chipCell: MDCChipCollectionViewCell
        if collectionView == ingredientsChipsCollectionView,
           let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "IngredientChip", for: indexPath) as? MDCChipCollectionViewCell {
            chipCell = cell
        } else if collectionView == suggestChipsCollectionView,
                  let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SuggestChip", for: indexPath) as? MDCChipCollectionViewCell {
            chipCell = cell
        } else {
            return UICollectionViewCell()
        }
        
        
        let chipView = chipCell.chipView
        chipView.sizeToFit()
        
        if collectionView == ingredientsChipsCollectionView {
            if indexPath.row >= ingredients.count {
                chipView.titleLabel.text = "+"
            } else {
                chipView.titleLabel.text = ingredients[indexPath.row].name
            }
        } else if collectionView == suggestChipsCollectionView {
            chipView.titleLabel.text = suggestions[indexPath.row].name
        }
        
        chipView.setBackgroundColor(UIColor(named: "MainColor"), for: .normal)
        chipView.setTitleColor(UIColor.white, for: .normal)
        
        chipView.setBackgroundColor(UIColor(named: "MainColor"), for: .selected)
        chipView.setTitleColor(UIColor.white, for: .selected)
        
        return chipCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == ingredientsChipsCollectionView {
            if indexPath.row >= ingredients.count {
                displayAddIngredientAlert()
            }
            ingredientsChipsCollectionView.deselectItem(at: indexPath, animated: true)
        } else if collectionView == suggestChipsCollectionView {
            suggestChipsCollectionView.deselectItem(at: indexPath, animated: true)
            if suggestions.indices.contains(indexPath.row) {
                do {
                    try addIngredient(suggestions[indexPath.row])
                    fetchData()
                } catch {
                    print(error)
                }
            }
        }
    }
}
