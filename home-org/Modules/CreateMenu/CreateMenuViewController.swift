//
//  CreateMenuViewController.swift
//  home-org
//
//  Created by Benjamin Cante on 23/05/2021.
//

import UIKit
import MaterialComponents
import CoreData

protocol CreateMenuViewControllerDelegate: AnyObject {
    func handleClose(_ needUpdate: Bool)
}

class CreateMenuViewController: UIViewController {
    
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var courseSwitch: UISwitch!
    @IBOutlet weak var midiChipCollectionView: UICollectionView!
    @IBOutlet weak var soirChipCollectionView: UICollectionView!
    @IBOutlet weak var suggestChipCollectionView: UICollectionView!
    
    weak var delegate: CreateMenuViewControllerDelegate?
    private var needUpdate = false
    
    var date: Date?
    var menu: Menu?
    var midiDishes = [Dish]()
    var soirDishes = [Dish]()
    var dishes = [Dish]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        questionLabel.text = Constants.createMenu.question
        menu = fetchMenu() ?? createMenu()
        courseSwitch.isOn = menu?.courseDay ?? false
        dishes = fetchDishes()
        if let midi = menu?.midi {
            midiDishes = dishes.filter({ midi.contains($0.name ?? "") })
        }
        if let soir = menu?.soir {
            soirDishes = dishes.filter({ soir.contains($0.name ?? "") })
        }
        
        midiChipCollectionView.register(MDCChipCollectionViewCell.self, forCellWithReuseIdentifier: "MidiChip")
        midiChipCollectionView.dataSource = self
        midiChipCollectionView.delegate = self
        soirChipCollectionView.register(MDCChipCollectionViewCell.self, forCellWithReuseIdentifier: "SoirChip")
        soirChipCollectionView.dataSource = self
        soirChipCollectionView.delegate = self
        suggestChipCollectionView.register(MDCChipCollectionViewCell.self, forCellWithReuseIdentifier: "SuggestChip")
        suggestChipCollectionView.dataSource = self
        suggestChipCollectionView.delegate = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        delegate?.handleClose(needUpdate)
    }
    
    @IBAction func switchValueChanged(_ sender: UISwitch) {
        menu = updateMenu(sender.isOn)
    }
    
    private func fetchMenu() -> Menu? {
        guard let date = date else { return nil }
        let context = CoreDataManager.shared.mainContext
        let fetchRequest: NSFetchRequest<Menu> = Menu.fetchRequest()
        do {
            let results = try context.fetch(fetchRequest)
            return results.first(where: { $0.date == date })
        }
        catch {
            print(error)
        }
        return nil
    }
    
    private func createMenu() -> Menu? {
        guard let date = date else { return nil }
        
        let context = CoreDataManager.shared.mainContext
        let entity = Menu.entity()
        let menu = Menu(entity: entity, insertInto: context)
        menu.midi = []
        menu.soir = []
        menu.date = date
        
        do {
            try context.save()
            needUpdate = true
            return menu
        }
        catch {
            print(error)
        }
        return nil
    }
    
    private func updateMenu(_ isCourseDay: Bool) -> Menu? {
        guard let menu = menu else { return nil }
        
        let context = CoreDataManager.shared.mainContext
        menu.courseDay = isCourseDay
        
        do {
            try context.save()
            needUpdate = true
            return menu
        }
        catch {
            print(error)
        }
        return nil
    }
    
    private func fetchDishes() -> [Dish] {
        let context = CoreDataManager.shared.mainContext
        let fetchRequest: NSFetchRequest<Dish> = Dish.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "count", ascending: false)]
        do {
            let results = try context.fetch(fetchRequest)
            return results
        }
        catch {
            print(error)
        }
        return []
    }
    
    private func displayAddIngredientAlert(_ dish: Dish) {
        let alert = UIAlertController(title: Constants.AddDishToMenuAlert.title, message: Constants.AddDishToMenuAlert.subtitle, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: Constants.AddDishToMenuAlert.actionTitle1, style: .default, handler: { [weak self] action in
            self?.addDish(dish, isMidi: true)
        }))
        alert.addAction(UIAlertAction(title: Constants.AddDishToMenuAlert.actionTitle2, style: .default, handler: { [weak self] action in
            self?.addDish(dish, isMidi: false)
        }))
        
        present(alert, animated: true, completion: nil)
    }
    
    private func addDish(_ dish: Dish, isMidi: Bool) {
        guard let name = dish.name else { return }
        let context = CoreDataManager.shared.mainContext
        if isMidi {
            guard let midi = menu?.midi,
                  !midi.contains(name) else { return }
            menu?.midi?.append(name)
        } else {
            guard let soir = menu?.soir,
                  !soir.contains(name) else { return }
            menu?.soir?.append(name)
        }
        
        do {
            dish.count += 1
            needUpdate = true
            try context.save()
            reloadData()
        }
        catch {
            print(error)
        }
    }
    
    private func removeDish(_ dish: Dish, isMidi: Bool) {
        guard let name = dish.name else { return }
        let context = CoreDataManager.shared.mainContext
        if isMidi {
            guard let midi = menu?.midi,
                  midi.contains(name) else { return }
            menu?.midi = midi.filter({ $0 != name })
        } else {
            guard let soir = menu?.soir,
                  soir.contains(name) else { return }
            menu?.soir = soir.filter({ $0 != name })
        }
        
        do {
            dish.count -= 1
            needUpdate = true
            try context.save()
            reloadData()
        }
        catch {
            print(error)
        }
    }
    
    func reloadData() {
        menu = fetchMenu()
        dishes = fetchDishes()
        if let midi = menu?.midi {
            midiDishes = dishes.filter({ midi.contains($0.name ?? "") })
        }
        if let soir = menu?.soir {
            soirDishes = dishes.filter({ soir.contains($0.name ?? "") })
        }
        midiChipCollectionView.reloadData()
        soirChipCollectionView.reloadData()
        suggestChipCollectionView.reloadData()
    }
    
}

extension CreateMenuViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == midiChipCollectionView {
            return midiDishes.count
        } else if collectionView == soirChipCollectionView {
            return soirDishes.count
        } else if collectionView == suggestChipCollectionView {
            return dishes.count
        }
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var chipCell: MDCChipCollectionViewCell
        if collectionView == midiChipCollectionView,
           let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MidiChip", for: indexPath) as? MDCChipCollectionViewCell {
            chipCell = cell
        } else if collectionView == soirChipCollectionView,
                  let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SoirChip", for: indexPath) as? MDCChipCollectionViewCell {
            chipCell = cell
        } else if collectionView == suggestChipCollectionView,
                  let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SuggestChip", for: indexPath) as? MDCChipCollectionViewCell {
            chipCell = cell
        } else {
            return UICollectionViewCell()
        }
        
        
        let chipView = chipCell.chipView
        chipView.sizeToFit()
        
        if collectionView == midiChipCollectionView {
            if indexPath.row >= midiDishes.count {
                chipView.titleLabel.text = "+"
            } else {
                chipView.titleLabel.text = midiDishes[indexPath.row].name
            }
        } else if collectionView == soirChipCollectionView {
            if indexPath.row >= soirDishes.count {
                chipView.titleLabel.text = "+"
            } else {
                chipView.titleLabel.text = soirDishes[indexPath.row].name
            }
        } else if collectionView == suggestChipCollectionView {
            chipView.titleLabel.text = dishes[indexPath.row].name
        }
        
        chipView.setBackgroundColor(UIColor.white, for: .normal)
        chipView.setTitleColor(UIColor.black, for: .normal)
        
        chipView.setBackgroundColor(UIColor.white, for: .selected)
        chipView.setTitleColor(UIColor.black, for: .selected)
        
        return chipCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == midiChipCollectionView {
            midiChipCollectionView.deselectItem(at: indexPath, animated: true)
            guard midiDishes.indices.contains(indexPath.row) else { return }
            removeDish(midiDishes[indexPath.row], isMidi: true)
        } else if collectionView == soirChipCollectionView {
            soirChipCollectionView.deselectItem(at: indexPath, animated: true)
            guard soirDishes.indices.contains(indexPath.row) else { return }
            removeDish(soirDishes[indexPath.row], isMidi: false)
        } else if collectionView == suggestChipCollectionView {
            suggestChipCollectionView.deselectItem(at: indexPath, animated: true)
            if dishes.indices.contains(indexPath.row) {
                displayAddIngredientAlert(dishes[indexPath.row])
            }
        }
    }
}
