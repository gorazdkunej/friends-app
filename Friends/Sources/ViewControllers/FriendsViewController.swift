//
//  FriendsTableViewController.swift
//  Friends
//
//  Created by Gorazd Kunej on 01/04/2021.
//

import UIKit

class FriendsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        UsersModel.shared.getUsers(count: 2) { (result) in
            if case let .success(users) = result {
                print("Friends users: \(users)")
            }
        }
    }
}
