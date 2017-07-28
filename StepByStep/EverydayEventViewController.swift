//
//  EverydayEventViewController.swift
//  StepByStep
//
//  Created by Francis Tseng on 2017/7/28.
//  Copyright © 2017年 Francis Tseng. All rights reserved.
//

import UIKit
import JTAppleCalendar
import IQKeyboardManagerSwift

class EverydayEventViewController: UIViewController {

    let formatter = DateFormatter()
    
    let selectedMonthColor = UIColor.darkGray
    
    let monthColor = UIColor.white
    
    let outsideMonthColor = UIColor.green
    
    let todaysDate = Date()
    
    @IBOutlet weak var eventCalendarView: JTAppleCalendarView!

    @IBOutlet weak var month: UILabel!
    
    @IBOutlet weak var year: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupCalendarView()
        
        eventCalendarView.scrollToDate(Date())
        
        eventCalendarView.selectDates([ Date() ])
    
    }

    var eventsFromTheServer: [String : String] = [:]
    
    func setupCalendarView() {
        
        //Setup calendar spacing
        eventCalendarView.minimumLineSpacing = 0
        
        eventCalendarView.minimumInteritemSpacing = 0
        
        //Setup labels
        eventCalendarView.visibleDates { (visibleDates) in
            
            self.setupViewOfCalendar(from: visibleDates)
            
        }
        
    }
    
    func handleCelltextColor(view: JTAppleCell?, cellState: CellState) {
        
        guard let validCell = view as? EventCalendarCell else { return }
        
        formatter.dateFormat = "yyyy MM dd"
        
        let todaysDateString = formatter.string(from: todaysDate)
        
        let monthDateString = formatter.string(from: cellState.date)
        
        if todaysDateString == monthDateString {
            
            validCell.dateLabel.textColor = .blue
            
        } else {
            
            if cellState.isSelected {
                
                validCell.dateLabel.textColor = selectedMonthColor
                
            } else {
                
                if cellState.dateBelongsTo == .thisMonth {
                    
                    validCell.dateLabel.textColor = monthColor
                    
                } else {
                    
                    validCell.dateLabel.textColor = outsideMonthColor
                    
                }
                
            }
            
        }
        
    }
    
    func handleCellSelected(view: JTAppleCell?, cellState: CellState) {
        
        guard let validCell = view as? EventCalendarCell else { return }
        
        if validCell.isSelected {
            
            validCell.selectedView.isHidden = false
            
        } else {
            
            validCell.selectedView.isHidden = true
            
        }
        
    }
    
    func setupViewOfCalendar(from visibleDates: DateSegmentInfo) {
        
        let date = visibleDates.monthDates.first!.date
        
        self.formatter.dateFormat = "yyyy"
        
        self.year.text = self.formatter.string(from: date)
        
        self.formatter.dateFormat = "MMMM"
        
        self.month.text = self.formatter.string(from: date)
        
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

extension EverydayEventViewController {
    
    func getServerEvents() -> [Date : String] {
        
        formatter.dateFormat = "yyyy MM dd"
        
        return [
            
            formatter.date(from: "2017 07 26")!: "1",
            formatter.date(from: "2017 07 19")!: "1",
            formatter.date(from: "2017 07 22")!: "1",
            formatter.date(from: "2017 07 29")!: "1",
            formatter.date(from: "2017 07 27")!: "1",
            formatter.date(from: "2017 07 15")!: "1"
            
        ]
        
    }
    
}

