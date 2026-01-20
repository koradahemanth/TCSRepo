//
//  EndpointTests.swift
//  ApplicationSampleTests
//
//  Created by Murali on 20/01/26.
//

import Foundation

import XCTest
@testable import ApplicationSample

final class EndpointTests: XCTestCase {

    func test_usersEndpointURL() {
        // Given
        let endpoint = EndPoint.users

        // When
        let url = endpoint.url

        // Then
        XCTAssertNotNil(url)
        XCTAssertEqual(
            url?.absoluteString,
            "https://jsonplaceholder.typicode.com/users"
        )
    }
}
