//
//  Constants.swift
//  home-org
//
//  Created by Benjamin Cante on 22/05/2021.
//

import UIKit

enum Constants {
    struct HomeTitle {
        static let first = "Menus"
        static let second = "Courses"
        static let third = "Plats"
        static let fourth = "Inventaires"
    }
    
    struct StoryBoardName {
        static let menus = "Menus"
        static let courses = "Courses"
        static let dishes = "Dishes"
        static let inventories = "Inventories"
        static let createMenu = "CreateMenu"
    }
    
    static let cardCornerRadius: CGFloat = 10
    
    struct ButtonTitle {
        static let addCourse = "Ajouter un article"
        static let addDish = "Ajouter un plat"
        static let addInventory = "Créer un inventaire"
    }
    
    struct LabelTitle {
        static let noCourse = "Aucun article dans la liste de courses"
        static let noDish = "Aucun plat"
        static let noInventory = "Aucun inventaire"
    }
    
    struct InventoryAlert {
        static let title = "Créer un inventaire"
        static let subtitle = "Quel est le nom de l'inventaire (congélateur, cave, ...) ?"
        static let placeholder = "Nom de l'inventaire"
        static let actionTitle = "Ok"
        static let cancelTitle = "Plus tard"
    }
    
    struct AddDishAlert {
        static let title = "Ajouter un plat"
        static let subtitle = "Quel est le nom du plat ?"
        static let placeholder = "Nom du plat"
        static let actionTitle = "Ok"
        static let cancelTitle = "Annuler"
    }
    
    static let days = [
        "Samedi",
        "Dimanche",
        "Lundi",
        "Mardi",
        "Mercredi",
        "Jeudi",
        "Vendredi"
    ]
    
    struct createMenu {
        static let question = "Qu'avez vous envie de manger ?"
    }
}
