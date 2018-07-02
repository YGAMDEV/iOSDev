//
//  DashboardViewController.swift
//  YGAM
//
//  Created by Andrew Donnelly on 01/06/2018.
//  Copyright © 2018 Sky Betting and Gaming. All rights reserved.
//

import UIKit

class DashboardViewController: UIViewController {

    private var questions: [Question]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let questionsRequest = QuestionsRequest()
        questionsRequest.createModel() { result in
            switch result {
            case .failure(let error):
                print("Failed: \(error)")
            case .success(let questionList):
                self.questions = questionList.questions
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "QuestionSegue":
            if let controller = segue.destination as? BubbleQuestionViewController {
                controller.questions = questions
            }
        case "SignpostSegue":
            if let controller = segue.destination.childViewControllers.first as? SignpostingViewController {
                controller.questions = questions
            }
        default:
            break
        }
    }
    
    @IBAction func unwindToDashboard(segue: UIStoryboardSegue) {
    
    }
}
