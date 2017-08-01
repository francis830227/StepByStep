//
//  fetchManager.swift
//  StepByStep
//
//  Created by Francis Tseng on 2017/7/31.
//  Copyright © 2017年 Francis Tseng. All rights reserved.
//

import Foundation
import Firebase

struct EndDate {
    
    var year: String
    
    var month: String
    
    var day: String
    
    var titleName: String
    
}

protocol FetchManagerDelegate: class {
    
    func manager(didGet data: [EndDate])

}

class FetchManager {
    
    var dataInFM = [EndDate]()

    weak var delegate: FetchManagerDelegate?
    
    func requestData() {
        
        let ref = Database.database().reference()
        
        let uid = Auth.auth().currentUser!.uid
        
        ref.child("title").child(uid).observe(DataEventType.childAdded, with: { snapshot in
            print(snapshot.value!)
            
        guard let dictionary = snapshot.value as? [String: Any] else { return }
                
                if let year = dictionary["year"] as? String,
                    let month = dictionary["month"] as? String,
                    let day = dictionary["day"] as? String,
                    let titleName = dictionary["titleName"] as? String {
                    
                    self.dataInFM.append(EndDate(year: year, month: month, day: day, titleName: titleName))
                    
                    print(self.dataInFM)
                    
                    self.delegate?.manager(didGet: self.dataInFM)

            }
            
            
        })
        
    }
    
}
