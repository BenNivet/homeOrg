//
//  CoursesViewController.swift
//  home-org
//
//  Created by Benjamin Cante on 22/05/2021.
//

import UIKit
import MaterialComponents
import CoreData

class CoursesViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var addButton: MDCFloatingButton!
    @IBOutlet weak var noCourseLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    private let cellIdentifier = "ArticleCell"
    
    private var allMenus = [Menu]()
    private var allDishes = [Dish]()
    private var menus = [Menu]()
    private var course: Course?
    private var courseDay: Date?
    private var secondCourseDay: Date?
    private var allIngredients = [String]()
    private var checkedIngredients = [String]()
    
    private var today: Date {
        Calendar.current.startOfDay(for: Date())
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initComponent()
        
        allMenus = fetchMenus()
        courseDay = allMenus.first(where: { $0.courseDay })?.date
        if let courseDay = courseDay {
            secondCourseDay = allMenus
                .filter({ $0.date ?? Date.distantFuture > courseDay })
                .first(where: { $0.courseDay })?.date
        }
        
        if let courseDay = courseDay {            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "EEEE dd MMMM"
            dateFormatter.locale = Locale(identifier: "fr")
            let dateString = dateFormatter.string(from: courseDay)
            
            if let secondCourseDay = secondCourseDay {
                menus = allMenus.filter({ $0.date ?? Date.distantFuture >= courseDay &&  $0.date ?? Date.distantPast < secondCourseDay })
                let endDateString = dateFormatter.string(from: secondCourseDay)
                titleLabel.text = "Courses du \(dateString) au \(endDateString)"
            } else {
                menus = allMenus.filter({ $0.date ?? Date.distantFuture >= courseDay })
                titleLabel.text = "Courses du \(dateString)"
            }
        } else {
            titleLabel.text = "Rien de pr??vu"
            addButton.isEnabled = false
        }
        allDishes = fetchDishes()
        updateData()
    }
    
    private func initComponent() {
        noCourseLabel.text = Constants.LabelTitle.noCourse
        addButton.setTitle(Constants.ButtonTitle.addCourse.uppercased(), for: .normal)
        addButton.mode = .expanded
        addButton.reloadInputViews()
        
        tableView.delegate = self
        tableView.dataSource = self
        registerTableViewCells()
        tableView.contentInset = UIEdgeInsets(top:0, left: 0, bottom: 85, right: 0)
        tableView.separatorInset = UIEdgeInsets.zero
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    private func registerTableViewCells() {
        let articleCell = UINib(nibName: String(describing: ArticleTableViewCell.self), bundle: nil)
        tableView.register(articleCell,forCellReuseIdentifier: cellIdentifier)
    }
    
    private func updateData() {
        course = fetchCourse() ?? createCourse()
        allIngredients = getAllIngredients()
        noCourseLabel.isHidden = allIngredients.count > 0
        tableView.reloadData()
    }
    
    private func fetchMenus() -> [Menu] {
        let context = CoreDataManager.shared.mainContext
        let fetchRequest: NSFetchRequest<Menu> = Menu.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
        do {
            let results = try context.fetch(fetchRequest)
            return results.filter({ ($0.date ?? Date.distantPast) >= today })
        }
        catch {
            print(error)
        }
        return []
    }
    
    private func fetchCourse() -> Course? {
        guard let courseDay = courseDay else { return nil }
        let context = CoreDataManager.shared.mainContext
        let fetchRequest: NSFetchRequest<Course> = Course.fetchRequest()
        do {
            let results = try context.fetch(fetchRequest)
            return results.first(where: { $0.date == courseDay })
        }
        catch {
            print(error)
        }
        return nil
    }
    
    private func fetchDishes() -> [Dish] {
        let context = CoreDataManager.shared.mainContext
        let fetchRequest: NSFetchRequest<Dish> = Dish.fetchRequest()
        do {
            let results = try context.fetch(fetchRequest)
            return results
        }
        catch {
            print(error)
        }
        return []
    }
    
    private func createCourse() -> Course? {
        guard let courseDay = courseDay else { return nil }
        
        let context = CoreDataManager.shared.mainContext
        let entity = Course.entity()
        let course = Course(entity: entity, insertInto: context)
        course.date = courseDay
        course.others = []
        course.checked = []
        
        do {
            try context.save()
            return course
        }
        catch {
            print(error)
        }
        return nil
    }
    
    private func getAllIngredients() -> [String] {
        
        var dishes = [String]()
        for menu in menus {
            dishes.append(contentsOf: menu.midi ?? [])
            dishes.append(contentsOf: menu.soir ?? [])
        }
        
        dishes = Array(Set(dishes))
        
        var ingredients = [String]()
        let dishesToAdd = allDishes.filter({ dishes.contains($0.name ?? "") })
        for dish in dishesToAdd {
            ingredients.append(contentsOf: dish.ingredients ?? [])
        }
        
        if let course = course {
            ingredients.append(contentsOf: course.others ?? [])
            checkedIngredients = (course.checked ?? []).filter({ ingredients.contains($0) }).sorted()
        }
        
        ingredients = Array(Set(ingredients)).sorted()
        ingredients = ingredients.filter({ !checkedIngredients.contains($0) })
        
        ingredients.append(contentsOf: self.checkedIngredients)
        
        return ingredients
    }
    
    private func displayAddArticleAlert() {
        let alert = UIAlertController(title: Constants.AddArticleAlert.title, message: Constants.AddArticleAlert.subtitle, preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = Constants.AddArticleAlert.placeholder
            textField.autocapitalizationType = .sentences
        }
        alert.addAction(UIAlertAction(title: Constants.AddIngredientAlert.actionTitle, style: .default, handler: { [weak self] action in
            guard let textField =  alert.textFields?.first,
                  let name = textField.text else {
                return
            }
            self?.addArticle(name)
            self?.updateData()
        }))
        alert.addAction(UIAlertAction(title: Constants.AddArticleAlert.cancelTitle, style: .cancel, handler: nil))
        
        present(alert, animated: true, completion: nil)
    }
    
    private func addArticle(_ name: String) {
        guard let course = course else { return }
        
        let context = CoreDataManager.shared.mainContext
        course.others?.append(name)
        
        do {
            try context.save()
        }
        catch {
            print(error)
        }
    }
    
    private func removeArticle(_ name: String) {
        guard let course = course else { return }
        
        let context = CoreDataManager.shared.mainContext
        course.others = course.others?.filter({ $0 != name })
        
        do {
            try context.save()
        }
        catch {
            print(error)
        }
    }
    
    private func updateArticle(_ name: String) {
        guard let course = course else { return }
        
        let context = CoreDataManager.shared.mainContext
        
        if course.checked?.contains(name) ?? false {
            course.checked = course.checked?.filter({ $0 != name })
        } else {
            course.checked?.append(name)
        }
        
        do {
            try context.save()
        }
        catch {
            print(error)
        }
    }
    
    @IBAction func addArticle() {
        displayAddArticleAlert()
    }    
}

extension CoursesViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allIngredients.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? ArticleTableViewCell else {
            return UITableViewCell()
        }
        
        let article = allIngredients[indexPath.row]
        cell.articleTitle.text = article
        cell.updateData(isChecked: checkedIngredients.contains(article))
        cell.delegate = self
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard allIngredients.indices.contains(indexPath.row) else { return }
        updateArticle(allIngredients[indexPath.row])
        updateData()
    }
}

extension CoursesViewController: ArticleTableViewCellDelegate {
    func didSelectArticle(_ name: String) {
        updateArticle(name)
        updateData()
    }
}
