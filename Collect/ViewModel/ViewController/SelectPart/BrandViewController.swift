//
//  BrandViewController.swift
//  Collect
//
//  Created by 박진서 on 2021/09/04.
//

import UIKit
import NSObject_Rx
import RxSwift
import RxCocoa
import Kingfisher

class BrandViewController: UIViewController, ViewModelBindableType {

    var viewModel: BrandViewModel!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func bindViewModel() {
        
        viewModel.brandsSubject
            .bind(to: collectionView.rx.items(cellIdentifier: "brandCell", cellType: BrandCell.self)) { index, brand, cell in
                cell.buttonImage.kf.indicatorType = .activity
                cell.buttonImage.kf.setImage(with: brand.buttonImage, placeholder: nil, options: [.transition(.fade(0.7))])
               
            }
            .disposed(by: rx.disposeBag)
        
        collectionView.rx.modelSelected(BrandModel.self)
            .subscribe(onNext: { brand in
                Observable.just(brand)
                    .bind(to: self.viewModel.brandMainAction.inputs)
                    .disposed(by: self.rx.disposeBag)
            })
            .disposed(by: rx.disposeBag)
            
    }
}
