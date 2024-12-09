//
//  DetailViewController.swift
//  StockApplication
//
//  Created by user265285 on 11/30/24.
//

import UIKit

class DetailViewController: UIViewController {
    
    var performanceId: String?{
        didSet { updateUIIfNeeded() }
    }
    var nc: String?{
        didSet { updateUIIfNeeded() }
    }
    var pnc: String?{
        didSet { updateUIIfNeeded() }
    }
    var lp: String?{
        didSet { updateUIIfNeeded() }
    }
    var name: String?{
        didSet { updateUIIfNeeded() }
    }
    var r: String?{
        didSet { updateUIIfNeeded() }
    }
    
    
    @IBOutlet weak var stockName: UILabel!
    @IBOutlet weak var pNetChange: UILabel!
    
    @IBOutlet weak var netChange: UILabel!
    @IBOutlet weak var rank: UILabel!
    
    @IBOutlet weak var lastPrice: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func updateUIIfNeeded() {
        DispatchQueue.main.async {
            guard self.isViewLoaded else { return }
            self.stockName.text = self.name
            self.netChange.text = self.nc
            self.lastPrice.text = self.lp
            self.pNetChange.text = self.pnc
            self.rank.text = self.r
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
