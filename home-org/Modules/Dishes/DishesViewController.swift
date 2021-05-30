//
//  DishesViewController.swift
//  home-org
//
//  Created by Benjamin Cante on 22/05/2021.
//

import UIKit
import MaterialComponents

class DishesViewController: UIViewController {
    
    @IBOutlet weak var addButton: MDCFloatingButton!
    @IBOutlet weak var noDishLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    let cellIdentifier = "DishCell"
    let dishSegueIdentifier = "dishSegue"
    var dataArray = [String]()
    var selectedDish: Dish?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initComponent()
        fillData()        
        noDishLabel.isHidden = !dataArray.isEmpty
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
           dataArray.indices.contains(index) {
            // Fetch dish in local DB
            selectedDish = Dish(name: dataArray[index])
            performSegue(withIdentifier: dishSegueIdentifier, sender: nil)
        } else if let name = name {
            // Create dish in local DB
            selectedDish = Dish(name: name)
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
    }
    
    private func registerTableViewCells() {
        let dishCell = UINib(nibName: String(describing: DishTableViewCell.self), bundle: nil)
        tableView.register(dishCell,forCellReuseIdentifier: cellIdentifier)
    }
    
    private func fillData() {
        dataArray.append("Toto")
        dataArray.append("Test d'un nom de plat assez long")
        dataArray.append("Titi")
        dataArray.append("Test d'un nom de plat assez long, voire beaucoup, beaucoup trop long !")
        dataArray.append("Tabac")
        dataArray.append("Un bon petit plat")
        dataArray.append("Plat test")
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == dishSegueIdentifier {
            if let vc = segue.destination as? DishViewController {
                vc.dish = selectedDish
            }
        }
    }
}

extension DishesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? DishTableViewCell else {
            return UITableViewCell()
        }
        
        cell.dishTitle.text = dataArray[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        goToDish(index: indexPath.row)
    }
}
