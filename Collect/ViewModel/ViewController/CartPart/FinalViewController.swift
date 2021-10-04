//
//  FinalViewController.swift
//  Collect
//
//  Created by 박진서 on 2021/09/17.
//

import UIKit
import Kingfisher

class FinalViewController: UIViewController, ViewModelBindableType {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var finalButton: UIButton!
    var viewModel: FinalViewModel!
    var timer: Timer?
    var count = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { time in
            self.count += 1
            print("final \(self.count)")
            if self.count == 60 {
                self.timer?.invalidate()
                self.viewModel.cart.resetCart()
                self.navigationController?.popToRootViewController(animated: false)
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.timer?.invalidate()
        print("final timer all stopped")
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var prefersHomeIndicatorAutoHidden: Bool {
        return true
    }
    
    deinit {
        print("FinalViewController deinited")
    }
    
    func bindViewModel() {
        nameLabel.text = viewModel.name
        finalButton.rx.tap
            .subscribe(onNext: { [unowned self] in
                self.viewModel.cart.resetCart()
                self.navigationController?.popToRootViewController(animated: false)
            })
            .disposed(by: rx.disposeBag)
    }

}
