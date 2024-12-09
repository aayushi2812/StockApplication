//
//  StockViewController.swift
//  StockApplication
//
//  Created by user265285 on 11/27/24.
//

import UIKit


class StockViewController: UIViewController {
    
    
    lazy var searchResultTVC = storyboard?.instantiateViewController(withIdentifier: "searchResultsTVC") as! SearchTableTableViewController
    
    lazy var searchController = UISearchController(searchResultsController : searchResultTVC)

    var stockHere: Stock?
    var stockName: String = ""
    var performanceId: String = ""
    
    
    @IBOutlet weak var rank: UISegmentedControl!
    
    @IBOutlet weak var status: UISegmentedControl!
    override func viewDidLoad() {
        super.viewDidLoad()
        if let stock = stockHere {
            
        }else{
            navigationItem.searchController = searchController
            searchController.searchResultsUpdater = self
            searchResultTVC.delegate = self
        }
        // Do any additional setup after loading the view.
    }
    
    @IBAction func saveOnClick(_ sender: Any) {
        if(status.selectedSegmentIndex == 0){
            if(rank.selectedSegmentIndex == 0){
                CoreDataManager.shared.saveStock(name: stockName,performanceId: performanceId, status: "Active", rank: "Cold")
            }else if(rank.selectedSegmentIndex == 1){
                CoreDataManager.shared.saveStock(name: stockName,performanceId: performanceId, status: "Active",rank: "Hot")
            }else{
                CoreDataManager.shared.saveStock(name: stockName,performanceId: performanceId, status: "Active",rank: "Very Hot")
            }
            
        }
        else{
            if(rank.selectedSegmentIndex == 0){
                CoreDataManager.shared.saveStock(name: stockName,performanceId: performanceId, status: "Watching", rank: "Cold")
            }else if(rank.selectedSegmentIndex == 1){
                CoreDataManager.shared.saveStock(name: stockName,performanceId: performanceId, status: "Watching",rank: "Hot")
            }else{
                CoreDataManager.shared.saveStock(name: stockName,performanceId: performanceId, status: "Watching",rank: "Very Hot")
            }
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
	
}
extension StockViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let data   = searchController.searchBar.text else {return}
        let urlStr = "https://ms-finance.p.rapidapi.com/market/v2/auto-complete?q=\(data)"
        print(urlStr)
        
        Service.shared.getData(fromURL: urlStr){[unowned self] data in
            print(data)
            let st = String(data: data, encoding: .utf8)
            print(st)
            
            if let value = try? JSONDecoder().decode(ResultValues.self, from: data){
                self.searchResultTVC.stocksFromSearch = value.results
            }
        }
    }
}
extension StockViewController: SearchTableTableViewControllerDelegate{
    func SearchTableTableViewControllerDidFinishWith(stock: TStock) {
        searchController.isActive = false
        print(stock.name)
        print(stock.performanceId)
        stockHere?.name = stock.name
        stockHere?.performanceID = stock.performanceId
        stockName = stock.name
        performanceId = stock.performanceId
        title = stock.name
        
        
    }
}
