//
//  Tick.swift
//  Quotes
//
//  Created by Vladimir Kokhanevich on 23/08/2017.
//  Copyright © 2017 Vladimir Kokhanevich. All rights reserved.
//

import Foundation
import ObjectMapper

/// Describes a type of data using for payload between server and client.
class Tick: NSObject, Mappable, NSCoding {
    
    /// Symbol is a pair of two currencies. For example EUR/USD.
    var symbol = Symbol.undefined
    
    /// Is an offer made by an investor.
    var bid = ""
    
    /// Is the price a seller is willing to accept.
    var ask = ""
    
    /// Is the difference between yields.
    var spread = ""
    
    /// Optional callback shows that item has new data.
    var onItemChanged: ((_ item: Tick) -> Void)?
    
    override var hash: Int {
        
        return symbol.rawValue.hash ^ 344
    }
    
    override func isEqual(_ object: Any?) -> Bool {
        
        if let other = object as? Tick {
            
            return self.symbol.rawValue == other.symbol.rawValue
        }
        
        return false
    }
    
    override init() {
        
    }
    
    // MARK: - NSCoder protocol implementation
    
    required init?(coder aDecoder: NSCoder) {
        
        symbol = Symbol(rawValue: aDecoder.decodeObject(forKey: "symbol") as! String)!
        bid = aDecoder.decodeObject(forKey: "bid") as! String
        ask = aDecoder.decodeObject(forKey: "ask") as! String
        spread = aDecoder.decodeObject(forKey: "spread") as! String
    }
    
    func encode(with aCoder: NSCoder) {
        
        aCoder.encode(symbol.rawValue, forKey: "symbol")
        aCoder.encode(bid, forKey: "bid")
        aCoder.encode(ask, forKey: "ask")
        aCoder.encode(spread, forKey: "spread")
    }
    
    // MARK: - Mappable protocol implementation
    
    required convenience init?(map: Map) {
        
        self.init()
    }
    
    func mapping(map: Map) {
        
        symbol <- (map["s"], TransformOf<Symbol, String>(fromJSON: { Symbol(rawValue: $0!.lowercased()) },
                                                         toJSON: { $0!.rawValue.uppercased() }))
        bid <- map["b"]
        ask <- map["a"]
        spread <- map["spr"]
    }
    
    /// Copies data from the updated tick.
    /// - Parameter other: The new updated tick that holds new data about the current symbol.
    func copyData(from other: Tick) {
        
        self.bid = other.bid
        self.ask = other.ask
        self.spread = other.spread
    }
}
