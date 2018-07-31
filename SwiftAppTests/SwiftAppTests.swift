//
//  SwiftAppTests.swift
//  SwiftAppTests
//
//  Created by Harshini Lakshmi on 23/07/18.
//  Copyright © 2018 Harshini Lakshmi. All rights reserved.
//

import XCTest
import Alamofire
import SwiftyJSON
@testable import SwiftApp

class SwiftAppTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testLoadJson() {
        let apiUrl = URL(string: "https://dl.dropboxusercontent.com/s/2iodh4vg0eortkl/facts.json")
        let expectationDict = expectation(description: "Dictonary exists")
        NetworkResource.sharedInstance.serviceCall(requestURL: apiUrl!) { (finalDict) in
            XCTAssertNotNil(finalDict)
            expectationDict.fulfill()
        }
        
        waitForExpectations(timeout: 5) { error in
            if let error = error {
                XCTFail("waitForExpectationsWithTimeout errored: \(error)")
            }
        }
    }
    
    func testLoadJsonNegative() {

        let expectationNoDict = expectation(description: "Dictonary doesn't exists")
        NetworkResource.sharedInstance.serviceCall(requestURL: URL(string: "https://dl.dropboxusercontent.com/s/2iodh4vg0eortkl/facts.json")!) { (finalDict) in
            var dict: NSMutableDictionary? = finalDict
            dict = nil
            XCTAssertNil(dict)
            expectationNoDict.fulfill()
        }
        waitForExpectations(timeout: 5) { error in
            if let error = error {
                XCTFail("waitForExpectationsWithTimeout errored: \(error)")
            }
        }
    }
}
