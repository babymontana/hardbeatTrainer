//
//  UsuarioTableViewCell.swift
//  heartbeatTrainer
//
//  Created by Emmanuel Paez on 30/03/17.
//  Copyright © 2017 emmanuel. All rights reserved.
//

import UIKit

class UsuarioTableViewCell: UITableViewCell {
    @IBOutlet weak var userImg: UIImageView!
    @IBOutlet weak var nombre: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
