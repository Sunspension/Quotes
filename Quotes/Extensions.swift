//
//  Extensions.swift
//  Quotes
//
//  Created by Vladimir Kokhanevich on 23/08/2017.
//  Copyright © 2017 Vladimir Kokhanevich. All rights reserved.
//

import UIKit

extension UIColor {
    
    static var lightGreen: UIColor {
        
        return UIColor(red: 200 / 255.0, green: 1, blue: 193 / 255.0, alpha: 1)
    }
    
    static var lightBlue: UIColor {
        
        return UIColor(red: 138 / 255.0, green: 198 / 255.0, blue: 1, alpha: 1)
    }
    
    static var lightRed: UIColor {
        
        return UIColor(red: 1, green: 151 / 255.0, blue: 165 / 255.0, alpha: 1)
    }
    
    static var grayText: UIColor {
        
        return UIColor(red: 120 / 255.0, green: 120 / 255.0, blue: 120 / 255.0, alpha: 1)
    }
}

extension UIView {
    
    static func loadFromNib<T: UIView>(view: T.Type) -> T? {
        
        return Bundle.main.loadNibNamed(String(describing: T.self), owner: self, options: nil)?.first as? T
    }
}

extension UIViewController {
    
    func showDummyView() {
        
        guard
            self.view.subviews.first(where: { $0 is DummyView }) == nil,
            let dummy = UIView.loadFromNib(view: DummyView.self) else {
                
                return
        }
        
        dummy.sizeToFit()
        
        self.view.addSubview(dummy)
        
        var center = self.view.center
        
        if let bar = self.navigationController?.navigationBar {
            
            center.y = center.y - (bar.isHidden ? 0 : bar.frame.size.height)
        }
        
        dummy.center = center
    }
    
    func hideDummyView() {
        
        self.view.subviews.forEach { view in
            
            if view.self is DummyView {
                
                view.removeFromSuperview()
            }
        }
    }
    
    func dummyView() -> UIView? {
        
        return self.view.subviews.first(where: { $0.self is DummyView })
    }
}
