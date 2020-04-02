//
//  CalendarViewController.swift
//  MiniCalendar
//
//  Created by Gyani, Ravi, SKY on 31.03.20.
//  Copyright © 2020 Gyani, Ravi, SKY. All rights reserved.
//

import Cocoa

class CalendarViewController: NSViewController {
    
    @IBOutlet weak var containerView: NSView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureCollectionView()
    }
    
    let calendarView = THCalendarView()

    fileprivate func configureCollectionView() {
  
        // Step 2 - Add calendar to view hierarchy
        addChild(calendarView)
        calendarView.view.frame = containerView.frame
        view.addSubview(calendarView.view)
        print("add View : ", calendarView.view)
    }
}

extension CalendarViewController {
    // MARK: Storyboard instantiation
    static func freshController() -> CalendarViewController {
        //1.
        let storyboard = NSStoryboard(name: "Main", bundle: nil)
        //2.
        let identifier = NSStoryboard.SceneIdentifier("CalendarViewController")
        //3.
        guard let viewcontroller = storyboard.instantiateController(withIdentifier: identifier) as? CalendarViewController else {
            fatalError("Why cant i find CalendarViewController? - Check Main.storyboard")
        }
        return viewcontroller
    }
}
