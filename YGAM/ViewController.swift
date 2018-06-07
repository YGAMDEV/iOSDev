//
//  ViewController.swift
//  YGAM
//
//  Created by Jon Fulton on 16/05/2018.
//  Copyright © 2018 Sky Betting and Gaming. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func startPressed(_ sender: UIButton) {
        let questionsRequest = QuestionsRequest()
        questionsRequest.createModel() { result in
            switch result {
            case .failure(let error):
                print("Failed: \(error)")
            case .success(let questionList):
                DispatchQueue.main.async {
                    self.showQuestions(questions: questionList.questions)
                }
            }
        }
    }
    
    private func showQuestions(questions: [Question]) {
        guard let navController = navigationController else {
            return
        }
        let questionViewController = BubbleQuestionViewController(navController: navController, questions: questions, nibName: "BubbleQuestionViewController", bundle: nil)
        navController.pushViewController(questionViewController, animated: true)
    }
}

