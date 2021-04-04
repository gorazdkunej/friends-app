//
//  FriendAnnotationView.swift
//  Friends
//
//  Created by Gorazd Kunej on 02/04/2021.
//

import Mapbox
import UIKit

class FriendAnnotationView: MGLAnnotationView {
    var imageView: UIImageView!
    
    required init(reuseIdentifier: String?, user: User) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        if let name = user.name?.first {
            addUserNameLabel(name)
        }
        if let image = user.image?.getImage() {
            addUserImage(image)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = bounds.width / 2
        layer.borderWidth = 3
        layer.borderColor = UIColor.white.cgColor
        
    }
    
    private func addUserNameLabel(_ name: String) {
        let labelHeight: CGFloat = 22
        
        let font = UIFont.skratch.book(size: 12) ?? UIFont.systemFont(ofSize: 12)

        let width = name.width(withConstrainedHeight: labelHeight, font: font) + 10
        let label = UILabel(frame: CGRect(x: 30 - (width/2), y: -30, width: width, height: labelHeight))
        label.text = name
        label.backgroundColor = .white
        label.textAlignment = .center
        label.textColor = UIColor.skratch.navy
        label.font = font
        label.cornerRadius = labelHeight / 2
        
        self.addSubview(label)
    }
    
    private func addUserImage(_ image: UIImage) {
        imageView = UIImageView(frame: CGRect(x: 3, y: 3, width: 54, height: 54))
        imageView.image = image.circle
        self.addSubview(imageView)
    }
}
