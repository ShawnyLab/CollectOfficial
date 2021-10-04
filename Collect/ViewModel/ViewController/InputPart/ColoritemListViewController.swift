//
//  ColoritemListViewController.swift
//  Collect
//
//  Created by 박진서 on 2021/09/16.
//

import UIKit
import RxSwift
import RxCocoa
import Firebase

class ColoritemListViewController: UIViewController, ViewModelBindableType {    

    var viewModel: ColoritemListViewModel!
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var colorTableView: UITableView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var addButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    func bindViewModel() {
        colorTableView.rx.setDelegate(self)
            .disposed(by: rx.disposeBag)
        colorTableView.layer.cornerRadius = 24
        
        titleLabel.text = "\(viewModel.itemModel.brand!) \(viewModel.itemModel.name!)"
        
        backButton.rx.action = viewModel.commonPopAction
        
        viewModel.colorItemSubject
            .bind(to: colorTableView.rx.items(cellIdentifier: "colorlistCell", cellType: ColorListCell.self)) { _, coloritem, cell in
                cell.updateUI()
                cell.colorLabel.text = "\(coloritem.colorNameKor!)"
                Observable.just(!coloritem.isEmpty)
                    .bind(to: cell.isEmptySwitch.rx.isOn)
                    .disposed(by: self.rx.disposeBag)
                
                cell.isEmptySwitch.rx.value
                    .subscribe(onNext: { bool in
                        if bool == true {
                            Database.database().reference()
                                .child("1").child("Brand").child(coloritem.brand!).child("Item").child(coloritem.itemName!).child("colorItems").child(coloritem.fileName!).child("isEmpty").setValue(false)
                        } else {
                            Database.database().reference()
                                .child("1").child("Brand").child(coloritem.brand!).child("Item").child(coloritem.itemName!).child("colorItems").child(coloritem.fileName!).child("isEmpty").setValue(true)
                        }
                    })
                    .disposed(by: self.rx.disposeBag)
                
                cell.removeBtn.rx.tap
                    .subscribe(onNext: {
                        self.viewModel.removeFromColorList(self, coloritem)
                    })
                    .disposed(by: self.rx.disposeBag)
            }
            .disposed(by: rx.disposeBag)
        
        addButton.rx.action = viewModel.itemAddAction
    }

}

extension ColoritemListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(77)
    }
}

class ColorListCell: UITableViewCell {
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var colorLabel: UILabel!
    @IBOutlet weak var removeBtn: UIButton!
    @IBOutlet weak var isEmptySwitch: UISwitch!
    
    func updateUI() {
        containerView.layer.cornerRadius = 24
    }
}
