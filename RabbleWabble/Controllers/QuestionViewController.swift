//
//  QuestionViewController.swift
//  RabbleWabble
//
//  Created by Emil on 11.03.23.
//

import UIKit

class QuestionViewController: UIViewController {
    
    public var questionGroup: QuestionGroup! {
      didSet {
        navigationItem.title = questionGroup.title
      }
    }
    public var questionIndex = 0
    public var correctCount = 0
    public var incorrectCount = 0
    public var questionView: QuestionView! {
        guard isViewLoaded else { return nil }
        return (view as! QuestionView)
    }
    private lazy var questionIndexItem: UIBarButtonItem = {
      let item = UIBarButtonItem(title: "",
                                 style: .plain,
                                 target: nil,
                                 action: nil)
      item.tintColor = .black
      navigationItem.rightBarButtonItem = item
      return item
    }()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        showQuestion()
    }
    private func showQuestion() {
        let question = questionGroup.questions[questionIndex]
        questionView.answerLabel.text = question.answer
        questionView.promptLabel.text = question.prompt
        questionView.hintLabel.text = question.hint
        questionView.answerLabel.isHidden = true
        questionView.hintLabel.isHidden = true
        questionIndexItem.title = "\(questionIndex + 1)/" +
        "\(questionGroup.questions.count)"
    }
    
    @IBAction func toggleAnswerLabels(_ sender: Any) {
        questionView.answerLabel.isHidden =
        !questionView.answerLabel.isHidden
        questionView.hintLabel.isHidden =
        !questionView.hintLabel.isHidden
    }
    
    // 1
    @IBAction func handleCorrect(_ sender: Any) {
        correctCount += 1
        questionView.correctCountLabel.text = "\(correctCount)"
        showNextQuestion()
    }
    // 2
    @IBAction func handleIncorrect(_ sender: Any) {
        incorrectCount += 1
        questionView.incorrectCountLabel.text = "\(incorrectCount)"
        showNextQuestion()
    }
    // 3
    private func showNextQuestion() {
        questionIndex += 1
        guard questionIndex < questionGroup.questions.count else { endQuiz(); return }
        showQuestion()
    }
    
    private func endQuiz() {
        let alertController = UIAlertController(title: "Quiz Complete", message: "You have answered all the questions in the quiz", preferredStyle: .alert)
        let restartAction = UIAlertAction(title: "Restart Quiz", style: .default) { [weak self] action in
            self?.questionIndex = 0
            self?.correctCount = 0
            self?.incorrectCount = 0
            self?.reloadView()
        }
        alertController.addAction(restartAction)
        present(alertController, animated: true, completion: nil)
    }
    
    private func reloadView() {
        let promptLabel = self.questionView.promptLabel
        let answerLabel = self.questionView.answerLabel
        let correctCountLabel = self.questionView.correctCountLabel
        let incorrectCountLabel = self.questionView.incorrectCountLabel
        
        let question = questionGroup.questions[questionIndex]
        promptLabel?.text = question.prompt
        answerLabel?.text = question.answer
        correctCountLabel?.text = "0"
        incorrectCountLabel?.text = "0"
    }
}
