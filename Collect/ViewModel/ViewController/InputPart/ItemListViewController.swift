//
//  ItemListViewController.swift
//  Collect
//
//  Created by 박진서 on 2021/09/16.
//

import UIKit

class ItemListViewController: UIViewController, ViewModelBindableType {

    var viewModel: ItemListViewModel!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var addItemButton: UIButton!
    @IBOutlet weak var itemTableView: UITableView!
    @IBOutlet weak var backButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    func bindViewModel() {
        
        itemTableView.layer.cornerRadius = 24
        
        self.titleLabel.text = "\(viewModel.brandModel.name!) 제품 리스트"
        itemTableView.rx.setDelegate(self)
            .disposed(by: rx.disposeBag)
            
        viewModel.itemModelSubject
            .bind(to: itemTableView.rx.items(cellIdentifier: "itemlisttableCell", cellType: ItemListTableCell.self)) { _, item, cell in
                cell.updateUI()
                cell.itemLabel.text = item.name!
                cell.removeBtn.rx.tap
                    .subscribe(onNext: {
                        self.viewModel.removeFromItemList(self, item)
                    })
                    .disposed(by: self.rx.disposeBag)
            }
            .disposed(by: rx.disposeBag)
        
        itemTableView.rx.modelSelected(ItemModel.self)
            .bind(to: viewModel.colorListAction.inputs)
            .disposed(by: rx.disposeBag)
        
        addItemButton.rx.action = viewModel.itemAddAction
        backButton.rx.action = viewModel.commonPopAction
    }

}

extension ItemListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(77)
    }
}

class ItemListTableCell: UITableViewCell {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var removeBtn: UIButton!
    @IBOutlet weak var itemLabel: UILabel!
    func updateUI() {
        containerView.layer.cornerRadius = 24
    }
}
