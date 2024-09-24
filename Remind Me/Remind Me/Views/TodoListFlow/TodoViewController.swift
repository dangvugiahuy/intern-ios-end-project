//
//  TodoViewController.swift
//  Remind Me
//
//  Created by huy.dang on 9/13/24.
//

import UIKit

class TodoViewController: BaseViewController {
        
    @IBOutlet weak var switchTaskSegmentControl: UISegmentedControl!
    @IBOutlet weak var filterButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupFirstLoadVC()
    }
    
    private func setupFirstLoadVC() {
        self.title = "Todo"
        switchTaskSegmentControl.setupSegment()
    }
    
    @IBAction func filterButtonClicked(_ sender: UIBarButtonItem) {
        
    }
}
