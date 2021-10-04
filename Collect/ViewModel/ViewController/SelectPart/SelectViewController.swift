//
//  SelectViewController.swift
//  Collect
//
//  Created by 박진서 on 2021/09/04.
//

import UIKit
import NSObject_Rx
import RxSwift
import RxCocoa
import SDWebImage
import Kingfisher

class SelectViewController: UIViewController, ViewModelBindableType {

    var viewModel: SelectViewModel!
    var timer: Timer?
    var resetTimer: Timer?
    var nowPage = 0
    var imgCnt = 0
    
    var reset = 0
    let cart = CartModel.shared
    
    @IBOutlet weak var bannerCollectionView: UICollectionView!
    @IBOutlet weak var brandCollectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        resetTimer?.invalidate()
        print("select Timer ----> reset, banner stopped)")
        timer?.invalidate()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //reset Timer
        reset = 0
        resetTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { time in
            self.reset += 1
            print("select Timer ----> \(self.reset)")
            if self.reset == 180 {
                self.cart.resetCart()
                self.navigationController?.popToRootViewController(animated: false)
                self.resetTimer?.invalidate()
            }
        }
        
        //Banner Timer
        timer = Timer.scheduledTimer(withTimeInterval: 3, repeats: true) { time in
            self.bannerMove()
        }
    }
    
    deinit {
        print("SelectViewController Deinited")
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var prefersHomeIndicatorAutoHidden: Bool {
        return true
    }

    func bindViewModel() {
        //Banner CollectionView
        bannerCollectionView.rx.setDelegate(self)
            .disposed(by: rx.disposeBag)
        bannerCollectionView.decelerationRate = .fast
        
            //set imgCnt
        viewModel.bannerUrlSubject
            .subscribe(onNext: { urlArr in
                self.imgCnt = urlArr.count
            })
            .disposed(by: rx.disposeBag)
            //set collectionView
        viewModel.bannerUrlSubject
            .bind(to: bannerCollectionView.rx.items(cellIdentifier: "selectbannerCell", cellType: SelectBannerCell.self)) { _, url, cell in
                cell.bannerImage.sd_setImage(with: url, completed: nil)
            }
            .disposed(by: rx.disposeBag)
            //Banner Select
        bannerCollectionView.rx.modelSelected(URL.self)
            .throttle(.seconds(5), latest: false, scheduler: MainScheduler.instance)
            .subscribe(onNext: { [unowned self] url in
                self.viewModel.bannerSubject
                    .subscribe(onNext: { [unowned self] refUrl in
                        self.resetTimer?.invalidate()
                        self.timer?.invalidate()
                        let ref = refUrl[url]
                        self.viewModel.changeToUrl(ref: ref!)
                            .subscribe(onNext: { [unowned self] newUrl in
                                if newUrl == nil {
                                } else {
                                    Observable.just(newUrl!)
                                        .bind(to: self.viewModel.bannerAction.inputs)
                                        .disposed(by: self.rx.disposeBag)
                                }
                            })
                            .disposed(by: self.rx.disposeBag)
                    })
                    .disposed(by: self.rx.disposeBag)
            })
            .disposed(by: rx.disposeBag)
        
        //Brand Part
        
        brandCollectionView.rx.setDelegate(self)
            .disposed(by: rx.disposeBag)

        viewModel.brandsSubject
            .bind(to: brandCollectionView.rx.items(cellIdentifier: "brandCell", cellType: BrandCell.self)) { index, brand, cell in
                cell.layer.cornerRadius = 12
                cell.buttonImage.image = brand.logoImage
                let hex = Int(brand.wallColor!, radix: 16)!
                cell.containerView.backgroundColor = UIColor(rgb: hex)
            }
            .disposed(by: rx.disposeBag)
        
        brandCollectionView.rx.modelSelected(BrandModel.self)
            .throttle(.seconds(3), latest: false, scheduler: MainScheduler.instance)
            .subscribe(onNext: { [unowned self] brand in
                Observable.just(brand)
                    .bind(to: self.viewModel.brandMainAction.inputs)
                    .disposed(by: self.rx.disposeBag)
            })
            .disposed(by: rx.disposeBag)
    }

    func bannerMove() {
        if nowPage == imgCnt-1 {
            bannerCollectionView.scrollToItem(at: NSIndexPath(item: 0, section: 0) as IndexPath, at: .right, animated: true)
            nowPage = 0
        } else {
            nowPage += 1
            bannerCollectionView.scrollToItem(at: NSIndexPath(item: nowPage, section: 0) as IndexPath, at: .right, animated: true)
        }
    }

}

extension SelectViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        
        if collectionView == brandCollectionView {
            return CGSize(width: CGFloat(370), height: CGFloat(133))
        } else {
            return CGSize(width: CGFloat(1180), height: CGFloat(288))
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if scrollView == bannerCollectionView {
            timer?.invalidate()
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView == bannerCollectionView {
            if scrollView.contentOffset.x / scrollView.frame.width > CGFloat(Int(scrollView.contentOffset.x / scrollView.frame.width)) + CGFloat(0.5) {
                nowPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width) + 1
            } else {
                nowPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
            }
            bannerCollectionView.scrollToItem(at: [0, nowPage], at: .right, animated: true)
            self.timer? = Timer.scheduledTimer(withTimeInterval: 3, repeats: true) { time in
                print("select Timer ----> bannerTimer Moving")
                self.bannerMove()
            }
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == bannerCollectionView {
            if scrollView.contentOffset.x / scrollView.frame.width > CGFloat(Int(scrollView.contentOffset.x / scrollView.frame.width)) + CGFloat(0.5) {
                nowPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width) + 1
            } else {
                nowPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
            }
            bannerCollectionView.scrollToItem(at: [0, nowPage], at: .right, animated: true)
        }
    }
}

class BrandCell: UICollectionViewCell {
    @IBOutlet weak var buttonImage: UIImageView!
    @IBOutlet weak var containerView: UIView!
    
}

class SelectBannerCell: UICollectionViewCell {
    @IBOutlet weak var bannerImage: UIImageView!
    
}

