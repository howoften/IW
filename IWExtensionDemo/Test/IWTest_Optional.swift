//
//  IWTest_Optional.swift
//  IWExtensionDemoTests
//
//  Created by iWw on 2018/6/22.
//  Copyright © 2018 iWe. All rights reserved.
//

import XCTest
@testable import IWExtensionDemo

class IWTest_Optional: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        let str: String = "https://www.iwecon.cc/p.php?id=123"
        print(str.getParameterValue(exactName: "id").orEmpty)
        print(str.getParameterValue(fuzzyName: ["ids", "id"]).orEmpty)
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
