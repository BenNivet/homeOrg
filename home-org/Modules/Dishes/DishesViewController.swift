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

    override func viewDidLoad() {
        super.viewDidLoad()
        noDishLabel.text = Constants.LabelTitle.noDish
        addButton.setTitle(Constants.ButtonTitle.addDish.uppercased(), for: .normal)
        addButton.mode = .expanded
    }
    
    @IBAction func addDish() {
        // TODO
    }
}
