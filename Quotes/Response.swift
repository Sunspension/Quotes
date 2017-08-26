//
//  ResponseModel.swift
//  Quotes
//
//  Created by Vladimir Kokhanevich on 21/08/2017.
//  Copyright © 2017 Vladimir Kokhanevich. All rights reserved.
//

import Foundation
import ObjectMapper

/// Describes a type of response data from server
struct Response: Mappable {
    
    /// Array of Tick elements will be preseneted on the screen
    var ticks = [Tick]()
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        ticks <- map["ticks"]
        
        if ticks.count == 0 {
            
            ticks <- map["subscribed_list.ticks"]
        }
    }
}
