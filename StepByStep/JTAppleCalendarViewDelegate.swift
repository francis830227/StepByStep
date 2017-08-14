//
//  JTAppleCalendarViewDelegate.swift
//  StepByStep
//
//  Created by Francis Tseng on 2017/7/27.
//  Copyright © 2017年 Francis Tseng. All rights reserved.
//

import Foundation
import JTAppleCalendar

extension PickEndDateViewController: JTAppleCalendarViewDelegate {
    
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "CalendarCell",
                                                       for: indexPath) as! CalendarCell
        
        cell.dateLabel.text = cellState.text
        
        handleCellSelected(view: cell, cellState: cellState)
        
        handleCelltextColor(view: cell, cellState: cellState)
        
        handleCellEvents(view: cell, cellState: cellState)
        
        handleCellVisibility(view: cell, cellState: cellState)
        
        return cell
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        
        handleCellSelected(view: cell, cellState: cellState)
        
        handleCelltextColor(view: cell, cellState: cellState)
        
        handleCellEvents(view: cell, cellState: cellState)
        
        handleCellVisibility(view: cell, cellState: cellState)
        
        guard let validCell = cell as? CalendarCell else { return }
        
        validCell.selectedViewLayout()
        
        formatter.dateFormat = "yyyy"
        
        yearString = self.formatter.string(from: date)
        
        formatter.dateFormat = "MM"
        
        monthString = self.formatter.string(from: date)
        
        formatter.dateFormat = "dd"
        
        dayString = self.formatter.string(from: date)
        
        print(yearString, monthString, dayString)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        
        handleCellSelected(view: cell, cellState: cellState)
        
        handleCelltextColor(view: cell, cellState: cellState)
        
        handleCellEvents(view: cell, cellState: cellState)
        
        handleCellVisibility(view: cell, cellState: cellState)
    }
    
    
    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        
        setupViewOfCalendar(from: visibleDates)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, headerViewForDateRange range: (start: Date, end: Date), at indexPath: IndexPath) -> JTAppleCollectionReusableView {
        
        let header = calendar.dequeueReusableJTAppleSupplementaryView(withReuseIdentifier: "header", for: indexPath) as! CalendarHeaderCollectionReusableView
        
        return header
    }
    
    func calendarSizeForMonths(_ calendar: JTAppleCalendarView?) -> MonthSize? {

        return MonthSize(defaultSize: 50)
    }
}

