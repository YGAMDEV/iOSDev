//
//  SignpostingViewController.swift
//  YGAM
//
//  Created by Andrew Donnelly on 01/06/2018.
//  Copyright © 2018 Sky Betting and Gaming. All rights reserved.
//

import UIKit

class SignpostingViewController: UIViewController {

    public var questions: [Question]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        self.view.backgroundColor = UIColor.cyan
    }

    @IBAction func doneTapped(_ sender: Any) {
        self.dismiss(animated: true) {
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "QuestionSegue" {
            if let controller = segue.destination as? BubbleQuestionViewController {
                controller.questions = questions
            }
        }
    }
}
