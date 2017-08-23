//
//  CheckedViewController.swift
//  StepByStep
//
//  Created by Francis Tseng on 2017/8/23.
//  Copyright © 2017年 Francis Tseng. All rights reserved.
//

import UIKit

class CheckedViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var historyEvents = [HistoryEvent]()
    
    let fetchManager = FetchManager()
    
    @IBOutlet weak var historyTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        fetchManager.delegate = self
        
        fetchManager.requestHistoryEvent()
        
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return historyEvents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CheckedCell", for: indexPath) as! CheckedTableViewCell
        
        let year = historyEvents[indexPath.row].year
        let month = historyEvents[indexPath.row].month
        let day = historyEvents[indexPath.row].day
        
        cell.historyDateLabel.text = "DATE : \(year)/\(month)/\(day)"
        
        cell.historyTitleLabel.text = historyEvents[indexPath.row].titleName
        
        cell.historyImageView.contentMode = .scaleAspectFill
        
        cell.historyImageView.sd_setShowActivityIndicatorView(true)
        
        cell.historyImageView.sd_setIndicatorStyle(.white)
        
        cell.historyImageView.sd_setImage(with: URL(string: historyEvents[indexPath.row].imageUrl), completed: nil)
        
        return cell
    }
    
    @IBAction func exitButtonPressed(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
    }
}

extension CheckedViewController: FetchManagerDelegate {
    
    func manager(didGet data: [EndDate]) {
        return
    }
    
    func manager(didGet data: [FavoritePlace]) {
        return
    }
    
    func manager(didGet data: User?) {
        return
    }
    
    func manager(didGet data: [HistoryEvent]) {
        historyEvents = data
        
        historyTableView.reloadData()
    }
}
