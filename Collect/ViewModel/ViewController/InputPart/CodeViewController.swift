//
//  CodeViewController.swift
//  Collect
//
//  Created by 박진서 on 2021/09/23.
//

import UIKit
import RxSwift
import RxCocoa

class CodeViewController: UIViewController, ViewModelBindableType {

    @IBOutlet weak var popButton: UIButton!
    var viewModel: CodeViewModel!
    var validSub = BehaviorSubject<Bool>(value: false)
    @IBOutlet weak var editorButton: UIButton!
    
    @IBOutlet weak var codeTextfield: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    func bindViewModel() {
        codeTextfield.rx.text
            .map { str -> Bool in
                if str == "127" { return true }
                else { return false }
            }
            .bind(to: validSub)
            .disposed(by: rx.disposeBag)
        
        validSub
            .bind(to: editorButton.rx.isEnabled)
            .disposed(by: rx.disposeBag)
        
        editorButton.rx.action = viewModel.editorButton()
        
        popButton.rx.action = viewModel.commonPopAction
    }
}
