//
//  TableViewController.swift
//  Quotes
//
//  Created by Vladimir Kokhanevich on 22/08/2017.
//  Copyright © 2017 Vladimir Kokhanevich. All rights reserved.
//

import UIKit

/// Displays main screen with list of Tick elements.
class TableViewController: UITableViewController {
    
    fileprivate let dataSource = SymbolsDataSource()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView()
        tableView.rowHeight = 44
        
        dataSource.onDataSourceChanged = {
            
            self.showDummyIfNeeded()
            self.tableView.reloadData()
        }
        
        self.showDummyIfNeeded()
        self.clearsSelectionOnViewWillAppear = true
        self.navigationItem.leftBarButtonItem = self.editButtonItem
    }

    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
            
        case 0:
            
            return 1
            
        default:
            
            return dataSource.items.count
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
        cell.selectionStyle = .none
        
        switch indexPath.section {
            
        case 0:
            
            cell.setup(for: .header)
            
            cell.symbol.text = "SYMBOL"
            cell.ba.text = "BID/ASK"
            cell.spread.text = "SPREAD"
            
            return cell
            
        default:
            
            cell.setup(for: .row)
            
            let tick = dataSource.items[indexPath.row]
            cell.symbol.text = tick.symbol.decoratedValue
            
            tick.onItemChanged = { tick in
                
                if !tick.bid.isEmpty {
                    
                    cell.ba.text = tick.bid + "/" + tick.ask
                }
                
                if !tick.spread.isEmpty {
                    
                    cell.spread.text = tick.spread
                }
            }
            
            tick.onItemChanged!(tick)
            
            return cell
        }
    }
 
    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        return indexPath.section != 0
    }
    

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
    
        if editingStyle == .delete {
            
            dataSource.removeSymbol(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    

    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

        dataSource.moveSymbol(from: fromIndexPath.row, to: to.row)
    }
    
    
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        
        return indexPath.section != 0
    }

    override func tableView(_ tableView: UITableView, targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath, toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath {
        
        if sourceIndexPath.section != proposedDestinationIndexPath.section {
            
            return IndexPath(row: 0, section: sourceIndexPath.section)
        }
        
        return proposedDestinationIndexPath
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier != "symbols" {
            
            return
        }
        
        let controller = (segue.destination as! UINavigationController).visibleViewController as! SymbolsTableViewController
        controller.selectedSymbols = dataSource.items.map({ $0.symbol })
    }
    
    fileprivate func showDummyIfNeeded() {
    
        if dataSource.items.count == 0 {
            
            self.showDummyView()
        }
        else {
            
            self.hideDummyView()
        }
    }
}
