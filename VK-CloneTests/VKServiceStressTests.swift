//
//  VKServiceStressTests.swift
//  VK-CloneTests
//
//  Created by Artem Kufaev on 05/05/2019.
//  Copyright © 2019 Artem Kufaev. All rights reserved.
//

import XCTest
@testable import VK_Clone

class VKServiceStressTests: XCTestCase {
    
    let requestsCount = 160
    let time = 60.0
    
    func testStress() {
        let expectation = XCTestExpectation(description: "Stress test")
        VKService.shared.start()
        for index in 1...requestsCount {
            VKService.shared.getCurrentUser { data in
                switch(data.result) {
                case .success(_): print("\(index) task completed")
                case .failure(let error):
                    print(error.localizedDescription)
                    XCTFail()
                    expectation.fulfill()
                }
                if (index == self.requestsCount) {
                    expectation.fulfill()
                }
            }
        }
        wait(for: [expectation], timeout: time)
    }
    
}
