//
//  VKPhotosTests.swift
//  VK-CloneTests
//
//  Created by Artem Kufaev on 05/05/2019.
//  Copyright © 2019 Artem Kufaev. All rights reserved.
//

import XCTest
@testable import VK_Clone

class VKPhotosTests: XCTestCase {
    
    let requestsCount = 160
    let time = 60.0
    
    func testGetPhotos() {
        let expectation = XCTestExpectation(description: "Get photos")
        
        VKService.shared.getOwnerPhotos { data in
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
        
        wait(for: [expectation], timeout: time)
    }
    
}
