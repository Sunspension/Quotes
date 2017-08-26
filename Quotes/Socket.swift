//
//  Socket.swift
//  Quotes
//
//  Created by Vladimir Kokhanevich on 21/08/2017.
//  Copyright © 2017 Vladimir Kokhanevich. All rights reserved.
//

import Foundation
import Starscream

/// Class for communication between server and client. Implements SocketProtocol.
class Socket: SocketProtocol {
    
    fileprivate let socket: WebSocket
    
    var onEvent: ((_ data: [String: Any]) -> Void)?
    
    var onConnect: (() -> Void)?
    
    var onDisconnect: (() -> Void)?
    
    
    deinit {
        
        socket.disconnect()
        NotificationCenter.default.removeObserver(self)
    }
    
    init(urlString: String) {
        
        let url = URL(string: urlString)!
        socket = WebSocket(url: url)
        socketSetup()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.onApplicationWillEnterForeground),
                                               name: NSNotification.Name.UIApplicationWillEnterForeground, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.onApplicationDidEnterBackground),
                                               name: NSNotification.Name.UIApplicationDidEnterBackground, object: nil)
    }
    
    func sendRequest(request: String) {
        
        debugPrint("request: " + request)
        
        socketConnect {
            
            self.socket.write(string: request)
        }
    }
    
    fileprivate func socketSetup() {
        
        socket.onDisconnect = { error in
            
            debugPrint(error ?? "")
            
            self.onDisconnect?()
            
            if let error = error, error.code != 1000 {
                
                self.socketConnect {
                    
                    self.onConnect?()
                }
            }
            else {
                
                self.onSocketDisconnected()
            }
        }
        
        socket.onText = { text in
            
            debugPrint(text)
            
            guard let json = self.serializeJSON(text: text) else {
                
                return
            }
            
            self.onEvent?(json)
        }
    }
    
    fileprivate func serializeJSON(text: String) -> [String : AnyObject]? {
        
        let responseData = text.data(using: String.Encoding.utf8)
        
        var json: [String : AnyObject]? = nil
        
        do {
            
            json = try JSONSerialization.jsonObject(with: responseData!, options: []) as? [String : AnyObject]
        }
        catch let error {
            
            debugPrint(error)
        }
        
        return json
    }
    
    fileprivate func socketConnect(callback: @escaping () -> Void) {
        
        if !socket.isConnected {
            
            socket.onConnect = {
                
                callback()
            }
            
            socket.connect()
        }
        else {
            
            callback()
        }
    }
    
    @objc fileprivate func onApplicationWillEnterForeground() {
        
        if !socket.isConnected {
            
            socketConnect {
                
                self.socketSetup()
                self.onConnect?()
            }
        }
    }
    
    @objc fileprivate func onApplicationDidEnterBackground() {
        
        if socket.isConnected {
            
            socket.disconnect()
        }
    }
    
    fileprivate func onSocketDisconnected() {
        
        socket.onConnect = nil
        socket.onDisconnect = nil
        socket.onText = nil
    }
}
