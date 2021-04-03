//
//  KeyboardAccessoryView.swift
//  Friends
//
//  Created by Gorazd Kunej on 03/04/2021.
//

import UIKit

protocol KeyboardAccessoryDelegate {
    func finishEditing()
}

class KeyboardAccessoryView: UIView {
    
    @IBOutlet var textLabel: UILabel!
    @IBOutlet var labelBackgroundView: UIView!
    @IBOutlet var finishButton: UIButton!
    
    var delegate: KeyboardAccessoryDelegate?
    
    @IBAction func finishButtonClick(_ sender: Any) {
        delegate?.finishEditing()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidAppear), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillAppear() {
        //Do something here
        self.backgroundColor = .clear
        finishButton.backgroundColor = .clear
        labelBackgroundView.backgroundColor = .clear
        self.isHidden = true
    }
    
    @objc func keyboardDidAppear() {
        self.isHidden = false
        
        UIView.animate(withDuration: 0.3) {
            self.backgroundColor = UIColor.skratch.overlay
            self.finishButton.backgroundColor = UIColor.skratch.purple
            self.labelBackgroundView.backgroundColor = .white
        }
    }
    
    @objc func keyboardWillDisappear() {
        self.isHidden = true
    }

}
