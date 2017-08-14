//
//  fetchManager.swift
//  StepByStep
//
//  Created by Francis Tseng on 2017/7/31.
//  Copyright © 2017年 Francis Tseng. All rights reserved.
//

import Foundation
import Firebase
import NVActivityIndicatorView

struct EndDate {
    
    var year: String
    
    var month: String
    
    var day: String
    
    var imageURL: String
    
    var titleName: String
    
    var titleKey: String
    
    var minute: Int {
        
        let formatter = DateFormatter()
        
        formatter.dateFormat = "yyyy MM dd"
        
        let minute = formatter.date(from: "\(year) \(month) \(day)")
        print(year,month,day)
        let targetDayNS = minute! as NSDate
        
        return  Int(targetDayNS.timeIntervalSinceReferenceDate)
    }
    
}

extension EndDate: Comparable {
    static func < (lhs: EndDate, rhs: EndDate) -> Bool {
        return lhs.minute < rhs.minute
    }
    static func <= (lhs: EndDate, rhs: EndDate) -> Bool {
        return lhs.minute <= rhs.minute
    }
    static func > (lhs: EndDate, rhs: EndDate) -> Bool {
        return lhs.minute > rhs.minute
    }
    static func >= (lhs: EndDate, rhs: EndDate) -> Bool {
        return lhs.minute >= rhs.minute
    }
    static func == (lhs: EndDate, rhs: EndDate) -> Bool {
        return lhs.minute == rhs.minute
    }
}

struct FavoritePlace {
    
    var placeName: String
    
    var placeAddress: String
    
    var placeImageURL: String
    
    var placeKey: String
    
}

protocol FetchManagerDelegate: class {
    
    func manager(didGet data: [EndDate])
    
    func manager(didGet data: [FavoritePlace])

}

class FetchManager {

    weak var delegate: FetchManagerDelegate?
    
    let ref = Database.database().reference()
    
    let uid = Auth.auth().currentUser!.uid
    
    let activityData = ActivityData()

    func requestData() {
        
        NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData)
        
        ref.child("title").child(uid).observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
            
            if snapshot.exists() == false {
                
                NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
            }
        })
        
        ref.child("title").child(uid).observe(DataEventType.value, with: { [weak self] (snapshot) in
            print(snapshot.value!)
            
            var dataInFM = [EndDate]()
            
            for item in snapshot.children {
                
                guard let itemSnapshot = item as? DataSnapshot else { return }
                
                guard let dictionary = itemSnapshot.value as? [String: String] else { return }
                
                if let year = dictionary["year"],
                    let month = dictionary["month"],
                    let day = dictionary["day"],
                    let titleName = dictionary["titleName"],
                    let imageURL = dictionary["image"] {
                    
                    dataInFM.append(EndDate(year: year, month: month, day: day, imageURL: imageURL, titleName: titleName, titleKey: itemSnapshot.key))
                    
                    self?.delegate?.manager(didGet: dataInFM)
                    
                    NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
                }
            }
            
        })
    }
    
    func requestPlace() {
        
        NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData)
        
        ref.child("favorite").child(uid).observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
            
            if snapshot.exists() == false {
            
                NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
            }
        })

        ref.child("favorite").child(uid).observe(DataEventType.value, with: { [weak self] (snapshot) in
            //print(snapshot.value)
            
            var placeInFM = [FavoritePlace]()
            
            if snapshot.childrenCount == 0 {
                placeInFM = []
                DispatchQueue.main.async {
                    self?.delegate?.manager(didGet: placeInFM)
                }
                
            } else {
            
                for item in snapshot.children {
                
                guard let itemSnapshot = item as? DataSnapshot else { return }
            
                guard let dictionary = itemSnapshot.value as? [String: String] else { return }
                
                if let name = dictionary["name"],
                    let address = dictionary["address"],
                    let imageURL = dictionary["image"] {
                    
                    placeInFM.append(FavoritePlace(placeName: name, placeAddress: address, placeImageURL: imageURL, placeKey: itemSnapshot.key))
                    
                    DispatchQueue.main.async {
                        self?.delegate?.manager(didGet: placeInFM)
                    }
                    
                    NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
                    }
                }
            }
        })
        
    }
    
}
