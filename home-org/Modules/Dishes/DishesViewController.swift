//
//  DishesViewController.swift
//  home-org
//
//  Created by Benjamin Cante on 22/05/2021.
//

import UIKit
import MaterialComponents
import CoreData

class DishesViewController: UIViewController {
    
    @IBOutlet weak var addButton: MDCFloatingButton!
    @IBOutlet weak var noDishLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    private let cellIdentifier = "DishCell"
    let dishSegueIdentifier = "dishSegue"
    var dishes = [Dish]()
    var selectedDish: Dish?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initComponent()
        updateData()
    }
    
    @IBAction func addDish() {
        let alert = UIAlertController(title: Constants.AddDishAlert.title, message: Constants.AddDishAlert.subtitle, preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = Constants.AddDishAlert.placeholder
            textField.autocapitalizationType = .sentences
        }
        alert.addAction(UIAlertAction(title: Constants.AddDishAlert.actionTitle, style: .default, handler: { [weak self] action in
            guard let textField =  alert.textFields?.first else {
                return
            }
            self?.goToDish(name: textField.text)
        }))
        alert.addAction(UIAlertAction(title: Constants.AddDishAlert.cancelTitle, style: .cancel, handler: nil))
        
        present(alert, animated: true, completion: nil)
    }
    
    func goToDish(index: Int? = nil, name: String? = nil) {
        if let index = index,
           dishes.indices.contains(index) {
            selectedDish = dishes[index]
            performSegue(withIdentifier: dishSegueIdentifier, sender: nil)
        } else if let name = name {
            saveDish(name: name)
            updateData()
            performSegue(withIdentifier: dishSegueIdentifier, sender: nil)
        }
    }
    
    private func initComponent() {
        tableView.delegate = self
        tableView.dataSource = self
        registerTableViewCells()
        tableView.contentInset = UIEdgeInsets(top:0, left: 0, bottom: 85, right: 0)
        tableView.separatorInset = UIEdgeInsets.zero
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        
        noDishLabel.text = Constants.LabelTitle.noDish
        
        addButton.setTitle(Constants.ButtonTitle.addDish.uppercased(), for: .normal)
        addButton.mode = .expanded
        addButton.reloadInputViews()
    }
    
    private func registerTableViewCells() {
        let dishCell = UINib(nibName: String(describing: DishTableViewCell.self), bundle: nil)
        tableView.register(dishCell,forCellReuseIdentifier: cellIdentifier)
    }
    
    private func updateData() {
        dishes = fetchDishes()
        noDishLabel.isHidden = !dishes.isEmpty
        tableView.reloadData()
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
    
    func saveDish(name: String) {
        let context = CoreDataManager.shared.mainContext
        let entity = Dish.entity()
        let dish = Dish(entity: entity, insertInto: context)
        do {
            dish.name = name
            dish.ingredients = []
            dishes.append(dish)
            selectedDish = dish
            try context.save()
        }
        catch {
            print(error)
        }
    }
    
    private func removeDish(_ dish: Dish) {
        do {
            removeDishInMenus(dish)
            let context = CoreDataManager.shared.mainContext
            context.delete(dish)
            try context.save()
        }
        catch {
            print(error)
        }
    }
    
    private func removeDishInMenus(_ dish: Dish) {
        let context = CoreDataManager.shared.mainContext
        let fetchRequest: NSFetchRequest<Menu> = Menu.fetchRequest()
        do {
            let results = try context.fetch(fetchRequest)
            for menu in results {
                if let midi = menu.midi {
                    menu.midi = midi.filter({ $0 != dish.name })
                }
                if let soir = menu.soir {
                    menu.soir = soir.filter({ $0 != dish.name })
                }
            }
            try context.save()
        }
        catch {
            print(error)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == dishSegueIdentifier {
            if let vc = segue.destination as? DishViewController {
                vc.dish = selectedDish
                vc.delegate = self
            }
        }
    }
}

extension DishesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dishes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? DishTableViewCell else {
            return UITableViewCell()
        }
        let dish = dishes[indexPath.row]
        cell.dishTitle.text = dish.name
        cell.dish = dish
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        goToDish(index: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
}
    
extension DishesViewController: UITableViewDelegate {
    private func deleteDish(at indexPath: IndexPath) {
        guard dishes.indices.contains(indexPath.row) else { return }
        removeDish(dishes[indexPath.row])
        dishes.remove(at: indexPath.row)
        tableView.beginUpdates()
        tableView.deleteRows(at: [indexPath], with: .automatic)
        tableView.endUpdates()
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        return UISwipeActionsConfiguration(actions: [UIContextualAction(style: .destructive, title: Constants.ButtonTitle.deleteMenu) { (action, swipeButtonView, completion) in
            self.deleteDish(at: indexPath)
            completion(true)
        }])
    }
}

extension DishesViewController: DishViewControllerDelegate {
    func handleClose(_ needUpdate: Bool) {
        needUpdate ? updateData() : nil
    }
}
