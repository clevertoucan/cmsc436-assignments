//
//  model.swift
//  assign1
//
//  Created by Josh on 2/17/20.
//  Copyright © 2020 Josh. All rights reserved.
//

import Foundation
import UIKit

enum Direction: CaseIterable {
    case up, down, left, right
}

class Tile: Equatable, Hashable {
    static func == (lhs: Tile, rhs: Tile) -> Bool {
        return lhs.value == rhs.value &&
            lhs.id == rhs.id &&
            lhs.row == rhs.row &&
            lhs.col == rhs.col
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    var value: Int
    var id: Int
    var row: Int
    var col: Int
    var swapped = false
    
    init(value: Int, id: Int, row: Int, col: Int){
        self.value = value
        self.id = id
        self.row = row
        self.col = col
    }
    
}

class ButtonTile: UIButton {
    var tile = Tile(value: 0, id: 0, row: 0, col: 0)

    convenience init(t: Tile) {
        self.init()
        tile = t
    }
}


class Triples: CustomStringConvertible {
    var board : [[Tile?]]
    let boardsize = 4
    var currID = 1
    var movedTiles: [Tile: (Int, Int)]
    var newTiles: Set<Tile>
    var fadeTiles: Set<Tile>
    public var description: String {
        var d = "|"
        for y in 0...boardsize - 1{
            for x in 0...boardsize-1 {
                if let t = board[y][x] {
                    d += "\(t.value), "
                } else {
                    d += "0, "
                }
            }
            d += "|\n|"
        }
        return d
    }
    public var score: Int {
        var score = 0
        for y in 0...boardsize - 1{
            for x in 0...boardsize-1 {
                if let tile = board[y][x]{
                    score += tile.value
                }
            }
        }
        return score
    }
    
    init(){
        board = Array<Array<Tile?>>(repeating: Array<Tile?>(repeating: nil, count: boardsize), count: boardsize)
        newTiles = Set<Tile>()
        movedTiles = Dictionary<Tile, (Int, Int)>()
        fadeTiles = Set<Tile>()
    }
    
    func newgame(_ rand: Bool){
        var seed: Int
        if rand {
            seed = Int.random(in: 0...1000)
        } else {
            seed = 42
        }
        srand48(seed)
        board = Array<Array<Tile?>>(repeating: Array<Tile?>(repeating: nil, count: boardsize), count: boardsize)
        
        spawn()
        spawn()
        spawn()
        spawn()
    }
        
    func spawn(){
        var indices: [Int] = Array()
        for y in 0...boardsize - 1 {
            for x in 0...boardsize - 1 {
                if board[y][x] == nil{
                    indices.append(y * boardsize + x)
                }
            }
        }
        if(indices.count > 0){
            let val = prng(max: 2) + 1
            let x = indices[prng(max: indices.count)]
            let tile = Tile(value: val, id: currID, row: x % boardsize, col: x / boardsize)
            board[x / boardsize][x % boardsize] = tile
            currID += 1
            newTiles.insert(tile)
        }
    }
    
    func isDone() -> Bool {
        let temp = Triples()
        temp.board = board
        for dir in Direction.allCases {
            temp.collapse(dir: dir)
            if temp.board != board{
                return false
            }
        }
        return true
    }
    
    func shift(){
        for y in 0...boardsize - 1 {
            for x in 0...boardsize - 1 {
                if let tile = board[y][x] {
                    tile.swapped = false
                }
            }
        }
        for y in 0...boardsize - 1 {
            for x in 0...boardsize - 1 {
                if x < 3 {
                    if let currTile = board[y][x]{
                        let value = currTile.value
                        if let nextTile = board[y][x+1] {
                            if nextTile.value == value && value != 1 && value != 2 {
                                board[y][x] = nextTile
                                board[y][x+1] = nil
                                nextTile.value += nextTile.value
                                fadeTiles.insert(currTile)
                            } else if nextTile.value + value == 3{
                                nextTile.value = 3
                                board[y][x] = nextTile
                                board[y][x+1] = nil
                                fadeTiles.insert(currTile)
                            }
                        }
                    //if 0, swap no matter
                    } else {
                        board[y][x] = board[y][x+1]
                        board[y][x+1] = nil
                    }
                }
            }
        }
    }
    
    func rotate(){
        board = rotate2D(input: board)
    }
    
    func collapse(dir: Direction){
        switch dir{
            
        case .left:
            shift()
        
        case .down:
            rotate()
            shift()
            rotate()
            rotate()
            rotate()

        
        case .right:
            rotate()
            rotate()
            shift()
            rotate()
            rotate()
        
        case .up:
            rotate()
            rotate()
            rotate()
            shift()
            rotate()

        }
        for y in 0...boardsize - 1 {
            for x in 0...boardsize - 1 {
                if let tile = board[y][x]{
                    if(tile.row != x || tile.col != y){
                        movedTiles[tile] = (Int(tile.row - x), Int(tile.col - y))
                        tile.row = x
                        tile.col = y
                        
                    }
                }
            }
        }
    }
    
    func collapseWithSpawn(_ dir: Direction){
        let x = Triples()
        x.board = board
        collapse(dir: dir)
        if(board != x.board){
            spawn()
        }
    }

    
}


func prng(max: Int) -> Int {
    let ret = Int(floor(drand48() * (Double(max))))
    return (ret < max) ? ret : (ret-1)
}


func rotate2D<T>(input: Array<Array<T>>) -> Array<Array<T>> {
    // iterates through each cycle
    var arr = input
    let count = input.count
    
    
    for  i in 0...(count/2) - 1 {
        if i <= count - i - 2 {
            for j in i...count - i - 2 {
                let temp = arr[i][j];
                arr[i][j] = arr[count - 1 - j][i];
                arr[count - 1 - j][i] = arr[count - 1 - i][count - 1 - j];
                arr[count - 1 - i][count - 1 - j] = arr[j][count - 1 - i];
                arr[j][count - 1 - i] = temp;
            }
        }
    }
    return arr
}

func rotate2DInts(input: Array<Array<Int>>) -> Array<Array<Int>>{
    return rotate2D(input: input)
}
