//
//  JTAppleCalendarDelegate.swift
//  StepByStep
//
//  Created by Francis Tseng on 2017/7/28.
//  Copyright © 2017年 Francis Tseng. All rights reserved.
//

import Foundation
import JTAppleCalendar

extension EverydayEventViewController: JTAppleCalendarViewDelegate {
    
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "EventCalendarCell",
                                                       for: indexPath) as! EventCalendarCell
        
        cell.dateLabel.text = cellState.text
        
        handleCellSelected(view: cell, cellState: cellState)
        
        handleCelltextColor(view: cell, cellState: cellState)
            
        return cell
        
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        
        handleCellSelected(view: cell, cellState: cellState)
        
        handleCelltextColor(view: cell, cellState: cellState)
        
        guard let validCell = cell as? EventCalendarCell else { return }
        
        validCell.bounce()
        //print(date)
        
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        
        handleCellSelected(view: cell, cellState: cellState)
        
        handleCelltextColor(view: cell, cellState: cellState)
                
    }
    
    
    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        
        setupViewOfCalendar(from: visibleDates)
        
    }
    
}
