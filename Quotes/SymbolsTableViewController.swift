//
//  SymbolsTableViewController.swift
//  Quotes
//
//  Created by Vladimir Kokhanevich on 23/08/2017.
//  Copyright © 2017 Vladimir Kokhanevich. All rights reserved.
//

import UIKit

/// Displays list of available symbols.
class SymbolsTableViewController: UITableViewController {

    fileprivate let dataSource = Symbol.allCases
    
    var selectedSymbols = [Symbol]()
    
    var defaultTintColor = UIColor()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.tableFooterView = UIView()
        self.tableView.rowHeight = 44
        self.tableView.allowsMultipleSelection = true
        self.defaultTintColor = self.view.tintColor
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return dataSource.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        let cell = tableView.dequeueReusableCell(withIdentifier: "basic", for: indexPath)
        cell.textLabel?.text = dataSource[indexPath.row].decoratedValue
        cell.selectionStyle = .none
        
        let symbol = dataSource[indexPath.row]
        
        if selectedSymbols.contains(symbol) {
            
            tableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
            cell.tintColor = defaultTintColor
        }
        else {
            
            cell.tintColor = UIColor.lightGray
        }
        
        return cell
    }

    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath)
        cell?.tintColor = defaultTintColor
        
        selectedSymbols.append(dataSource[indexPath.row])
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath)
        cell?.tintColor = UIColor.lightGray
        
        let symbol = dataSource[indexPath.row]
        let index = selectedSymbols.index(of: symbol)!
        selectedSymbols.remove(at: index)
    }

    // MARK: - Actions
    
    @IBAction func done(_ sender: Any) {
        
        NotificationCenter.default.post(name: NSNotification.Name(selectSymbolsNotification), object: selectedSymbols)
        self.dismiss(animated: true, completion: nil)
    }
}
