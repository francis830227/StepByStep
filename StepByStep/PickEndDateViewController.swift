//
//  PickEndDateViewController.swift
//  StepByStep
//
//  Created by Francis Tseng on 2017/7/26.
//  Copyright © 2017年 Francis Tseng. All rights reserved.
//

import UIKit
import JTAppleCalendar

class PickEndDateViewController: UIViewController {
    
    let formatter = DateFormatter()
    
    let selectedMonthColor = UIColor.darkGray
    
    let monthColor = UIColor.white
    
    let outsideMonthColor = UIColor.green

    @IBOutlet weak var calendarView: JTAppleCalendarView!
    
    @IBOutlet weak var year: UILabel!
    
    @IBOutlet weak var month: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupCalendarView()
        
    }
    
    func setupCalendarView() {
        
        //Setup calendar spacing
        calendarView.minimumLineSpacing = 0
        
        calendarView.minimumInteritemSpacing = 0
        
        //Setup labels
        calendarView.visibleDates { (visibleDates) in
            
            self.setupViewOfCalendar(from: visibleDates)
            
        }
    }

    func handleCelltextColor(view: JTAppleCell?, cellState: CellState) {
        
        guard let validCell = view as? CalendarCell else { return }

        if cellState.isSelected {
            
            validCell.selectedView.layer.backgroundColor = selectedMonthColor.cgColor
            
            validCell.dateLabel.textColor = selectedMonthColor
        
        } else {
            
            if cellState.dateBelongsTo == .thisMonth {
                
                validCell.dateLabel.textColor = monthColor
                
            } else {
                
                validCell.dateLabel.textColor = outsideMonthColor
            }
        }
        
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
        
        self.formatter.dateFormat = "MMMM"
        
        self.month.text = self.formatter.string(from: date)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
        
    }
    
}

extension PickEndDateViewController: JTAppleCalendarViewDataSource {
    
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        
        let formatter = DateFormatter()
        
        formatter.dateFormat = "yyyy MM dd"
        
        formatter.timeZone = Calendar.current.timeZone
        
        formatter.locale = Calendar.current.locale
        
        let startDate = formatter.date(from: "2017 01 01")!
        
        let endDate = formatter.date(from: "2030 12 31")!
        
        let parameters = ConfigurationParameters(startDate: startDate,
                                                 endDate: endDate,
                                                 generateInDates: .forAllMonths,
                                                 generateOutDates: .tillEndOfGrid,
                                                 hasStrictBoundaries: false)
        
        return parameters
        
    }
    
}

extension PickEndDateViewController: JTAppleCalendarViewDelegate {
    
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "CalendarCell",
                                                       for: indexPath) as! CalendarCell
        
        cell.dateLabel.text = cellState.text
        
        handleCellSelected(view: cell, cellState: cellState)
        
        handleCelltextColor(view: cell, cellState: cellState)
        
        return cell
        
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        
        handleCellSelected(view: cell, cellState: cellState)
        
        handleCelltextColor(view: cell, cellState: cellState)
        
        print(date)
        
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        
        handleCellSelected(view: cell, cellState: cellState)
        
        handleCelltextColor(view: cell, cellState: cellState)
        
    }
    

    
    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
    
        setupViewOfCalendar(from: visibleDates)
        
    }
    
}
