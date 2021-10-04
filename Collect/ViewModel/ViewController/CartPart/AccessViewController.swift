//
//  AccessViewController.swift
//  Collect
//
//  Created by 박진서 on 2021/09/19.
//

import UIKit

class AccessViewController: UIViewController, ViewModelBindableType {

    var viewModel: AccessViewModel!
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var popButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var prefersHomeIndicatorAutoHidden: Bool {
        return true
    }
    
    func bindViewModel() {
        textView.layer.cornerRadius = 13
        popButton.rx.action = viewModel.commonPopAction
    }
}
