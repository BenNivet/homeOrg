//
//  ArticleTableViewCell.swift
//  home-org
//
//  Created by Benjamin Cante on 06/06/2021.
//

import UIKit
import MaterialComponents

protocol ArticleTableViewCellDelegate: AnyObject {
    func didSelectArticle(_ name: String)
}

class ArticleTableViewCell: UITableViewCell {
    
    @IBOutlet weak var card: MDCCard!
    @IBOutlet weak var articleTitle: UILabel!
    @IBOutlet weak var checkImageView: UIImageView!
    
    weak var delegate: ArticleTableViewCellDelegate?
    var isChecked: Bool = false
    
    private var imageName: String {
        return isChecked ? "CheckBoxOn" : "CheckBoxOff"
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initComponent()
    }
    
    private func initComponent() {
        selectionStyle = .none
        checkImageView.tintColor = .white
        card.addTarget(self, action: #selector(tap), for: .touchUpInside)
    }
    
    func updateData(isChecked: Bool) {
        self.isChecked = isChecked
        checkImageView.image = UIImage(named: imageName)?.withRenderingMode(.alwaysTemplate)
    }
    
    @objc func tap() {
        isChecked.toggle()
        checkImageView.image = UIImage(named: imageName)?.withRenderingMode(.alwaysTemplate)
        if let name = articleTitle.text {
            delegate?.didSelectArticle(name)
        }
    }
}
