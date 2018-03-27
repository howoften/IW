//
//  IWTest_KeyChain.swift
//  IWExtensionDemoTests
//
//  Created by iWw on 2018/3/18.
//  Copyright © 2018年 iWe. All rights reserved.
//

import XCTest
@testable import IWExtensionDemo

class IWTest_KeyChain: XCTestCase {
    
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
        testAdd()
        testLoad()
        testUpdate()
        testLoad()
        testDelete()
        testLoad()
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}

extension IWTest_KeyChain {
    
    func testAdd() -> Void {
        print("添加Keyhain service: homepage -> https://www.iwecon.cc")
        IWKeyChainManager.save(service: "homepage", value: "https://github.com/iwecon")
    }
    
    func testLoad() -> Void {
        guard let result = IWKeyChainManager.loadString(service: "homepage") else {
            assertionFailure("没有取到值")
            return
        }
        print("值为: \(result)")
    }
    
    func testUpdate() -> Void {
        print("更新Keyhain service: homepage -> https://www.iwecon.cc")
        IWKeyChainManager.update(service: "homepage", value: "https://www.iwecon.cc")
    }
    
    func testDelete() -> Void {
        print("删除Keyhain service: homepage")
        IWKeyChainManager.delete(service: "homepage")
    }
    
    
}
