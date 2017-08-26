//
//  SocketCommands.swift
//  Quotes
//
//  Created by Vladimir Kokhanevich on 21/08/2017.
//  Copyright © 2017 Vladimir Kokhanevich. All rights reserved.
//

import Foundation

/// Describes enumeration of commands to comunicate with the server.
public enum SocketCommand {
    
    case subscribe, unsubscribe
    
    var toString: String {
        
        switch self {
            
        case .subscribe:
            
            return "SUBSCRIBE: "
            
        case .unsubscribe:
            
            return "UNSUBSCRIBE: "
        }
    }
}
