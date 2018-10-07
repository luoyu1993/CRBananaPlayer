//
//  CRAudioTests.swift
//  CRBananerPlayerTests
//
//  Created by CRMO on 2018/2/4.
//  Copyright © 2018年 CRMO. All rights reserved.
//

import XCTest
@testable import CRBananerPlayer

class CRAudioTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testInitWithPath() {
        let path1 = "errorPath"
        let audio1 = CRAudio(path: path1)
        XCTAssert(path1 == audio1.name)
        
        let path2 = "/var/folders/mj/Session-CRBananerPlayerTests-2018-02-04_231829-X5dBHc.log"
        let name2 = "Session-CRBananerPlayerTests-2018-02-04_231829-X5dBHc.log"
        let audio2 = CRAudio(path: path2)
        XCTAssert(name2 == audio2.name)
        
        let path3 = "/var/folders/mj.txt/"
        let name3 = ""
        let audio3 = CRAudio(path: path3)
        XCTAssert(name3 == audio3.name)
    }
}
