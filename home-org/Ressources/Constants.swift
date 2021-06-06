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
        static let deleteMenu = "Supprimer"
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
        static let actionTitle = "Valider"
        static let cancelTitle = "Annuler"
    }
    
    struct RenameDishAlert {
        static let title = "Renommer le plat"
        static let subtitle = "Quel est le nom du plat ?"
        static let actionTitle = "Valider"
        static let cancelTitle = "Annuler"
    }
    
    struct AddIngredientAlert {
        static let title = "Ajouter un ingrédient"
        static let subtitle = "Quel est le nom de l'ingrédient ?"
        static let placeholder = "Nom de l'ingrédient"
        static let actionTitle = "Valider"
        static let cancelTitle = "Annuler"
    }
    
    struct AddArticleAlert {
        static let title = "Ajouter un article"
        static let subtitle = "Quel est le nom de l'article ?"
        static let placeholder = "Nom de l'article"
        static let actionTitle = "Valider"
        static let cancelTitle = "Annuler"
    }
    
    struct createMenu {
        static let question = "Qu'avez vous envie de manger ?"
    }
    
    struct AddDishToMenuAlert {
        static let title = "Ajouter un plat"
        static let subtitle = "Pour quel repas ?"
        static let placeholder = "Nom du plat"
        static let actionTitle1 = "Midi"
        static let actionTitle2 = "Soir"
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
}
