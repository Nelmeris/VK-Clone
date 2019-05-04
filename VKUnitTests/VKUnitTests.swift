//
//  VKUnitTests.swift
//  VKUnitTests
//
//  Created by Artem Kufaev on 03/05/2019.
//  Copyright © 2019 NONE. All rights reserved.
//

import XCTest

@testable import VK_X
class VKUnitTests: XCTestCase {
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testGetGroups() {
        let expectation = XCTestExpectation(description: "Change user data")
        VKService.shared.getGroups { data in
            guard let data = data.value else {
                XCTFail()
                return
            }
            print(data)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 10.0)
    }
    
    func testJoinAndLeaveGroup() {
        let expectation = XCTestExpectation(description: "Change user data")
        VKService.shared.joinGroup(groupId: 31480508) { data in
            guard let data = data.value else {
                XCTFail()
                return
            }
            print(data)
            VKService.shared.leaveGroup(groupId: 31480508) { data in
                guard let data = data.value else {
                    XCTFail()
                    return
                }
                print(data)
                expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: 10.0)
    }
    
    func testGetFriends() {
        let expectation = XCTestExpectation(description: "Change user data")
        VKService.shared.getFriends { data in
            guard let data = data.value else {
                XCTFail()
                return
            }
            print(data)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 10.0)
    }
    
    func testGetNewsFeed() {
        let expectation = XCTestExpectation(description: "Change user data")
        VKService.shared.getNewsFeed(type: .post, count: 1) { data in
            guard let data = data.value else {
                XCTFail()
                return
            }
            print(data)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 10.0)
    }
    
    func testGetDialogs() {
        let expectation = XCTestExpectation(description: "Change user data")
        VKService.shared.getDialogs { data in
            guard let data = data.value else {
                XCTFail()
                return
            }
            print(data)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 10.0)
    }
    
    func testLikeAndDislike() {
        let expectation = XCTestExpectation(description: "Change user data")
        VKService.shared.addLike(type: .post, itemId: 1124498, authorId: -31976785) { data in
            guard let data = data.value else {
                XCTFail()
                return
            }
            print(data)
            VKService.shared.deleteLike(type: .post, itemId: 1124498, authorId: -31976785) { data in
                guard let data = data.value else {
                    XCTFail()
                    return
                }
                print(data)
                expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: 10.0)
    }
    
    func testCheckToken() {
        let expectation = XCTestExpectation(description: "Change user data")
        VKService.shared.checkToken { data in
            guard let data = data.value else {
                XCTFail()
                return
            }
            print(data)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 10.0)
    }
    
}
