//
//  DataSource.swift
//  Quotes
//
//  Created by Vladimir Kokhanevich on 22/08/2017.
//  Copyright © 2017 Vladimir Kokhanevich. All rights reserved.
//

import Foundation

/// Responsible for managing symbols given from server.
class SymbolsDataSource {
    
    private let rootObjectKey = "tickList"
    
    private var _items: [Tick]?
    
    private(set) var items: [Tick] {
        
        get {
            
            guard let items = _items else {
                
                if let items = itemsFromArchive() {
                    
                    _items = items
                    WireFrame.serverAPI.sendCommand(command: .subscribe, symbols: items.map({ $0.symbol }))
                }
                else {
                    
                    _items = [Tick]()
                }
                
                return _items!
            }
            
            return items
        }
        
        set {
            
            _items = newValue
        }
    }
    
    /// Optional callback that notify about the data source changes
    public var onDataSourceChanged: (() -> Void)?
    
    
    deinit {
        
        NotificationCenter.default.removeObserver(self)
    }
    
    init() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.onResponseNotification(_:)),
                                               name: NSNotification.Name(responseObjectNotification), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.onSelectSymbolsNotification(_:)),
                                               name: NSNotification.Name(selectSymbolsNotification), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.onSocketConnectNotification),
                                               name: NSNotification.Name(socketConnectNotification), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.archiveData),
                                               name: NSNotification.Name.UIApplicationWillTerminate, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.archiveData),
                                               name: NSNotification.Name.UIApplicationDidEnterBackground, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.archiveData),
                                               name: NSNotification.Name.UIApplicationDidReceiveMemoryWarning, object: nil)
    }
    
    /// Removes a given symbol from data source by index.
    /// - Parameter index: The index of deleting symbol.
    public func removeSymbol(at index: Int) {
        
        let symbol = items[index].symbol
        items.remove(at: index)

        WireFrame.serverAPI.sendCommand(command: .unsubscribe, symbols: [symbol])
    }
    
    /// Changes index of a symbol in data source by using startIndex and endIndex parameters.
    /// - Parameter startIndex: The original index of a symbol.
    /// - Parameter endIndex: The final index of a symbol.
    public func moveSymbol(from startIndex: Int, to endIndex: Int) {
        
        let item = items[startIndex]
        items.remove(at: startIndex)
        items.insert(item, at: endIndex)
    }
    
    /// Updates data source by using a given symbols.
    /// - Parameter symbols: Array of symbols user have chosen. These symbols will be presented on the screen.
    public func updateSymbols(_ symbols: [Symbol]) {
        
        var newSet = Set<Tick>()
        
        for symbol in symbols {
            
            let tick = Tick()
            tick.symbol = symbol
            
            newSet.insert(tick)
        }
        
        let oldSet = Set(items)
        
        let unsubscribe = oldSet.subtracting(newSet)
        let subscribe = newSet.subtracting(oldSet)
        
        if unsubscribe.count > 0 {
            
            for tick in unsubscribe {
                
                let index = items.index(of: tick)!
                items.remove(at: index)
            }
            
            WireFrame.serverAPI.sendCommand(command: .unsubscribe, symbols: unsubscribe.map({ $0.symbol }))
        }
        
        if subscribe.count > 0 {
            
            items.append(contentsOf: subscribe)
            WireFrame.serverAPI.sendCommand(command: .subscribe, symbols: subscribe.map({ $0.symbol }))
        }
        
        self.onDataSourceChanged?()
    }
    
    @objc fileprivate func onResponseNotification(_ notification: Notification) {
        
        let response = notification.object as! Response
        
        for tick in response.ticks {
            
            if let index = items.index(of: tick) {
                
                let item = items[index]
                
                item.copyData(from: tick)
                item.onItemChanged?(item)
            }
        }
    }
    
    @objc fileprivate func onSelectSymbolsNotification(_ notification: Notification) {
        
        let symbols = notification.object as! [Symbol]
        updateSymbols(symbols)
    }
    
    @objc fileprivate func onSocketConnectNotification() {
        
        let symbols = items.map({ $0.symbol })
        WireFrame.serverAPI.sendCommand(command: .subscribe, symbols: symbols)
    }
    
    @objc fileprivate func archiveData() {
        
        let ticks = items
        
        DispatchQueue.global().async {
            
            let data = NSKeyedArchiver.archivedData(withRootObject: ticks)
            
            let userDefaults = UserDefaults.standard
            userDefaults.set(data, forKey: self.rootObjectKey)
            userDefaults.synchronize()
        }
    }
    
    fileprivate func itemsFromArchive() -> [Tick]? {
        
        let userDefaults = UserDefaults.standard
        
        guard let data = userDefaults.object(forKey: rootObjectKey) else {
            
            return nil
        }
        
        return NSKeyedUnarchiver.unarchiveObject(with: data as! Data) as? [Tick]
    }
}
