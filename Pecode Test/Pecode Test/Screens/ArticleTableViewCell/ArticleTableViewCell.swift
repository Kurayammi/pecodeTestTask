//
//  ArticleTableViewCell.swift
//  Pecode Test
//
//  Created by Kito on 11/4/22.
//

import UIKit

class ArticleTableViewCell: UITableViewCell {
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var sourceLabel: UILabel!
    @IBOutlet var authorLabel: UILabel!
    
    @IBOutlet var saveButton: UIButton!
    
    var buttonHandler: ((ArticleTableViewCell) -> Void)?
    
    func setup(title: String?,
               description: String?,
               source: String?,
               author: String?,
               iconURL: String?,
               isSaved: Bool,
               buttonHandler: ((ArticleTableViewCell) -> Void)? ) {
        
        titleLabel.text = title
        descriptionLabel.text = description
        sourceLabel.text = source
        authorLabel.text = author
        
        //iconView.loadImageBy(URLAdress: iconURL)
        
        self.buttonHandler = buttonHandler
        
        if isSaved {
            saveButton.setTitle("", for: .normal)
            saveButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
        } else {
            saveButton.setTitle("", for: .normal)
            saveButton.setImage(UIImage(systemName: "star"), for: .normal)
        }
        saveButton.addTarget(self, action:  #selector(didTapCellButton(sender:)), for: .touchUpInside)
       // descriptionLabel.addGestureRecognizer(actionForCellTaped)
        
    }
    
    @objc func didTapCellButton(sender: UIButton) {
        
        buttonHandler?(self)
    }
}
