//
//  CartKakaoViewController.swift
//  Collect
//
//  Created by 박진서 on 2021/09/17.
//

import UIKit
import RxSwift
import RxCocoa

class CartKakaoViewController: UIViewController, ViewModelBindableType {

    var viewModel: CartKakaoViewModel!
    
    var resetTimer: Timer?
    var reset = 0
    let cart = CartModel.shared
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var staffButton: UIButton!
    @IBOutlet weak var userInfoButton: UIButton!
    @IBOutlet weak var container: UIView!
    @IBOutlet weak var backCollectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        reset = 0
        resetTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { Timer in
            self.reset += 1
            if self.reset == 240 {
                self.cart.resetCart()
                self.navigationController?.popToRootViewController(animated: false)
                self.resetTimer?.invalidate()
            }
        })
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        resetTimer?.invalidate()
    }
    
    deinit {
        print("cartKakaoViewcontroller deinited")
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var prefersHomeIndicatorAutoHidden: Bool {
        return true
    }
    
    func bindViewModel() {
        container.layer.cornerRadius = 13
        
        backButton.rx.action = viewModel.commonPopAction
        userInfoButton.rx.action = viewModel.userInfoAction
        staffButton.rx.action = viewModel.staffAction
        
        backCollectionView.rx.setDelegate(self)
            .disposed(by: rx.disposeBag)
        
        viewModel.cart.colorItemSubject
            .bind(to: backCollectionView.rx.items(cellIdentifier: "coloritemCell", cellType: ColorItemCell.self)) { [unowned self] index, colorItem, cell in
                Observable.just(colorItem.itemName!)
                    .subscribe(onNext: { name in
                        if name == "default" {
                            cell.itemNameLabel.isHidden = true
                            cell.isEmptyLabel.isHidden = true
                            cell.isEmptyColorView.isHidden = true
                            cell.mainImageView.isHidden = true
                            cell.removeButton.isHidden = true
                            
                            cell.addCartButton.isHidden = false
                        } else {
                            cell.itemNameLabel.isHidden = false
                            cell.isEmptyLabel.isHidden = false
                            cell.isEmptyColorView.isHidden = false
                            cell.mainImageView.isHidden = false
                            cell.removeButton.isHidden = false
                            
                            cell.mainImageView.sd_setImage(with: colorItem.images[0], completed: nil)
                            cell.itemNameLabel.text = "\(colorItem.brand!) - \(colorItem.itemName!) \(colorItem.colorNameKor!)"
                            cell.isEmptyColorView.layer.cornerRadius = cell.isEmptyColorView.bounds.width / 2
                            if colorItem.isEmpty == true {
                                cell.isEmptyColorView.backgroundColor = .red
                                cell.isEmptyLabel.text = "매장에 재고가 없습니다."
                            } else {
                                cell.isEmptyColorView.backgroundColor = .green
                                cell.isEmptyLabel.text = "매장에 재고가 있습니다."
                            }

                            cell.addCartButton.isHidden = true
                        }
                    })
                    .disposed(by: self.rx.disposeBag)
            }
            .disposed(by: rx.disposeBag)
    }

}

extension CartKakaoViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: CGFloat(310), height: CGFloat(484))
    }
}
