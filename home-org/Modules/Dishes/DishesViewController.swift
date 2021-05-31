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
    
    let cellIdentifier = "DishCell"
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
            do {
                try saveDish(name: name)
                performSegue(withIdentifier: dishSegueIdentifier, sender: nil)
            } catch {
                print(error)
            }
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
    
    func fetchDishes() -> [Dish] {
        let mainContext = CoreDataManager.shared.mainContext
        let fetchRequest: NSFetchRequest<Dish> = Dish.fetchRequest()
        do {
            let results = try mainContext.fetch(fetchRequest)
            return results
        }
        catch {
            print(error)
        }
        return []
    }
    
    func saveDish(name: String) throws {
        let context = CoreDataManager.shared.mainContext
        let entity = Dish.entity()
        let dish = Dish(entity: entity, insertInto: context)
        dish.name = name
        dish.ingredients = []
        dishes.append(dish)
        selectedDish = dish
        try context.save()
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

extension DishesViewController: UITableViewDelegate, UITableViewDataSource {
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
}

extension DishesViewController: DishViewControllerDelegate {
    func handleClose(_ needUpdate: Bool) {
        needUpdate ? updateData() : nil
    }
}
