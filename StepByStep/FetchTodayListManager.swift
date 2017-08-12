//
//  FetchTodayListManager.swift
//  StepByStep
//
//  Created by Francis Tseng on 2017/8/12.
//  Copyright © 2017年 Francis Tseng. All rights reserved.
//

import Foundation
import Firebase
import NVActivityIndicatorView

struct EveryDayList {
    
    var endDate: String
    
    var titleName: String
    
}

protocol FetchTodayListManagerDelegate: class {
    
    func manager(didGet data: EveryDayListType)

}

typealias EveryDayListType = [String :[[String: [String: String]]]]

class FetchTodayListManager {
    
    var everyDayLists = EveryDayListType()
    
    weak var delegate: FetchTodayListManagerDelegate?
    
    let ref = Database.database().reference()
    
    let uid = Auth.auth().currentUser!.uid
    
    func requestData() {
        
        ref.child("Event").child(uid).observe(DataEventType.childAdded, with: { [weak self] (snapshot) in
            print(snapshot.value!)
            
            guard let dictionary = snapshot.value as? [String: Any] else { return }
            
            self?.everyDayLists = dictionary as! EveryDayListType
                
                if self?.everyDayLists != nil {
                    
                    self?.delegate?.manager(didGet: (self?.everyDayLists)!)
                    
                }
        })
        
    }
    
}
