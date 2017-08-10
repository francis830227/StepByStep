//
//  FavoriteViewController.swift
//  StepByStep
//
//  Created by Francis Tseng on 2017/8/2.
//  Copyright © 2017年 Francis Tseng. All rights reserved.
//

import UIKit
import GooglePlaces
import SFFocusViewLayout
import GooglePlacePicker
import GoogleMaps
import Firebase
import FirebaseStorage

struct Place {
    var name: String
    var address: String
    var image: UIImage?
}

class FavoriteViewController: UIViewController {

    var resultsViewController: GMSAutocompleteResultsViewController?
    
    var searchController: UISearchController?
    
    var resultView: UITextView?
    
    let fetchManager = FetchManager()
    
    var places = [Place]()
    
    var placesInfo = [FavoritePlace]()
    
    @IBOutlet weak var favoriteTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchManager.delegate = self
        
        fetchManager.requestPlace()
        
        resultsViewController = GMSAutocompleteResultsViewController()
        
        resultsViewController?.delegate = self
        
        let subView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 45.0))

        gradientFavoriteNavi()

        searchBarAndNaviLayout()
        
        subView.addSubview((searchController?.searchBar)!)
        
        view.addSubview(subView)
        
        searchController?.searchBar.sizeToFit()
        
        // When UISearchController presents the results view, present it in
        // this view controller, not one further up the chain.
        definesPresentationContext = true
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        favoriteTableView.reloadData()
    }
    

    @IBAction func backButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    func searchBarAndNaviLayout() {

        searchController = UISearchController(searchResultsController: resultsViewController)
        searchController?.searchResultsUpdater = resultsViewController
        searchController?.searchBar.barTintColor = UIColor(red: 42/255, green: 48/255, blue: 48/255, alpha: 1)
        searchController?.searchBar.tintColor = .white
        
        resultsViewController?.navigationController?.navigationBar.barTintColor = UIColor(red: 42/255, green: 48/255, blue: 48/255, alpha: 1)
        resultsViewController?.navigationController?.navigationBar.tintColor = UIColor.white
        resultsViewController?.primaryTextHighlightColor = .white
        resultsViewController?.primaryTextColor = .lightGray
        resultsViewController?.tableCellBackgroundColor = UIColor(red: 34/255, green: 41/255, blue: 41/255, alpha: 0.8)
        resultsViewController?.tableCellSeparatorColor = .lightGray
        resultsViewController?.secondaryTextColor = .lightGray
    }

    func loadFirstPhotoForPlace(placeID: String, placeName: String, placeAddress: String, indexPathRow: Int) {
        GMSPlacesClient.shared().lookUpPhotos(forPlaceID: placeID) { (photos, error) -> Void in
            if let error = error {
                // TODO: handle the error.
                print("Error: \(error.localizedDescription)")
            } else {
                if let firstPhoto = photos?.results.first {
                    self.loadImageForMetadata(photoMetadata: firstPhoto, placeName: placeName, placeAddress: placeAddress, indexPathRow: indexPathRow)
                }
            }
        }
    }
    
    func loadImageForMetadata(photoMetadata: GMSPlacePhotoMetadata, placeName: String, placeAddress: String, indexPathRow: Int) {
        GMSPlacesClient.shared().loadPlacePhoto(photoMetadata, callback: {
            (photo, error) -> Void in
            if let error = error {
                // TODO: handle the error.
                print("Error: \(error.localizedDescription)")
            } else {
                self.places[indexPathRow].image = photo
                
                self.getPhotoURL(photo, placeName, placeAddress, indexPathRow: indexPathRow)
                
//                let uid = Auth.auth().currentUser?.uid
//                
//                let ref = Database.database().reference().child("favorite").child(uid!).childByAutoId()
                
                
            }
        })
    }
    
    func getPhotoURL(_ image: UIImage?,_ placeName: String,_ placeAddress: String, indexPathRow: Int) {
        
        let uniqueString = NSUUID().uuidString
        
        let uid = Auth.auth().currentUser?.uid
        
        let ref = Database.database().reference().child("favorite").child(uid!).childByAutoId()
        
        guard let photo = image else { return }
        
        let storageRef = Storage.storage().reference().child("favoriteImage").child(uid!).child("\(uniqueString).png")
        
        if let uploadData = UIImagePNGRepresentation(photo) {
            
            storageRef.putData(uploadData, metadata: nil, completion: { (data, error) in
                
                if error != nil {
                    
                    print("Error: \(error!.localizedDescription)")
                    return
                    
                }
                
                if let uploadImageUrl = data?.downloadURL()?.absoluteString {
                    
                    print("Photo URL: \(uploadImageUrl)")
                    
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
    
}
