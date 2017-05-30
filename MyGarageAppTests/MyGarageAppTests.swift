//
//  MyGarageAppTests.swift
//  MyGarageAppTests
//
//  Created by Stefano Pedroli on 18/04/17.
//  Copyright © 2017 Stefano Pedroli. All rights reserved.
//

import XCTest
@testable import MyGarageApp

class MyGarageAppTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testLogin() {
        
        let expect = expectation(description: "...")
        
        let a = AutenticationService(user: "Stelive", password: "Admin")
        a.checkUser() { result in
            XCTAssert(result == true)
            XCTAssertTrue(result, "result deve essere true")
            
            
            expect.fulfill()
        }
        
        waitForExpectations(timeout: 5) { error in
            // ...
        }
        
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
