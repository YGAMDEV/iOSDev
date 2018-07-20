//
//  DashboardViewController.swift
//  YGAM
//
//  Created by Andrew Donnelly on 01/06/2018.
//  Copyright © 2018 Sky Betting and Gaming. All rights reserved.
//

import UIKit

class DashboardViewController: UIViewController {

    @IBOutlet weak var sectionSegmentedControl: UISegmentedControl!
    private var questions: [Question]?

    let buttonBar = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()

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

    func setUpUI() {
        sectionSegmentedControl.tintColor = .clear
        sectionSegmentedControl.backgroundColor = UIColor(red: 38/255.0, green: 104/255.0, blue: 138/255.0, alpha: 1.0)
        sectionSegmentedControl.setTitleTextAttributes([
            NSAttributedStringKey.font : UIFont(name: "Rubik-Bold", size: 18)!,
            NSAttributedStringKey.foregroundColor: UIColor.lightGray
            ], for: .normal)

        sectionSegmentedControl.setTitleTextAttributes([
            NSAttributedStringKey.font : UIFont(name: "Rubik-Bold", size: 18)!,
            NSAttributedStringKey.foregroundColor: UIColor.white
            ], for: .selected)

        self.buttonBar.translatesAutoresizingMaskIntoConstraints = false
        self.buttonBar.backgroundColor = UIColor(red: 37/255.0, green: 255/255.0, blue: 134/255.0, alpha: 1.0)
        self.view.addSubview(buttonBar)

        self.buttonBar.topAnchor.constraint(equalTo: sectionSegmentedControl.bottomAnchor).isActive = true
        self.buttonBar.heightAnchor.constraint(equalToConstant: 5).isActive = true
        self.buttonBar.leftAnchor.constraint(equalTo: sectionSegmentedControl.leftAnchor).isActive = true
        self.buttonBar.widthAnchor.constraint(equalTo: sectionSegmentedControl.widthAnchor, multiplier: 1 / CGFloat(sectionSegmentedControl.numberOfSegments)).isActive = true

        self.sectionSegmentedControl.layer.shadowColor = UIColor.black.cgColor
        self.sectionSegmentedControl.layer.shadowOffset = CGSize(width: 2, height: 2)
        self.sectionSegmentedControl.layer.shadowOpacity = 0.3
    }

    @IBAction func segmentValueChanged(_ sender: Any) {
        UIView.animate(withDuration: 0.3) {
            self.buttonBar.frame.origin.x = (self.sectionSegmentedControl.frame.width / CGFloat(self.sectionSegmentedControl.numberOfSegments)) * CGFloat(self.sectionSegmentedControl.selectedSegmentIndex)
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
