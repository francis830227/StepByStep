//
//  FavoriteAutoCompleted.swift
//  StepByStep
//
//  Created by Francis Tseng on 2017/8/2.
//  Copyright © 2017年 Francis Tseng. All rights reserved.
//

import Foundation
import UIKit
import GooglePlaces
import Firebase
import NVActivityIndicatorView

extension FavoriteViewController: GMSAutocompleteViewControllerDelegate {
    
    public func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        
        print("Place name: \(place.name)")
        
        print("Place address: \(place.formattedAddress!)")
        
        self.loadFirstPhotoForPlace(placeID: place.placeID, placeName: place.name, placeAddress: place.formattedAddress!)
        
        self.dismiss(animated: false, completion: nil)
        
        favoriteTableView.reloadData()
        
        let activityData = ActivityData()
        
        NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData)
        
        NVActivityIndicatorPresenter.sharedInstance.setMessage("Saving")
    }
    
    public func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }

    public func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        self.dismiss(animated: false, completion: nil)
        

    }
}
