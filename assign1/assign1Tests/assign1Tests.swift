//
//  assign1Tests.swift
//  assign1Tests
//
//  Created by Josh on 2/17/20.
//  Copyright © 2020 Josh. All rights reserved.
//

import XCTest
@testable import assign1

class assign1Tests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    
    func testSetup() {
        let game = Triples()
        game.newgame()
        
        XCTAssertTrue((game.board.count == 4) && (game.board[3].count == 4))
    }

    func testRotate0() {
        var board = [[4,8,12,16],
                     [3,7,11,15],
                     [2,6,10,14],
                     [1,5,9, 13]]
        board = rotate2DInts(input: board)
        XCTAssertTrue(board ==
            [[1,2,3,4],
             [5,6,7,8],
             [9,10,11,12],
             [13,14,15,16]])
    }
    func testRotate1() {
        var board = [[0,3,3,3],
                     [1,2,3,3],
                     [0,2,1,3],
                     [3,3,6,6]]
        board = rotate2DInts(input: board)
        XCTAssertTrue(board ==
            [[3,0,1,0],
             [3,2,2,3],
             [6,1,3,3],
             [6,3,3,3]])
    }

    func testRotate2() {
        var board = [[0,3,3,3],[1,2,3,3],[0,2,1,3],[3,3,6,6]]
        board = rotate2D(input: board)
        XCTAssertTrue(board == [[3,0,1,0],[3,2,2,3],[6,1,3,3],[6,3,3,3]])
    }

    func testRotate3() {
        var board = [["0","3","3","3"],["1","2","3","3"],["0","2","1","3"],["3","3","6","6"]]
        board = rotate2D(input: board)
        XCTAssertTrue(board == [["3","0","1","0"],["3","2","2","3"],["6","1","3","3"],["6","3","3","3"]])
    }

    func testShift() {
        let game = Triples()
        game.board = [[0,3,3,3],[1,2,3,3],[0,2,1,3],[3,3,6,6]]
        game.shift()
        XCTAssertTrue(game.board == [[3,3,3,0],[3,3,3,0],[2,1,3,0],[6,6,6,0]])
    }
    
    func testLeft() {
        let game = Triples()
        game.board = [[0,3,3,3],[1,2,3,3],[0,2,1,3],[3,3,6,6]]
        game.collapse(dir: .left)
        XCTAssertTrue(game.board == [[3,3,3,0],[3,3,3,0],[2,1,3,0],[6,6,6,0]])
    }

    func testRight() {
        let game = Triples()
        game.board = [[0,3,3,3],[1,2,3,3],[0,2,1,3],[3,3,6,6]]
        game.collapse(dir: .right)
        XCTAssertTrue(game.board == [[0,0,3,6],[0,1,2,6],[0,0,3,3],[0,3,3,12]])

    }

    func testDown() {
        let game = Triples()
        game.board = [[0,3,3,3],
                      [1,2,3,3],
                      [0,2,1,3],
                      [3,3,6,6]]
        game.collapse(dir: .down)
        XCTAssertTrue(game.board == [[0,3,0,0],
                                     [0,2,6,3],
                                     [1,2,1,6],
                                     [3,3,6,6]])
    }

    func testUp() {
        let game = Triples()
        game.board = [[0,3,3,3],[1,2,3,3],[0,2,1,3],[3,3,6,6]]
        game.collapse(dir: .up)
        XCTAssertTrue(game.board == [[1,3,6,6],[0,2,1,3],[3,2,6,6],[0,3,0,0]])
    }


    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
