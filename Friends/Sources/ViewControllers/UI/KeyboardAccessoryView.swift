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
    var delegate: KeyboardAccessoryDelegate?
    
    @IBAction func finishButtonClick(_ sender: Any) {
        delegate?.finishEditing()
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
