//
//  VKUsersTests.swift
//  VK-CloneTests
//
//  Created by Artem Kufaev on 03/05/2019.
//  Copyright © 2019 Artem Kufaev. All rights reserved.
//

import XCTest
@testable import VK_Clone

class VKUsersTests: XCTestCase {
    
    func testGetCurrentUser() {
        let expectation = XCTestExpectation(description: "Get current user info")
        VKService.shared.getCurrentUser { data in
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
    
    func testGetUsers() {
        let expectation = XCTestExpectation(description: "Get users")
        VKService.shared.getUsers(userIds: [1, 10, 313, 360130240]) { data in
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
    
}
