//
//  TodayViewController.swift
//  Collect
//
//  Created by 박진서 on 2021/09/04.
//

import UIKit
import RxSwift
import RxCocoa
import NSObject_Rx

class TodayViewController: UIViewController, ViewModelBindableType {

    var viewModel: TodayViewModel!
    
    @IBOutlet weak var bannerCollectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    func bindViewModel() {
        bannerCollectionView.rx.setDelegate(self)
            .disposed(by: rx.disposeBag)
    }
}

extension TodayViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = collectionView.bounds.height
        let width = collectionView.bounds.width
        return CGSize(width: width, height: height)
    }
}

class TodayBannerCell: UICollectionViewCell {
    
}
