//
//  Tools.swift
//  Quotes
//
//  Created by Vladimir Kokhanevich on 21/08/2017.
//  Copyright © 2017 Vladimir Kokhanevich. All rights reserved.
//

import Foundation

/// Describes the predefined symbols.
public enum Symbol: String {
    
    case undefined, eurusd, eurgbp, usdjpy, gbpusd, usdchf, usdcad, audusd, eurjpy, eurchf
    
    static var allCases: [Symbol] {
        
        return [.eurusd, .eurgbp, .usdjpy, .gbpusd, .usdchf, .usdcad, .audusd, .eurjpy, .eurchf]
    }
    
    var decoratedValue: String {
        
        switch self {
            
        case .eurusd:
            
            return "EUR/USD"
            
        case .eurgbp:
            
            return "EUR/GBP"
            
        case .usdjpy:
            
            return "USD/JPY"
            
        case .gbpusd:
            
            return "GBP/USD"
            
        case .usdchf:
            
            return "USD/CHF"
            
        case .usdcad:
            
            return "USD/CAD"
            
        case .audusd:
            
            return "AUD/USD"
            
        case .eurjpy:
            
            return "EUR/JPY"
            
        case .eurchf:
            
            return "EUR/CHF"
            
        default:
            return ""
        }
    }
}
