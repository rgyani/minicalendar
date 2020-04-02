//
//  AppDelegate.swift
//  calendar
//
//  Created by thierryH24 on 12/10/2017.
//  Copyright © 2017 thierryH24. All rights reserved.
//

import Cocoa

class THDateItem: NSCollectionViewItem {
    
    @IBOutlet weak var dateField: NSTextField!
    
    var backgroundViewLayer : CALayer?
    
    override var isSelected: Bool {
        didSet {
            guard backgroundViewLayer?.isHidden != true else { return }
            
            backgroundViewLayer?.backgroundColor = isSelected ? NSColor.selectedControlColor.cgColor: (isToday ? NSColor.blue.cgColor : NSColor.controlBackgroundColor.cgColor)
            dateField.textColor = isSelected ? NSColor.white : NSColor.black
        }
    }
    
    var dateItem : Date  = Date() {
        didSet {
//            print(dateItem)
        }
    }
    
    var isHidden : Bool = false {
        didSet {
            if isHidden == true && inCurrentMonth == false {
                dateField.isHidden = isHidden
                backgroundViewLayer?.isHidden = isHidden
            }
        }
    }
    
    var isToday : Bool = false {
        
        didSet {
            
            backgroundViewLayer?.backgroundColor = isToday ? NSColor.blue.cgColor : NSColor.controlBackgroundColor.cgColor
            dateField.textColor = isToday ? NSColor.white : NSColor.black

        }
    }
    
    var inCurrentMonth: Bool = true {
        didSet {
            dateField.alphaValue = inCurrentMonth ? 1.0 : 0.3
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    func configure(day: Int, inCurrentMonth: Bool) {
        
        self.inCurrentMonth = inCurrentMonth
        
        dateField.stringValue = "\(day)"
        dateField.alignment = .center
        dateField.isHidden = false

        view.wantsLayer = true
        view.layer?.sublayers?.forEach { $0.removeFromSuperlayer() }
        
        BackgroundViewLayer()
    }
    
    
    func BackgroundViewLayer() {
        
        backgroundViewLayer = CALayer()
        
        var frame = CGRect( x: 0, y: 0, width: view.bounds.width, height: view.bounds.height)
        frame = frame.insetBy(dx: 3.0, dy: 3.0)
        
        backgroundViewLayer?.frame = frame
        backgroundViewLayer?.cornerRadius = 4.0
        backgroundViewLayer?.backgroundColor = NSColor.controlColor.cgColor
        
        backgroundViewLayer?.borderColor = NSColor.controlColor.cgColor
        backgroundViewLayer?.borderWidth = 1.0
                
        backgroundViewLayer?.anchorPoint = CGPoint(x : 0.5, y : 0.5)
        backgroundViewLayer?.position =  CGPoint(x: view.bounds.width / 2, y: view.bounds.height / 2)
        view.layer?.addSublayer(backgroundViewLayer!)
        view.wantsLayer = true
        
//        let gradient = CAGradientLayer()
//        gradient.colors = [NSColor.blue, NSColor.lightGray, NSColor.red]
//        gradient.frame = (backgroundViewLayer?.bounds)!
//        self.view.layer = gradient

    }
    
}
