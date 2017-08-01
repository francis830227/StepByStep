//
//  MainViewController.swift
//  StepByStep
//
//  Created by Francis Tseng on 2017/7/26.
//  Copyright © 2017年 Francis Tseng. All rights reserved.
//

import UIKit
import AnimatedCollectionViewLayout
import Firebase
import NVActivityIndicatorView

class MainViewController: UIViewController {
    
    let animator = LinearCardAttributesAnimator()
    
    let fetchManager = FetchManager()
    
    let formatter = DateFormatter()
    
    var dates = [EndDate]()
    
    @IBOutlet weak var addLabel: UILabel!
    
    @IBOutlet weak var todayTime: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchManager.delegate = self
        
        fetchManager.requestData()
        
        let todayDate = Date()
        
        formatter.dateFormat = "yyyy MM dd"
        
        let date = formatter.string(from: todayDate)
        
        todayTime.text = date
        
        collectionViewLayout(collectionView: collectionView, animator: animator)
        
    }
    
    
    @IBAction func todayListButtonPressed(_ sender: Any) {
    }
    
}

func collectionViewLayout(collectionView: UICollectionView, animator: LinearCardAttributesAnimator) {
    
        collectionView.isPagingEnabled = true
        
        if let layout = collectionView.collectionViewLayout as? AnimatedCollectionViewLayout {
            
            layout.scrollDirection = .horizontal
            
            layout.animator = animator
            
        }
        
    }

extension MainViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if dates.count > 0 {
        
            addLabel.isHidden = true
        
        }
        
        return dates.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MainCollectionViewCell", for: indexPath) as! MainCollectionViewCell
        
        let year = dates[indexPath.row].year
        
        let month = dates[indexPath.row].month
        
        let day = dates[indexPath.row].day
        
        cell.bind()
        
        if year == "" || month == "" || day == "" {
            
            cell.countDownLabel.text = ""
            
            cell.finishDateLabel.text = ""
            
            cell.totalGoingLabel.text = ""
            
            cell.todayGoingLabel.text = ""
            
            cell.clipsToBounds = false
            
        } else {
            
            let formatter = DateFormatter()
            
            let today = NSDate()
            
            formatter.dateFormat = "yyyy MM dd"
            
            let targetDay = "\(dates[indexPath.row].year) \(dates[indexPath.row].month) \(dates[indexPath.row].day)"

            let date = formatter.date(from: targetDay)
            
            let targetDayNS = date! as NSDate
            
            let targetDayInt = Int(targetDayNS.timeIntervalSinceReferenceDate)
            
            let todayInt = Int(today.timeIntervalSinceReferenceDate)
            
            print(targetDayInt, todayInt)
            
            let minus = Int((targetDayInt - todayInt) / 86400)
            
            if minus < 0 {

                cell.countDownLabel.text = "\(Int(today.timeIntervalSinceReferenceDate - targetDayNS.timeIntervalSinceReferenceDate)/86400)天前"
                
            } else if minus == 0 {
                
                cell.countDownLabel.text = "今天"
                
            } else {

                cell.countDownLabel.text = "剩\(Int(targetDayNS.timeIntervalSinceReferenceDate - today.timeIntervalSinceReferenceDate)/86400)天"

            }
            //cell.countDownLabel.text = "\(arc4random_uniform(100))天"
            
            cell.finishDateLabel.text = "完成日：\(year)/\(month)/\(day)"
            
            cell.totalGoingLabel.text = "\(arc4random_uniform(99))%"
            
            cell.todayGoingLabel.text = "總進度\(arc4random_uniform(99))%"
            
            cell.clipsToBounds = false
        }
        
        cell.eventLabel.text = dates[indexPath.row].titleName
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
       
        return CGSize(width: view.bounds.width, height: view.bounds.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return 0
        
    }
    
}

extension MainViewController: FetchManagerDelegate {
    
    func manager(didGet data: [EndDate]) {
        
        self.dates = data
        print(self.dates)
        collectionView.reloadData()

    
    }
    
}
