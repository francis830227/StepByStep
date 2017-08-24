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
import UserNotifications
import Crashlytics

class MainViewController: UIViewController {
    
    let animator = LinearCardAttributesAnimator()
    
    let fetchManager = FetchManager()
    
    let formatter = DateFormatter()
    
    var dates = [EndDate]()
        
    var todayInt: Int?
    
    
    @IBOutlet weak var todayTime: UILabel!
    
    @IBOutlet weak var addImageView: UIImageView!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var addButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchManager.delegate = self
        
        fetchManager.requestData()
        
        let todayDate = Date()
        
        formatter.dateFormat = "yyyy/MM/dd"
        
        let date = formatter.string(from: todayDate)
        
        todayTime.text = date
        
        collectionViewLayout(collectionView: collectionView, animator: animator)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        collectionView.reloadData()
    }
    
    @IBAction func settingButtonPressed(_ sender: Any) {
        self.slideMenuController()?.openLeft()
        
        Analytics.logEvent("settingButtonPressed", parameters: nil)
    }
    
    @IBAction func addButtonPressed(_ sender: UIButton) {
        
        sender.bounce()

        let vc = self.storyboard?.instantiateViewController(withIdentifier: "pickDate")
        
        Analytics.logEvent("addButtonPressed", parameters: nil)
        
        self.present(vc!, animated: true, completion: nil)
    }
    
    func collectionViewLayout(collectionView: UICollectionView, animator: LinearCardAttributesAnimator) {
        
        collectionView.isPagingEnabled = true
        
        if let layout = collectionView.collectionViewLayout as? AnimatedCollectionViewLayout {
            
            layout.scrollDirection = .horizontal
            
            layout.animator = animator
            
        }
    }
    
    @IBAction func favoriteButtonPressed(_ sender: UIButton) {
        
        Analytics.logEvent("favoriteButtonPressed", parameters: nil)
    }
}

extension MainViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if dates.count > 0 {
        
            addImageView.isHidden = true
        }
        
        return dates.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MainCollectionViewCell", for: indexPath) as! MainCollectionViewCell
        
        let year = dates[indexPath.row].year
        
        let month = dates[indexPath.row].month
        
        let day = dates[indexPath.row].day

        cell.bind()
        
        cell.imageView.blur(withStyle: .dark)
        
        cell.imageView.contentMode = .scaleAspectFill
        
        cell.imageView.sd_setShowActivityIndicatorView(true)
        
        cell.imageView.sd_setIndicatorStyle(.gray)
        
        cell.imageView.sd_setImage(with: URL(string: dates[indexPath.row].imageURL), completed: nil)
        
        if year == "" || month == "" || day == "" {
            
            cell.countDownLabel.text = ""
            
            cell.finishDateLabel.text = ""
            
            cell.clipsToBounds = false
            
        } else {
            
            let formatter = DateFormatter()
            
            let today = Date()
            
            formatter.dateFormat = "yyyy MM dd"
            
            let todayString = formatter.string(from: today)
            
            let todayDate = formatter.date(from: todayString)

            let targetDay = "\(dates[indexPath.row].year) \(dates[indexPath.row].month) \(dates[indexPath.row].day)"

            let date = formatter.date(from: targetDay)
            
            let targetDayNS = date! as NSDate
            
            let todayNS = todayDate! as NSDate
            
            let targetDayInt = Int(targetDayNS.timeIntervalSinceReferenceDate)
            
            todayInt = Int(todayNS.timeIntervalSinceReferenceDate)
            
            let minus = Int((targetDayInt - todayInt!) / 86400)
            
            if minus < 0 {

                cell.countDownLabel.text = "\(Int((todayInt! - targetDayInt) / 86400)) - DAY PASSED"
                
            } else if minus == 0 {
                
                cell.countDownLabel.text = "TODAY"
                
            } else {

                cell.countDownLabel.text = "\(Int((targetDayInt - todayInt!) / 86400)) - DAY LEFT"

            }
            
            cell.finishDateLabel.text = "DATE : \(year)/\(month)/\(day)"
            
            cell.clipsToBounds = false
        }
        
        cell.eventLabel.text? = dates[indexPath.row].titleName
        
        cell.eventLabel.text = cell.eventLabel.text?.uppercased()
        
        cell.checkButton.tag = indexPath.row
        
        cell.checkButton.addTarget(self, action: #selector(checkCompletedEvent(sender:)), for: .touchUpInside)

        cell.deleteButton.tag = indexPath.row
        
        cell.deleteButton.addTarget(self, action: #selector(dealWithCollectionViewCell(sender:)), for: .touchUpInside)
        
        cell.eventImageView.contentMode = .scaleAspectFill
        
        cell.eventImageView.sd_setShowActivityIndicatorView(true)
        
        cell.eventImageView.sd_setIndicatorStyle(.white)
        
        cell.eventImageView.sd_setImage(with: URL(string: dates[indexPath.row].imageURL), completed: nil)
        
        return cell
    }
    
    func checkCompletedEvent(sender: UIButton) {
        
        let imageUrl = dates[sender.tag].imageURL
        let year = dates[sender.tag].year
        let month = dates[sender.tag].month
        let day = dates[sender.tag].day
        let title = dates[sender.tag].titleName
        
        uploadToHistoryList(imageUrl, year, month, day, title)
        
        let key = dates[sender.tag].titleKey
        removeFromFirebase(key)
    }
    
    func uploadToHistoryList(_ imageURL: String, _ year: String, _ month: String, _ day: String, _ eventText: String) {
        
        let uid = Auth.auth().currentUser?.uid
        
        let ref = Database.database().reference().child("historyList").child(uid!).childByAutoId()
        
        let values = ["year": year, "month": month, "day": day, "titleName": eventText, "imageUrl": imageURL]
                    
        ref.updateChildValues(values)
    }

    func removeFromFirebase(_ key: String) {
        
        let uid = Auth.auth().currentUser!.uid
        
        let ref = Database.database().reference().child("title").child(uid)
        
        ref.child(key).removeValue()
        
        self.dates = []
        
        self.addImageView.isHidden = false
        
        self.collectionView.reloadData()
    }
    
    func dealWithCollectionViewCell(sender: UIButton) {
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        alert.darkAlert(alert)
        
        let editAction = UIAlertAction(title: "Edit", style: UIAlertActionStyle.default, handler: { (_ : UIAlertAction) -> Void in
            
            let editEventViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "editEvent") as! EditEventViewController
            
            editEventViewController.yearString = self.dates[sender.tag].year
            editEventViewController.monthString = self.dates[sender.tag].month
            editEventViewController.dayString = self.dates[sender.tag].day
            editEventViewController.eventText = self.dates[sender.tag].titleName
            editEventViewController.eventKey = self.dates[sender.tag].titleKey
            editEventViewController.imageURL = self.dates[sender.tag].imageURL
            
            self.present(editEventViewController, animated: true, completion: nil)
            
            alert.dismiss(animated: true, completion: nil)
        })
        
        let deleteAction = UIAlertAction(title: "Delete", style: UIAlertActionStyle.destructive, handler: { (_ : UIAlertAction) -> Void in
            
            let deleteAlert = UIAlertController(title: "Sure？", message: nil, preferredStyle: .actionSheet)
            
            deleteAlert.darkAlert(deleteAlert)
            
            let deleteSureAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.destructive, handler: { (_ : UIAlertAction) -> Void in
                
                //delete
                let uid = Auth.auth().currentUser!.uid
                
                let ref = Database.database().reference().child("title").child(uid)
                
                ref.child(self.dates[sender.tag].titleKey).removeValue()
                
                self.dates = []
                
                self.addImageView.isHidden = false
                
                self.collectionView.reloadData()
                
                deleteAlert.dismiss(animated: true, completion: nil)
            })
            
            let deleteCancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: { (_ : UIAlertAction) -> Void in
                
                deleteAlert.dismiss(animated: true, completion: nil)
            })
            
            deleteAlert.addAction(deleteSureAction)
            deleteAlert.addAction(deleteCancelAction)
            
            deleteAlert.popoverPresentationController?.sourceView = self.view
            deleteAlert.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection()
            deleteAlert.popoverPresentationController?.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            
            self.present(deleteAlert, animated: true, completion: nil)
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: { (_ : UIAlertAction) -> Void in
            
            alert.dismiss(animated: true, completion: nil)
        })
        
        alert.addAction(editAction)
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        
        alert.popoverPresentationController?.sourceView = self.view
        alert.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection()
        alert.popoverPresentationController?.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
        
        self.present(alert, animated: true, completion: nil)
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
        
        let today = NSDate()
        
        todayInt = Int(today.timeIntervalSinceReferenceDate)
        
        self.dates = data
        
        guard let datesMin = dates.min() else { return }
        let delegate = UIApplication.shared.delegate as? AppDelegate
        delegate?.prepareNotification(datesMin, todayInt!)
        
        collectionView.reloadData()
    }
    
    func manager(didGet data: [FavoritePlace]) {
        return
    }
    
    func manager(didGet data: User?) {
        return
    }
    
    func manager(didGet data: [HistoryEvent]) {
        return
    }
}

extension MainViewController: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        print("Tapped in notification")
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        print("Notification being triggered")

        if notification.request.identifier == "reminder" {
            
            completionHandler( [.alert,.sound,.badge])
            
        }
    }
}

