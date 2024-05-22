//
//  Calender+Extention.swift
//  FarmHarvestNew
//
//  Created by Freeythm on 2024/05/24.
//

import SwiftUI

extension Calendar {
    
    func sameMonth(_ date1: Date, inSameMonthAs date2: Date) -> Bool {
        return isDate(date1, equalTo: date2, toGranularity: .month)
    }
    
    
}

func dateInput() -> Date {
    var calendar = Calendar(identifier: .gregorian)
    calendar.timeZone = TimeZone(identifier: "Asia/Tokyo") ?? TimeZone.gmt
     
    var read: Date = Date()
    if let date = calendar.date(from: DateComponents(year: 2024, month: 5, day: 12, hour: 11, minute: 0,second: 0)) {
        read = date
    }
    
    return read
}
