//
//  BrandListViewController.swift
//  Collect
//
//  Created by 박진서 on 2021/09/16.
//

import UIKit

class BrandListViewController: UIViewController, ViewModelBindableType {

    var viewModel: BrandListViewModel!
    @IBOutlet weak var addBrandButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var brandTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    func bindViewModel() {
        addBrandButton.rx.action = viewModel.brandAddAction
        brandTableView.rx.setDelegate(self)
            .disposed(by: rx.disposeBag)
        
        backButton.rx.action = viewModel.commonPopAction
        
        viewModel.brandListSubject
            .bind(to: brandTableView.rx.items(cellIdentifier: "brandlistCell", cellType: BrandListCell.self)) { _, brand, cell in
                cell.brandLabel.text = brand.name!
                cell.updateUI()
                cell.removeBtn.rx.tap
                    .subscribe(onNext: {
                        self.viewModel.removeFromBrandList(self, brand)
                    })
                    .disposed(by: self.rx.disposeBag)
            }
            .disposed(by: rx.disposeBag)
        
        brandTableView.rx.modelSelected(BrandModel.self)
            .bind(to: viewModel.itemListAction.inputs)
            .disposed(by: rx.disposeBag)
    }
}

extension BrandListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(77)
    }
}

class BrandListCell: UITableViewCell {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var removeBtn: UIButton!
    @IBOutlet weak var brandLabel: UILabel!
    func updateUI() {
        containerView.layer.cornerRadius = 24
    }
}

