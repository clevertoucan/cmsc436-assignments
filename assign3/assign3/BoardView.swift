//
//  BoardView.swift
//  assign3
//
//  Created by Josh on 4/12/20.
//  Copyright © 2020 Josh. All rights reserved.
//

import UIKit

class BoardView: UIView {
    var num = 0
    override func draw(_ rect: CGRect) {

    }
    
    override func layoutSubviews() {
        for view in subviews {
            if let button = view as? TileButton {
                button.setTitle(String(button.tile.value), for: .normal)
                if button.tile.value == 1 {
                    button.backgroundColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
                    button.setTitleColor(UIColor.black, for: .normal)
                } else if button.tile.value == 2 {
                    button.backgroundColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
                    button.setTitleColor(UIColor.black, for: .normal)
                } else {
                    button.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                    button.setTitleColor(UIColor.black, for: .normal)
                }
                button.frame = buttonFrame(button.tile.row, button.tile.col)
                switch(button.tile.animation){
                case .fadeIn:
                    button.alpha = 0
                    UIView.animate(withDuration: 0.5, animations: {
                        button.alpha = 1
                    })
                case .fadeOut:
                    button.alpha = 1
                    UIView.animate(withDuration: 0.5, animations: {
                        button.alpha = 0
                    }, completion: { finished in
                        button.removeFromSuperview()
                    })
                case .toFrom(let x, let y):
                    let dx = CGFloat(-x * Int(self.center.x) / 2)
                    let dy = CGFloat(-y * Int(self.center.y) / 2)
                    button.frame = button.frame.offsetBy(dx: -dx, dy: -dy)
                    UIView.animate(withDuration: 0.5, animations: {
                        button.frame = button.frame.offsetBy(dx: dx, dy: dy)
                    })
                default: continue
                }
                button.tile.animation = .none
                
                
                button.setNeedsDisplay()
            }
        }
    }
    
    func destroyButton(_ button: TileButton){
        button.alpha = 1
        UIView.animate(withDuration: 1, animations: {
            button.alpha = 0
        }, completion: { finished in
            button.removeFromSuperview()
        })
    }
    
    func buttonFrame(_ row: Int, _ col: Int) -> CGRect {
        return CGRect(x: Int(center.x) * (row) / 2,
                      y: Int(center.y) * (col) / 2,
                      width: Int(center.x / 2) - 10,
                      height: Int(center.y / 2) - 10)
 
        /*
        return CGRect(x: num,
                      y: num,
                      width: Int(center.x / 2),
                      height: Int(center.y / 2))
    */
    }
    
    

}
