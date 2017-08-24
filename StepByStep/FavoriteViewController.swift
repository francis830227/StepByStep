//
//  FavoriteViewController.swift
//  StepByStep
//
//  Created by Francis Tseng on 2017/8/2.
//  Copyright © 2017年 Francis Tseng. All rights reserved.
//

import UIKit
import GooglePlaces
import Firebase
import FirebaseStorage

class FavoriteViewController: UIViewController, UISearchBarDelegate {
    
    let resultsViewController = GMSAutocompleteViewController()

    var searchController: UISearchController?
    
    var resultView: UITextView?
    
    let fetchManager = FetchManager()
        
    var placesInfo = [FavoritePlace]()
    
    @IBOutlet weak var addImageView: UIImageView!
    
    @IBOutlet weak var favoriteTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchManager.delegate = self
        
        fetchManager.requestPlace()
        
        gradientFavoriteNavi()
        
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchController?.searchBar.text = searchBar.text
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        favoriteTableView.reloadData()
    }
    
    
    @IBAction func showSearchBarButtonPressed(_ sender: UIButton) {
        
        let resultsViewController = GMSAutocompleteViewController()
        
        resultsViewController.delegate = self
        
        UISearchBar.appearance().tintColor = .white
        
        UISearchBar.appearance().barStyle = UIBarStyle.default
        
        let searchBarTextAttributes: [String : AnyObject] = [NSForegroundColorAttributeName: UIColor.white, NSFontAttributeName: UIFont.systemFont(ofSize: UIFont.systemFontSize)]
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = searchBarTextAttributes
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).keyboardAppearance = .dark
        UINavigationBar.appearance().tintColor = .white
        
        UINavigationBar.appearance().barTintColor = UIColor(red: 42/255, green: 48/255, blue: 48/255, alpha: 1)
        resultsViewController.primaryTextHighlightColor = .white
        resultsViewController.primaryTextColor = .lightGray
        resultsViewController.tableCellBackgroundColor = UIColor(red: 34/255, green: 41/255, blue: 41/255, alpha: 0.8)
        resultsViewController.tableCellSeparatorColor = .lightGray
        resultsViewController.secondaryTextColor = .lightGray
        
//        // When UISearchController presents the results view, present it in
//        // this view controller, not one further up the chain.
        definesPresentationContext = true
        
        present(resultsViewController, animated: false, completion: nil)
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    func loadFirstPhotoForPlace(placeID: String, placeName: String, placeAddress: String) {
        GMSPlacesClient.shared().lookUpPhotos(forPlaceID: placeID) { (photos, error) -> Void in
            if let error = error {
                // TODO: handle the error.
                print("Error: \(error.localizedDescription)")
            } else {
                if let firstPhoto = photos?.results.first {
                    self.loadImageForMetadata(photoMetadata: firstPhoto, placeName: placeName, placeAddress: placeAddress)
                }
            }
        }
    }
    
    func loadImageForMetadata(photoMetadata: GMSPlacePhotoMetadata, placeName: String, placeAddress: String) {
        GMSPlacesClient.shared().loadPlacePhoto(photoMetadata, callback: {
            (photo, error) -> Void in
            if let error = error {
                // TODO: handle the error.
                print("Error: \(error.localizedDescription)")
            } else {
                
                self.getPhotoURL(photo, placeName, placeAddress)
            }
        })
    }
    
    func getPhotoURL(_ image: UIImage?,_ placeName: String,_ placeAddress: String) {
        
        let uniqueString = NSUUID().uuidString
        
        let uid = Auth.auth().currentUser?.uid
        
        let ref = Database.database().reference().child("favorite").child(uid!).childByAutoId()
        
        guard let photo = image else { return }
        
        let photoComp = UIImageJPEGRepresentation(photo, 0.6)
        
        let storageRef = Storage.storage().reference().child("favoriteImage").child(uid!).child("\(uniqueString).png")
        
        if let uploadData = photoComp {
            
            storageRef.putData(uploadData, metadata: nil, completion: { (data, error) in
                
                if error != nil {
                    
                    print("Error: \(error!.localizedDescription)")
                    
                    return
                }
                
                if let uploadImageUrl = data?.downloadURL()?.absoluteString {
                    
                    let values = ["name": placeName, "address": placeAddress, "image": uploadImageUrl]
                    
                    ref.updateChildValues(values)
                }
            })
        }
    }
}

extension FavoriteViewController: FetchManagerDelegate {
    
    func manager(didGet data: [FavoritePlace]) {
        
        self.placesInfo = data
        favoriteTableView.reloadData()
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
