//
//  UserCell.swift
//  Friends
//
//  Created by Gorazd Kunej on 03/04/2021.
//

import UIKit

class UserCell: UITableViewCell {
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    
    func prepareCell(for user: User) {
        usernameLabel.text = user.login?.username
        nameLabel.text = user.name?.fullName
    }
}
