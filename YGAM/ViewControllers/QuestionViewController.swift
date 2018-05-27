//
//  QuestionViewController.swift
//  YGAM
//
//  Created by Jon Fulton on 26/05/2018.
//  Copyright © 2018 Sky Betting and Gaming. All rights reserved.
//

import UIKit

class QuestionViewController: UIViewController {

    public var question: Question
    public weak var delegate: QuestionCoordinatorDelegate?
    
    private var answers = [Answer]()
    private var nudged = false
    
    struct Constants {
        static let QuestionCollectionViewCell = "QuestionCollectionViewCell"
    }
    
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var answerCollectionView: UICollectionView!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var infoLabel: UILabel!
    
    init(question: Question, nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        self.question = question
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        answerCollectionView.register(UINib(nibName: Constants.QuestionCollectionViewCell, bundle: nil), forCellWithReuseIdentifier: Constants.QuestionCollectionViewCell)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        questionLabel.text = question.text
        answerCollectionView.allowsMultipleSelection = question.type == .multi
    }
    
    @IBAction func nextPressed(_ sender: UIButton) {
        
        guard let selectedItems = answerCollectionView.indexPathsForSelectedItems else {
            return
        }

        // Check Min Selection
        if let minSelections = question.minSelections {
            if selectedItems.count < minSelections {
                infoLabel.text = "You need to select at least \(minSelections) answer(s)"
                return
            }
        }
        
        // Save the answers
        answers = selectedItems.map { question.answers![$0.row] }
        
        // Check for any nudges
        if let nudge = question.nudge {
            let filter = answers.filter() { nudge.trigger.contains($0.text) }
            let textAnswers = selectedItems.map { question.answers![$0.row].text }
                if nudge.trigger == textAnswers || filter.count > 0 {
                // Check the users answers against the triggers
                infoLabel.text = nudge.text
                if nudged {
                    delegate?.didFinish(questionID: question.id, answer: answers, action: nudge.confirmedAction)
                } else {
                    infoLabel.text = nudge.text
                    nudged = true
                }
                return
            }
        }
        
        // Single answer question - action is associated with the selected answer
        if question.type == .single, let answerIndex = selectedItems.first?.row, let action = question.answers![answerIndex].action {
            delegate?.didFinish(questionID: question.id, answer: answers, action: action)
            return
        }
        
        delegate?.didFinish(questionID: question.id, answer: answers, action: question.completeAction)
    }
}

extension QuestionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let cellCount = question.answers?.count else {
            return 0
        }
        return cellCount
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.QuestionCollectionViewCell, for: indexPath) as! QuestionCollectionViewCell

        cell.answerLabel.text = question.answers![indexPath.row].text
        return cell
    }
}

extension QuestionViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        nextButton.isHidden = false
    }
}
