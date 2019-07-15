//
//  VKFriendsTests.swift
//  VK-CloneTests
//
//  Created by Artem Kufaev on 03/05/2019.
//  Copyright © 2019 Artem Kufaev. All rights reserved.
//

import XCTest
@testable import VK_Clone

class VKFriendsTests: XCTestCase {
    
    func testGetFriends() {
        let expectation = XCTestExpectation(description: "Get friends")
        VKService.shared.getFriends { data in
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
