//
//  TableViewCell.swift
//  Quotes
//
//  Created by Vladimir Kokhanevich on 23/08/2017.
//  Copyright © 2017 Vladimir Kokhanevich. All rights reserved.
//

import UIKit

public enum TypeEnum {
    
    case header, row
}

/// Table view cell displays Ticks elements.
class TableViewCell: UITableViewCell {

    @IBOutlet fileprivate weak var stackView: UIStackView!
    
    @IBOutlet weak var symbol: UILabel!
    
    @IBOutlet weak var ba: UILabel!
    
    @IBOutlet weak var spread: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        clear()
    }

    override func prepareForReuse() {
        
        clear()
    }
    
    /// Helps to setup colors and text fonts for labels
    /// - Parameter type: Presents the enumeration of skins types.
    public func setup(for type: TypeEnum) {
        
        switch type {
            
        case .row:
            
            symbol.backgroundColor = UIColor.white
            ba.backgroundColor = UIColor.white
            spread.backgroundColor = UIColor.white
            
            let font = UIFont.systemFont(ofSize: 14)
            
            symbol.font = font
            symbol.textColor = UIColor.grayText
            ba.font = font
            ba.textColor = UIColor.grayText
            spread.font = font
            spread.textColor = UIColor.grayText
            
            break
            
        case .header:
            
            symbol.textColor = UIColor.black
            symbol.backgroundColor = UIColor.lightGreen
            
            ba.textColor = UIColor.black
            ba.backgroundColor = UIColor.lightBlue
            
            spread.textColor = UIColor.black
            spread.backgroundColor = UIColor.lightRed
            
            break
        }
    }
    
    fileprivate func clear() {
        
        symbol.text = "-"
        ba.text = "-"
        spread.text = "-"
    }
}
