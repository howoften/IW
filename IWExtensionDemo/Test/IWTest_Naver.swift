//
//  IWTest_Naver.swift
//  IWExtensionDemoTests
//
//  Created by iWw on 2018/4/14.
//  Copyright © 2018年 iWe. All rights reserved.
//

import XCTest
@testable import IWExtensionDemo

class IWTest_Naver: XCTestCase {
    
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
        
        testPush()
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}


extension IWTest_Naver {
    
    func testPush() {
        //IWNaver.shared.push(to: "naver://..")
        print("t13".matches("^t\\d+$") ? "是" : "否")
    }
    
}
