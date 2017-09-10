//
//  JTAppleCalendarViewDataSource.swift
//  StepByStep
//
//  Created by Francis Tseng on 2017/7/27.
//  Copyright © 2017年 Francis Tseng. All rights reserved.
//

import Foundation
import JTAppleCalendar

extension PickEndDateViewController: JTAppleCalendarViewDataSource {

    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {

        let formatter = DateFormatter()

        formatter.dateFormat = "yyyy MM dd"

        formatter.timeZone = Calendar.current.timeZone

        formatter.locale = Calendar.current.locale

        let startDate = formatter.date(from: "2010 01 01")!

        let endDate = formatter.date(from: "2018 12 31")!

        let parameters = ConfigurationParameters(startDate: startDate,
                                                 endDate: endDate,
                                                 generateInDates: .forAllMonths,
                                                 generateOutDates: .tillEndOfGrid,
                                                 hasStrictBoundaries: false)

        return parameters
    }

}
