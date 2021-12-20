//
//  icriedTest.swift
//  icriedTest
//
//  Created by Nikita Kiselov on 12/19/21.
//

import XCTest
import icried

class icriedTest: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testDescription(){
        let us = [UIntx(70, [0b1001000110010010010000101110011000100101010001000101110010100010,0b101]),
        UIntx(1,[1]),UIntx(3,[0]),UIntx(64,[0b11101001011010101010])]
        let descs = ["0001011001000110010010010000101110011000100101010001000101110010100010","1","000","0000000000000000000000000000000000000000000011101001011010101010"]
        for i in 0..<us.count{
            XCTAssertEqual(us[i].description, descs[i])
        }
    }

    func testRightShift() throws {
        for l in 1...200{
            var arr:[UInt64] = Array(repeating: 0, count: (l+63)/64)
            for i in 0..<arr.count{
                arr[i] = UInt64.random(in: 0...UInt64.max)
            }
            let u = UIntx(l,arr)
            var str = u.description
            print(u.x)
            for i in 0...u.x{
                XCTAssertEqual(str, (u>>i).description)
                str = "0"+String(str[str.startIndex..<str.index(before: str.endIndex)])
            }
        }
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }
    
    func testLeftShift() throws {
        for l in 1...200{
            var arr:[UInt64] = Array(repeating: 0, count: (l+63)/64)
            for i in 0..<arr.count{
                arr[i] = UInt64.random(in: 0...UInt64.max)
            }
            let u = UIntx(l,arr)
            var str = u.description
            print(u.x)
            for i in 0...u.x{
                XCTAssertEqual(str, (u<<i).description)
                str = String(str[str.index(after: str.startIndex)..<str.endIndex])+"0"
            }
        }
    }
    
    func testRightRoll() throws {
        for l in 1...200{
            var arr:[UInt64] = Array(repeating: 0, count: (l+63)/64)
            for i in 0..<arr.count{
                arr[i] = UInt64.random(in: 0...UInt64.max)
            }
            let u = UIntx(l,arr)
            var str = u.description
            print(u.x)
            for i in 0...u.x{
                XCTAssertEqual(str, (u>>>i).description)
                str = String(str[str.index(before:str.endIndex)])+String(str[str.startIndex..<str.index(before: str.endIndex)])
            }
        }
    }
    
    func testLeftRoll() throws {
        for l in 1...200{
            var arr:[UInt64] = Array(repeating: 0, count: (l+63)/64)
            for i in 0..<arr.count{
                arr[i] = UInt64.random(in: 0...UInt64.max)
            }
            let u = UIntx(l,arr)
            var str = u.description
            print(u.x)
            for i in 0...u.x{
                XCTAssertEqual(str, (u<<<i).description)
                str = String(str[str.index(after: str.startIndex)..<str.endIndex])+String(str[str.startIndex])
            }
        }
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        let l = 1000
        let i = 523//40
        var arr:[UInt64] = Array(repeating: 0, count: (l+63)/64)
        for j in 0..<arr.count{
            arr[j] = UInt64.random(in: 0...UInt64.max)
        }
        let u = UIntx(l,arr)
        var g = u
        var str = u.description
        measure {
            g = u<<<i
            // Put the code you want to measure the time of here.
        }
        str = String(str[str.index(str.endIndex, offsetBy: i-l)..<str.endIndex])+String(str[str.startIndex..<str.index(str.startIndex, offsetBy: i)])
        XCTAssertEqual(str, g.description)
    }

}
