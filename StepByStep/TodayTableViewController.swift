//
//  TodayTableViewController.swift
//  
//
//  Created by Francis Tseng on 2017/8/12.
//
//

import UIKit

class TodayTableViewController: UITableViewController {

    enum Component {
        
        case monday, tuesday, wednesday, thursday, friday, saturday, sunday
    
    }
    
    var components: [Component] = [ .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday ]
    
    var everyDayList = EveryDayListType()
    
    let fetchManager = FetchTodayListManager()
    
    var monLists: [EveryDayList]?
    
    var tuesLists: [EveryDayList]?

    var wedLists: [EveryDayList]?

    var thurLists: [EveryDayList]?

    var friLists: [EveryDayList]?

    var satLists: [EveryDayList]?

    var sonLists: [EveryDayList]?

    override func viewDidLoad() {
        super.viewDidLoad()

        fetchManager.delegate = self
        
        fetchManager.requestData()
        
        //guard let mondayList = everyDayList["2"] else { return }
        
//        for monday in mondayList {
//            monLists?.append(EveryDayList(endDate: monday["endDate"], titleName: monday["titleName"])
//        }
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return components.count
        
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        let component = components[section]
        
        switch component {
            
        case .monday:
            
            return "Monday"
            
        case .tuesday:
            
            return "Tuesday"
            
        case .wednesday:
            
            return "Wednesday"
            
        case .thursday:
            
            return "Thursday"
            
        case .friday:
            
            return "Friday"
            
        case .saturday:
            
            return "Saturday"
            
        case .sunday:
            
            return "Sunday"
            
        }
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let component = components[section]
        
        switch component {
            
        case .monday:
            
            let mondayList = everyDayList["2"]
            
            if mondayList?.isEmpty == true {
                return 0
            }
            
            return (mondayList?.count)!
            
        case .tuesday:
            
            let tuesdayList = everyDayList["3"]
            
            if tuesdayList?.isEmpty == true {
                return 0
            }
            
            return (tuesdayList?.count)!
            
        case .wednesday:
            
            let wednesdayList = everyDayList["4"]
            
            if wednesdayList?.isEmpty == true {
                return 0
            }
            
            return (wednesdayList?.count)!
            
        case .thursday:
            
            let thursdayList = everyDayList["5"]

            if thursdayList?.isEmpty == true {
                return 0
            }
            
            return (thursdayList?.count)!
            
        case .friday:
            
            let fridayList = everyDayList["6"]

            if fridayList?.isEmpty == true {
                return 0
            }
            
            return (fridayList?.count)!
            
        case .saturday:
            
            let saturdayList = everyDayList["7"]

            if saturdayList?.isEmpty == true {
                return 0
            }
            
            return (saturdayList?.count)!
            
        case .sunday:
            
            let sundayList = everyDayList["1"]

            if sundayList?.isEmpty == true {
                return 0
            }
            
            return (sundayList?.count)!
        }
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 44.0
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let component = components[indexPath.section]
        
        switch component {
            
        case .monday:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "mondayCell", for: indexPath)
            
            
            
            
            return cell
            
        case .tuesday:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "tuesdayCell", for: indexPath)
            
            
            
            
            return cell
            
        case .wednesday:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "wednesdayCell", for: indexPath)
            
            //            cell.contentView.addSubview(massiveViewController.view)
            
            return cell
            
        case .thursday:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "thursdayCell", for: indexPath)
            
            //            cell.contentView.addSubview(massiveViewController.view)
            
            return cell
            
        case .friday:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "fridayCell", for: indexPath)
            
            //            cell.contentView.addSubview(massiveViewController.view)
            
            return cell
            
        case .saturday:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "saturdayCell", for: indexPath)
            
            //            cell.contentView.addSubview(massiveViewController.view)
            
            return cell
            
        case .sunday:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "sundayCell", for: indexPath)
            
            //            cell.contentView.addSubview(massiveViewController.view)
            
            return cell
            
        }
        
        
    }

}
extension TodayTableViewController: FetchTodayListManagerDelegate {
    
    func manager(didGet data: EveryDayListType) {
        everyDayList = data
    }
    
}
