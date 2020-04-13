//
//  ViewController.swift
//  assign2
//
//  Created by Josh on 3/9/20.
//  Copyright © 2020 Josh. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet weak var uiBoard: BoardView!
    @IBOutlet weak var ScoreLabel: UILabel!
    @IBOutlet weak var randSwitch: UISegmentedControl!
    @IBOutlet var dirButtons: [UIButton]!
    @IBOutlet var buttons: [UIButton]!
    var board: Triples = Triples()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        newGameHelper()
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeRight.direction = UISwipeGestureRecognizer.Direction.right
        self.view.addGestureRecognizer(swipeRight)

        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeDown.direction = UISwipeGestureRecognizer.Direction.down
        self.view.addGestureRecognizer(swipeDown)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeLeft.direction = UISwipeGestureRecognizer.Direction.left
        self.view.addGestureRecognizer(swipeLeft)

        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeUp.direction = UISwipeGestureRecognizer.Direction.up
        self.view.addGestureRecognizer(swipeUp)
    }

    @objc
    func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case .right:
                shiftHelper(.right)
            case .down:
                shiftHelper(.down)
            case .left:
                shiftHelper(.left)
            case .up:
                shiftHelper(.up)
                default:
                    break
            }
        }
    }


    @IBAction func randSelector(_ sender: Any) {
        print("foo")
    }
    
    @IBAction func shift(_ sender: Any) {
        if let x = sender as? UIButton {
            print(x.accessibilityIdentifier!)
            switch x.accessibilityIdentifier{
            case "up": shiftHelper(.up)
            case "down": shiftHelper(.down)
            case "left": shiftHelper(.left)
            case "right": shiftHelper(.right)
                default: return
            }
        }

        
    }
    
    func shiftHelper(_ dir: Direction) {
        board.collapseWithSpawn(dir)
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
    
    func find(_ row: Int, _ col: Int) -> TileButton?{
        for v in uiBoard.subviews {
            if let b = v as? TileButton {
                if b.tile.row == row && b.tile.col == col {
                    return b
                }
            }
        }
        return nil
    }
    
    func boardUpdate(){
        print(board)
        for y in 0...board.boardsize - 1 {
            for x in 0...board.boardsize - 1 {
                if let tile = board.board[y][x] {
                    let uiTile = UITile(tile)
                    if board.fadeTiles.contains(tile){
                        uiTile.animation = .fadeOut
                        board.fadeTiles.remove(tile)
                    }
                    if board.newTiles.contains(tile) {
                        uiTile.animation = .fadeIn
                        board.newTiles.remove(tile)
                    }
                    if board.movedTiles.keys.contains(tile){
                        let (offsetX, offsetY) = board.movedTiles[tile]!
                        uiTile.animation = .toFrom(offsetX: offsetX, offsetY: offsetY)
                        board.movedTiles.removeValue(forKey: tile)
                    }
                    
                    if let button = find(x, y){
                        button.tile = uiTile
                    } else {
                        let button = TileButton(t: uiTile)
                        uiBoard.addSubview(button)
                    }
                } else {
                    if let b = find(x, y) {
                        uiBoard.destroyButton(b)
                    }
                }
                /*
                if let b = find(y * board.boardsize + x) {
                    if let tile = board.board[y][x] {
                        b.setTitle(String(tile.value), for: .normal)
                        if tile.value == 1 {
                            b.backgroundColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
                        } else if tile.value == 2 {
                            b.backgroundColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
                        } else {
                            b.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                        }
                    }
                    b.setNeedsDisplay()
                }
                */
            }
        }
        uiBoard.setNeedsDisplay()
        ScoreLabel.text = "Score: \(board.score)"
        
    }
    
    func newGameHelper() {
        let rand = randSwitch.selectedSegmentIndex == 0
        print(rand)
        board.newgame(rand)
        boardUpdate()
    }
    
}

class TileButton: UIButton {
    var tile = UITile(value: 0, id: 0, row: 0, col: 0)

    convenience init(t: UITile) {
        self.init()
        tile = t
    }

}

enum Animation {
    case none, fadeIn, fadeOut, toFrom(offsetX: Int, offsetY: Int)
}

class UITile {
    var value: Int
    var id: Int
    var row: Int
    var col: Int
    var animation = Animation.none
    
    init(value: Int, id: Int, row: Int, col: Int){
        self.value = value
        self.id = id
        self.row = row
        self.col = col
    }
    
    convenience init(_ t: Tile){
        self.init(value: t.value, id: t.id, row: t.row, col: t.col)
    }
}

