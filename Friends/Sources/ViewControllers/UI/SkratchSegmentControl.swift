//
//  SkratchSegmentControl.swift
//  Friends
//
//  Created by Gorazd Kunej on 03/04/2021.
//

import UIKit

@IBDesignable class SkratchSegmentControl: UIControl {
    private var thumbView = UIView()
    
    fileprivate var imageViews = [UIImageView]()
    public var items: [UIImage] = [] {
        didSet {
            if items.count > 0 { setupImageView() }
        }
    }
    
    public var selectedIndex: Int = 0 {
        didSet { displayNewSelectedIndex() }
    }
    
    @IBInspectable public var selectedImageColor: UIColor = UIColor.black {
        didSet { setSelectedColors() }
    }
    
    @IBInspectable public var unselectedImageColor: UIColor = UIColor.white {
        didSet { setSelectedColors() }
    }
    
    @IBInspectable public var thumbColor: UIColor = UIColor.white {
        didSet { setSelectedColors() }
    }
    
    public var padding: CGFloat = 0 {
        didSet { setupImageView() }
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)!
        setupView()
    }
    
    private func setupView() {
        layer.cornerRadius = frame.height / 2
        layer.borderColor = UIColor(white: 1.0, alpha: 0.5).cgColor
        layer.borderWidth = 2
        
        backgroundColor = UIColor.white
        setupImageView()
        insertSubview(thumbView, at: 0)
    }
    
    private func setupImageView() {
        for label in imageViews {
            label.removeFromSuperview()
        }
        
        imageViews.removeAll(keepingCapacity: true)
        
        items.forEach { image in
            let imageView = UIImageView(image: image)
            imageView.image = image
            imageView.contentMode = .center
            imageView.translatesAutoresizingMaskIntoConstraints = false
            
            addSubview(imageView)
            imageViews.append(imageView)
        }
        
        addIndividualItemConstraints(imageViews, mainView: self)
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        if imageViews.count > 0 {
            let imageView = imageViews[selectedIndex]
            //label.textColor = selectedLabelColor
            thumbView.frame = imageView.frame
            thumbView.backgroundColor = thumbColor
            thumbView.layer.cornerRadius = thumbView.frame.height / 2
            displayNewSelectedIndex()
        }
    }
    
    public override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        let location = touch.location(in: self)
        var calculatedIndex : Int?
        for (index, item) in imageViews.enumerated() {
            if item.frame.contains(location) {
                calculatedIndex = index
            }
        }
        
        if calculatedIndex != nil {
            selectedIndex = calculatedIndex!
            sendActions(for: .valueChanged)
        }
        
        return false
    }
    
    private func displayNewSelectedIndex() {
        for (_, item) in imageViews.enumerated() {
            item.image = item.image?.maskWithColor(color: unselectedImageColor)
        }
        
        let imageView = imageViews[selectedIndex]
        imageView.image = imageView.image?.maskWithColor(color: selectedImageColor)
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.8, animations: {
            self.thumbView.frame = imageView.frame
        }, completion: nil)
    }
    
    private func addIndividualItemConstraints(_ items: [UIView], mainView: UIView) {
        for (index, button) in items.enumerated() {
            button.topAnchor.constraint(equalTo: mainView.topAnchor, constant: padding).isActive = true
            button.bottomAnchor.constraint(equalTo: mainView.bottomAnchor, constant: -padding).isActive = true
            
            ///set leading constraint
            if index == 0 {
                /// set first item leading anchor to mainView
                button.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: padding).isActive = true
            } else {
                let prevButton: UIView = items[index - 1]
                let firstItem: UIView = items[0]
                
                /// set remaining items to previous view and set width the same as first view
                button.leadingAnchor.constraint(equalTo: prevButton.trailingAnchor, constant: padding).isActive = true
                button.widthAnchor.constraint(equalTo: firstItem.widthAnchor).isActive = true
            }
            
            ///set trailing constraint
            if index == items.count - 1 {
                /// set last item trailing anchor to mainView
                button.trailingAnchor.constraint(equalTo: mainView.trailingAnchor, constant: -padding).isActive = true
            } else {
                /// set remaining item trailing anchor to next view
                let nextButton: UIView = items[index + 1]
                button.trailingAnchor.constraint(equalTo: nextButton.leadingAnchor, constant: -padding).isActive = true
            }
        }
    }
    
    private func setSelectedColors() {
        for item in imageViews {
            item.image = item.image?.maskWithColor(color: unselectedImageColor)
        }
        
        if imageViews.count > 0 {
            imageViews[0].image = imageViews[0].image?.maskWithColor(color: selectedImageColor)
        }
        
        thumbView.backgroundColor = thumbColor
    }
    
}
