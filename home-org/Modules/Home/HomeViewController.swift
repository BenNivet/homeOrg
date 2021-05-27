//
//  HomeViewController.swift
//  home-org
//
//  Created by Benjamin Cante on 22/05/2021.
//

import UIKit
import MaterialComponents

class HomeViewController: UIViewController {
    @IBOutlet weak var firstCard: MDCCard!
    @IBOutlet weak var firstLabel: UILabel!
    @IBOutlet weak var secondCard: MDCCard!
    @IBOutlet weak var secondLabel: UILabel!
    @IBOutlet weak var thirdCard: MDCCard!
    @IBOutlet weak var thirdLabel: UILabel!
    @IBOutlet weak var fourthCard: MDCCard!
    @IBOutlet weak var fourthLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        firstLabel.text = Constants.HomeTitle.first.uppercased()
        secondLabel.text = Constants.HomeTitle.second.uppercased()
        thirdLabel.text = Constants.HomeTitle.third.uppercased()
        fourthLabel.text = Constants.HomeTitle.fourth.uppercased()
        
        firstCard.addTarget(self, action: #selector(firstTapped), for: .touchUpInside)
        secondCard.addTarget(self, action: #selector(secondTapped), for: .touchUpInside)
        thirdCard.addTarget(self, action: #selector(thirdTapped), for: .touchUpInside)
        fourthCard.addTarget(self, action: #selector(fourthTapped), for: .touchUpInside)
    }
    
    @objc func firstTapped() {
        guard let vc = UIStoryboard(name: Constants.StoryBoardName.menus, bundle: .main).instantiateInitialViewController() else { return }
        present(vc, animated: true)
    }
    
    @objc func secondTapped() {
        guard let vc = UIStoryboard(name: Constants.StoryBoardName.courses, bundle: .main).instantiateInitialViewController() else { return }
        present(vc, animated: true)
    }
    
    @objc func thirdTapped() {
        guard let vc = UIStoryboard(name: Constants.StoryBoardName.dishes, bundle: .main).instantiateInitialViewController() else { return }
        present(vc, animated: true)
    }
    
    @objc func fourthTapped() {
        guard let vc = UIStoryboard(name: Constants.StoryBoardName.inventories, bundle: .main).instantiateInitialViewController() else { return }
        present(vc, animated: true)
    }
}

