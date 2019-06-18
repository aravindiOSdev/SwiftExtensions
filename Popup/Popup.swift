//
//  Popup.swift
//  Popup
//
//  Created by Ankit Bhana on 19/06/19.
//  Copyright © 2019 Ankit Bhana. All rights reserved.
//

import UIKit

class Popup: UIView {
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var bottomLblMessage: NSLayoutConstraint!
    
    
    enum AnimationDirection {
        case `in`, out
    }
    
    static var popup: Popup?
    var completion: (() -> ())?
    
    static func showWith(title: String? = nil, message: String, image: UIImage? = nil, btnTitle: String, completion: (() -> ())?) {
        
        if popup != nil {
            popup!.removeFromSuperview()
            popup = nil
        }
        
        let nibObj = UINib(nibName: "Popup", bundle: nil).instantiate(withOwner: nil, options: nil)
        popup = nibObj.first as? Popup
        popup!.completion = completion
        popup!.frame = UIScreen.main.bounds
        
        if btnTitle.isEmpty {
            popup!.button.removeFromSuperview()
            popup!.bottomLblMessage.priority = UILayoutPriority(752)
        } else {
            popup!.button.setTitle(btnTitle, for: .normal)
        }
        
        popup!.lblTitle.text = title
        popup!.lblMessage.text = message
        popup!.imageView.image = image
        popup!.animate(.in)
    }
    
    static func remove() {
        guard let popup = popup else { return }
        popup.animate(.out)
    }
    
    private func animate(_ animationDirection: AnimationDirection) {
        
        DispatchQueue.main.async {
            guard let popup = Popup.popup else { return }
            
            switch animationDirection {
            case .in:
                guard let keyWindow = UIApplication.shared.keyWindow else { return }
                popup.alpha = 0
                keyWindow.addSubview(popup)
                UIView.animate(withDuration: 0.2) {
                    popup.alpha = 1
                    
                }
                
            case .out:
                UIView.animate(withDuration: 0.1, animations: {
                    popup.alpha = 0
                }, completion: { (_) in
                    popup.removeFromSuperview()
                })
            }
        }
    }
    
    
    
    @IBAction func btnTapped() {
        Popup.remove()
        completion?()
    }
    
    @IBAction func btnCross() {
        Popup.remove()
    }
    
}
