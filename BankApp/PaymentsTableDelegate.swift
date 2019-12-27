//
//  PaymentsTableDelegate.swift
//  BankApp
//
//  Created by Abdurahimov Aliakbar on 06.02.17.
//  Copyright © 2017 Abdurahimov Aliakbar. All rights reserved.
//

import UIKit

class PaymentsTableDelegate: NSObject, UITableViewDelegate, UITableViewDataSource {

    let sections = [["Переводы", ["Между своими счетами","Клиенту Binary Bank"]]]
    
    var activeRow: IndexPath?
    
    //Constants
    let headerHeight: CGFloat = 45.0
    
    
    //MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let table = tableView as? TableSegueProtocol{
            let cell = tableView.cellForRow(at: indexPath)!
            
            animate(cell, with: #colorLiteral(red: 0.9307184815, green: 0.9273709655, blue: 0.934214592, alpha: 1), duration: 0.25, delay: nil, completion: { _ in
                self.animate(cell, with: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), duration: 0.25, delay: nil, completion: nil)
            })
            
            let segue = indexPath.section == 0 ? indexPath.row == 0 ? SegueID.selfTransfer : SegueID.transfer : SegueID.payment
            let array = sections[indexPath.section][1] as? [String]
            let data = array?[indexPath.row]
            table.prepareForSegue(data: data, segue: segue)
        }
        
        activeRow = indexPath
    }
    
    //MARK: - UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0.0, y: tableView.frame.origin.y, width: tableView.frame.size.width, height: headerHeight))
        
        headerView.backgroundColor = #colorLiteral(red: 0.9120810628, green: 0.9349395633, blue: 0.9612939954, alpha: 1)
        
        //Custom label
        let label = UILabel(frame: CGRect(x: 15.0, y: 0.0, width: tableView.frame.size.width, height: headerHeight))
        label.text = sections[section][0] as? String
        label.textColor = UIColor.black.withAlphaComponent(0.5)
        headerView.addSubview(label)

        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return headerHeight
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let array = sections[section][1] as! [String]
        return array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PaymentsCell", for: indexPath) as! PaymentsCell
        let section = indexPath.section
        let array = sections[section][1] as! [String]
        cell.label.text = array[indexPath.row]
        return cell
    }
    
}
