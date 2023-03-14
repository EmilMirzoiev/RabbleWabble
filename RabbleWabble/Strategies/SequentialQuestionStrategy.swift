//
//  SequentialQuestionStrategy.swift
//  RabbleWabble
//
//  Created by Emil on 13.03.23.
//

import Foundation

public class SequentialQuestionStrategy: QuestionStrategy {
    
    // MARK: - Properties
    public var correctCount: Int {
      get { return questionGroup.score.correctCount }
      set { questionGroup.score.correctCount = newValue }
    }
    public var incorrectCount: Int {
      get { return questionGroup.score.incorrectCount }
      set { questionGroup.score.incorrectCount = newValue }
    }
    private let questionGroup: QuestionGroup
    private var questionIndex = 0
    
    // MARK: - Object Lifecycle
    public init(questionGroup: QuestionGroup) {
        self.questionGroup = questionGroup
    }
    
    // MARK: - QuestionStrategy
    public var title: String {
        return questionGroup.title
    }
    public func currentQuestion() -> Question {
        return questionGroup.questions[questionIndex]
    }
    public func advanceToNextQuestion() -> Bool {
        guard questionIndex + 1 < questionGroup.questions.count else { return false }
        questionIndex += 1
        return true
    }
    public func markQuestionCorrect(_ question: Question) {
        correctCount += 1
    }
    public func markQuestionIncorrect(_ question: Question) {
        incorrectCount += 1
    }
    public func questionIndexTitle() -> String {
        return "\(questionIndex + 1)/" + "\(questionGroup.questions.count)"
    }
}
