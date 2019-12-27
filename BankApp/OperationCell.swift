//
//  OperationCell.swift
//  BankApp
//
//  Created by Abdurahimov Aliakbar on 06.02.17.
//  Copyright © 2017 Abdurahimov Aliakbar. All rights reserved.
//
import UIKit

class OperationCell: UITableViewCell {

    
    @IBOutlet weak var operationImage: UIImageView!
    @IBOutlet weak var receiverTitle: UILabel!
    @IBOutlet weak var operationType: UILabel!
    @IBOutlet weak var operationSum: UILabel!
    @IBOutlet weak var operationDate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
