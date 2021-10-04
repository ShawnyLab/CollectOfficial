//
//  SortViewController.swift
//  Collect
//
//  Created by 박진서 on 2021/09/16.
//

import UIKit
import RxSwift
import RxCocoa

class SortViewController: UIViewController, ViewModelBindableType {

    var viewModel: SortViewModel!
    
    @IBOutlet weak var EmptyButton: UIButton!
    @IBOutlet weak var highCostButton: UIButton!
    @IBOutlet weak var dateButton: UIButton!
    @IBOutlet weak var container: UIView!
    @IBOutlet weak var lowCostButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var prefersHomeIndicatorAutoHidden: Bool {
        return true
    }
    
    func bindViewModel() {
        dateButton.rx.action = viewModel.sortNewAction
        highCostButton.rx.action = viewModel.sortHighAction
        lowCostButton.rx.action = viewModel.sortLowAction
        
        container.layer.cornerRadius = 13
        EmptyButton.rx.action = viewModel.commonPopAction
    }
    
    deinit {
        print("sort View Deinited")
    }

}
