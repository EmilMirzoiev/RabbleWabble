//
//  AppSettings.swift
//  RabbleWabble
//
//  Created by Emil on 13.03.23.
//

import Foundation

public class AppSettings {
    // MARK: - Keys
    private struct Keys {
        static let questionStrategy = "questionStrategy"
    }
    
    // MARK: - Instance Properties
    public var questionStrategyType: QuestionStrategyType {
        get {
            let rawValue = userDefaults.integer(forKey: Keys.questionStrategy)
            return QuestionStrategyType(rawValue: rawValue)!
        } set {
            userDefaults.set(newValue.rawValue, forKey: Keys.questionStrategy)
        }
    }
    
    private let userDefaults = UserDefaults.standard
    
    // MARK: - Static Properties
    public static let shared = AppSettings()
    
    // MARK: - Object Lifecycle
    private init() { }
    
    // MARK: - Instance Methods
    public func questionStrategy(for questionGroupCaretaker: QuestionGroupCaretaker) -> QuestionStrategy {
        return questionStrategyType.questionStrategy(for: questionGroupCaretaker)
    }
}

// MARK: - QuestionStrategyType
public enum QuestionStrategyType: Int, CaseIterable {
    case random
    case sequential
    
    // MARK: - Instance Methods
    public func title() -> String {
        switch self {
        case .random:
            return "Random"
        case .sequential:
            return "Sequential"
        }
    }
    
    public func questionStrategy(for questionGroupCaretaker: QuestionGroupCaretaker) -> QuestionStrategy {
        switch self {
        case .random:
            return RandomQuestionStrategy(questionGroupCaretaker: questionGroupCaretaker)
        case .sequential:
            return SequentialQuestionStrategy(questionGroupCaretaker: questionGroupCaretaker)
        }
    }
}
