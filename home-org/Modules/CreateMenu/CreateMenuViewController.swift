//
//  CreateMenuViewController.swift
//  home-org
//
//  Created by Benjamin Cante on 23/05/2021.
//

import UIKit
import MaterialComponents

class CreateMenuViewController: UIViewController {
    
    @IBOutlet weak var questionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        questionLabel.text = Constants.createMenu.question
    }
}
