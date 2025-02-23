//
//  TabularQLearning.swift
//  QLearningKit
//
//  Created by divij mahajan on 15/02/25.
//

import Foundation

public class TabularQLearningAgent<State: Hashable & Codable, Action: Hashable & Codable> {
    public var Q: [State: [Action: Double]] = [:]
    public let actions: [Action]
    public var alpha: Double
    public var gamma: Double
    public var epsilon: Double
    private var actionMapping: [Action: String]

    public init(actions: [Action], alpha: Double = 0.1, gamma: Double = 0.9, epsilon: Double = 0.1) {
        self.actions = actions
        self.alpha = alpha
        self.gamma = gamma
        self.epsilon = epsilon
        self.actionMapping = Self.generateActionMapping(actions)
    }

    public static func generateActionMapping(_ actions: [Action]) -> [Action: String] {
        var mapping: [Action: String] = [:]
        for (index, action) in actions.enumerated() {
            mapping[action] = String(index + 1)
        }
        return mapping
    }

    public func getQValue(for state: State, action: Action) -> Double {
        return Q[state]?[action] ?? 0.0
    }

    public func chooseAction(for state: State) -> Action {
        if Double.random(in: 0...1) < epsilon {
            return actions.randomElement()! // Exploration
        } else {
            guard let actionValues = Q[state], let maxQ = actionValues.values.max() else {
                return actions.randomElement()!
            }
            return actions.first { getQValue(for: state, action: $0) == maxQ } ?? actions.randomElement()!
        }
    }

    public func updateQValue(for state: State, action: Action, reward: Double, nextState: State) {
        let maxNextQ = Q[nextState]?.values.max() ?? 0.0
        let currentQ = getQValue(for: state, action: action)
        let newQ = currentQ + alpha * (reward + gamma * maxNextQ - currentQ)

        if Q[state] == nil {
            Q[state] = [:]  // Initialize if it doesn't exist
        }
        Q[state]![action] = newQ
    }

    public func train(
        episodes: Int,
        initialState: () -> State,
        getNextState: (State, Action) -> State,
        getReward: (State, Action, State) -> Double,
        isTerminal: (State) -> Bool
    ) {
        for _ in 0..<episodes {
            var state = initialState()
            var step = 0
            while !isTerminal(state) && step < 1000 {
                let action = chooseAction(for: state)
                let nextState = getNextState(state, action)
                let reward = getReward(state, action, nextState)

                updateQValue(for: state, action: action, reward: reward, nextState: nextState)

                state = nextState
                step += 1
            }
        }
    }

    public func saveQTable(to fileURL: URL) {
        let encoder = JSONEncoder()
        var stringKeyedQTable: [String: [String: Double]] = [:]

        for (state, actionDict) in Q {
            let encodedState = try? encoder.encode(state)
            if let stateString = encodedState?.base64EncodedString() {
                var stringKeyedActions: [String: Double] = [:]
                for (action, value) in actionDict {
                    if let actionString = actionMapping[action] {
                        stringKeyedActions[actionString] = value
                    }
                }
                stringKeyedQTable[stateString] = stringKeyedActions
            }
        }

        do {
            let data = try encoder.encode(stringKeyedQTable)
            try data.write(to: fileURL)
            print("Q-table saved successfully at \(fileURL.path)")
        } catch {
            print("Error saving Q-table:", error.localizedDescription)
        }
    }

    public func loadQTable(from fileURL: URL) {
        let decoder = JSONDecoder()

        do {
            let data = try Data(contentsOf: fileURL)
            let stringKeyedQTable = try decoder.decode([String: [String: Double]].self, from: data)

            var loadedQTable: [State: [Action: Double]] = [:]
            for (stateString, actionDict) in stringKeyedQTable {
                if let decodedStateData = Data(base64Encoded: stateString),
                   let decodedState = try? decoder.decode(State.self, from: decodedStateData) {
                    var actionValueDict: [Action: Double] = [:]
                    for (actionString, value) in actionDict {
                        if let action = actionMapping.first(where: { $0.value == actionString })?.key {
                            actionValueDict[action] = value
                        }
                    }
                    loadedQTable[decodedState] = actionValueDict
                }
            }

            self.Q = loadedQTable
            print("Q-table loaded successfully from \(fileURL.path)")
        } catch {
            print("Error loading Q-table:", error.localizedDescription)
        }
    }
}
