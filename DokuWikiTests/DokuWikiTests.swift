//
//  DokuWikiTests.swift
//  DokuWikiTests
//
//  Created by Connor Temple on 12/11/18.
//  Copyright © 2018 Connor Temple. All rights reserved.
//

import XCTest
import SWXMLHash
@testable import DokuWiki

class DokuWikiTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
			let api = DokuWiki(session: URLSession.shared, xmlRPC: URL(string: "http://localhost:7776/lib/exe/xmlrpc.php")!, auth: "Basic c3VwZXJ1c2VyOmJpdG5hbWkx")
			api.getPagelist(namespace: "", depth: 0) { data, err in
				guard err == nil else {
					print(err!)
					return
				}
				guard let data = data else {
					print("err")
					return
				}
		
				print(data)
			}
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
