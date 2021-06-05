//
//  MenusViewController.swift
//  home-org
//
//  Created by Benjamin Cante on 22/05/2021.
//

import UIKit
import MaterialComponents
import CoreData

class MenusViewController: UIViewController {
    
    enum Week {
        case this
        case next
    }
    
    @IBOutlet weak var weekSegmented: UISegmentedControl!
    
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
    
    @IBOutlet weak var menu1ChipCollectionView: UICollectionView!
    @IBOutlet weak var menu2ChipCollectionView: UICollectionView!
    @IBOutlet weak var menu3ChipCollectionView: UICollectionView!
    @IBOutlet weak var menu4ChipCollectionView: UICollectionView!
    @IBOutlet weak var menu5ChipCollectionView: UICollectionView!
    @IBOutlet weak var menu6ChipCollectionView: UICollectionView!
    @IBOutlet weak var menu7ChipCollectionView: UICollectionView!
    
    @IBOutlet weak var menu1CartImage: UIImageView!
    @IBOutlet weak var menu2CartImage: UIImageView!
    @IBOutlet weak var menu3CartImage: UIImageView!
    @IBOutlet weak var menu4CartImage: UIImageView!
    @IBOutlet weak var menu5CartImage: UIImageView!
    @IBOutlet weak var menu6CartImage: UIImageView!
    @IBOutlet weak var menu7CartImage: UIImageView!
    
    private var menusDays = [Date]()
    private var menus = [Menu]()
    private var week: Week = .this
    
    private var selectedCollectionView: UICollectionView?
    
    private var today: Date {
        Calendar.current.startOfDay(for: Date())
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let titleTextAttributes: [NSAttributedString.Key: Any] = [.font: UIFont.boldSystemFont(ofSize: 15),
                                                                  .foregroundColor: UIColor.black]
        weekSegmented.setTitleTextAttributes(titleTextAttributes, for:.normal)
        
        let titleTextAttributesSelected: [NSAttributedString.Key: Any] = [.font: UIFont.boldSystemFont(ofSize: 15),
                                                                          .foregroundColor: UIColor.white]
        weekSegmented.setTitleTextAttributes(titleTextAttributesSelected, for:.selected)
        
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
        
        menu1ChipCollectionView.register(MDCChipCollectionViewCell.self, forCellWithReuseIdentifier: "MenuChip")
        menu1ChipCollectionView.dataSource = self
        
        menu2ChipCollectionView.register(MDCChipCollectionViewCell.self, forCellWithReuseIdentifier: "MenuChip")
        menu2ChipCollectionView.dataSource = self
        
        menu3ChipCollectionView.register(MDCChipCollectionViewCell.self, forCellWithReuseIdentifier: "MenuChip")
        menu3ChipCollectionView.dataSource = self
        
        menu4ChipCollectionView.register(MDCChipCollectionViewCell.self, forCellWithReuseIdentifier: "MenuChip")
        menu4ChipCollectionView.dataSource = self
        
        menu5ChipCollectionView.register(MDCChipCollectionViewCell.self, forCellWithReuseIdentifier: "MenuChip")
        menu5ChipCollectionView.dataSource = self
        
        menu6ChipCollectionView.register(MDCChipCollectionViewCell.self, forCellWithReuseIdentifier: "MenuChip")
        menu6ChipCollectionView.dataSource = self
        
        menu7ChipCollectionView.register(MDCChipCollectionViewCell.self, forCellWithReuseIdentifier: "MenuChip")
        menu7ChipCollectionView.dataSource = self
        
        // Data
        while menusDays.count < 14 {
            var dateComponent = DateComponents()
            dateComponent.day = menusDays.count
            let date = Calendar.current.date(byAdding: dateComponent, to: today)
            if let date = date {
                menusDays.append(date)
            }
        }
        menus = fetchMenus()
        manageCartIcon()
    }
    
    private func fetchMenus() -> [Menu] {
        let context = CoreDataManager.shared.mainContext
        let fetchRequest: NSFetchRequest<Menu> = Menu.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
        do {
            let results = try context.fetch(fetchRequest)
            let menusToRemove = results.filter({ $0.date ?? Date.distantPast < today })
            for menu in menusToRemove {
                context.delete(menu)
            }
            try context.save()
            return results.filter({ ($0.date ?? Date.distantPast) >= today })
        }
        catch {
            print(error)
        }
        return []
    }
    
    private func getMenu(for collectionView: UICollectionView) -> Menu? {
        var index = 0
        if collectionView == menu1ChipCollectionView {
            index = week == .this ? 0 : 7
        } else if collectionView == menu2ChipCollectionView {
            index = week == .this ? 1 : 8
        } else if collectionView == menu3ChipCollectionView {
            index = week == .this ? 2 : 9
        } else if collectionView == menu4ChipCollectionView {
            index = week == .this ? 3 : 10
        } else if collectionView == menu5ChipCollectionView {
            index = week == .this ? 4 : 11
        } else if collectionView == menu6ChipCollectionView {
            index = week == .this ? 5 : 12
        } else if collectionView == menu7ChipCollectionView {
            index = week == .this ? 6 : 13
        }
        
        guard menusDays.indices.contains(index) else { return nil }
        
        let day = menusDays[index]
        return menus.first(where: { $0.date ?? Date.distantPast == day })
    }
    
    private func updateData(for collectionView: UICollectionView? = nil) {
        menus = fetchMenus()
        reloadCollections(collectionView: collectionView)
        selectedCollectionView = nil
        manageCartIcon()
    }
    
    private func reloadCollections(collectionView: UICollectionView? = nil) {
        if let collectionView = collectionView {
            collectionView.reloadData()
        } else {
            menu1ChipCollectionView.reloadData()
            menu2ChipCollectionView.reloadData()
            menu3ChipCollectionView.reloadData()
            menu4ChipCollectionView.reloadData()
            menu5ChipCollectionView.reloadData()
            menu6ChipCollectionView.reloadData()
            menu7ChipCollectionView.reloadData()
        }
    }
    
    private func manageCartIcon() {
        menu1CartImage.isHidden = !(menus.first(where: { $0.date ?? Date.distantPast == menusDays[week == .this ? 0 : 7]})?.courseDay ?? false)
        menu2CartImage.isHidden = !(menus.first(where: { $0.date ?? Date.distantPast == menusDays[week == .this ? 1 : 8]})?.courseDay ?? false)
        menu3CartImage.isHidden = !(menus.first(where: { $0.date ?? Date.distantPast == menusDays[week == .this ? 2 : 9]})?.courseDay ?? false)
        menu4CartImage.isHidden = !(menus.first(where: { $0.date ?? Date.distantPast == menusDays[week == .this ? 3 : 10]})?.courseDay ?? false)
        menu5CartImage.isHidden = !(menus.first(where: { $0.date ?? Date.distantPast == menusDays[week == .this ? 4 : 11]})?.courseDay ?? false)
        menu6CartImage.isHidden = !(menus.first(where: { $0.date ?? Date.distantPast == menusDays[week == .this ? 5 : 12]})?.courseDay ?? false)
        menu7CartImage.isHidden = !(menus.first(where: { $0.date ?? Date.distantPast == menusDays[week == .this ? 6 : 13]})?.courseDay ?? false)
    }
    
    @IBAction func segmentedValueChanged(_ sender: Any) {
        week = weekSegmented.selectedSegmentIndex == 0 ? .this : .next
        updateData()
    }
    
    @objc func firstTapped() {
        guard let vc = UIStoryboard(name: Constants.StoryBoardName.createMenu, bundle: .main).instantiateInitialViewController() as? CreateMenuViewController else { return }
        var dateComponent = DateComponents()
        dateComponent.day = week == .this ? 0 : 7
        let date = Calendar.current.date(byAdding: dateComponent, to: today)
        vc.date = date
        vc.delegate = self
        selectedCollectionView = menu1ChipCollectionView
        present(vc, animated: true)
    }
    
    @objc func secondTapped() {
        guard let vc = UIStoryboard(name: Constants.StoryBoardName.createMenu, bundle: .main).instantiateInitialViewController() as? CreateMenuViewController else { return }
        var dateComponent = DateComponents()
        dateComponent.day = week == .this ? 1 : 8
        let date = Calendar.current.date(byAdding: dateComponent, to: today)
        vc.date = date
        vc.delegate = self
        selectedCollectionView = menu2ChipCollectionView
        present(vc, animated: true)
    }
    
    @objc func thirdTapped() {
        guard let vc = UIStoryboard(name: Constants.StoryBoardName.createMenu, bundle: .main).instantiateInitialViewController() as? CreateMenuViewController else { return }
        var dateComponent = DateComponents()
        dateComponent.day = week == .this ? 2 : 9
        let date = Calendar.current.date(byAdding: dateComponent, to: today)
        vc.date = date
        vc.delegate = self
        selectedCollectionView = menu3ChipCollectionView
        present(vc, animated: true)
    }
    
    @objc func fourthTapped() {
        guard let vc = UIStoryboard(name: Constants.StoryBoardName.createMenu, bundle: .main).instantiateInitialViewController() as? CreateMenuViewController else { return }
        var dateComponent = DateComponents()
        dateComponent.day = week == .this ? 3 : 10
        let date = Calendar.current.date(byAdding: dateComponent, to: today)
        vc.date = date
        vc.delegate = self
        selectedCollectionView = menu4ChipCollectionView
        present(vc, animated: true)
    }
    
    @objc func fifthTapped() {
        guard let vc = UIStoryboard(name: Constants.StoryBoardName.createMenu, bundle: .main).instantiateInitialViewController() as? CreateMenuViewController else { return }
        var dateComponent = DateComponents()
        dateComponent.day = week == .this ? 4 : 11
        let date = Calendar.current.date(byAdding: dateComponent, to: today)
        vc.date = date
        vc.delegate = self
        selectedCollectionView = menu5ChipCollectionView
        present(vc, animated: true)
    }
    
    @objc func sixthTapped() {
        guard let vc = UIStoryboard(name: Constants.StoryBoardName.createMenu, bundle: .main).instantiateInitialViewController() as? CreateMenuViewController else { return }
        var dateComponent = DateComponents()
        dateComponent.day = week == .this ? 5 : 12
        let date = Calendar.current.date(byAdding: dateComponent, to: today)
        vc.date = date
        vc.delegate = self
        selectedCollectionView = menu6ChipCollectionView
        present(vc, animated: true)
    }
    
    @objc func seventhTapped() {
        guard let vc = UIStoryboard(name: Constants.StoryBoardName.createMenu, bundle: .main).instantiateInitialViewController() as? CreateMenuViewController else { return }
        var dateComponent = DateComponents()
        dateComponent.day = week == .this ? 6 : 13
        let date = Calendar.current.date(byAdding: dateComponent, to: today)
        vc.date = date
        vc.delegate = self
        selectedCollectionView = menu7ChipCollectionView
        present(vc, animated: true)
    }
}

extension MenusViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let menu = getMenu(for: collectionView) else { return 0 }
        return (menu.midi?.count ?? 0) + (menu.soir?.count ?? 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MenuChip", for: indexPath) as? MDCChipCollectionViewCell,
              let menu = getMenu(for: collectionView) else { return UICollectionViewCell() }
        
        let chipView = cell.chipView
        chipView.sizeToFit()
        
        let dishes = (menu.midi ?? []) + (menu.soir ?? [])
        if dishes.indices.contains(indexPath.row) {
            chipView.titleLabel.text = dishes[indexPath.row]
        }
        
        chipView.setBackgroundColor(UIColor.white, for: .normal)
        chipView.setTitleColor(UIColor.black, for: .normal)
        
        chipView.setBackgroundColor(UIColor.white, for: .selected)
        chipView.setTitleColor(UIColor.black, for: .selected)
        
        return cell
    }
}

extension MenusViewController: CreateMenuViewControllerDelegate {
    func handleClose(_ needUpdate: Bool) {
        guard let selectedCollectionView = selectedCollectionView else { return }
        needUpdate ? updateData(for: selectedCollectionView) : nil
    }
}
