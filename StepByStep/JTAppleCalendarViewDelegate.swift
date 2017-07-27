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
        
        return cell
        
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        
        handleCellSelected(view: cell, cellState: cellState)
        
        handleCelltextColor(view: cell, cellState: cellState)
        
        handleCellEvents(view: cell, cellState: cellState)

        //print(date)
        
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        
        handleCellSelected(view: cell, cellState: cellState)
        
        handleCelltextColor(view: cell, cellState: cellState)
        
        handleCellEvents(view: cell, cellState: cellState)

    }
    
    
    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        
        setupViewOfCalendar(from: visibleDates)
        
    }
    
}
