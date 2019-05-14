//
//  StatisticsViewController.swift
//  telegram-charts
//
//  Created by Roman Aliyev on 3/12/19.
//  Copyright © 2019 Roman Aliyev. All rights reserved.
//

import UIKit

class StatisticsViewController: UIViewController {
    @IBOutlet var statisticsView: StatisticsView!
    
    var delegate: StatisticsViewDelegate!
    
    var wasAppearedBefore = false
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.delegate.viewWillAppear(wasAppearedBefore: self.wasAppearedBefore)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.wasAppearedBefore = true
    }
}
