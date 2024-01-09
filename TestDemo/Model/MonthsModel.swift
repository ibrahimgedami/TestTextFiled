//
//  MonthsModel.swift
//  TestDemo
//
//  Created by Ibrahim Gedami on 28/12/2023.
//

import Foundation

struct ViewMonth: Identifiable {
    
    let id = UUID()
    let date: Date?
    let views: Int?
    
}

extension Date {
    
    static func from(year: Int, month: Int, day: Int) -> Date? {
        let component = DateComponents(year: year, month: month, day: day)
        return Calendar.current.date(from: component)
    }
    
}

struct MockData {
    
    let viewMonths = [
        ViewMonth(date: Date.from(year: 2023, month: 12, day: 21), views: 526700),
        ViewMonth(date: Date.from(year: 2023, month: 12, day: 18), views: 14700),
        ViewMonth(date: Date.from(year: 2023, month: 12, day: 18), views: 1233),
        ViewMonth(date: Date.from(year: 2023, month: 12, day: 27), views: 41866),
        ViewMonth(date: Date.from(year: 2023, month: 12, day: 27), views: 55866),
        ViewMonth(date: Date.from(year: 2023, month: 12, day: 27), views: 8180),
        ViewMonth(date: Date.from(year: 2023, month: 12, day: 27), views: 75866),
        ViewMonth(date: Date.from(year: 2023, month: 12, day: 27), views: 85866),
        ViewMonth(date: Date.from(year: 2023, month: 12, day: 21), views: 4066),
        ViewMonth(date: Date.from(year: 2023, month: 12, day: 21), views: 4366),
        ViewMonth(date: Date.from(year: 2023, month: 12, day: 21), views: 637000)
    ]
    
}
