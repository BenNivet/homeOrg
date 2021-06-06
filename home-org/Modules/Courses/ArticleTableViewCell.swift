//
//  ArticleTableViewCell.swift
//  home-org
//
//  Created by Benjamin Cante on 06/06/2021.
//

import UIKit
import MaterialComponents

class ArticleTableViewCell: UITableViewCell {
    
    @IBOutlet weak var articleTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initComponent()
    }
    
    private func initComponent() {
        selectionStyle = .none
    }
}
