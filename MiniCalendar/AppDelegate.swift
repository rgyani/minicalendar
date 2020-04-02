//
//  AppDelegate.swift
//  MiniCalendar
//
//  Created by Gyani, Ravi, SKY on 31.03.20.
//  Copyright © 2020 Gyani, Ravi, SKY. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    var statusBarItem: NSStatusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    
    
    var timer: Timer? = nil
    var dateFormatter:DateFormatter = DateFormatter()
    let popover = NSPopover()
//    var eventMonitor: EventMonitor?
    
    func applicationWillResignActive(_ notification: Notification) {
        print("resign active")
        closePopover(sender:notification)
    }

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        NSApp.setActivationPolicy(.accessory)
        
        guard let statusButton = statusBarItem.button else { return }
        statusButton.action = #selector(togglePopover(_:))
        popover.contentViewController = CalendarViewController.freshController()
        
        
        dateFormatter.dateFormat = "E dd MMM hh:mm a"
        
        timer = Timer.scheduledTimer(
            timeInterval: 1,
            target: self,
            selector: #selector(updateStatusText),
            userInfo: nil,
            repeats: true
        )
        
        RunLoop.main.add(timer!, forMode: .common)
        
//        eventMonitor = EventMonitor(mask: [.leftMouseDown, .rightMouseDown]) { [weak self] event in
//            if let strongSelf = self, strongSelf.popover.isShown {
//                strongSelf.closePopover(sender: event)
//            }
//        }
    }
    
    @objc
    func updateStatusText(_ sender: Timer)
    {
        guard let statusButton = statusBarItem.button else { return }
        statusButton.title = dateFormatter.string(from: Date())
    }
    
    @objc func togglePopover(_ sender: Any?) {
        if popover.isShown {
            closePopover(sender: sender)
        } else {
            showPopover(sender: sender)
        }
    }
    
    func showPopover(sender: Any?) {
        if let button = statusBarItem.button {
//            eventMonitor?.start()
            popover.behavior = NSPopover.Behavior.transient;
            NSApp.activate(ignoringOtherApps: true)

            popover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)

        }
    }
    
    func closePopover(sender: Any?) {
        popover.performClose(sender)
//        eventMonitor?.stop()
        
    }
}

