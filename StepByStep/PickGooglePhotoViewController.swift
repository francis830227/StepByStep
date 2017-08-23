//
//  PickGooglePhotoViewController.swift
//  StepByStep
//
//  Created by Francis Tseng on 2017/8/16.
//  Copyright © 2017年 Francis Tseng. All rights reserved.
//

import UIKit
import Firebase
import GooglePlaces

protocol GetImageDelegate: class {
    
    func setImagePickedFromGoogle(_ imageUrl: String)
    
}

class PickGooglePhotoViewController: UIViewController {

    let fetchManager = FetchManager()
    
    var placesInfo = [FavoritePlace]()
    
    var delegate: GetImageDelegate?
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var noFavLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        fetchManager.delegate = self
        
        fetchManager.requestPlace()
        
        gradientPickGoogleNavi()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }
    

    @IBAction func backButtonPressed(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
    }
    
}

extension PickGooglePhotoViewController: FetchManagerDelegate {
    
    func manager(didGet data: [FavoritePlace]) {
        
        self.placesInfo = data
        tableView.reloadData()
    }
    
    func manager(didGet data: [EndDate]) {
        return
    }
    
    func manager(didGet data: User?) {
        return
    }
    
    func manager(didGet data: [HistoryEvent]) {
        return
    }
    
}

