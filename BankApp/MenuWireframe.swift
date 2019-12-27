//
//  MenuViewController.swift
//  BankApp
//
//  Created by Abdurahimov Aliakbar on 06.02.17.
//  Copyright © 2017 Abdurahimov Aliakbar. All rights reserved.
//

import UIKit

public enum SegueID: String{
    case cards = "cardDescriptionSegue"
    case goal = "goalSegue"
    case transfer = "transferSegue"
    case payment = "paymentSegue"
    case selfTransfer = "selfTransferSegue"
}

//MARK: - Notification Extension

extension Notification.Name
{
    static let DidSelectCellAtIndexNotification = Notification.Name("DidSelectCellAtIndexNotification")
    
}

//MARK: - Gesture Extension

public extension UIViewController
{
    func addGestureToScene()
    {
        if(self.revealViewController() != nil)
        {
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            self.navigationController?.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())

        }
    }
}

//MARK: - Main Frame

class MenuWireframe: UIViewController {
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var bottomView: UIView!
    
    let constant: CGFloat = 300.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Default menu size
        self.revealViewController().rearViewRevealWidth = constant
    }
 
    
    //Invoke this method after changing the device orientation
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        self.revealViewController().rearViewRevealWidth = constant
    }
    
}

//MARK: - Table Delegate

class MenuViewDelegate: NSObject, UITableViewDelegate
{
    var parentController: UITableViewController?
    let defaultBGColor = #colorLiteral(red: 0.2605174184, green: 0.2605243921, blue: 0.260520637, alpha: 1)
    let selectedBGColor = #colorLiteral(red: 0.2367918491, green: 0.2358009517, blue: 0.2378268242, alpha: 1)
    var selectedID: IndexPath?
    
    func updateCellsInTableView(tableView: UITableView)
    {
        let numberOfRows = tableView.numberOfRows(inSection: 0)
        
        for i in 0..<numberOfRows
        {
            let indexPath = IndexPath(row: i, section: 0)
            let cell = tableView.cellForRow(at: indexPath)
            cell?.contentView.backgroundColor = defaultBGColor
        }
        
        selectedID = nil
       
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        //Setting the initial state
        
        if parentController is TopMenuViewController
        {
            if indexPath.row == 0
            {
                cell.contentView.backgroundColor = selectedBGColor
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        NotificationCenter.default.post(name: .DidSelectCellAtIndexNotification, object: nil, userInfo: ["parent":parentController!])
        
        let cell = tableView.cellForRow(at: indexPath)
        
        if selectedID != nil
        {
            let activeCell = tableView.cellForRow(at: selectedID!)
            
            if selectedID != indexPath{
                activeCell?.contentView.backgroundColor = defaultBGColor
                cell?.contentView.backgroundColor = selectedBGColor
            }
        }
        else{
            let initialStateCell = tableView.cellForRow(at: IndexPath.init(row: 0, section: 0))
            initialStateCell?.contentView.backgroundColor = defaultBGColor
            cell?.contentView.backgroundColor = selectedBGColor
        }
        
        selectedID = indexPath
    }
    
    
}
