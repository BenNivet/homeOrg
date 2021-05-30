//
//  MenusViewController.swift
//  home-org
//
//  Created by Benjamin Cante on 22/05/2021.
//

import UIKit
import MaterialComponents

class MenusViewController: UIViewController {
    
    @IBOutlet weak var weekSegmented:
        UISegmentedControl!
    
    @IBOutlet weak var firstDayLabel: UILabel!
    @IBOutlet weak var secondDayLabel: UILabel!
    @IBOutlet weak var thirdDayLabel: UILabel!
    @IBOutlet weak var fourthDayLabel: UILabel!
    @IBOutlet weak var fifthDayLabel: UILabel!
    @IBOutlet weak var sixthDayLabel: UILabel!
    @IBOutlet weak var seventhDayLabel: UILabel!
    
    @IBOutlet weak var firstCard: MDCCard!
    @IBOutlet weak var secondCard: MDCCard!
    @IBOutlet weak var thirdCard: MDCCard!
    @IBOutlet weak var fourthCard: MDCCard!
    @IBOutlet weak var fifthCard: MDCCard!
    @IBOutlet weak var sixthCard: MDCCard!
    @IBOutlet weak var seventhCard: MDCCard!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        weekSegmented.setTitleTextAttributes(titleTextAttributes, for:.normal)
        let titleTextAttributes1 = [NSAttributedString.Key.foregroundColor: UIColor.white]
        weekSegmented.setTitleTextAttributes(titleTextAttributes1, for:.selected)
        
        let date = Date()
        let todayIndex = Calendar.current.dateComponents([.weekday], from: date).weekday ?? 0
        
        firstDayLabel.text = Constants.days[todayIndex % 7]
        secondDayLabel.text = Constants.days[(todayIndex + 1) % 7]
        thirdDayLabel.text = Constants.days[(todayIndex + 2) % 7]
        fourthDayLabel.text = Constants.days[(todayIndex + 3) % 7]
        fifthDayLabel.text = Constants.days[(todayIndex + 4) % 7]
        sixthDayLabel.text = Constants.days[(todayIndex + 5) % 7]
        seventhDayLabel.text = Constants.days[(todayIndex + 6) % 7]
        
        firstCard.addTarget(self, action: #selector(firstTapped), for: .touchUpInside)
        secondCard.addTarget(self, action: #selector(secondTapped), for: .touchUpInside)
        thirdCard.addTarget(self, action: #selector(thirdTapped), for: .touchUpInside)
        fourthCard.addTarget(self, action: #selector(fourthTapped), for: .touchUpInside)
        fifthCard.addTarget(self, action: #selector(fifthTapped), for: .touchUpInside)
        sixthCard.addTarget(self, action: #selector(sixthTapped), for: .touchUpInside)
        seventhCard.addTarget(self, action: #selector(seventhTapped), for: .touchUpInside)
    }
    
    @IBAction func firstTapped() {
        guard let vc = UIStoryboard(name: Constants.StoryBoardName.createMenu, bundle: .main).instantiateInitialViewController() else { return }
        present(vc, animated: true)
    }
    
    @IBAction func secondTapped() {
        guard let vc = UIStoryboard(name: Constants.StoryBoardName.createMenu, bundle: .main).instantiateInitialViewController() else { return }
        present(vc, animated: true)
    }
    
    @IBAction func thirdTapped() {
        guard let vc = UIStoryboard(name: Constants.StoryBoardName.createMenu, bundle: .main).instantiateInitialViewController() else { return }
        present(vc, animated: true)
    }
    
    @IBAction func fourthTapped() {
        guard let vc = UIStoryboard(name: Constants.StoryBoardName.createMenu, bundle: .main).instantiateInitialViewController() else { return }
        present(vc, animated: true)
    }
    
    @IBAction func fifthTapped() {
        guard let vc = UIStoryboard(name: Constants.StoryBoardName.createMenu, bundle: .main).instantiateInitialViewController() else { return }
        present(vc, animated: true)
    }
    
    @IBAction func sixthTapped() {
        guard let vc = UIStoryboard(name: Constants.StoryBoardName.createMenu, bundle: .main).instantiateInitialViewController() else { return }
        present(vc, animated: true)
    }
    
    @IBAction func seventhTapped() {
        guard let vc = UIStoryboard(name: Constants.StoryBoardName.createMenu, bundle: .main).instantiateInitialViewController() else { return }
        present(vc, animated: true)
    }
}
