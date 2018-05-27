//
//  ViewController.swift
//  YGAM
//
//  Created by Jon Fulton on 16/05/2018.
//  Copyright © 2018 Sky Betting and Gaming. All rights reserved.
//

import UIKit

protocol CoordinatorDelegate: AnyObject {
    func coordinatorCompleted()
}

class ViewController: UIViewController {
    
    var questionsCoordinator: QuestionCoordinator?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func startPressed(_ sender: UIButton) {
        guard let navController = navigationController else {
            return
        }
        questionsCoordinator = QuestionCoordinator(rootViewController: navController)
        questionsCoordinator?.delegate = self
        questionsCoordinator!.start()
    }
}

extension ViewController: CoordinatorDelegate {
    func coordinatorCompleted() {
        navigationController?.popToViewController(self, animated: true)
        questionsCoordinator = nil
    }
}
