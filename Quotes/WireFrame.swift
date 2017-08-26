//
//  WireFrame.swift
//  Quotes
//
//  Created by Vladimir Kokhanevich on 21/08/2017.
//  Copyright © 2017 Vladimir Kokhanevich. All rights reserved.
//

import Foundation

/// Helper that holds instances of useful tools.
struct WireFrame {
    
    static var serverAPI = ServerAPI(socket: Socket(urlString: "wss://quotes.exness.com:18400"))
}
