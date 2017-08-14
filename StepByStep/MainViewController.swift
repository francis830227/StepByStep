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
        
    var todayInt: Int?
    
    @IBOutlet weak var addLabel: UILabel!
    
    @IBOutlet weak var todayTime: UILabel!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var countLabel: UILabel!
    
    @IBOutlet weak var addButton: UIButton!
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        collectionView.reloadData()
    }
        
    func prepareNotification(_ dateMin: EndDate, _ todayInt: Int) {
        
        let minute = dateMin.minute
        
        let minus = Int((minute - todayInt) / 86400)
        
        let content = UNMutableNotificationContent()
        
        if minus > 1 {
            
            content.title = "\(dateMin.titleName)再\(minus)天就到了～"
            content.body = "點進來看還有什麼沒完成的吧！"
            content.sound = UNNotificationSound.default()
        } else {
            
            content.title = "\(dateMin.titleName)今天到期！"
            content.body = ""
            content.sound = UNNotificationSound.default()
        }
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 86400, repeats: true)

        let request = UNNotificationRequest(identifier: "reminder", content: content, trigger: trigger)
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().add(request){(error) in
            
            if (error != nil) {
                
                print(error?.localizedDescription ?? "")
            }
        }
    
    }
    
    @IBAction func addButtonPressed(_ sender: UIButton) {
        
        sender.bounce()

        let navigationVC = self.storyboard?.instantiateViewController(withIdentifier: "addNVC")
        
        self.present(navigationVC!, animated: true, completion: nil)
    }

    
    @IBAction func logout(_ sender: Any) {
        let alert = UIAlertController(title: "確定登出？", message: "", preferredStyle: UIAlertControllerStyle.actionSheet)
        
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

                cell.countDownLabel.text = "\(Int((todayInt! - targetDayInt) / 86400))天前"
                
            } else if minus == 0 {
                
                cell.countDownLabel.text = "今天"
                
            } else {

                cell.countDownLabel.text = "剩\(Int((targetDayInt - todayInt!) / 86400))天"

            }
            
            cell.finishDateLabel.text = "完成日：\(year)/\(month)/\(day)"
            
            cell.clipsToBounds = false
        }
        
        cell.eventLabel.text = dates[indexPath.row].titleName

        cell.deleteButton.tag = indexPath.row
        
        cell.deleteButton.addTarget(self, action: #selector(dealWithCollectionViewCell(sender:)), for: .touchUpInside)
        
        cell.eventImageView.contentMode = .scaleAspectFill
        
        cell.eventImageView.sd_setShowActivityIndicatorView(true)
        
        cell.eventImageView.sd_setIndicatorStyle(.white)
        
        cell.eventImageView.sd_setImage(with: URL(string: dates[indexPath.row].imageURL), completed: nil)
        
        return cell
    }
    
    func dealWithCollectionViewCell(sender: UIButton) {
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        alert.darkAlert(alert)
        
        let editAction = UIAlertAction(title: "修改卡片", style: UIAlertActionStyle.default, handler: { (_ : UIAlertAction) -> Void in
            
            let editEventViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "editEvent")
            
            self.present(editEventViewController, animated: true, completion: nil)
            
            alert.dismiss(animated: true, completion: nil)
            
        })
        
        let deleteAction = UIAlertAction(title: "刪除卡片", style: UIAlertActionStyle.destructive, handler: { (_ : UIAlertAction) -> Void in
            
            let deleteAlert = UIAlertController(title: "確定刪除？", message: nil, preferredStyle: .actionSheet)
            
            deleteAlert.darkAlert(deleteAlert)
            
            let deleteSureAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.destructive, handler: { (_ : UIAlertAction) -> Void in
                
                //delete
                let uid = Auth.auth().currentUser!.uid
                
                let ref = Database.database().reference().child("title").child(uid)
                
                ref.child(self.dates[sender.tag].titleKey).removeValue()
                print(sender.tag, self.dates[sender.tag].titleKey)
                
                self.dates = []
                
                self.addLabel.isHidden = false
                
                self.collectionView.reloadData()
                
                deleteAlert.dismiss(animated: true, completion: nil)
                
            })
            
            let deleteCancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: { (_ : UIAlertAction) -> Void in
                
                deleteAlert.dismiss(animated: true, completion: nil)
            })
            
            deleteAlert.addAction(deleteSureAction)
            
            deleteAlert.addAction(deleteCancelAction)
            
            self.present(deleteAlert, animated: true, completion: nil)
        })
        
        let cancelAction = UIAlertAction(title: "取消", style: UIAlertActionStyle.default, handler: { (_ : UIAlertAction) -> Void in
            
            alert.dismiss(animated: true, completion: nil)
        })
        
        alert.addAction(editAction)
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        
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
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        print("Notification being triggered")

        if notification.request.identifier == "reminder" {
            
            completionHandler( [.alert,.sound,.badge])
            
        }
    }
}

