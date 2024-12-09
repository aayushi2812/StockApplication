//
//  StockTableViewController.swift
//  StockApplication
//
//  Created by user265285 on 11/28/24.
//

import UIKit

class StockTableViewController: UITableViewController {
    
    var tableSections = [
        "Active": [],
        "Watching": []
    ]
    
    var sectionTitles: [String] {
        return Array(tableSections.keys)
    }

    @objc func addItem() {
        print("Add button tapped!")
        // Add your logic to add a new item here
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = editButtonItem
        print("Fetched Stocks")
        let stocks = CoreDataManager.shared.fetchStocks()
        for stock in stocks{
            if(stock.status == "Active"){
                tableSections["Active"]?.append(stock.name!)
            }
            else{
                tableSections["Watching"]?.append(stock.name!)
            }
        }
        tableView.reloadData()
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Identify the section and item being deleted
            let key = Array(tableSections.keys)[indexPath.section]
            guard var items = tableSections[key] else { return }
            
            // Get the item to delete
            let itemToDelete = items[indexPath.row]
            // 1. Delete the item from Core Data
            CoreDataManager.shared.deleteStock("\(itemToDelete)")

            // 2. Update the data source
            items.remove(at: indexPath.row)
            tableSections[key] = items

            // 3. Delete the row in the table view
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return sectionTitles.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        let sectionTitle = sectionTitles[section]
        return tableSections[sectionTitle]?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        let sectionTitle = sectionTitles[indexPath.section]
        if let items = tableSections[sectionTitle] {
            cell.textLabel?.text = items[indexPath.row] as! String
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section];
    }
    
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true // Allow all rows to be movable
    }

    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true // Enable editing mode for all rows
    }


    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        tableView.setEditing(editing, animated: animated)
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        // Identify the source and destination sections
            let sourceKey = Array(tableSections.keys)[sourceIndexPath.section]
            let destinationKey = Array(tableSections.keys)[destinationIndexPath.section]

            // Update the data source
            guard var sourceItems = tableSections[sourceKey],
                  var destinationItems = tableSections[destinationKey] else { return }

            // Remove the item from the source section
            let movedItem = sourceItems.remove(at: sourceIndexPath.row)

            // Add the item to the destination section
            destinationItems.insert(movedItem, at: destinationIndexPath.row)

            // Update the sections in the dictionary
            tableSections[sourceKey] = sourceItems
            tableSections[destinationKey] = destinationItems
            // Core Data: Update the status of the moved item
            CoreDataManager.shared.updateStockStatus(for: "\(movedItem)", newStatus: destinationKey)

            // Save the context to persist changes
            CoreDataManager.shared.saveContext()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let sectionKey = Array(tableSections.keys)[indexPath.section]
        
            
            // Get the stock name for the selected row
            if let stocks = tableSections[sectionKey] {
                let selectedStock = stocks[indexPath.row]
                print("Selected Stock: \(selectedStock)")
                
                var performanceId = "";
                var rank = ""
                let stocks = CoreDataManager.shared.fetchStocks()
                
                let detailVC = DetailViewController()
                
                for s in stocks{
                    if(s.name! == "\(selectedStock)"){
                        print("inprint")
                        performanceId = s.performanceID!
                        rank = s.rank!
                        let urlStr = "https://ms-finance.p.rapidapi.com/market/v3/get-realtime-data?performanceIds=\(performanceId)"
                        
                        
                        
                        Service.shared.getRealtimeData(fromURL: urlStr) { [unowned self] data in
                            let st = String(data: data, encoding: .utf8)
                            
                            // Decode JSON using `StockDictionary` typealias
                            if let value = try? JSONDecoder().decode(StockDictionary.self, from: data) {
                                
                                // Use `performanceId` to access the specific stock
                                if let stock = value[performanceId] {
                                    // Safely unwrap values
                                    let netChange = stock.netChange?.value ?? 0
                                    let name = stock.name?.value
                                    let lastPrice = stock.lastPrice?.value ?? 0
                                    let percentNetChange = stock.percentNetChange?.value ?? 0
                                    
                                    // Print the extracted values
                                    print("Net Change: \(netChange)")
                                    print("Name: \(name)")
                                    print("Last Price: \(lastPrice)")
                                    detailVC.performanceId = performanceId
                                    detailVC.r = rank
                                    detailVC.nc = "\(netChange)"
                                    detailVC.pnc = "\(percentNetChange)"
                                    detailVC.lp = "\(lastPrice)"
                                    detailVC.name = "\(selectedStock)"
                                    DispatchQueue.main.async {
                                        performSegue(withIdentifier: "showDetail", sender: detailVC)
                                    }
                                    
                                    
                                } else {
                                    print("No stock data found for performanceId: \(performanceId)")
                                }
                            } else {
                                print("Failed to decode JSON")
                            }
                        }

                    }
                }
            }
    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
