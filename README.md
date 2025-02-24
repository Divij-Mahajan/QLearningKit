
# **QLearningKit**  – A Swift Package for Q-Learning  

QLearningKit provides an easy-to-use implementation of **Q-learning** in Swift, offering two types of agents:  

- **Tabular Q-Learning Agent** – Best for small, discrete state spaces.  
- **Linear Q-Learning Agent** – Uses function approximation for handling large or continuous state spaces.  

This package allows **training, saving, and loading** models with minimal effort!  

## Installation
To use QLearningKit in your Swift project:  
1. Open Xcode and navigate to **File > Add Packages**.  
2. Enter the repository URL.  
3. Select the latest version and add it to your project.  

## Usage 

### **1.) Tabular Q-Learning Agent**  
The **TabularQLearningAgent** maintains a Q-table (`[State: [Action: Double]]`) and updates values using the Bellman equation.  

#### Create a Tabular Q-Learning Agent
```swift
let actions = ["left", "right", "up", "down"]
let agent = TabularQLearningAgent<String, String>(actions: actions, alpha: 0.1, gamma: 0.9, epsilon: 0.1)
```

#### Choose an Action (ε-greedy strategy) 
```swift
let state = "A"
let action = agent.chooseAction(for: state)
print("Chosen action:", action)
```

#### Update Q-Values
```swift
let reward = 10.0
let nextState = "B"
agent.updateQValue(for: state, action: action, reward: reward, nextState: nextState)
```

#### Save and Load Q-Table
```swift
let fileURL = URL(fileURLWithPath: "qtable.json")
agent.saveQTable(to: fileURL)
agent.loadQTable(from: fileURL)
```

---

### 2.) Linear Q-Learning Agent
The **LinearQLearningAgent** uses **function approximation** instead of a table. It represents Q-values using a weight vector and **feature extraction**.  

#### Create a Linear Q-Learning Agent
```swift
let actions = ["left", "right"]
let numFeatures = 3

func featureExtractor(state: String, action: String) -> [Double] {
    return state == "A" ? [1.0, 0.5, -1.2] : [-1.0, 1.2, 0.3]
}

let linearAgent = LinearQLearningAgent<String, String>(
    actions: actions, numFeatures: numFeatures,
    alpha: 0.1, gamma: 0.9, epsilon: 0.1,
    featureExtractor: featureExtractor
)
```

#### Choose an Action
```swift
let action = linearAgent.getAction(for: "A")
print("Chosen action:", action)
```

#### Save and Load Weights
```swift
let weightsURL = URL(fileURLWithPath: "weights.json")
linearAgent.saveWeights(to: weightsURL)
linearAgent.loadWeights(from: weightsURL)
```

---

## Features
-  **Tabular and Linear Q-Learning**  
-  **Save and Load Models**  
-  **Customizable Learning Rate & Exploration**  
-  **Train Models in Swift**  

---

