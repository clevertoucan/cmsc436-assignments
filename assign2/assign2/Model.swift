//
//  model.swift
//  assign1
//
//  Created by Josh on 2/17/20.
//  Copyright © 2020 Josh. All rights reserved.
//

import Foundation

enum Direction: CaseIterable {
    case up, down, left, right
}

class Triples: CustomStringConvertible {
    var board : [[Int]]
    let boardsize = 4
    public var description: String {
        var d = "|"
        for y in 0...boardsize - 1{
            for x in 0...boardsize-1 {
                d += String(board[y][x]) + ", "
            }
            d += "|\n|"
        }
        return d
    }
    public var score: Int {
        var score = 0
        for y in 0...boardsize - 1{
            for x in 0...boardsize-1 {
                score += board[y][x]
            }
        }
        return score
    }
    
    init(){
        board = Array<Array<Int>>(repeating: Array<Int>(repeating: 0, count: boardsize), count: boardsize)
    }
    
    func newgame(_ rand: Bool){
        var seed: Int
        if rand {
            seed = Int.random(in: 0...1000)
        } else {
            seed = 42
        }
        srand48(seed)
        board = Array<Array<Int>>(repeating: Array<Int>(repeating: 0, count: boardsize), count: boardsize)
        
        spawn()
        spawn()
        spawn()
        spawn()
    }
        
    func spawn(){
        var indices: [Int] = Array()
        for y in 0...boardsize - 1 {
            for x in 0...boardsize - 1 {
                if board[y][x] == 0 {
                    indices.append(y * boardsize + x)
                }
            }
        }
        if(indices.count > 0){
            let val = prng(max: 2) + 1
            let x = indices[prng(max: indices.count)]
            board[x / boardsize][x % boardsize] = val
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
                if x < 3 {
                    switch board[y][x] {
                    //if 0, swap no matter what
                    case 0:
                        board[y][x] = board[y][x+1]
                        board[y][x+1] = 0
                    // if same, combine
                    case board[y][x+1]:
                        if board[y][x] != 1 && board[y][x] != 2 {
                            board[y][x] = board[y][x] * 2
                            board[y][x+1] = 0
                        }
                    case 1, 2:
                        if board[y][x] + board[y][x+1] == 3 {
                            board[y][x] = 3
                            board[y][x+1] = 0
                        }
                    default: continue
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
