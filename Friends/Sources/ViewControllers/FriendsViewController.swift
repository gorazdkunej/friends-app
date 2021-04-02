//
//  FriendsTableViewController.swift
//  Friends
//
//  Created by Gorazd Kunej on 01/04/2021.
//

import UIKit
import FloatingPanel

class UserCell: UITableViewCell {
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    
    func prepareCell(for user: User) {
        usernameLabel.text = user.name?.fullName
        nameLabel.text = user.name?.fullName
    }
}

class FriendsViewController: ContainerChildViewController {

    @IBOutlet weak var tableView: UITableView!
    var fpc: FloatingPanelController!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UsersModel.shared.getUsers(count: 6) { (result) in
            if case let .success(users) = result {
                
                print("Friends users: \(users)")
            }
        }
    }
    
    func openPanel() {
       
    }
}

extension FriendsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "userCell", for: indexPath) as! UserCell
        let user = UsersModel.shared.users[indexPath.row]
        
        cell.prepareCell(for: user)
        
        if let image = user.image {
            cell.userImageView.image = image.getImage()?.circle
        } else {
            cell.userImageView.image = UIImage(contentsOfFile: "DefaultPromotion")
            self.downloadImage(in: tableView, for: user, at: indexPath)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard UsersModel.shared.users.count >= indexPath.row else {
            print("missing user for indexPath \(indexPath)")
            return
        }
        
        let user = UsersModel.shared.users[indexPath.row]
        delegate?.openPanel(for: user)
    }
}

extension FriendsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return UsersModel.shared.users.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70.0
    }
}

extension FriendsViewController {
    func downloadImage(in tableView: UITableView, for item: User, at indexPath: IndexPath) {
        
        guard let imageURL = item.picture?.thumbnail?.url
            else {
                print("Missing image url in user detail.")
                return
        }
        
        UsersModel.shared.getUserImage(with: imageURL) { result in
            switch result {
            case .success(let image):
                UsersModel.shared.users[indexPath.row].image = Image(withImage: image)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    guard let cell = tableView.cellForRow(at: indexPath) as? UserCell
                        else {
                            return
                    }
                    
                    cell.userImageView.image = image.circle
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
