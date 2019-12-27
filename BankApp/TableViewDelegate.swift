//
//  TableViewDelegate.swift
//  BankApp
//
//  Created by Abdurahimov Aliakbar on 06.02.17.
//  Copyright © 2017 Abdurahimov Aliakbar. All rights reserved.
//
import UIKit

enum Section: Int{
    case cards = 0
    case deposits = 1
    case goals = 2
}

extension UITableViewDelegate{
    func animate(_ cell: UITableViewCell, with color: UIColor, duration: TimeInterval, delay: TimeInterval?, completion: ((Bool) -> (Void))?){
        UIView.animate(withDuration: duration, delay: delay ?? 0.0, options: .curveEaseIn, animations: {
            cell.backgroundColor = color
        }, completion: completion)
    }
}


class TableViewDelegate: NSObject, UITableViewDataSource, UITableViewDelegate, HomeTableDataDelegate, DepositLoaderDelegate {
    
    let tableData = HomeTableData.instance
    var cards: [Card]!
    var activeRow: IndexPath?
    var deposits: [Deposit] = []
    
    
    //Constants
    let headerHeight: CGFloat = 45.0
    
    override init() {
        super.init()
        tableData.delegate = self
        DepositLoader.instance.delegate = self
        cards = []
    }
    
    //MARK: - HomeTableDataDelegate
    
    func cardsDidLoad(cards: NSArray){
        self.cards = cards as! [Card]
        NotificationCenter.default.post(name: .CardsHaveBeenLoadedNotification, object: nil)
        UserDefaults.standard.saveObject(object:self.cards, key: "cards")
        UserDefaults.standard.synchronize()
    }
    
    //MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let table = tableView as? TableSegueProtocol{
            
            let cell = tableView.cellForRow(at: indexPath)!
            
            animate(cell, with: #colorLiteral(red: 0.9307184815, green: 0.9273709655, blue: 0.934214592, alpha: 1), duration: 0.25, delay: nil, completion: { _ in
                self.animate(cell, with: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), duration: 0.25, delay: nil, completion: nil)
            })
            
            if indexPath.section == Section.cards.rawValue{
                if cards.count > 0{
                    let card = cards[indexPath.row]
                    table.prepareForSegue(data: card, segue: SegueID.cards)
                }
            }
            else if indexPath.section == Section.deposits.rawValue{
                table.prepareForSegue(data: nil, segue: SegueID.goal)
            }
            else if indexPath.section == Section.goals.rawValue{
                table.prepareForSegue(data: nil, segue: SegueID.goal)
            }
            
            activeRow = indexPath
        }
    }
    
    //MARK: - UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return tableData.sections.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        let headerView = UIView(frame: CGRect(x: 0.0, y: tableView.frame.origin.y, width: tableView.frame.size.width, height: headerHeight))
        
        headerView.backgroundColor = #colorLiteral(red: 0.9120810628, green: 0.9349395633, blue: 0.9612939954, alpha: 1)
        
        //Custom label
        let label = UILabel(frame: CGRect(x: 15.0, y: 0.0, width: tableView.frame.size.width, height: headerHeight))
        label.text = tableData.sections[section]
        label.textColor = UIColor.black.withAlphaComponent(0.5)
        headerView.addSubview(label)

        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return headerHeight
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section{
        case Section.cards.rawValue:
            return cards.count != 0 ? cards.count: 1
        case 2:
            return deposits.count
        default:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == Section.cards.rawValue{
            if cards.count > 0{
                return cellForCard(tableView, cellForRowAt: indexPath)
            }
            else{
                return cellForEmptyCard(tableView, cellForRowAt: indexPath)
            }
        }
        else if indexPath.section == Section.deposits.rawValue{
            return cellForEmptyDeposit(tableView, cellForRowAt: indexPath)
        }
        else if indexPath.section == Section.goals.rawValue{
            return cellForEmptyGoal(tableView, cellForRowAt: indexPath)
        }
        
        return UITableViewCell()
    }
    
    
    func cellForCard(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "CardCell", for: indexPath) as! CardCell
        let row = indexPath.row
        let title = cards[row].title
        let balance = cards[row].balance
        let number = String(cards[row].info.number)
        let index = number!.index(number!.endIndex, offsetBy: -4)
        let securedNumber = "**** \(number!.substring(from: index))"
        var image: UIImage
        
        
        switch cards[row].info.title{
        case .visa:
            image = #imageLiteral(resourceName: "visa")
        case .mastercard:
            image = #imageLiteral(resourceName: "mastercard")
        case .maestro:
            image = #imageLiteral(resourceName: "maestro")
        }
        
        cell.titleLabel.text = title
        cell.numberLabel.text = securedNumber
        cell.balanceLabel.text = "\(balance.stringFormat) Р"
        cell.cardProducerView.image = image
        
        
        
        return cell
    }
    func cellForEmptyCard(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = "К сожалению, у вас нет доступных карт"
        cell.selectionStyle = .none
        return cell
    }
    
    func cellForEmptyDeposit(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "DepositCell", for: indexPath) as! DepositCell
        
        return cell
    }
    func cellForEmptyGoal(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "GoalCell", for: indexPath) as! GoalCell
        
        cell.sumLabel.text = "\(deposits[indexPath.row].initialSum) Р"
        cell.termLabel.text = "\(deposits[indexPath.row].date) г."
        
        
        return cell
    }
    
    func depositsHaveBeenLoaded(deposits: NSArray) {
        self.deposits = deposits as! [Deposit]
        NotificationCenter.default.post(name: .DepositsHaveBeenLoadedNotification, object: nil)
    }
    
}
