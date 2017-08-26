//
//  STWebSocket.swift
//  Quotes
//
//  Created by Vladimir Kokhanevich on 21/08/2017.
//  Copyright © 2017 Vladimir Kokhanevich. All rights reserved.
//

import Foundation

/// Provides the server API to comunicate with.
public struct ServerAPI {
    
    fileprivate var socket: SocketProtocol
    
    /// Creates a `ServerAPI` instance from the specified parameter.
    /// - Parameter socket: The `SocketProtocol` implementer instance.
    public init(socket: SocketProtocol) {
        
        self.socket = socket
        
        self.socket.onEvent = { json in
            
            if let response = Response(JSON: json) {
                
                let name = NSNotification.Name(responseObjectNotification)
                NotificationCenter.default.post(name: name, object: response)
            }
        }
        
        self.socket.onConnect = {
            
            let name = NSNotification.Name(socketConnectNotification)
            NotificationCenter.default.post(name: name, object: nil)
        }
        
        self.socket.onDisconnect = {
            
            let name = NSNotification.Name(socketDisconnectNotification)
            NotificationCenter.default.post(name: name, object: nil)
        }
    }
    
    /// Sends the predefined commands to the server.
    /// - Parameter command: The server command will be executed.
    /// - Parameter symbols: The array of symbols will be work with.
    public func sendCommand(command: SocketCommand, symbols: [Symbol]) {
        
        var request = command.toString
        request += symbols.map({ $0.rawValue.uppercased() }).joined(separator: ",")
        
        self.socket.sendRequest(request: request)
    }
}
