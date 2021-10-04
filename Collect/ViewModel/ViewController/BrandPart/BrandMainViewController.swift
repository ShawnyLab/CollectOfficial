//
//  BrandMainViewController.swift
//  Collect
//
//  Created by 박진서 on 2021/09/04.
//

import UIKit
import RxSwift
import RxCocoa
import NSObject_Rx
import Kingfisher

class BrandMainViewController: UIViewController, ViewModelBindableType {
    
    var viewModel: BrandMainViewModel!
    
    private weak var timer: Timer?
    private var reset = 0
    private let cart = CartModel.shared
    
    private var resetTimer: Timer?
    private var nowPage: Int = 0
    private var imgCnt: Int = 0
    
    private var cacheTimer: Timer?
            
    @IBOutlet weak var realBackButton: UIButton!
    @IBOutlet weak var downButton: UIButton!
    @IBOutlet weak var realDownButton: UIButton!
    @IBOutlet weak var mainScrollView: UIScrollView!
    @IBOutlet weak var topBannerCover: UIView!
    @IBOutlet weak var topCoverView: UIView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var itemCollectionView: UICollectionView!
    @IBOutlet weak var smallLogoImage: UIImageView!
    @IBOutlet weak var wallpaperLogoImage: UIImageView!
    @IBOutlet weak var desImage: UIImageView!
    @IBOutlet weak var wallpaperCollectionView: UICollectionView!
    @IBOutlet weak var cartButton: UIButton!
    @IBOutlet weak var sortButton: UIButton!
    
    @IBOutlet weak var itemContainer: UIView!
    @IBOutlet weak var itemContainerHeight: NSLayoutConstraint!
    
    
    deinit {
        print("BrandMain Deinited")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let _ = Timer.scheduledTimer(withTimeInterval: 5, repeats: false) { Timer in
            self.itemCollectionView.reloadData()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        resetTimer?.invalidate()
        timer?.invalidate()
        print("brandMain timer all stopped")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        itemCollectionView.reloadData()
        reset = 0
        resetTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { timer in
            self.reset += 1
            print("BrandMain ----> reset \(self.reset)")
            if self.reset == 240 {
                self.cart.resetCart()
                self.navigationController?.popToRootViewController(animated: false)
                self.resetTimer?.invalidate()
            }
        })
        bannerMove()
        mainScrollView.delegate = self
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var prefersHomeIndicatorAutoHidden: Bool {
        return true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        print("diddisappear")
    }
    
    func bindViewModel() {
        viewModel.updateViewModel()
        
        //TopView
        let hex = Int(viewModel.brandModel.wallColor!, radix: 16)!
        topView.backgroundColor = UIColor(rgb: hex)
        topCoverView.backgroundColor = UIColor(rgb: hex)
        topBannerCover.backgroundColor = UIColor(rgb: hex)
        
        //Logo, DesImg
        
        viewModel.logoDriver
            .drive(onNext: { [unowned self] img in
                self.smallLogoImage.image = img
                self.wallpaperLogoImage.image = img
            })
            .disposed(by: rx.disposeBag)
        
        viewModel.desDriver
            .drive(onNext: { [unowned self] img in
                self.desImage.image = img
            })
            .disposed(by: rx.disposeBag)
        
        //Black Or White
        viewModel.blackOrWhiteSubject
            .subscribe(onNext: { [unowned self] bow in
                if bow == "White" {
                    self.backButton.setBackgroundImage(UIImage(named: "whiteBack"), for: .normal)
                    self.downButton.setBackgroundImage(UIImage(named: "whiteDown"), for: .normal)
                    self.cartButton.setBackgroundImage(UIImage(named: "whiteBrandMain"), for: .normal)
                    self.cartButton.setTitleColor(.black, for: .normal)
                    
                } else if bow == "Black" {
                    print("black")
                }
            })
            .disposed(by: rx.disposeBag)
        
        //DownButton
        realDownButton.rx.tap
            .subscribe(onNext: { [unowned self] in
                self.mainScrollView.setContentOffset(CGPoint(x: 0, y: 1000), animated: true)
            })
            .disposed(by: rx.disposeBag)
        
        //ItemCollectionView part
        itemCollectionView.rx.setDelegate(self)
            .disposed(by: rx.disposeBag)
        
        viewModel.itemsSubject
            .subscribe(onNext: { [unowned self] itemArr in
                let height = (itemArr.count / 3 + 1) * 469
                self.itemContainerHeight.constant = CGFloat(height)
                self.itemContainer.layoutIfNeeded()
                
            })
            .disposed(by: rx.disposeBag)
        
        viewModel.itemsSubject
            .bind(to: itemCollectionView.rx.items(cellIdentifier: "brandmainitemCell", cellType: BrandMainItemCell.self)) { index, item, cell in
                cell.itemImages.sd_setImage(with: item.mainImage, completed: nil)
                
                let cache = ImageCache.default
                cache.retrieveImage(forKey: item.mainImage!.absoluteString) { result in
                    switch result {
                    case .success(let value):
                        if let image = value.image {
                            cell.itemImages.image = image
                        } else {
                            let url = item.mainImage!
                            let resource = ImageResource(downloadURL: url, cacheKey: url.absoluteString)
                            cell.itemImages.kf.indicatorType = .activity
                            cell.itemImages.kf.setImage(with: resource, options: [.transition(.fade(0.7))])
                        }
                    case .failure(let err):
                        print(err)
                    }
                }
                
                cell.itemName.text = item.name
                let len = "\(item.cost!)".count
                if len < 7 {
                    var str = Array("\(item.cost!)").map{String($0)}
                    str.insert(",", at: len-3)
                    cell.itemPrice.text = "\(String(str.joined()))원"
                } else if len < 10 && len >= 7 {
                    var str = Array("\(item.cost!)").map{String($0)}
                    str.insert(",", at: len-3)
                    str.insert(",", at: len-6)
                    cell.itemPrice.text = "\(String(str.joined()))원"
                }
                cell.itemModel = item
                //Colors
                cell.updateUI()
                cell.colorCollectionView.reloadData()
            }
            .disposed(by: rx.disposeBag)
            //ItemSelection
        itemCollectionView.rx.modelSelected(ItemModel.self)
            .subscribe(onNext: { [unowned self] item in
                Observable.just(item)
                    .bind(to: self.viewModel.itemDetailAction.inputs)
                    .disposed(by: self.rx.disposeBag)
            })
            .disposed(by: rx.disposeBag)
        
        //WallPaper
        wallpaperCollectionView.rx.setDelegate(self)
            .disposed(by: rx.disposeBag)
        wallpaperCollectionView.decelerationRate = .fast

        imgCnt = viewModel.brandModel.wallPaper.count
        
        viewModel.wallpaperObservable
            .map { $0.sorted(by: { $0.absoluteString < $1.absoluteString })}
            .drive(wallpaperCollectionView.rx.items(cellIdentifier: "brandwallpaperCell", cellType: BrandWallpaperCell.self)) { _, url, cell in
                
                let cache = ImageCache.default
                cache.retrieveImage(forKey: url.absoluteString) { result in
                    switch result {
                    case .success(let value):
                        if let image = value.image {
                            cell.wallpaperImage.image = image
                        } else {
                            let resource = ImageResource(downloadURL: url, cacheKey: url.absoluteString)
                            cell.wallpaperImage.kf.indicatorType = .activity
                            cell.wallpaperImage.kf.setImage(with: resource, options: [.transition(.fade(0.7))])
                        }
                    case .failure(let err):
                        print(err)
                    }
                }
            }
            .disposed(by: rx.disposeBag)
        
        //Buttons
        cartButton.rx.action = viewModel.cartPresentAction
        realBackButton.rx.action = viewModel.popAction
        sortButton.rx.action = viewModel.sortAction
    }
    
    func bannerMove() {
        self.timer = Timer.scheduledTimer(withTimeInterval: 3, repeats: true, block: { timer in
            print("BrandMain banner Moved")
            if self.nowPage == self.imgCnt-1 {
                self.wallpaperCollectionView.scrollToItem(at: NSIndexPath(item: 0, section: 0) as IndexPath, at: .right, animated: true)
                self.nowPage = 0
            } else {
                self.nowPage += 1
                self.wallpaperCollectionView.scrollToItem(at: NSIndexPath(item: self.nowPage, section: 0) as IndexPath, at: .right, animated: true)
            }
        })
    }
}

extension BrandMainViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == itemCollectionView {
            return CGSize(width: CGFloat(310), height: CGFloat(409))
        } else if collectionView == wallpaperCollectionView {
            return CGSize(width: CGFloat(1180), height: CGFloat(730))
        } else {
            return CGSize(width: CGFloat(20), height: CGFloat(20))
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        var scrollCnt = 0
        let _ = Timer.scheduledTimer(withTimeInterval: 5, repeats: false) { Timer in
            scrollCnt += 1
        }
        
        if scrollCnt == 0 {
            self.itemCollectionView.reloadData()
        }
        if scrollView == wallpaperCollectionView {
            timer?.invalidate()
        }
        reset = 0
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView == wallpaperCollectionView {
            if scrollView.contentOffset.x / scrollView.frame.width > CGFloat(Int(scrollView.contentOffset.x / scrollView.frame.width)) + CGFloat(0.5) {
                nowPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width) + 1
            } else {
                nowPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
            }
            wallpaperCollectionView.scrollToItem(at: [0, nowPage], at: .right, animated: true)
            self.bannerMove()
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == wallpaperCollectionView {
            if scrollView.contentOffset.x / scrollView.frame.width > CGFloat(Int(scrollView.contentOffset.x / scrollView.frame.width)) + CGFloat(0.5) {
                nowPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width) + 1
            } else {
                nowPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
            }
            wallpaperCollectionView.scrollToItem(at: [0, nowPage], at: .right, animated: true)
        }
    }
}

extension BrandMainViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == mainScrollView {
            self.reset = 0
        }
    }
}

class BrandMainItemCell: UICollectionViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    
    
    @IBOutlet weak var itemImages: UIImageView!
    @IBOutlet weak var itemName: UILabel!
    @IBOutlet weak var itemPrice: UILabel!
    @IBOutlet weak var colorCollectionView: UICollectionView!
    var itemModel: ItemModel!
    
    func updateUI() {
        colorCollectionView.delegate = self
        colorCollectionView.dataSource = self
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itemModel.colorCodes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "itemcolorCell", for: indexPath) as! ItemColorCell
        let hex = Int(itemModel.colorCodes[indexPath.row], radix: 16)!
        cell.colorView.layer.cornerRadius = cell.colorView.bounds.width / 2
        cell.colorView.backgroundColor = UIColor(rgb: hex)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: CGFloat(20), height: CGFloat(20))
    }
}

class ItemColorCell: UICollectionViewCell {
    @IBOutlet weak var colorView: UIView!
}

class BrandWallpaperCell: UICollectionViewCell {
    @IBOutlet weak var wallpaperImage: UIImageView!
    
}
