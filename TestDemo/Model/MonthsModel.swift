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
        ViewMonth(date: Date.from(year: 2023, month: 1, day: 2), views: 4500),
        ViewMonth(date: Date.from(year: 2023, month: 2, day: 3), views: 5550),
        ViewMonth(date: Date.from(year: 2023, month: 3, day: 4), views: 20599),
        ViewMonth(date: Date.from(year: 2023, month: 4, day: 5), views: 7655),
        ViewMonth(date: Date.from(year: 2023, month: 5, day: 6), views: 15846),
        ViewMonth(date: Date.from(year: 2023, month: 6, day: 9), views: 890),
        ViewMonth(date: Date.from(year: 2023, month: 7, day: 4), views: 7556),
        ViewMonth(date: Date.from(year: 2023, month: 8, day: 5), views: 4422),
        ViewMonth(date: Date.from(year: 2023, month: 9, day: 9), views: 5645),
        ViewMonth(date: Date.from(year: 2023, month: 10, day: 6 ), views: 8976),
        ViewMonth(date: Date.from(year: 2023, month: 11, day: 7), views: 1234),
        ViewMonth(date: Date.from(year: 2023, month: 12, day: 1), views: 12643)
    ]
    
}
