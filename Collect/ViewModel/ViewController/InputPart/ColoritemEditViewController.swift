//
//  ColoritemEditViewController.swift
//  Collect
//
//  Created by 박진서 on 2021/09/16.
//

import UIKit

class ColoritemEditViewController: UIViewController, ViewModelBindableType {

    var viewModel: ColoritemEditViewModel!
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var rgbTextfield: UITextField!
    @IBOutlet weak var colornameKorTextfield: UITextField!
    @IBOutlet weak var itemCodeTextfield: UITextField!
    @IBOutlet weak var filenameTextfield: UITextField!
    @IBOutlet weak var addButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    func bindViewModel() {
        backButton.rx.action = viewModel.commonPopAction
        
        rgbTextfield.rx.text
            .orEmpty
            .bind(to: viewModel.colorSub)
            .disposed(by: rx.disposeBag)
        
        colornameKorTextfield.rx.text
            .orEmpty
            .bind(to: viewModel.colorNameSub)
            .disposed(by: rx.disposeBag)
        
        itemCodeTextfield.rx.text
            .orEmpty
            .bind(to: viewModel.itemCodeSub)
            .disposed(by: rx.disposeBag)
        
        filenameTextfield.rx.text
            .orEmpty
            .bind(to: viewModel.fileNameSub)
            .disposed(by: rx.disposeBag)
        
        addButton.rx.action = viewModel.addAction
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

}
