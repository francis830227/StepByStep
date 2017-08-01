//
//  PickEndDateViewController.swift
//  StepByStep
//
//  Created by Francis Tseng on 2017/7/26.
//  Copyright © 2017年 Francis Tseng. All rights reserved.
//

import UIKit
import JTAppleCalendar
import IQKeyboardManagerSwift

protocol EndDateDelegate {
    
    func manager(_ data: [EndDate])
    
}

struct EndDate {
    
    var year: String
    
    var month: String
    
    var day: String
    
}

class PickEndDateViewController: UIViewController {
    
    let formatter = DateFormatter()
    
    let selectedMonthColor = UIColor.white
    
    let monthColor = UIColor.white
    
    let outsideMonthColor = UIColor.darkGray
    
    let todaysDate = Date()
    
    var delegate: EndDateDelegate?
    
    var yearForDelegate = ""
    
    var monthForDelegate = ""
    
    var day = ""
    
    @IBOutlet weak var eventTextField: UITextField!

    @IBOutlet weak var calendarView: JTAppleCalendarView!
    
    @IBOutlet weak var year: UILabel!
    
    @IBOutlet weak var month: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //抓假資料
        DispatchQueue.global().async {
            let serverObjects = self.getServerEvents()
            for (date, event) in serverObjects {
                let stringDate = self.formatter.string(from: date)
                self.eventsFromTheServer[stringDate] = event
            }
            
            DispatchQueue.main.async {
                self.calendarView.reloadData()
            }
        //抓完假資料
            
        }
        
        gradientNavi()
        
        setupCalendarView()
        
        
        
    }
    
    @IBAction func donePickEndButtonPressed(_ sender: Any) {
        
    }
    
    func requestData() {
        
        var dates = [EndDate]()
        
        dates.append( EndDate(year: yearForDelegate, month: monthForDelegate, day: day) )
        
        delegate?.manager(dates)
        
    }
    
    var eventsFromTheServer: [String : String] = [:]
    
    func setupCalendarView() {
        
        //Setup calendar spacing
        calendarView.minimumLineSpacing = 0
        
        calendarView.minimumInteritemSpacing = 0
        
        calendarView.layer.shadowColor = UIColor.black.cgColor
        
        calendarView.layer.shadowOffset = CGSize(width: 0, height: 1.0)
        
        calendarView.layer.masksToBounds = false
        
        calendarView.layer.shadowOpacity = 1
        
        calendarView.layer.shadowRadius = 2
        
        calendarView.scrollToDate(Date())
        
        calendarView.selectDates([ Date() ])
        
        //Setup labels
        calendarView.visibleDates { (visibleDates) in
            
            self.setupViewOfCalendar(from: visibleDates)
            
        }
        
    }

    func handleCelltextColor(view: JTAppleCell?, cellState: CellState) {
        
        guard let validCell = view as? CalendarCell else { return }
        
        formatter.dateFormat = "yyyy MM dd"
        
        let todaysDateString = formatter.string(from: todaysDate)
        
        let monthDateString = formatter.string(from: cellState.date)
        
        if todaysDateString == monthDateString {
            
            validCell.dateLabel.textColor = UIColor(red: 2/255.0, green: 158/255.0, blue: 183/255.0, alpha: 1)
            
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
    
    func handleCellEvents(view: JTAppleCell?, cellState: CellState) {
        
        guard let validCell = view as? CalendarCell else { return }
        
        validCell.eventDotView.isHidden = !eventsFromTheServer.contains { $0.key == formatter.string(from: cellState.date)}
                
    }
    
    func handleCellSelected(view: JTAppleCell?, cellState: CellState) {
        
        guard let validCell = view as? CalendarCell else { return }
        
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
        
        yearForDelegate = self.year.text ?? ""
        
        self.formatter.dateFormat = "MMMM"
        
        self.month.text = self.formatter.string(from: date)
        
        monthForDelegate = self.month.text ?? ""
        
        self.formatter.dateFormat = "dddd"
        
        self.day = self.formatter.string(from: date)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
        
    }
    
}

extension PickEndDateViewController {
    
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




