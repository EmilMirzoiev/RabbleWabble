//
//  QuestionStrategy.swift
//  RabbleWabble
//
//  Created by Emil on 13.03.23.
//

import Foundation
public protocol QuestionStrategy: AnyObject {
    //title will be the title for which set of questions is selected, such as "Basic Phrases."
    var title: String { get }
    
    //correctCount and incorrectCount will return the current number of correct and incorrect questions, respectively.
    var correctCount: Int { get }
    var incorrectCount: Int { get }
    
    //advanceToNextQuestion() will be used to move onto the next question. If there isn’t a next question available, this method will return false. Otherwise, it will return true.
    func advanceToNextQuestion() -> Bool
    
    //currentQuestion() will simply return the current question. Since advanceToNextQuestion() will prevent the user from advancing beyond the available questions, currentQuestion() will always return a Question and never be nil.
    func currentQuestion() -> Question
    
    //As their method names imply, markQuestionCorrect(_:) will mark a question correct, and markQuestionIncorrect(_:) will mark a question incorrect.
    func markQuestionCorrect(_ question: Question)
    func markQuestionIncorrect(_ question: Question)
    
    //questionIndexTitle() will return the “index title” for the current question to indicate progress, such as "1 / 10" for the first question out of ten total.
    func questionIndexTitle() -> String
}

