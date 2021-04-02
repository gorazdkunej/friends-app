//
//  UserDetailsViewController.swift
//  Friends
//
//  Created by Gorazd Kunej on 02/04/2021.
//

import UIKit

class UserDetailsViewController: UIViewController {
    
    @IBOutlet var userImageView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var usernameLabel: UILabel!
    @IBOutlet var genderLabel: UILabel!
    @IBOutlet var birdthdayLabel: UILabel!
    @IBOutlet var addressLabel: UILabel!
    @IBOutlet var stateLabel: UILabel!
    @IBOutlet var phoneNumberLabel: UILabel!
    @IBOutlet var emailLabel: UILabel!
    @IBOutlet var registeredLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func populateUser(_ user: User) {
        nameLabel.text = user.name?.fullName
        usernameLabel.text = user.login?.username
        genderLabel.text = user.genderWithAge
        addressLabel.text = user.addressString
        stateLabel.text = user.countryString
        birdthdayLabel.text = user.birdthday
        
        phoneNumberLabel.text = user.cell
        emailLabel.text = user.email
        
        registeredLabel.text = "Registered on " + (user.registration ?? "")
        
        if let timezone = user.timezone {
            registeredLabel.text?.append(" \(timezone)")
        }
        
        userImageView.image = user.image?.getImage()?.circle
    }
}
