//
//  BrandEditViewController.swift
//  Collect
//
//  Created by 박진서 on 2021/09/16.
//

import UIKit
import Firebase

class BrandEditViewController: UIViewController, ViewModelBindableType {

    var viewModel: BrandEditViewModel!
    
    @IBOutlet weak var backButton: UIButton!
    
    @IBOutlet weak var brandNameCover: UIView!
    @IBOutlet weak var brandNameTextfield: UITextField!
    @IBOutlet weak var brandColorTextfield: UITextField!
    @IBOutlet weak var brandColorCover: UIView!
    @IBOutlet weak var addButton: UIButton!
   
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    func bindViewModel() {

        brandNameCover.layer.cornerRadius = 24
        brandColorCover.layer.cornerRadius = 24
        
        backButton.rx.action = viewModel.commonPopAction
        
        brandColorTextfield.rx.text
            .orEmpty
            .bind(to: viewModel.colorSub)
            .disposed(by: rx.disposeBag)
        
        brandNameTextfield.rx.text
            .orEmpty
            .bind(to: viewModel.nameSub)
            .disposed(by: rx.disposeBag)
        
        if brandColorTextfield.text != nil && brandNameTextfield.text != nil {
            addButton.rx.action = viewModel.addAction
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

}
