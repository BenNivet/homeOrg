//
//  InventoriesViewController.swift
//  home-org
//
//  Created by Benjamin Cante on 22/05/2021.
//

import UIKit
import MaterialComponents

class InventoriesViewController: UIViewController {
    
    @IBOutlet weak var addButton: MDCFloatingButton!
    @IBOutlet weak var noInventoryLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        noInventoryLabel.text = Constants.LabelTitle.noInventory
        addButton.setTitle(Constants.ButtonTitle.addInventory.uppercased(), for: .normal)
        addButton.mode = .expanded
        addButton.reloadInputViews()
    }
    
    @IBAction func addInventory() {
        let alert = UIAlertController(title: Constants.InventoryAlert.title, message: Constants.InventoryAlert.subtitle, preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = Constants.InventoryAlert.placeholder
            textField.autocapitalizationType = .sentences
        }
        alert.addAction(UIAlertAction(title: Constants.InventoryAlert.actionTitle, style: .default, handler: { [weak self] action in
            guard let textField =  alert.textFields?.first else {
                self?.createInventory(nil)
                return
            }
            self?.createInventory(textField.text)
        }))
        alert.addAction(UIAlertAction(title: Constants.InventoryAlert.cancelTitle, style: .cancel, handler: nil))
        
        present(alert, animated: true, completion: nil)
    }
    
    func createInventory(_ name: String?) {
        guard let name = name else { return }
        print(name)
    }
}
