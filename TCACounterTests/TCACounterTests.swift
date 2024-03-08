//
//  TCACounterTests.swift
//  TCACounterTests
//
//  Created by Tobi Omotayo on 08/03/2024.
//

import ComposableArchitecture
@testable import TCACounter
import XCTest

@MainActor
final class TCACounterTests: XCTestCase {
	func testCounter() async {
		let store = TestStore(initialState: CounterFeature.State()) {
			CounterFeature()
		}
		
		await store.send(.incrementButtonTapped) {
			$0.count = 1
		}
		await store.send(.decrementButtonTapped) {
			$0.count = 0
		}
	}
}
