//
//  AppDelegate.swift
//  calendar
//
//  Created by thierryH24 on 12/10/2017.
//  Copyright © 2017 thierryH24. All rights reserved.
//

import Cocoa

protocol ChangeDateDelegate: class {    // <-- needs :class for weak
    func changeDate(month:Int, year:Int)
}

class THPicker: NSCollectionViewItem,NSTableViewDataSource, NSTableViewDelegate {

    let minYear = 2000
    
    
    @IBOutlet weak var tblMonth: NSTableView!
    @IBOutlet weak var tblYear: NSTableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.wantsLayer = true
        view.layer?.backgroundColor = NSColor.controlBackgroundColor.cgColor
            }
    
    func configure(month: String, year: Int) {
        tblMonth.selectRowIndexes(NSIndexSet(index: THCalendarView.Months.index(of: month)!) as IndexSet, byExtendingSelection: false)
        
        tblYear.selectRowIndexes( NSIndexSet(index: year - minYear) as IndexSet, byExtendingSelection: false)
        tblYear.scrollRowToVisible(year - minYear);

    }
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return tableView.identifier?.rawValue == "tblMonth" ? 12 :  100;
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
          guard let cell = tableView.makeView(withIdentifier: tableColumn!.identifier, owner: self) as? NSTableCellView else { return nil }
        cell.textField?.stringValue = tableView.identifier?.rawValue == "tblMonth" ? THCalendarView.Months[row] : "\(minYear + row)"

        return cell
    }
   
    weak var delegate: ChangeDateDelegate?    // <-- delegate

    @IBAction func btnOKClick(_ sender: Any) {
        delegate?.changeDate(month:tblMonth.selectedRow+1, year:tblYear.selectedRow + minYear)
    }
}
