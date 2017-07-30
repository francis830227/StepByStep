//
//  MainViewController.swift
//  StepByStep
//
//  Created by Francis Tseng on 2017/7/26.
//  Copyright © 2017年 Francis Tseng. All rights reserved.
//

import UIKit
import AnimatedCollectionViewLayout

class MainViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    override var prefersStatusBarHidden: Bool { return true }
    
    let animator = LinearCardAttributesAnimator()
    
    var dates = [EndDate]()
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.isPagingEnabled = true
        
        if let layout = collectionView?.collectionViewLayout as? AnimatedCollectionViewLayout {
            
            layout.scrollDirection = .horizontal
            
            layout.animator = animator
        
        }
        
        let dataManager = PickEndDateViewController()
        
        dataManager.delegate = self
        
        dataManager.requestData()
        
    }
    
    @IBAction func todayListButtonPressed(_ sender: Any) {
    }

}

extension MainViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
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
            
            cell.addCardLabel.isHidden = true
            
            //        cell.countDownLabel.text = dates[indexPath.row].
            cell.countDownLabel.text = "\(arc4random_uniform(100))天"
            
            cell.finishDateLabel.text = "完成日：\(year)/\(month)/\(day)"
            
            cell.totalGoingLabel.text = "\(arc4random_uniform(99))%"
            
            cell.todayGoingLabel.text = "總進度\(arc4random_uniform(99))%"
            
            cell.clipsToBounds = false
        }
        
        
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

extension MainViewController: EndDateDelegate {
    
    func manager(_ data: [EndDate]) {
        
        dates = data
        
    }
    
    
}
