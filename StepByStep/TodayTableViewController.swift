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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
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
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 44.0
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let component = components[indexPath.section]
        
        switch component {
            
        case .monday:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "EmojiCell", for: indexPath)
            
            let emoji = emojis[indexPath.row]
            
            cell.textLabel?.text = emoji
            
            return cell
            
        case .tuesday:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "CharacterCell", for: indexPath)
            
            let character = charaters[indexPath.row]
            
            cell.textLabel?.text = character
            
            return cell
            
        case .massive:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "MassiveCell", for: indexPath)
            
            //            cell.contentView.addSubview(massiveViewController.view)
            
            return cell
            
        }
        
        
    }
}
