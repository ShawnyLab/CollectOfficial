//
//  FirstViewController.swift
//  Collect
//
//  Created by 박진서 on 2021/09/06.
//

import UIKit

class FirstViewController: UIViewController, ViewModelBindableType {

    var viewModel: FirstViewModel!
    @IBOutlet weak var editorButton: UIButton!
    
    @IBOutlet weak var showcaseButton: UIButton!
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
        showcaseButton.rx.action = viewModel.selectButton()
        editorButton.rx.action = viewModel.editorButton()
    }
}
