//
//  DateHelper.swift
//  YGAM
//
//  Created by Jon Fulton on 01/10/2018.
//  Copyright © 2018 Sky Betting and Gaming. All rights reserved.
//

import Foundation

extension Date {
    func save(as key: String, stripTime: Bool = false) {
        UserDefaults.standard.set(self.stripTime(), forKey: key)
    }
    
    func stripTime() -> Date {
        let components = Calendar.current.dateComponents([.year, .month, .day], from: self)
        let date = Calendar.current.date(from: components)
        return date!
    }
    
    func daysPastSinceTaskStartDate() -> Int {
        guard let startDate = UserDefaults.standard.value(forKey: EntryLogicConstants.taskStartDate) as? Date,
              let daysPast = Calendar.current.dateComponents([.day], from: startDate, to: self).day else {
            return 0
        }
        return daysPast
    }
}
