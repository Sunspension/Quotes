//
//  SocketProtocol.swift
//  Quotes
//
//  Created by Vladimir Kokhanevich on 21/08/2017.
//  Copyright © 2017 Vladimir Kokhanevich. All rights reserved.
//

import Foundation

/// Describes WebSocket protocol
protocol SocketProtocol {
    
    /// Optional callback fires when received a payload from the server.
    /// - Parameter data: Presents the data a given from the server after subscribe.
    var onEvent: ((_ data: [String: Any]) -> Void)? { get set }
    
    /// Optional callback fires when connection between client and server has established.
    var onConnect: (() -> Void)? { get set }
    
    /// Optional callback fires when connection between client and server is over.
    var onDisconnect: (() -> Void)? { get set }
    
    /// Sends request to a given server.
    /// - Parameter request: Presents a string request which will be send to the server.
    func sendRequest(request: String)
}
