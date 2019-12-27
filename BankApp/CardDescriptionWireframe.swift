//
//  CardDescriptionWireframe.swift
//  BankApp
//
//  Created by Abdurahimov Aliakbar on 06.02.17.
//  Copyright © 2017 Abdurahimov Aliakbar. All rights reserved.
//

import UIKit

class CardDescriptionWireframe: UIViewController, UITableViewDelegate, UITableViewDataSource, OperationDataDelegate{

    var card: Card!
    var operations: [Operation] = []
    
    @IBOutlet weak var balanceLabel: UILabel!
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var cardContainer: UIView!
    
    var operationData = OperationManager.instance
    let headerHeight: CGFloat = 35.0
    
    lazy private var activityIndicator : CustomActivityIndicatorView = {
        let image : UIImage = UIImage(named: "loading")!
        return CustomActivityIndicatorView(image: image)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cardContainer.isHidden = true
        let tapRec = UITapGestureRecognizer(target: self, action: #selector(didTapAfterExpansion(_:)))
        view.addGestureRecognizer(tapRec)
        
        operationData.delegate = self
        operationData.loadOperations(ownerID: card.id)
        
        activityIndicator.frame.origin = CGPoint(x: view.frame.width/2 - activityIndicator.frame.width/2, y: view.frame.height/2 - activityIndicator.frame.height/2)
        self.view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
    
        table.delegate = self
        table.dataSource = self
        table.tableFooterView = UIView(frame: CGRect.zero)
        table.register(UINib(nibName: "OperationCell", bundle: nil), forCellReuseIdentifier: "OperationCell")
        table.layer.opacity = 0
        table.rowHeight = UITableViewAutomaticDimension
        table.estimatedRowHeight = 70.0
        
        balanceLabel.text = "\(card.balance.stringFormat) Р"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationItem.title = card.title
    }
    
    func animateContainerTransition(isHidden: Bool){
        
        let duration = 0.35
        
        if isHidden{
            cardContainer.layer.opacity = 0
            cardContainer.isHidden = false
            cardContainer.layer.transform = CATransform3DMakeTranslation(0.0, 15.0, 0.0)
            UIView.animate(withDuration: duration, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
                self.cardContainer.layer.opacity = 0.9
                self.cardContainer.layer.transform = CATransform3DIdentity
            }, completion: nil)
        }
        else{
            
            UIView.animate(withDuration: duration, delay: 0.0, options: UIViewAnimationOptions.curveEaseInOut, animations: {
                self.cardContainer.layer.opacity = 0
                self.cardContainer.layer.transform = CATransform3DMakeTranslation(0.0, 15.0, 0.0)
            }, completion: { completed in
                self.cardContainer.isHidden = true
            })
        }

    }

    
    //MARK: - OperationDataDelegate
    
    func operationsDidLoad(operations: NSArray) {
        self.operations = operations as! [Operation]
        table.reloadData()
        activityIndicator.stopAnimating()
        
        UIView.animate(withDuration: 0.5, delay: 0.0, options: UIViewAnimationOptions.curveEaseInOut, animations: {
            self.table.layer.opacity = 1
        }, completion: nil)
    }
    
    //MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame:CGRect(x: 0.0, y: tableView.frame.origin.y, width: tableView.frame.size.width, height: headerHeight))
        
        headerView.backgroundColor = #colorLiteral(red: 0.9120810628, green: 0.9349395633, blue: 0.9612939954, alpha: 1)
        
        //Custom label
        let label = UILabel(frame: CGRect(x: 15.0, y: 0.0, width: tableView.frame.size.width, height: headerHeight))
        label.text = "Последние операции"
        label.textColor = UIColor.black.withAlphaComponent(0.5)
        headerView.addSubview(label)
        
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return headerHeight
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return operations.count > 0 ? operations.count : 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if operations.count > 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "OperationCell", for: indexPath) as! OperationCell
            let j = indexPath.row
            let sum = String(-operations[j].sum) + " Р"
            let date = operations[j].date
            var fullname = ""
            var type = ""
            var img: UIImage!
            
            let formatter = DateFormatter()
            formatter.dateFormat = "dd.MM"
            let formattedDate = formatter.string(from: date)
            
            switch operations[j].receiver{
            case .service:
                type = "Оплата услуг"
                fullname = operations[j].receiverID?["name"] as! String
                img = #imageLiteral(resourceName: "usluga")
                break
            case .user:
                type = "Перевод клиенту Binary Bank"
                fullname = operations[j].receiverID?["owner"] as! String
                img = #imageLiteral(resourceName: "user-1")
                break
            }
            
            cell.receiverTitle.text = fullname
            cell.operationSum.text = sum
            cell.operationType.text = type
            cell.operationImage.image = img
            cell.operationDate.text = formattedDate
            
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "OperationEmptyCell", for: indexPath)
        cell.textLabel?.text = "Ваша история пуста"
        return cell
    }
    
    //Event Handler
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EmbedSegue"{
            let dvc = segue.destination as! CardContainerController
            dvc.parentFrame = cardContainer.frame
            dvc.card = card
        }
    }
    
    @IBAction func didTouchCardExpander(_ sender: Any) {
        animateContainerTransition(isHidden: cardContainer.isHidden)
    }
    
    func didTapAfterExpansion(_ sender: Any?){
        if !cardContainer.isHidden{
            animateContainerTransition(isHidden: cardContainer.isHidden)
        }
    }

}
