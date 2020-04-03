//
//  AppDelegate.swift
//  calendar
//
//  Created by thierryH24 on 12/10/2017.
//  Copyright © 2017 thierryH24. All rights reserved.
//

import Foundation
import Cocoa

extension THCalendarView: NSCollectionViewDelegateFlowLayout {
    
    public func collectionView(_ collectionView: NSCollectionView, layout collectionViewLayout: NSCollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> NSSize {
        
        if(showMonthPicker) {return NSMakeSize(collectionView.bounds.width, collectionView.bounds.height)}

        let width = collectionView.bounds.width
        var size = NSSize()
        
        switch Section(rawValue: indexPath.section)! {
        case .month:
            size =  NSMakeSize(width, 28)
        case .week:
            size = NSMakeSize(width / 7, 28)
        case .date:
            size = NSMakeSize(width / 7, 28 )
        }
        
        return size
    }
    
}
extension THCalendarView: NSCollectionViewDataSource {
    
    func numberOfSections(in: NSCollectionView) -> Int {
        return showMonthPicker ? 1: 3
    }
    
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if(showMonthPicker) {return 1}
        
        switch Section(rawValue: section)! {
        case .month:
            return 1
        case .week:
            return 7
        case .date:
            return 7 * 6
       
        }
    }
    
    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        
        var item: NSCollectionViewItem
        let calendar = Calendar.current

        if(showMonthPicker)
        {
            item = collectionView.makeItem(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "THPicker"), for: indexPath)
            if let item = item as? THPicker {
                item.configure(month: THCalendarView.Months[calendar.month(date) - 1], year: calendar.year(date))
                item.delegate = self
            }
            return item
        }
        
        
        switch Section(rawValue: indexPath.section)! {
        case .month:
            item = collectionView.makeItem(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "THMonthItem"), for: indexPath)
            
            if let item = item as? THMonthItem {
                item.configure(month: THCalendarView.Months[calendar.month(date) - 1], year: calendar.year(date))
            }
        case .week:
            item = collectionView.makeItem(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "THWeekItem"), for: indexPath)
            
            if let item = item as? THWeekItem {
                let beginWeek = 6
                let begin = 6 - beginWeek
                let formatter = DateFormatter()
                var index = indexPath.item + begin
                index  =  index >= 7 ? index - 7 : index
                
                let day = formatter.shortWeekdaySymbols[index]
                item.configure(week: day)
            }
        case .date:
            
            let (day, month, year, inMonth) = dayInMonthForItem(item: indexPath.item)
            item = collectionView.makeItem(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "THDateItem"), for: indexPath)
            
            if let item = item as? THDateItem {
                let beginWeek = 0
                item.configure(day: day, inCurrentMonth: inMonth)
                
                let index = indexPathForDate(selectedDate: selectedDate)
                let strMonth = THCalendarView.Months[calendar.month(date) - 1]
                let monthSelect = THCalendarView.Months[calendar.month(Date()) - 1]
                if indexPath.item == (index?.item)! + beginWeek && strMonth ==  monthSelect {
                    item.isToday = true
                } else
                {
                    item.isToday = false
                }
                
                // current date
                var dateComponents = DateComponents()
                dateComponents.year = year
                dateComponents.month = month
                dateComponents.day = day
                let dateItem = Calendar.current.date(from: dateComponents)
                item.dateItem = dateItem!
                
                item.isHidden = false
            }
        }
        return item

    }
    
    // MARK: - Private
    private func dayInMonthForItem(item: Int) -> (Int, Int, Int, Bool) {
        
        var day: Int = 0
        var month : Int = 0
        var year : Int = 0
        var inMonth = false
        
        let beginWeek = 6
        let calendar = Calendar.current

        let start = date.startOfMonth()
        var weekDay = calendar.component(.weekday, from: start) + beginWeek
        
        let numberOfDaysInMonthCurrent = calendar.numberOfDaysInMonthForDate(date)
        month = calendar.month(date)
        year = calendar.year(date)

        weekDay = weekDay >= 7 ? weekDay - 7 : weekDay

        // Previous month
        if item < weekDay
        {
            let datePrevious = calendar.prevStartOfMonthForDate(date)
            let numberOfDaysInMonthPrevious = calendar.numberOfDaysInMonthForDate(datePrevious)
            month = calendar.month(datePrevious)
            year = calendar.year(datePrevious)

            let day3 = dayForItem(item: item, weekDay: weekDay)

            day = day3 + numberOfDaysInMonthPrevious
        }
        else
        {
            if item - weekDay - 1 < numberOfDaysInMonthCurrent - 1
            {
                // Current month
                day = dayForItem(item: item, weekDay: weekDay)
                inMonth = true
            }
            else
            {
                // Next month ??
                let dateNext = calendar.nextStartOfMonthForDate(date)
                month = calendar.month(dateNext)
                year = calendar.year(dateNext)
                
                let day3 = dayForItem(item: item, weekDay: weekDay)
                day = day3 - numberOfDaysInMonthCurrent
            }
        }
        return (day, month, year, inMonth)
    }
    
    private func dayForItem(item: Int, weekDay: Int) -> Int {
        let day = item - weekDay + 1
        return day
    }
}

extension Date {
    func startOfMonth() -> Date {
        return Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: Calendar.current.startOfDay(for: self)))!
    }
    
    func endOfMonth() -> Date {
        return Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: self.startOfMonth())!
    }
}

