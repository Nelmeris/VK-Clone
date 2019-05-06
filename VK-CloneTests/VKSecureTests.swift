//
//  VKSecureTests.swift
//  VK-CloneTests
//
//  Created by Artem Kufaev on 03/05/2019.
//  Copyright © 2019 Artem Kufaev. All rights reserved.
//

import XCTest
@testable import VK_Clone

class VKSecureTests: XCTestCase {
    
    func testGetAccessToken() {
        let expectation = XCTestExpectation(description: "Get access token")
        VKTokenService.shared.get() { token in
            print(token)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 180.0)
    }
    
    func testCheckToken() {
        let expectation = XCTestExpectation(description: "Check valid access token")
        VKTokenService.shared.get() { token in
            VKService.shared.checkToken(token: token) { data in
                guard let data = data.value else {
                    XCTFail()
                    expectation.fulfill()
                    return
                }
                print(data)
                expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: 10.0)
    }
    
}
