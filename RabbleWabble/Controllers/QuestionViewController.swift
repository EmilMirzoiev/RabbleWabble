//
//  QuestionViewController.swift
//  RabbleWabble
//
//  Created by Emil on 11.03.23.
//

import UIKit

protocol QuestionViewControllerDelegate: AnyObject {
    // Would be called when the user presses the Cancel button.
    func questionViewController(_ viewController: QuestionViewController,
                                didCancel questionGroup: QuestionStrategy)
    // Would be called when the user completes all of the questions.
    func questionViewController(_ viewController: QuestionViewController,
                                didComplete questionGroup: QuestionStrategy)
}

class QuestionViewController: UIViewController {
    
    public weak var delegate: QuestionViewControllerDelegate?
    
    public var questionStrategy: QuestionStrategy! {
        didSet {
            navigationItem.title = questionStrategy.title
        }
    }
    
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
        setupCancelButton()
        showQuestion()
    }
    
    private func setupCancelButton() {
        let action = #selector(handleCancelPressed(sender:))
        let image = UIImage(named: "ic_menu")
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: image,
                                                           landscapeImagePhone: nil,
                                                           style: .plain,
                                                           target: self,
                                                           action: action)
    }
    
    @objc private func handleCancelPressed(
      sender: UIBarButtonItem) { delegate?.questionViewController(self, didCancel: questionStrategy)
    }
    
    private func showQuestion() {
        let question = questionStrategy.currentQuestion()
        questionView.answerLabel.text = question.answer
        questionView.promptLabel.text = question.prompt
        questionView.hintLabel.text = question.hint
        questionView.answerLabel.isHidden = true
        questionView.hintLabel.isHidden = true
        questionIndexItem.title = questionStrategy.questionIndexTitle()
    }
    
    @IBAction func toggleAnswerLabels(_ sender: Any) {
        questionView.answerLabel.isHidden =
        !questionView.answerLabel.isHidden
        questionView.hintLabel.isHidden =
        !questionView.hintLabel.isHidden
    }
    
    @IBAction func handleCorrect(_ sender: Any) {
        let question = questionStrategy.currentQuestion()
        questionStrategy.markQuestionCorrect(question)
        questionView.correctCountLabel.text = String(questionStrategy.correctCount)
        showNextQuestion()
    }
    
    @IBAction func handleIncorrect(_ sender: Any) {
        let question = questionStrategy.currentQuestion()
        questionStrategy.markQuestionIncorrect(question)
        questionView.incorrectCountLabel.text = String(questionStrategy.incorrectCount)
        showNextQuestion()
    }
    
    private func showNextQuestion() {
        guard questionStrategy.advanceToNextQuestion() else {
            delegate?.questionViewController(self, didComplete: questionStrategy)
            return
        }
        showQuestion()
    }
    
    private func endQuiz() {
//        delegate?.questionViewController(self, didComplete: questionGroup)
        let alertController = UIAlertController(title: "Quiz Complete",
                                                message: "You have answered all the questions in the quiz",
                                                preferredStyle: .alert)
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


