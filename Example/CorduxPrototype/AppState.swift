//
//  AppState.swift
//  CorduxPrototype
//
//  Created by Ian Terrell on 7/21/16.
//  Copyright © 2016 WillowTree. All rights reserved.
//

import Foundation
import Cordux

typealias Store = Cordux.Store<AppState>

struct AppState: StateType {
    var route: Route = []
    var name: String = "Hello"
    var authenticationState: AuthenticationState = .unauthenticated
}

enum AuthenticationState {
    case unauthenticated
    case authenticated
}

enum AuthenticationAction: Action {
    case signIn
    case signOut
}

struct Noop: Action {}

final class AppReducer: Reducer {
    func handleAction(_ action: Action, state: AppState) -> AppState {
        var state = state
        state = reduceAuthentication(action, state: state)
        return state
    }

    func reduceAuthentication(_ action: Action, state: AppState) -> AppState {
        guard let action = action as? AuthenticationAction else {
            return state
        }

        var state = state

        switch action {
        case .signIn:
            state.route = ["catalog"]
            state.authenticationState = .authenticated
        case .signOut:
            state.route = ["auth"]
            state.authenticationState = .unauthenticated
        }

        return state
    }
}

final class ActionLogger: Middleware {
    func before(action: Action, state: AppState) {
        print("Before: \(action): \(state)")
    }
    func after(action: Action, state: AppState) {
        print("After: \(action): \(state)")
    }
}
