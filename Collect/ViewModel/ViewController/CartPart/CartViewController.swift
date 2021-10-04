//
//  CartViewController.swift
//  Collect
//
//  Created by 박진서 on 2021/09/08.
//

import UIKit
import RxSwift
import RxCocoa

class CartViewController: UIViewController, ViewModelBindableType {

    let cart = CartModel.shared
    
    var viewModel: CartViewModel!
    var resetTimer: Timer?
    var reset = 0
    
    @IBOutlet weak var infoText: UILabel!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var realBackButton: UIButton!
    @IBOutlet weak var sendItemsButton: UIButton!
    @IBOutlet weak var itemCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        reset = 0
        resetTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { Timer in
            self.reset += 1
            print("cartView reset timer ----> \(self.reset)")
            if self.reset == 240 {
                self.cart.resetCart()
                self.navigationController?.popToRootViewController(animated: false)
                self.resetTimer?.invalidate()
            }
        })
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        resetTimer?.invalidate()
        print("cartView timer all stopped")
    }
    
    deinit {
        print("CartViewController deinited")
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var prefersHomeIndicatorAutoHidden: Bool {
        return true
    }
    
    func bindViewModel() {
        
        realBackButton.rx.action = viewModel.popAction

        itemCollectionView.rx.setDelegate(self)
            .disposed(by: rx.disposeBag)
        
        viewModel.cartModel.colorItemSubject
            .bind(to: itemCollectionView.rx.items(cellIdentifier: "coloritemCell", cellType: ColorItemCell.self)) { [unowned self] index, colorItem, cell in
                Observable.just(colorItem.itemName!)
                    .subscribe(onNext: { [unowned self] name in
                        if name == "default" {
                            cell.itemNameLabel.isHidden = true
                            cell.isEmptyLabel.isHidden = true
                            cell.isEmptyColorView.isHidden = true
                            cell.mainImageView.isHidden = true
                            cell.removeButton.isHidden = true
                            
                            cell.addCartButton.isHidden = false
                            cell.addCartButton.rx.tap
                                .subscribe(onNext: { [unowned self] in
                                    self.navigationController?.popToViewController(self.viewModel.selectVC, animated: false)
                                })
                                .disposed(by: self.rx.disposeBag)
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
                            cell.buttonClickHandler = {
                                self.viewModel.cartModel.removeItemOnCart(index)
                                self.reset = 0
                            }
                        }
                    })
                    .disposed(by: self.rx.disposeBag)
            }
            .disposed(by: rx.disposeBag)
        sendItemsButton.rx.tap
            .subscribe(onNext: { [unowned self] in
                self.resetTimer?.invalidate()
            })
            .disposed(by: rx.disposeBag)
        sendItemsButton.rx.action = viewModel.userInfoAction
        
        viewModel.enableSub
            .subscribe(onNext: { [unowned self] bool in
                if bool == true {
                    self.infoText.text = "최대 3개까지 비교하고 바로 착용해 볼 수 있습니다."
                    self.infoText.textColor = .black
                } else {
                    self.infoText.text = "제품 추가를 눌러 착용해 보고싶은 제품을 선택하세요."
                    self.infoText.textColor = UIColor(red: 235, green: 90, blue: 70)
                }
                
            })
            .disposed(by: rx.disposeBag)
        
        viewModel.enableSub
            .bind(to: sendItemsButton.rx.isEnabled)
            .disposed(by: rx.disposeBag)

    }
    
}

extension CartViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: CGFloat(310), height: CGFloat(484))
    }
}

class ColorItemCell: UICollectionViewCell {
    @IBOutlet weak var itemNameLabel: UILabel!
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var isEmptyLabel: UILabel!
    @IBOutlet weak var isEmptyColorView: UIView!
    @IBOutlet weak var removeButton: UIButton!
    @IBOutlet weak var addCartButton: UIButton!
    
    var buttonClickHandler: (() -> Void)?
    
    @IBAction func removeAction(_ sender: Any) {
        buttonClickHandler!()
    }
    
}
