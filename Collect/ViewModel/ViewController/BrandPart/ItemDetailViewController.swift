//
//  ItemDetailViewController.swift
//  Collect
//
//  Created by 박진서 on 2021/09/04.
//

import UIKit
import NSObject_Rx
import RxSwift
import RxCocoa
import SDWebImage
import Firebase
import Kingfisher

class ItemDetailViewController: UIViewController, ViewModelBindableType {

    let cache = ImageCache.default
    var viewModel: ItemDetailViewModel!
    
    var pageObservable = BehaviorSubject<Int>(value: 0)
    var colorIndexOb = BehaviorSubject<Int>(value: 0)
    
    var colorSelected = 0
    
    var resetTimer: Timer?
    var reset = 0
    
    var nowPage: Int = 0
    var nowUrl: URL?
    
    var imgSelectedOb = BehaviorSubject<Int>(value: 0)
    
    var imgTimer: Timer?
    var imgUrl: [URL] = []
    var realImg: [UIImage] = []
    
    let notEmptyText = "현재 매장에 재고가 있습니다."
    let emptyText = "현재 매장에 재고가 없습니다."
    
    let imgOb = BehaviorSubject<[URL]>(value: [])
    
    var oriSub = BehaviorSubject<String>(value: "landscape")
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    @IBOutlet weak var imageContainer: UIView!
    @IBOutlet weak var realPopButton: UIButton!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var finalButtonView: UIView!
    @IBOutlet weak var exclusiveLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var brandLabel: UILabel!
    @IBOutlet weak var ItemName: UILabel!
    @IBOutlet weak var itemNameKor: UILabel!
    @IBOutlet weak var itemDesLabel: UITextView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var imageCollectionView: UICollectionView!
    @IBOutlet weak var colorCollectionView: UICollectionView!
    @IBOutlet weak var infoCollectionView: UICollectionView!
    @IBOutlet weak var smallCollectionView: UICollectionView!
    
    @IBOutlet weak var infoScrollView: UIScrollView!
    @IBOutlet weak var myCartButton: UIButton!
    @IBOutlet weak var colorLabel: UILabel!
    @IBOutlet weak var isEmptyColorView: UIView!
    @IBOutlet weak var addCartButton: UIButton!
    @IBOutlet weak var isEmptyLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        addCartButton.isEnabled = false
        
        imgTimer = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true) { time in
            if self.imgUrl.count < 3 {
                self.imgUrl = self.viewModel.itemModel.colorItems[0].images
                self.imgOb.onNext(self.imgUrl)
                self.imageCollectionView.reloadData()
            } else {
                self.addCartButton.isEnabled = true
                self.imgTimer?.invalidate()
                print("imgTimerStopped")
            }
        }
        imgUrl = viewModel.itemModel.colorItems[0].images
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        print(size)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        reset = 0
        resetTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { Timer in
            self.reset += 1
            print("itemdetail -----> \(self.reset)")
            if self.reset == 300 {
                self.cache.clearCache()
                self.viewModel.cart.resetCart()
                self.navigationController?.popToRootViewController(animated: false)
                self.resetTimer?.invalidate()
            }
        })
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        resetTimer?.invalidate()
        imgTimer?.invalidate()
        print("itemdetail timer all stopped")
    }
    
    deinit {
        print("itemdetail deinited")
    }
    
    @objc func detectOrientation() {
        if (UIDevice.current.orientation == .landscapeLeft) || (UIDevice.current.orientation == .landscapeRight) {
            self.oriSub.onNext("landscape")
        } else {
            self.oriSub.onNext("default")
        }
        self.imageCollectionView.reloadData()
        self.loadViewIfNeeded()
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var prefersHomeIndicatorAutoHidden: Bool {
        return true
    }

    func bindViewModel() {
        exclusiveLabel.isHidden = !viewModel.itemModel.isExclusive
        
        imageCollectionView.decelerationRate = .fast
        smallCollectionView.rx.setDelegate(self)
            .disposed(by: rx.disposeBag)
        
        viewModel.updateViewModel()
        
        self.colorIndexOb
            .bind(to: viewModel.colorIndexOb)
            .disposed(by: rx.disposeBag)
                
        let len = "\(viewModel.itemModel!.cost!)".count
        if len < 7 {
            var str = Array("\(viewModel.itemModel!.cost!)").map{String($0)}
            str.insert(",", at: len-3)
            priceLabel.text = "\(String(str.joined()))원"
        } else if len < 10 && len >= 7 {
            var str = Array("\(viewModel.itemModel!.cost!)").map{String($0)}
            str.insert(",", at: len-3)
            str.insert(",", at: len-6)
            priceLabel.text = "\(String(str.joined()))원"
        }
        
        Observable.just(viewModel.itemModel!)
            .subscribe(onNext: { [unowned self] item in
                self.brandLabel.text = item.brand
                self.ItemName.text = item.name
                self.itemNameKor.text = item.nameKor
                self.itemDesLabel.text = item.des
            })
            .disposed(by: rx.disposeBag)
        
        //smallView
        imgOb
            .bind(to: smallCollectionView.rx.items(cellIdentifier: "smallCell", cellType: SmallCell.self)) { [unowned self] index, url, cell in
                cell.smallImage.kf.setImage(with: url)
                self.imgSelectedOb.subscribe(onNext: { num in
                    if num == index {
                        cell.bottomBar.isHidden = false
                    } else {
                        cell.bottomBar.isHidden = true
                    }
                })
                .disposed(by: self.rx.disposeBag)
            }
            .disposed(by: rx.disposeBag)
        
        smallCollectionView.rx.itemSelected
            .subscribe(onNext: { [unowned self] index in
                self.reset = 0
                self.imageCollectionView.scrollToItem(at: index, at: .right, animated: false)
                self.imgSelectedOb.onNext(index.row)
                
            })
            .disposed(by: rx.disposeBag)
        
        //FinalView
        finalButtonView.addShadow(location: .top)
        finalButtonView.addShadow(offset: CGSize(width: 0, height: -2), color: UIColor.black, opacity: 0.2, radius: 3)

        //TopView
        
        topView.addShadow(location: .bottom)
        topView.addShadow(offset: CGSize(width: 0, height: 2), color: UIColor.black, opacity: 0.2, radius: 3)
        
        //color Circle Binding

        Observable.just(viewModel.itemModel.colorItems)
            .bind(to: colorCollectionView.rx.items(cellIdentifier: "itemdetailcolorCell", cellType: ItemDetailColorCell.self)) { [unowned self] idx, coloritem, cell in
                cell.colorImage.layer.cornerRadius = cell.colorImage.bounds.width / 2
                let hex = Int(coloritem.colorCode!, radix: 16)!
                cell.colorImage.backgroundColor = UIColor(rgb: hex)
                
                self.colorIndexOb
                    .subscribe(onNext: { [unowned self] colorIndex in
                        if idx == self.colorSelected {
                            cell.colorImage.layer.borderWidth = 2
                            cell.colorImage.layer.borderColor = UIColor.lightGray.cgColor
                        } else {
                            cell.colorImage.layer.borderWidth = 0
                        }
                    })
                    .disposed(by: self.rx.disposeBag)
            }
            .disposed(by: rx.disposeBag)
        
        //color Selection
        
        colorCollectionView.rx.itemSelected
            .map { $0.row }
            .subscribe(onNext: { [unowned self] index in
                self.pageObservable.onNext(0)
                self.nowPage = 0
                self.colorSelected = index
                self.colorIndexOb.onNext(index)
                self.imgSelectedOb.onNext(0)
                self.reset = 0
                self.imgOb.onNext(self.viewModel.itemModel.colorItems[index].images)
            })
            .disposed(by: rx.disposeBag)
        
        colorIndexOb
            .subscribe(onNext: { [unowned self] index in
                self.imgUrl = self.viewModel.itemModel.colorItems[index].images
                self.imageCollectionView.scrollToItem(at: [0, 0], at: .left, animated: false)
                self.imageCollectionView.reloadData()
                
                self.colorLabel.text = "색상 - \(self.viewModel.itemModel.colorItems[index].colorNameKor!)"
                if self.viewModel.itemModel.colorItems[index].isEmpty == true {
                    self.isEmptyColorView.backgroundColor = UIColor(red: 191, green: 63, blue: 63)
                    self.isEmptyLabel.text = self.emptyText
                } else {
                    self.isEmptyColorView.backgroundColor = UIColor(red: 89, green: 191, blue: 63)
                    self.isEmptyLabel.text = self.notEmptyText
                }
            })
            .disposed(by: rx.disposeBag)

        //set Image
        imageCollectionView.delegate = self
        imageCollectionView.dataSource = self
        infoScrollView.delegate = self

        //set info
        viewModel.infoSubject
            .bind(to: infoCollectionView.rx.items(cellIdentifier: "itemdetailinfoCell", cellType: ItemDetailInfoCell.self)) { _, info, cell in
                cell.mainView.layer.cornerRadius = 13
                cell.mainView.layer.borderWidth = 1
                cell.mainView.layer.borderColor = UIColor(rgb: 0xE1E1E1).cgColor
                cell.categoryLabel.text = info.keys.first
                cell.infoLabel.text = info.values.first
            }
            .disposed(by: rx.disposeBag)
                
        isEmptyColorView.layer.cornerRadius = isEmptyColorView.bounds.width / 2
        
        addCartButton.rx.tap
            .subscribe(onNext: { [unowned self] in
                Observable.just(self.viewModel.itemModel.colorItems[self.colorSelected])
                    .bind(to: self.viewModel.cartAction.inputs)
                    .disposed(by: self.rx.disposeBag)
            })
            .disposed(by: rx.disposeBag)
    
        
        myCartButton.rx.action = viewModel.cartPresentAction
        realPopButton.rx.action = viewModel.popAction
    }
    
    func makeView(_ view: UIView) {
        view.layer.cornerRadius = 13
        view.layer.borderColor = UIColor.black.cgColor
        view.layer.borderWidth = 1
    }
}

extension ItemDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == imageCollectionView {
            return imgUrl.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == imageCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "itemdetailCell", for: indexPath) as! ItemDetailCell
            
            cache.retrieveImage(forKey: imgUrl[indexPath.row].absoluteString) { result in
                switch result {
                case .success(let value):
                    if let image = value.image {
                        cell.detailImage.image = image
                    } else {
                        let url = self.imgUrl[indexPath.row]
                        let resource = ImageResource(downloadURL: url, cacheKey: url.absoluteString)
                        cell.detailImage.kf.indicatorType = .activity
                        cell.detailImage.kf.setImage(with: resource, options: [.transition(.fade(0.7))])
                    }
                    cell.realWideButton.rx.tap
                        .subscribe(onNext: { [unowned self] in
                            self.reset = 0
                        })
                        .disposed(by: self.rx.disposeBag)

                    cell.realWideButton.rx.tap
                        .throttle(.seconds(2), latest: false, scheduler: MainScheduler.instance)
                        .subscribe(onNext: { [unowned self] in
                            Observable.just(cell.detailImage.image!)
                                .take(1)
                                .bind(to: self.viewModel.wideAction.inputs)
                                .disposed(by: self.rx.disposeBag)
                        })
                        .disposed(by: self.rx.disposeBag)
                case .failure(let err):
                    print(err)
                }
            }
            return cell
        }
        return UICollectionViewCell()
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == imageCollectionView {
            return CGSize(width: 522, height: 522)
        } else if collectionView == smallCollectionView {
            return CGSize(width: CGFloat(70), height: CGFloat(70))
        }
        return CGSize(width: CGFloat(34), height: CGFloat(34))
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if scrollView == infoScrollView {
            self.reset = 0
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView == imageCollectionView {
            if scrollView.contentOffset.x / scrollView.frame.width > CGFloat(Int(scrollView.contentOffset.x / scrollView.frame.width)) + CGFloat(0.5) {
                nowPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width) + 1
            } else {
                nowPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
            }
            imageCollectionView.scrollToItem(at: [0, nowPage], at: .right, animated: true)
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == imageCollectionView {
            if scrollView.contentOffset.x / scrollView.frame.width > CGFloat(Int(scrollView.contentOffset.x / scrollView.frame.width)) + CGFloat(0.5) {
                nowPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width) + 1
            } else {
                nowPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
            }
            imageCollectionView.scrollToItem(at: [0, nowPage], at: .right, animated: true)
        }
    }
}

class ItemDetailCell: UICollectionViewCell {
    @IBOutlet weak var detailImage: UIImageView!
    @IBOutlet weak var wideButton: UIButton!
    @IBOutlet weak var realWideButton: UIButton!
}

class ItemDetailColorCell: UICollectionViewCell {
    @IBOutlet weak var colorImage: UIView!
    
}

class ItemDetailInfoCell: UICollectionViewCell {
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var mainView: UIView!
    
}

class SmallCell: UICollectionViewCell {
    @IBOutlet weak var smallImage: UIImageView!
    @IBOutlet weak var bottomBar: UIView!
}
