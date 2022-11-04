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
    
    @IBOutlet var iconView: UIImageView!
    
    func setup(title: String?,
               description: String?,
               source: String?,
               author: String?,
               iconURL: String?) {
        
        titleLabel.text = title
        descriptionLabel.text = description
        sourceLabel.text = source
        authorLabel.text = author
        
        iconView.loadImageBy(URLAdress: iconURL)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
