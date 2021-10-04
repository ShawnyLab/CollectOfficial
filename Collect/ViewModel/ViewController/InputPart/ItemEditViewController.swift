//
//  ItemEditViewController.swift
//  Collect
//
//  Created by 박진서 on 2021/09/16.
//

import UIKit

class ItemEditViewController: UIViewController, ViewModelBindableType {

    var viewModel: ItemEditViewModel!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var addItemButton: UIButton!
    
    @IBOutlet weak var nameKorTf: UITextField!
    @IBOutlet weak var nameTf: UITextField!
    @IBOutlet weak var costTf: UITextField!
    @IBOutlet weak var desTf: UITextField!
    @IBOutlet weak var madeInTf: UITextField!
    @IBOutlet weak var shapeTf: UITextField!
    @IBOutlet weak var sizeTf: UITextField!
    @IBOutlet weak var matTf: UITextField!
    @IBOutlet weak var isExTf: UITextField!
    @IBOutlet weak var dateTf: UITextField!
    @IBOutlet weak var codeTf: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    func bindViewModel() {
        
        backButton.rx.action = viewModel.commonPopAction
        addItemButton.rx.action = viewModel.addAction
        
        nameKorTf.rx.text
            .orEmpty
            .bind(to: viewModel.nameKorSub)
            .disposed(by: rx.disposeBag)
        
        nameTf.rx.text
            .orEmpty
            .bind(to: viewModel.nameSub)
            .disposed(by: rx.disposeBag)
        
        costTf.rx.text
            .orEmpty
            .map { str -> Int in
                if Int(str) != nil {
                    return Int(str)!
                } else {
                    return 0
                }
            }
            .bind(to: viewModel.costSub)
            .disposed(by: rx.disposeBag)
        
        desTf.rx.text
            .orEmpty
            .bind(to: viewModel.desSub)
            .disposed(by: rx.disposeBag)
        
        madeInTf.rx.text
            .orEmpty
            .bind(to: viewModel.madeInSub)
            .disposed(by: rx.disposeBag)
        
        shapeTf.rx.text
            .orEmpty
            .bind(to: viewModel.shapeSub)
            .disposed(by: rx.disposeBag)
        
        sizeTf.rx.text
            .orEmpty
            .bind(to: viewModel.sizeSub)
            .disposed(by: rx.disposeBag)
        
        matTf.rx.text
            .orEmpty
            .bind(to: viewModel.matSub)
            .disposed(by: rx.disposeBag)
        
        isExTf.rx.text
            .orEmpty
            .map { str -> Bool in
                if str == "예" { return true }
                else if str == "아니오" { return false }
                else { return false }
            }
            .bind(to: viewModel.isExSub)
            .disposed(by: rx.disposeBag)
        
        dateTf.rx.text
            .orEmpty
            .map{ str -> Int64 in
                if Int64(str) != nil {
                    return Int64(str)!
                } else {
                    return 0
                }
            }
            .bind(to: viewModel.dateSub)
            .disposed(by: rx.disposeBag)
        
        codeTf.rx.text
            .orEmpty
            .bind(to: viewModel.codeSub)
            .disposed(by: rx.disposeBag)
        
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

}
