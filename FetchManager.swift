//
//  fetchManager.swift
//  StepByStep
//
//  Created by Francis Tseng on 2017/7/31.
//  Copyright © 2017年 Francis Tseng. All rights reserved.
//

import Foundation
import Firebase
import NVActivityIndicatorView

struct EndDate {

    var year: String

    var month: String

    var day: String

    var imageURL: String

    var titleName: String

    var titleKey: String

    var second: Int {

        let formatter = DateFormatter()

        formatter.dateFormat = "yyyy MM dd"

        let second = formatter.date(from: "\(year) \(month) \(day)")

        let targetDayNS = second! as NSDate

        return  Int(targetDayNS.timeIntervalSinceReferenceDate)
    }
}

extension EndDate: Comparable {
    static func < (lhs: EndDate, rhs: EndDate) -> Bool {
        return lhs.second < rhs.second
    }
    static func <= (lhs: EndDate, rhs: EndDate) -> Bool {
        return lhs.second <= rhs.second
    }
    static func > (lhs: EndDate, rhs: EndDate) -> Bool {
        return lhs.second > rhs.second
    }
    static func >= (lhs: EndDate, rhs: EndDate) -> Bool {
        return lhs.second >= rhs.second
    }
    static func == (lhs: EndDate, rhs: EndDate) -> Bool {
        return lhs.second == rhs.second
    }
}

struct FavoritePlace {

    var placeName: String

    var placeAddress: String

    var placeImageURL: String

    var placeKey: String
}

struct User {

    var email: String

    var firstName: String

    var lastName: String

    var imageUrl: String?
}

struct HistoryEvent {

    var titleName: String

    var year: String

    var month: String

    var day: String

    var imageUrl: String

    var key: String
}

protocol FetchManagerDelegate: class {

    func manager(didGet data: [EndDate])

    func manager(didGet data: [FavoritePlace])

    func manager(didGet data: User?)

    func manager(didGet data: [HistoryEvent])
}

class FetchManager {

    weak var delegate: FetchManagerDelegate?

    let ref = Database.database().reference()

    let uid = Auth.auth().currentUser!.uid

    let activityData = ActivityData()

    func requestData() {

        NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData)
        NVActivityIndicatorPresenter.sharedInstance.setMessage("Loading...")

        ref.child("title").child(uid).observeSingleEvent(of: DataEventType.value, with: { (snapshot) in

            if snapshot.exists() == false {

                NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
            }
        })

        ref.child("title").child(uid).observe(DataEventType.value, with: { [weak self] (snapshot) in
            print(snapshot.value!)

            var dataInFM = [EndDate]()

            for item in snapshot.children {

                guard let itemSnapshot = item as? DataSnapshot else { return }

                guard let dictionary = itemSnapshot.value as? [String: String] else { return }

                if let year = dictionary["year"],
                    let month = dictionary["month"],
                    let day = dictionary["day"],
                    let titleName = dictionary["titleName"],
                    let imageURL = dictionary["image"] {

                    dataInFM.append(EndDate(year: year, month: month, day: day, imageURL: imageURL, titleName: titleName, titleKey: itemSnapshot.key))

                    self?.delegate?.manager(didGet: dataInFM)

                    NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
                }
            }

        })
    }

    func requestPlace() {

        NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData)
        NVActivityIndicatorPresenter.sharedInstance.setMessage("Loading...")

        ref.child("favorite").child(uid).observeSingleEvent(of: DataEventType.value, with: { (snapshot) in

            if snapshot.exists() == false {

                NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
            }
        })

        ref.child("favorite").child(uid).observe(DataEventType.value, with: { [weak self] (snapshot) in

            var placeInFM = [FavoritePlace]()

            if snapshot.childrenCount == 0 {
                placeInFM = []
                DispatchQueue.main.async {
                    self?.delegate?.manager(didGet: placeInFM)
                }

            } else {

                for item in snapshot.children {

                guard let itemSnapshot = item as? DataSnapshot else { return }

                guard let dictionary = itemSnapshot.value as? [String: String] else { return }

                if let name = dictionary["name"],
                    let address = dictionary["address"],
                    let imageURL = dictionary["image"] {

                    placeInFM.append(FavoritePlace(placeName: name, placeAddress: address, placeImageURL: imageURL, placeKey: itemSnapshot.key))

                    DispatchQueue.main.async {
                        self?.delegate?.manager(didGet: placeInFM)
                    }

                    NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
                    }
                }
            }
        })
    }

    func requestUser() {

        NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData)

        ref.child("users").child(uid).observe(DataEventType.value, with: { [weak self] (snapshot) in

            var user: User!

            print(self?.uid ?? "No UID")
            guard let dictionary = snapshot.value as? [String: String] else { return }
            if dictionary.has(key: "image") == false {

                if let email = dictionary["email"],
                    let firstName = dictionary["firstName"],
                    let lastName = dictionary["lastName"] {

                    user = User(email: email, firstName: firstName, lastName: lastName, imageUrl: nil)

                    DispatchQueue.main.async {
                        self?.delegate?.manager(didGet: user)
                    }

                    NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
                }

            } else {

                if let email = dictionary["email"],
                    let firstName = dictionary["firstName"],
                    let lastName = dictionary["lastName"],
                    let imageUrl = dictionary["image"] {

                    user = User(email: email,
                                firstName: firstName,
                                lastName: lastName,
                                imageUrl: imageUrl)

                    DispatchQueue.main.async {
                        self?.delegate?.manager(didGet: user)
                    }

                    NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
                }
            }

        })
    }

    func requestHistoryEvent() {

        NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData)
        NVActivityIndicatorPresenter.sharedInstance.setMessage("Loading...")

        ref.child("historyList").child(uid).observeSingleEvent(of: DataEventType.value, with: { (snapshot) in

            if snapshot.exists() == false {

                NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
            }
        })

        ref.child("historyList").child(uid).observe(DataEventType.value, with: { [weak self] (snapshot) in

            var dataInFM = [HistoryEvent]()

            for item in snapshot.children {

                guard let itemSnapshot = item as? DataSnapshot else { return }

                guard let dictionary = itemSnapshot.value as? [String: String] else { return }

                if let year = dictionary["year"],
                    let month = dictionary["month"],
                    let day = dictionary["day"],
                    let titleName = dictionary["titleName"],
                    let imageURL = dictionary["imageUrl"] {

                    dataInFM.append(HistoryEvent(titleName: titleName,
                                                 year: year,
                                                 month: month,
                                                 day: day,
                                                 imageUrl: imageURL,
                                                 key: itemSnapshot.key))

                    self?.delegate?.manager(didGet: dataInFM)

                    NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
                }
            }
        })
    }
}
