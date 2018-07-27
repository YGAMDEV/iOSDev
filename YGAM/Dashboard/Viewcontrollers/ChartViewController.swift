//
//  ChartViewController.swift
//  YGAM
//
//  Created by Andrew Donnelly on 13/07/2018.
//  Copyright © 2018 Sky Betting and Gaming. All rights reserved.
//

import UIKit

class ChartViewController: UIViewController, ChartDelegate {

    let chart = Chart()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let data = [
            (x: 0, y: 0),
            (x: 1, y: 3.1),
            (x: 4, y: 2),
            (x: 5, y: 4.2),
            (x: 7, y: 5),
            (x: 9, y: 9),
            (x: 10, y: 8)
        ]
        let series = ChartSeries(data: data)
        chart.add(series)
        chart.delegate = self
        self.view.addSubview(chart)
    }

    override func viewDidLayoutSubviews() {
        chart.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func didTouchChart(_ chart: Chart, indexes: [Int?], x: Double, left: CGFloat) {
        for (seriesIndex, dataIndex) in indexes.enumerated() {
            if dataIndex != nil {
                // The series at `seriesIndex` is that which has been touched
                let value = chart.valueForSeries(seriesIndex, atIndex: dataIndex)
                print(value!)
            }
        }
    }

    func didFinishTouchingChart(_ chart: Chart) {

    }

    func didEndTouchingChart(_ chart: Chart) {

    }

}
