//
//  TCACounterApp.swift
//  TCACounter
//
//  Created by Oluwatobi Omotayo on 12/07/2023.
//

import ComposableArchitecture
import SwiftUI

@main
struct TCACounterApp: App {
	static let store = Store(initialState: CounterFeature.State()) {
		CounterFeature()
			._printChanges()
	}

	var body: some Scene {
		WindowGroup {
			CounterView(
				store: TCACounterApp.store
			)
		}
	}
}
