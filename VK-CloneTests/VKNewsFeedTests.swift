//
//  VKNewsFeedTests.swift
//  VK-CloneTests
//
//  Created by Artem Kufaev on 03/05/2019.
//  Copyright © 2019 Artem Kufaev. All rights reserved.
//

import XCTest
@testable import VK_Clone

class VKNewsFeedTests: XCTestCase {
    
    func testGetNewsFeed() {
        let expectation = XCTestExpectation(description: "Get news feed")
        VKService.shared.getNewsFeed(count: 100) { data in
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
    
    func testLikeAndDislike() {
        let expectation = XCTestExpectation(description: "Like and dislike")
        VKService.shared.addLike(type: .post, itemId: 45546, authorId: 1) { data in
            switch(data.result) {
            case .success(let value):
                print(value)
                VKService.shared.deleteLike(type: .post, itemId: 45546, authorId: 1) { data in
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
    
    func testPostWall() {
        let expectation = XCTestExpectation(description: "Post wall")
        VKService.shared.postWall(message: "New post on my wall via my app.", place: nil) { data in
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
