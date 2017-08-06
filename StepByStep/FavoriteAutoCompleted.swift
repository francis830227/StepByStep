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

extension FavoriteViewController: GMSAutocompleteResultsViewControllerDelegate {
    
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                           didAutocompleteWith place: GMSPlace) {
        
        searchController?.isActive = false
        
        // Do something with the selected place.
        print("Place name: \(place.name)")
        
        print("Place address: \(place.formattedAddress!)")
        
        self.places.append(Place(name: place.name, address: place.formattedAddress!, image: nil))
        
        self.loadFirstPhotoForPlace(placeID: place.placeID, placeName: place.name, placeAddress: place.formattedAddress!, indexPathRow: self.places.count - 1)
        
        favoriteCollectionView.reloadData()
    }
    
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                           didFailAutocompleteWithError error: Error){
        
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
        
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(forResultsController resultsController: GMSAutocompleteResultsViewController) {
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(forResultsController resultsController: GMSAutocompleteResultsViewController) {
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
}