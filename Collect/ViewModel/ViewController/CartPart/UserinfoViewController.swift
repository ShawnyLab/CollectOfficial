//
//  UserinfoViewController.swift
//  Collect
//
//  Created by 박진서 on 2021/09/16.
//

import UIKit
import RxSwift
import RxCocoa
import NSObject_Rx

class UserinfoViewController: UIViewController, ViewModelBindableType {

    var viewModel: UserinfoViewModel!
    let cart = CartModel.shared
    
    var resetTimer: Timer?
    var reset = 0
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var realBackButton: UIButton!
    @IBOutlet weak var nameTextfield: UITextField!
    @IBOutlet weak var accessButton: UIButton!
    @IBOutlet weak var numberTextfield: UITextField!
    @IBOutlet weak var nextButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        reset = 0
        resetTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { Timer in
            self.reset += 1
            if self.reset == 240 {
                self.cart.resetCart()
                self.navigationController?.popToRootViewController(animated: false)
                self.resetTimer?.invalidate()
            }
        })
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        resetTimer?.invalidate()
    }
    
    deinit {
        print("userinfo ViewController deinited")
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var prefersHomeIndicatorAutoHidden: Bool {
        return true
    }
    
    func bindViewModel() {
        realBackButton.rx.action = viewModel.commonPopAction
        
        accessButton.rx.action = viewModel.accessAction
        
        numberTextfield.text = "010"
        
        nameTextfield.rx.text
            .orEmpty
            .bind(to: viewModel.nameSub)
            .disposed(by: rx.disposeBag)
        
        nameTextfield.rx.text
            .subscribe(onNext: { [unowned self] _ in
                self.reset = 0
            })
            .disposed(by: rx.disposeBag)
        
        numberTextfield.rx.text
            .subscribe(onNext: { [unowned self] _ in
                self.reset = 0
            })
            .disposed(by: rx.disposeBag)
        
        numberTextfield.rx.text
            .orEmpty
            .bind(to: viewModel.phoneSub)
            .disposed(by: rx.disposeBag)
        
        let enableSub = BehaviorSubject<Bool>(value: false)
        
        Observable.combineLatest(nameTextfield.rx.text, numberTextfield.rx.text)
            .map { t1, t2 -> Bool in
                if t1?.count == 0 && t2?.count == 0 {
                    return false
                }
                if t1!.count > 1 && t2!.count > 9 {
                    return true
                }
                return false
            }
            .bind(to: enableSub)
            .disposed(by: rx.disposeBag)
        nextButton.rx.action = viewModel.finalAction
        
        enableSub.bind(to: self.nextButton.rx.isEnabled)
            .disposed(by: rx.disposeBag)
        
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
