//
//  ViewController.swift
//  assign2
//
//  Created by Josh on 3/9/20.
//  Copyright © 2020 Josh. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet weak var ScoreLabel: UILabel!
    @IBOutlet weak var randSwitch: UISegmentedControl!
    @IBOutlet var dirButtons: [UIButton]!
    @IBOutlet var buttons: [UIButton]!
    var board: Triples = Triples()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        newGameHelper()
        // Do any additional setup after loading the view.
    }

    
    @IBAction func randSelector(_ sender: Any) {
        print("foo")
    }
    
    @IBAction func shift(_ sender: Any) {
        if let x = sender as? UIButton {
            switch x.accessibilityIdentifier{
                case "up": board.collapseWithSpawn(.up)
                case "down": board.collapseWithSpawn(.down)
                case "left": board.collapseWithSpawn(.left)
                case "right": board.collapseWithSpawn(.right)
                default: return
            }
        }
        boardUpdate()
        if(board.isDone()){
            let alert = UIAlertController(title: "Game Over", message: "Score: \(board.score)", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Darn", style: .cancel, handler: nil))
            self.present(alert, animated: true)
        }
        
    }
    
    
    @IBAction func newGame(_ sender: Any) {
        newGameHelper()
    }
    
    func find(_ num: Int) -> UIButton?{
        for b in buttons {
            if b.accessibilityIdentifier == String(num + 1){
                return b
            }
        }
        return nil
    }
    
    func boardUpdate(){
        for y in 0...board.boardsize - 1 {
            for x in 0...board.boardsize - 1 {
                let val = board.board[y][x]
                let b = find(y * board.boardsize + x)!
                if val != 0 {
                    b.setTitle(String(val), for: .normal)
                    if val == 1 {
                        b.backgroundColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
                    } else if val == 2 {
                        b.backgroundColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
                    } else {
                        b.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                    }
                } else {
                    b.backgroundColor = #colorLiteral(red: 0.333293438, green: 0.3333562911, blue: 0.3332894742, alpha: 1)
                    b.setTitle("", for: .normal)
                }
                b.setNeedsDisplay()
            }
        }
        ScoreLabel.text = "Score: \(board.score)"
        
    }
    
    func newGameHelper() {
        let rand = randSwitch.selectedSegmentIndex == 0
        print(rand)
        board.newgame(rand)
        boardUpdate()
    }
    
}

