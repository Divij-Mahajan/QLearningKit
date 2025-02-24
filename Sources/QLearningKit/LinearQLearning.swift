//
//  LinearQLearning.swift
//  QLearningKit
//
//  Created by divij mahajan on 15/02/25.
//

import Foundation

public class LinearQLearningAgent<State: Hashable & Codable, Action: Hashable & Codable> {
    public var weights: [Action: [Double]]
    public let actions: [Action]
    public var alpha: Double
    public var gamma: Double
    public var epsilon: Double
    public var numFeatures: Int
    public var featureExtractor: (State, Action) -> [Double]
    public var decay: Double
    public var isTrain: Bool
    private var actionMapping: [Action: String]
    public init(
        actions: [Action],
        numFeatures: Int,
        alpha: Double = 0.1,
        gamma: Double = 0.9,
        epsilon: Double = 0.1,
        featureExtractor: @escaping (State, Action) -> [Double],
        decay: Double = 1.0,
        isTrain: Bool = true
    ) {
        self.actions = actions
        self.numFeatures = numFeatures
        self.alpha = alpha
        self.gamma = gamma
        self.epsilon = epsilon
        self.featureExtractor = featureExtractor
        self.weights = [:]
        for action in actions {
            self.weights[action] = Array(repeating: 0.0, count: numFeatures)
        }
        self.decay=decay
        self.isTrain=isTrain
        let generatedMapping = Self.generateActionMapping(actions)
        self.actionMapping = generatedMapping
    }
    
    public static func generateActionMapping(_ actions: [Action]) -> [Action: String] {
        var mapping: [Action: String] = [:]
        
        for (index, action) in actions.enumerated() {
            mapping[action] = String(index + 1)  // Assign "1", "2", "3", ...
        }
        
        return mapping
    }

    
    public func getQValue(for state: State, action: Action) -> Double {
        let features = featureExtractor(state, action)
        let w = weights[action] ?? Array(repeating: 0.0, count: numFeatures)
        return zip(w, features).map(*).reduce(0, +)
    }
    
    public func getAction(for state: State) -> Action {
        
        if Double.random(in: 0...1) < epsilon && self.isTrain{
            return actions.randomElement()!
        } else {
            var bestAction = actions[0]
            var bestQ = getQValue(for: state, action: bestAction)
            for action in actions.shuffled() {
                let q = getQValue(for: state, action: action)
                  //print("\(action) \(q)")
                if q > bestQ {
                    bestQ = q
                    bestAction = action
                }
            }
            return bestAction
        }
    }
    
    public func updateQValue(for state: State, action: Action, reward: Double, nextState: State) {
        let regularization = 0.001
        let currentQ = getQValue(for: state, action: action)
        let maxNextQ = actions.map { getQValue(for: nextState, action: $0) }.max() ?? 0.0
        let error = reward + gamma * maxNextQ - currentQ
        let features = featureExtractor(state, action)
        var w = weights[action]!
        for i in 0..<numFeatures {
            w[i] += alpha * (error * features[i] - regularization * w[i])
        }
        self.epsilon=self.epsilon*self.decay
        weights[action] = w
    }
    
    
  
    public func saveWeights(to fileURL: URL) {
        let encoder = JSONEncoder()
        var stringKeyedWeights: [String: [Double]] = [:]
        
        for (action, weightValues) in weights {
            if let actionString = actionMapping[action] {
                stringKeyedWeights[actionString] = weightValues
            }
        }
        
        do {
            let data = try encoder.encode(stringKeyedWeights)
            try data.write(to: fileURL)
            print("Weights saved successfully at \(fileURL.path)")
        } catch {
            print("Error saving weights:", error.localizedDescription)
        }
    }
    
    public func loadWeights(from fileURL: URL) {
        let decoder = JSONDecoder()
        
        do {
            let data = try Data(contentsOf: fileURL)
            let stringKeyedWeights = try decoder.decode([String: [Double]].self, from: data)
            
            var loadedWeights: [Action: [Double]] = [:]
            for (actionString, weightValues) in stringKeyedWeights {
                if let action = actionMapping.first(where: { $0.value == actionString })?.key {
                    loadedWeights[action] = weightValues
                }
            }
            
            self.weights = loadedWeights
            print("Weights loaded successfully from \(fileURL.path)")
        } catch {
            print("Error loading weights:", error.localizedDescription)
        }
    }

    
}
