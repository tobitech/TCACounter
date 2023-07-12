//
//  CounterFeature.swift
//  TCACounter
//
//  Created by Oluwatobi Omotayo on 12/07/2023.
//

import ComposableArchitecture
import SwiftUI

struct CounterFeature: ReducerProtocol {
	struct State: Equatable {
		var count = 0
	}
	
	enum Action: Equatable {
		case decrementButtonTapped
		case incrementButtonTapped
	}
	
	
	func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
		switch action {
		case .decrementButtonTapped:
			state.count -= 1
			return .none
			
		case .incrementButtonTapped:
			state.count += 1
			return .none
		}
	}
}

struct CounterView: View {
	let store: StoreOf<CounterFeature>
	
	var body: some View {
		WithViewStore(self.store, observe: { $0 }) { viewStore in
			VStack {
				Text("\(viewStore.count)")
					.font(.largeTitle)
					.padding()
					.background(Color.black.opacity(0.1))
					.cornerRadius(10)
				HStack {
					Button("-") {
						viewStore.send(.decrementButtonTapped)
					}
					.font(.largeTitle)
					.padding()
					.background(Color.black.opacity(0.1))
					.cornerRadius(10)
					
					Button("+") {
						viewStore.send(.incrementButtonTapped)
					}
					.font(.largeTitle)
					.padding()
					.background(Color.black.opacity(0.1))
					.cornerRadius(10)
				}
			}
		}
	}
}

struct CounterPreview: PreviewProvider {
	static var previews: some View {
		CounterView(
			store: Store(initialState: CounterFeature.State()) {
				CounterFeature()
			}
		)
	}
}
