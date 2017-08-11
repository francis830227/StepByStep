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

class MainViewController: UIViewController {
    
    let animator = LinearCardAttributesAnimator()
    
    let fetchManager = FetchManager()
    
    let formatter = DateFormatter()
    
    var dates = [EndDate]()
    
//    var datesMin: EndDate?
    
    var todayInt: Int?
    
    @IBOutlet weak var addLabel: UILabel!
    
    @IBOutlet weak var todayTime: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        fetchManager.delegate = self
        
        fetchManager.requestData()
        
        let todayDate = Date()
        
        formatter.dateFormat = "yyyy MM dd"
        
        let date = formatter.string(from: todayDate)
        
        todayTime.text = date
        
        collectionViewLayout(collectionView: collectionView, animator: animator)
        
        let delegate = UIApplication.shared.delegate as? AppDelegate
        delegate?.scheduleNotification(at: todayDate)
        
    }
    

        
    func prepareNotification(_ dateMin: EndDate, _ todayInt: Int) {
        
        let minute = dateMin.minute
        
        let minus = Int((minute - todayInt) / 86400)
        
        let content = UNMutableNotificationContent()
        
        if minus > 1 {
            
            content.title = "\(dateMin.titleName)再\(minus)天就到了！"
            content.body = "get your ass down!!"
            content.sound = UNNotificationSound.default()
            
        }
        
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)

        let request = UNNotificationRequest(identifier: "reminder", content: content, trigger: trigger)
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().add(request){(error) in
            
            if (error != nil) {
                
                print(error?.localizedDescription ?? "")
            }
        }
    
    }
    
    

    @IBAction func todayListButtonPressed(_ sender: Any) {
        
        
        
    }
    
    @IBAction func logout(_ sender: Any) {
        let alert = UIAlertController(title: "確定登出？？", message: "", preferredStyle: UIAlertControllerStyle.actionSheet)
        
        let sureAction = UIAlertAction(title: "Sure", style: UIAlertActionStyle.default, handler: { (_: UIAlertAction) -> Void in
            
            try! Auth.auth().signOut()
            
            let defaults = UserDefaults.standard
            
            defaults.removeObject(forKey: "uid")
            
            let appDelegate = UIApplication.shared.delegate as? AppDelegate
            
            let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
            
            let homeController =  mainStoryboard.instantiateViewController(withIdentifier: "loginVC") as? LoginViewController
            
            appDelegate?.window?.rootViewController = homeController
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: { (_ : UIAlertAction) -> Void in
            
            alert.dismiss(animated: true, completion: nil)
        
        })
        
        alert.addAction(sureAction)
        
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: nil)
    }
}

func collectionViewLayout(collectionView: UICollectionView, animator: LinearCardAttributesAnimator) {
    
    collectionView.isPagingEnabled = true
    
    if let layout = collectionView.collectionViewLayout as? AnimatedCollectionViewLayout {
        
        layout.scrollDirection = .horizontal
        
        layout.animator = animator
        
    }
    
}

extension MainViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if dates.count > 0 {
        
            addLabel.isHidden = true
        
        }
        
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
            
            let formatter = DateFormatter()
            
            let today = NSDate()
            
            formatter.dateFormat = "yyyy MM dd"
            
            let targetDay = "\(dates[indexPath.row].year) \(dates[indexPath.row].month) \(dates[indexPath.row].day)"

            let date = formatter.date(from: targetDay)
            
            let targetDayNS = date! as NSDate
            
            let targetDayInt = Int(targetDayNS.timeIntervalSinceReferenceDate)
            
            todayInt = Int(today.timeIntervalSinceReferenceDate)
            
            print(targetDayInt, todayInt!)
            
            let minus = Int((targetDayInt - todayInt!) / 86400)
            
            if minus < 0 {

                cell.countDownLabel.text = "\(Int(today.timeIntervalSinceReferenceDate - targetDayNS.timeIntervalSinceReferenceDate)/86400)天前"
                
            } else if minus == 0 {
                
                cell.countDownLabel.text = "今天"
                
            } else {

                cell.countDownLabel.text = "剩\(Int(targetDayNS.timeIntervalSinceReferenceDate - today.timeIntervalSinceReferenceDate)/86400)天"

            }
            
            cell.finishDateLabel.text = "完成日：\(year)/\(month)/\(day)"
            
            cell.totalGoingLabel.text = "\(arc4random_uniform(99))%"
            
            cell.todayGoingLabel.text = "總進度\(arc4random_uniform(99))%"
            
            cell.clipsToBounds = false
        }
        
        cell.eventLabel.text = dates[indexPath.row].titleName
        
        return cell
    }
    
    //func calculateTargetDayInt()
    
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
        print(self.dates)
        
//        self.datesMin = dates.min()
        guard let datesMin = dates.min() else { return }
        prepareNotification(datesMin, todayInt!)
        
        collectionView.reloadData()
    }
    
    func manager(didGet data: [FavoritePlace]) {
        return
    }
    
}

extension MainViewController: UNUserNotificationCenterDelegate {
    
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        print("Tapped in notification")
    }
    
    //This is key callback to present notification while the app is in foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        print("Notification being triggered")
        //You can either present alert ,sound or increase badge while the app is in foreground too with ios 10
        //to distinguish between notifications
        if notification.request.identifier == "reminder" {
            
            completionHandler( [.alert,.sound,.badge])
            
        }
    }
}

