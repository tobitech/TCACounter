//
//  CounterFeature.swift
//  TCACounter
//
//  Created by Oluwatobi Omotayo on 12/07/2023.
//

import ComposableArchitecture
import SwiftUI

@Reducer
struct CounterFeature: Reducer {
	@ObservableState
	struct State: Equatable {
		var count = 0
	}
	
	enum Action: Equatable {
		case decrementButtonTapped
		case incrementButtonTapped
	}
	
	var body: some ReducerOf<Self> {
		Reduce { state, action in
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
}

struct CounterView: View {
	let store: StoreOf<CounterFeature>
	
	var body: some View {
		WithPerceptionTracking {
			VStack {
				Text("\(store.count)")
					.font(.largeTitle)
					.padding()
					.background(Color.black.opacity(0.1))
					.cornerRadius(10)
				HStack {
					Button("-") {
						store.send(.decrementButtonTapped)
					}
					.font(.largeTitle)
					.padding()
					.background(Color.black.opacity(0.1))
					.cornerRadius(10)
					
					Button("+") {
						store.send(.incrementButtonTapped)
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
