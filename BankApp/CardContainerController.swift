//
//  CardContainerController.swift
//  BankApp
//
//  Created by Abdurahimov Aliakbar on 06.02.17.
//  Copyright © 2017 Abdurahimov Aliakbar. All rights reserved.
//

import UIKit

class CardContainerController: UIViewController {

    var triangleView: TriangleView!
    var parentFrame: CGRect!
    var card: Card!
    
    @IBOutlet weak var cardTitle: UILabel!
    @IBOutlet weak var cardNumber: UILabel!
    @IBOutlet weak var cardType: UILabel!
    @IBOutlet weak var cardCVV: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cardTitle.text = card.title
        
        var infoType = ""
        
        switch card.info.type{
        case .credit:
            infoType = "Кредитная"
        case .debit:
            infoType = "Дебетовая"
        case .overdraft:
            infoType = "Овердрафтная"
        }
        
        cardType.text = infoType
        
        cardNumber.text = card.info.number
        cardCVV.text = String(card.info.cvv)
        
        view.layer.cornerRadius = 12.0
        drawTriangle(width: 30.0, height:15.0, offsetX: 8.0, offsetY: 10.0)
    }
    
    func drawTriangle(width: CGFloat, height:CGFloat, offsetX: CGFloat, offsetY: CGFloat){
        let x: CGFloat = parentFrame.width - width - offsetX
        let y: CGFloat = -offsetY
        triangleView = TriangleView(frame: CGRect(x: x, y: y, width: width, height: height))
        triangleView.bgColor = view.backgroundColor
        view.addSubview(triangleView)
    }
}

class TriangleView : UIView {
    
    var bgColor: UIColor!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    override func draw(_ rect: CGRect) {
        
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        context.beginPath()
        context.move(to: CGPoint(x: rect.minX, y: rect.maxY))
        context.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        context.addLine(to: CGPoint(x: (rect.maxX / 2.0), y: rect.minY))
        context.closePath()
        
        context.setFillColor(bgColor.cgColor)
        context.fillPath()
    }
}
