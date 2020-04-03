//
//  AppDelegate.swift
//  calendar
//
//  Created by thierryH24 on 12/10/2017.
//  Copyright © 2017 thierryH24. All rights reserved.
//

import Cocoa


class THCalendarView: NSViewController, ChangeDateDelegate {

    var showMonthPicker = false
    
    @IBOutlet weak var collectionView: NSCollectionView!

    
    public static let Months:[String] = DateFormatter().monthSymbols as [String]
    
    // Today
    var date = Date()
    // Selected Date
    public var selectedDate: Date = Date() {
        didSet {
            selectSelectedDateItem()
        }
    }

    
    enum Section: Int {
        case month = 0, week, date
    }

    public init() {
        super.init(nibName: NSNib.Name( "THCalendarView"), bundle: Bundle(for: THCalendarView.self))
    }

    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }

    override func viewWillLayout() {
        super.viewWillLayout()
        
        // When we're invalidating the collection view layout
        // it will call `collectionView(_:layout:sizeForItemAt:)` method
        collectionView.collectionViewLayout?.invalidateLayout()
        collectionView.reloadData()
    }

    func selectSelectedDateItem() {
    }

    func indexPathForDate(selectedDate: Date) -> IndexPath? {

        let calendar = Calendar.current
        
        if calendar.month(date) == calendar.month(selectedDate) {
            let start = date.startOfMonth()
            let weekDay = calendar.component(.weekday, from: start)
            
            let item = weekDay + calendar.day(selectedDate) - 2
            let index = IndexPath(item: item, section: Section.date.rawValue )
            return index
        }
        return nil
    }

    

    @IBAction func showPicker(_ sender: Any)
    {
        print("Show picker")
        showMonthPicker = true
        collectionView.reloadData()
        
    }
    @IBAction func previousMonth(_ sender: Any) {
        goToMonthWithOffet(-1)
    }
    
    
    @IBAction func toDayMonth(_ sender: Any) {
        
        self.date = Date()
        selectedDate = Date()
        
        collectionView.reloadData()
    }

    @IBAction func nextMonth(_ sender: Any) {
        goToMonthWithOffet(1)
    }

    func goToMonthWithOffet(_ offet:Int) {
        
        if let newDate = (date.applyOffSetOfMonth( offset: offet)) {
            date = newDate
            selectedDate = newDate
            collectionView.reloadData()
        }
    }
    
    func changeDate(month: Int, year: Int) {
    
        var component = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
        component.year = year
        component.month = month
        if let newDate = (Calendar.current.date(from: component)) {
            date = newDate
            selectedDate = newDate
            
            showMonthPicker = false
            collectionView.reloadData()
        }
    }

}

extension THCalendarView: NSCollectionViewDelegate {
 
}



extension Date {
    
    func applyOffSetOfMonth( offset:Int) -> Date? {

        var dateComponents = DateComponents()
        dateComponents.month = offset

        return Calendar.current.date(  byAdding: dateComponents, to: self, wrappingComponents: false)
    }
}

// just for the debug
extension NSView {

    override open var description: String {
        let id = identifier?.rawValue
        return "id: \(String(describing: id!))"
    }
}

