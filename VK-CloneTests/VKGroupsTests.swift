//
//  VK_CloneGroupsTests.swift
//  VK-CloneTests
//
//  Created by Artem Kufaev on 03/05/2019.
//  Copyright © 2019 Artem Kufaev. All rights reserved.
//

import XCTest
@testable import VK_Clone

class VK_CloneGroupsTests: XCTestCase {
    
    func testGetGroups() {
        let expectation = XCTestExpectation(description: "Get groups")
        VKService.shared.getGroups { data in
            switch(data.result) {
            case .success(let value):
                print(value)
                expectation.fulfill()
            case .failure(let error):
                print(error.localizedDescription)
                XCTFail()
                expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: 10.0)
    }
    
    func testSearchGroups() {
        let expectation = XCTestExpectation(description: "Search groups")
        VKService.shared.searchGroups(searchText: "Пикаб") { data in
            switch(data.result) {
            case .success(let value):
                print(value)
                expectation.fulfill()
            case .failure(let error):
                print(error.localizedDescription)
                XCTFail()
                expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: 10.0)
    }
    
    func testJoinAndLeaveGroup() {
        let expectation = XCTestExpectation(description: "Join and leave from group")
        VKService.shared.joinGroup(groupId: 31480508) { data in
            switch(data.result) {
            case .success(let value):
                print(value)
                VKService.shared.leaveGroup(groupId: 31480508) { data in
                    switch(data.result) {
                    case .success(let value):
                        print(value)
                        expectation.fulfill()
                    case .failure(let error):
                        print(error.localizedDescription)
                        XCTFail()
                        expectation.fulfill()
                    }
                }
            case .failure(let error):
                print(error.localizedDescription)
                XCTFail()
                expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: 10.0)
    }
    
}
