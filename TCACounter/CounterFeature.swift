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
		var fact: String?
		var isLoading = false
		var isTimerRunning = false
	}
	
	enum Action: Equatable {
		case decrementButtonTapped
		case factButtonTapped
		case factResponse(String)
		case incrementButtonTapped
		case timerTick
		case toggleTimerButtonTapped
	}
	
	enum CancelID { case timer }
	
	var body: some ReducerOf<Self> {
		Reduce { state, action in
			switch action {
			case .decrementButtonTapped:
				state.count -= 1
				state.fact = nil
				return .none
				
			case .factButtonTapped:
				state.fact = nil
				state.isLoading = true
				return .run { [count = state.count] send in
					let (data, _) = try await URLSession.shared
						.data(from: URL(string: "http://numbersapi.com/\(count)")!)
					let fact = String(decoding: data, as: UTF8.self)
					await send(.factResponse(fact))
				}
				
			case let .factResponse(fact):
				state.fact = fact
				state.isLoading = false
				return .none
				
			case .incrementButtonTapped:
				state.count += 1
				state.fact = nil
				return .none
				
			case .timerTick:
				state.count += 1
				state.fact = nil
				return .none
				
			case .toggleTimerButtonTapped:
				state.isTimerRunning.toggle()
				if state.isTimerRunning {
					return .run { send in
						while true {
							try await Task.sleep(for: .seconds(1))
							await send(.timerTick)
						}
					}
					.cancellable(id: CancelID.timer)
				} else {
					return .cancel(id: CancelID.timer)
				}
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
				
				Button(store.isTimerRunning ? "Stop timer" : "Start timer") {
					store.send(.toggleTimerButtonTapped)
				}
				.font(.largeTitle)
				.padding()
				.background(Color.black.opacity(0.1))
				.cornerRadius(10)
				
				Button("Fact") {
					store.send(.factButtonTapped)
				}
				.font(.largeTitle)
				.padding()
				.background(Color.black.opacity(0.1))
				.cornerRadius(10)
			}
			
			if store.isLoading {
				ProgressView()
			} else if let fact = store.fact {
				Text(fact)
					.font(.largeTitle)
					.multilineTextAlignment(.center)
					.padding()
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
