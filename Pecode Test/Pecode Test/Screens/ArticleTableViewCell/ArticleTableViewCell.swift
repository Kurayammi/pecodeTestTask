//
//  ArticleTableViewCell.swift
//  Pecode Test
//
//  Created by Kito on 11/4/22.
//

import UIKit

class ArticleTableViewCell: UITableViewCell {
    
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var descriptionLabel: UILabel!
    @IBOutlet private var sourceLabel: UILabel!
    @IBOutlet private var authorLabel: UILabel!
    @IBOutlet private var timeLabel: UILabel!
    @IBOutlet private var iconView: UIImageView!
    
    @IBOutlet var saveButton: UIButton!
    
    var buttonHandler: ((ArticleTableViewCell) -> Void)?
    
    func setup(title: String?,
               description: String?,
               source: String?,
               author: String?,
               icon: UIImage?,
               publishedAt: String?,
               isSaved: Bool,
               buttonHandler: ((ArticleTableViewCell) -> Void)? ) {
        
        titleLabel.text = title
        descriptionLabel.text = description
        sourceLabel.text = source
        authorLabel.text = author
        timeLabel.text = publishedAt
        iconView.image = icon
        
        self.buttonHandler = buttonHandler
        
        if isSaved {
            saveButton.setTitle("", for: .normal)
            saveButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
        } else {
            saveButton.setTitle("", for: .normal)
            saveButton.setImage(UIImage(systemName: "star"), for: .normal)
        }
        
        saveButton.addTarget(self, action:  #selector(didTapCellButton(sender:)), for: .touchUpInside)
      
        
    }
    
    @objc func didTapCellButton(sender: UIButton) {
        buttonHandler?(self)
    }
}
