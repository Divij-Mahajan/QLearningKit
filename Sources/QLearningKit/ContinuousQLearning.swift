/*
import Foundation

public class ContinuousQLearningAgent<State: Hashable & Codable> {
    public var weights: [[Double]]
    public let outputDimension: Int
    public let alpha: Double
    public let gamma: Double
    public let epsilon: Double
    public let numFeatures: Int
    public let featureExtractor: (State) -> [Double]
    public var isTrain: Bool
    public let actionMapping: (Double) -> Double
    
    public init(
        outputDimension: Int,
        numFeatures: Int,
        alpha: Double = 0.1,
        gamma: Double = 0.9,
        epsilon: Double = 0.1,
        featureExtractor: @escaping (State) -> [Double],
        actionMapping: @escaping (Double) -> Double
    ) {
        self.outputDimension = outputDimension
        self.numFeatures = numFeatures
        self.alpha = alpha
        self.gamma = gamma
        self.epsilon = epsilon
        self.featureExtractor = featureExtractor
        self.actionMapping = actionMapping
        self.weights = (0..<outputDimension).map { _ in
            (0..<numFeatures).map { _ in Double.random(in: -0.01...0.01) }
        }
        self.isTrain = true
    }
    
    public func getAction(for state: State, outputNumber: Int) -> Double {
        let features = featureExtractor(state)
        var output = zip(weights[outputNumber], features).map(*).reduce(0, +)
        output = min(5, max(-5, output))
        output = atan(output)
        
        if Double.random(in: 0...1) < epsilon {
            output = Double.random(in: -1...1)
        }
        
        return actionMapping(output)
    }
    
    public func getQValue(for state: State, outputNumber: Int) -> Double {
        let features = featureExtractor(state)
        var output = zip(weights[outputNumber], features).map(*).reduce(0, +)
        output = min(5, max(-5, output))
        output = atan(output)
        return output
    }
    
    public func updateWeights(for state: State, reward: Double, nextState: State, outputNumber: Int) {
        let features = featureExtractor(state)
        let currentQ = getQValue(for: state, outputNumber: outputNumber)
        let nextQ = getQValue(for: nextState, outputNumber: outputNumber)
        let error = reward + gamma * nextQ - currentQ
        
        for i in 0..<numFeatures {
            weights[outputNumber][i] += alpha * (error * features[i])
        }
    }
    
    public func saveWeights(to fileName: String) {
        let fileURL = getDocumentsDirectory().appendingPathComponent(fileName)
        let encoder = JSONEncoder()
        
        do {
            let data = try encoder.encode(weights)
            try data.write(to: fileURL)
            print("Weights saved successfully at \(fileURL.path)")
        } catch {
            print("Error saving weights:", error.localizedDescription)
        }
    }
    
    public func loadWeights(from fileName: String) {
        let fileURL = getDocumentsDirectory().appendingPathComponent(fileName)
        let decoder = JSONDecoder()
        
        do {
            let data = try Data(contentsOf: fileURL)
            self.weights = try decoder.decode([[Double]].self, from: data)
            print("Weights loaded successfully from \(fileURL.path)")
        } catch {
            print("Error loading weights:", error.localizedDescription)
        }
    }
    
    private func getDocumentsDirectory() -> URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
}

*/
