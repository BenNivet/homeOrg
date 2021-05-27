//
//  CoursesViewController.swift
//  home-org
//
//  Created by Benjamin Cante on 22/05/2021.
//

import UIKit
import MaterialComponents

class CoursesViewController: UIViewController {

    @IBOutlet weak var addButton: MDCFloatingButton!
    @IBOutlet weak var noCourseLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        noCourseLabel.text = Constants.LabelTitle.noCourse
        addButton.setTitle(Constants.ButtonTitle.addCourse.uppercased(), for: .normal)
        addButton.mode = .expanded
    }
    
    @IBAction func addArticle() {
        // TODO (name & quantity)
    }
    
}
