//
//  DashboardViewController.swift
//  YGAM
//
//  Created by Andrew Donnelly on 01/06/2018.
//  Copyright © 2018 Sky Betting and Gaming. All rights reserved.
//

import UIKit
import Charts

class DashboardViewController: UIViewController {

    @IBOutlet weak var aimImageView: UIImageView!
    @IBOutlet weak var taskDescription: UILabel!
    @IBOutlet weak var roundedTop: UIView!
    @IBOutlet weak var gradientView: GradientView!
    @IBOutlet weak var activityHeading: UILabel!
    @IBOutlet weak var chartView: LineChartView!
    @IBOutlet weak var chartViewContainerHeight: NSLayoutConstraint!
    @IBOutlet weak var signpostCollectionView: UICollectionView!
    @IBOutlet weak var taskCompletionView: UIView!
    @IBOutlet weak var taskCompletionBottomAnchor: NSLayoutConstraint!
    @IBOutlet weak var taskCompletionButton: UIButton!
    @IBOutlet weak var taskCompletionLabel: UILabel!
    @IBOutlet weak var taskInformationView: UIView!
    
    private struct Constants {
        static let signpostCell = "SignpostCollectionViewCell"
        static let SignpostViewAllCell = "SignpostViewAllCollectionViewCell"
        static let shadowRadius: CGFloat = 4.0
        static let shadowColor = UIColor(red: (85.0/255.0), green: (85.0/255.0), blue: (85.0/255.0), alpha: 0.35).cgColor
    }
    
    private var selectedTask: Task!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        signpostCollectionView.register(UINib(nibName: Constants.signpostCell, bundle: nil), forCellWithReuseIdentifier: Constants.signpostCell)
        signpostCollectionView.register(UINib(nibName: Constants.SignpostViewAllCell, bundle: nil), forCellWithReuseIdentifier: Constants.SignpostViewAllCell)
        setupUI()
        
        if let flowLayout = signpostCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.estimatedItemSize = UICollectionViewFlowLayoutAutomaticSize
        }
        
        if let task = UserDefaults.standard.value(forKey: EntryLogicConstants.selectedTask) as? String,
            let taskIdentifier = TaskIdentifier.init(rawValue: task) {
            switch taskIdentifier {
            case .control:
                selectedTask = ControlTask()
            case .money:
                selectedTask = MoneyTask()
            case .time:
                selectedTask = TimeTask()
            }
        }
        taskCompletionLabel.text = selectedTask.taskCompletion
        taskDescription.text = selectedTask.taskDescription
        gradientView.firstColor = selectedTask.gradientFirstColor!
        gradientView.secondColor = selectedTask.gradientSecondColor!
        gradientView.layer.cornerRadius = 2.0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if Date().daysPastSinceTaskStartDate() >= 7 {
            taskCompletionView.isHidden = false
            taskInformationView.isHidden = true
        } else {
            taskCompletionBottomAnchor?.isActive = false
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        signpostCollectionView.reloadData()
    }
    
    private func setupUI() {
        taskCompletionButton.layer.borderColor = UIColor.white.cgColor
        taskCompletionButton.layer.backgroundColor = UIColor.init(white: 1.0, alpha: 0.2).cgColor
        taskCompletionButton.layer.cornerRadius = 4.0
        taskCompletionButton.layer.borderWidth = 1
        
        roundedTop.layer.cornerRadius = 8
        roundedTop.layer.shadowColor = Constants.shadowColor
        roundedTop.layer.shadowRadius = Constants.shadowRadius
        roundedTop.layer.shadowOffset = .zero
        roundedTop.layer.shadowOpacity = 1.0
        
        aimImageView.image = aimImageView.image?.withRenderingMode(.alwaysTemplate)
        aimImageView.tintColor = .white
        
        setupChart()
    }
    
    private func setupChart() {
        guard let savedResults = UserDefaults.standard.array(forKey: DailyResultsConstants.dailyResults) as? [[String: Any]] else {
            chartViewContainerHeight.constant = 0
            return
        }
        
        let chartResults = savedResults.map { ChartDataEntry(x: $0[DailyResultsConstants.day] as! Double, y: $0[DailyResultsConstants.value] as! Double, icon: UIImage(named: $0[DailyResultsConstants.imageName] as! String)!) }
        
        let line = LineChartDataSet(values: chartResults, label: nil)
        line.colors = [NSUIColor.white]
        
        // Removes the circle at each point
        line.drawCirclesEnabled = false

        // Remove values on each point
        line.drawValuesEnabled = false

        // Make the line rounded
        line.mode = .cubicBezier
        
        // Set the line width and fill colour under the line
        line.lineWidth = 1
        line.fill = Fill(color: .init(white: 1.0, alpha: 0.4))
        line.drawFilledEnabled = true
        
        let data = LineChartData()
        data.addDataSet(line)
        
        chartView.pinchZoomEnabled = false
        chartView.autoScaleMinMaxEnabled = false
        
        
        // Turn off gridlines on xAxis
        chartView.xAxis.drawGridLinesEnabled = false
        chartView.leftAxis.drawGridLinesEnabled = false
        
        // Set the label position to be at the bottom of the graph
        chartView.xAxis.labelPosition = .bottom
        
        // Turn off the right axis, don't draw the left axis
        chartView.rightAxis.enabled = false
        chartView.leftAxis.drawAxisLineEnabled = false
        chartView.leftAxis.drawLabelsEnabled = false
        
        // Set the yAxis max to 100 and min to 0
        chartView.leftAxis.axisMaximum = 100
        chartView.leftAxis.axisMinimum = 0
        
        chartView.xAxis.axisMinimum = 1
        chartView.xAxis.axisMaximum = 7
        chartView.xAxis.axisLineColor = .white
        chartView.xAxis.axisLineWidth = 1
        chartView.xAxis.labelFont = UIFont(name: "Rubik", size: 8.0)!
        chartView.xAxis.labelTextColor = .white
        
        // Turn off description
        chartView.chartDescription?.enabled = false
        
        // Turn off legend
        chartView.legend.enabled = false
        
        chartView.animate(yAxisDuration: 1.5)
        
        // Set that data
        chartView.data = data
    }
    
    @IBAction func taskCompletionButtonTapped(_ sender: Any) {
        resetFlags()
        let entryLogic = EntryLogic()
        navigationController?.present(entryLogic.intialViewContoller(), animated: true, completion: nil)
    }

    private func resetFlags() {
        // Reset flags in preparation for the user to complete the full 10 questions again
        UserDefaults.standard.set(false, forKey: EntryLogicConstants.allQuestionsAnswered)
        UserDefaults.standard.removeObject(forKey: EntryLogicConstants.dailyQuestionsAnsweredDate)
        UserDefaults.standard.removeObject(forKey: EntryLogicConstants.selectedTask)
        UserDefaults.standard.removeObject(forKey: EntryLogicConstants.taskStartDate)
        
        // Remove values associated with Results
        UserDefaults.standard.removeObject(forKey: ResultsViewController.Constants.controlResult)
        UserDefaults.standard.removeObject(forKey: ResultsViewController.Constants.moneyResult)
        UserDefaults.standard.removeObject(forKey: ResultsViewController.Constants.timeResult)
        UserDefaults.standard.removeObject(forKey: DailyResultsConstants.dailyResults)
        
        UserDefaults.standard.synchronize()
    }
}

extension DashboardViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let signposts = selectedTask.signposts else {
            return 0
        }
        // Add one extra for the 'View all' cell
        return signposts.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == selectedTask.signposts!.count {
            // Last cell, show the view all cell
            return collectionView.dequeueReusableCell(withReuseIdentifier: Constants.SignpostViewAllCell, for: indexPath) as! SignpostViewAllCollectionViewCell
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.signpostCell, for: indexPath) as! SignpostCollectionViewCell
        cell.setup(signpost: selectedTask.signposts![indexPath.row])
        cell.horizontalRule.isHidden = false
        if indexPath.row + 1 == selectedTask.signposts!.count {
            // Last normal cell - hide the horizontal view
            cell.horizontalRule.isHidden = true
        }
        return cell
    }
}

extension DashboardViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row < selectedTask.signposts!.count {
            UIApplication.shared.open(selectedTask.signposts![indexPath.row].url!)
            return
        }
        performSegue(withIdentifier: "SignpostingSegue", sender: nil)
    }
}
