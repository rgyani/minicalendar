//
//  AppDelegate.swift
//  calendar
//
//  Created by thierryH24 on 12/10/2017.
//  Copyright © 2017 thierryH24. All rights reserved.
//

import Cocoa

class THMonthItem: NSCollectionViewItem {
    
    @IBOutlet weak var monthField: NSTextField!
    
    var attributesMonth = [NSAttributedString.Key: Any]()
    var attributesYear = [NSAttributedString.Key: Any]()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.wantsLayer = true
        view.layer?.backgroundColor = NSColor.controlBackgroundColor.cgColor
        
        
    }
    
    func configure(month: String, year: Int) {
        
        let month = String(month.prefix(1)).uppercased() + String(month.dropFirst().prefix(2))
        monthField.stringValue = "\(month) \(year)"
    }
}
