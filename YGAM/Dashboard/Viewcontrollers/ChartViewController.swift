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
        let series1 = ChartSeries([0, 6, 2, 8, 4, 7, 3, 10, 8])
        series1.color = ChartColors.yellowColor()
        series1.area = true

        let series2 = ChartSeries([1, 0, 0.5, 0.2, 0, 1, 0.8, 0.3, 1])
        series2.color = ChartColors.redColor()
        series2.area = true

        // A partially filled series
        let series3 = ChartSeries([9, 8, 10, 8.5, 9.5, 10])
        series3.color = ChartColors.purpleColor()

        chart.add([series1, series2, series3])
        chart.lineWidth = 4
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

    }

    func didFinishTouchingChart(_ chart: Chart) {

    }

    func didEndTouchingChart(_ chart: Chart) {

    }

}
