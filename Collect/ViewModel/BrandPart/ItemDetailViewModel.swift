//
//  ItemDetailViewModel.swift
//  Collect
//
//  Created by 박진서 on 2021/09/04.
//

import RxSwift
import RxCocoa
import Kingfisher
import Action

class ItemDetailViewModel: CommonViewModel {
    let service = Service.shared
    let cart = CartModel.shared
   
    var itemModel: ItemModel!
    var infoSubject: BehaviorRelay<Array<[String: String]>>
    
    var infoArray: Array<[String: String]> = []
    
    let colorIndexOb = BehaviorSubject<Int>(value: 0)

    init(item: ItemModel, title: String, sceneCoordinator: SceneCoordinatorType) {
        self.itemModel = item
        
        infoArray.append(["소재": itemModel.material!])
        infoArray.append(["쉐입": itemModel.shape!])
        infoArray.append(["원산지": itemModel.madeIn!])
        infoArray.append(["사이즈 (렌즈□브릿지, 다리)": itemModel.size!])
        
        infoSubject = BehaviorRelay<Array<[String: String]>>(value: infoArray)

        super.init(title: title, sceneCoordinator: sceneCoordinator)
        updateViewModel()
    }
    
    func updateViewModel() {
        
        for coloritem in self.itemModel.colorItems {
            let colorUrlSub = BehaviorRelay<[URL]>(value: [])
            self.service.fetchColorItemImages(colorItemModel: coloritem)
                .bind(to: colorUrlSub)
                .disposed(by: self.rx.disposeBag)
            colorUrlSub
                .subscribe(onNext: { urlArr in
                    coloritem.images = urlArr.sorted(by: {$0.absoluteString < $1.absoluteString})
                })
                .disposed(by: self.rx.disposeBag)
        }
    }
    
    lazy var cartAction: Action<ColorItemModel, Void> = {
        return Action { [unowned self] item in
            self.cart.addItemOnCart(item)
            let cartVM = CartViewModel(title: "cart", sceneCoordinator: self.sceneCoordinator)
            let cartVC = Scene.cart(cartVM)
            return self.sceneCoordinator.transition(to: cartVC, using: .push, animated: false).asObservable().map{ _ in }
        }
    }()
    
    lazy var cartPresentAction: Action<Void, Void> = {
        return Action { [unowned self] in
            let cartVM = CartViewModel(title: "cart", sceneCoordinator: self.sceneCoordinator)
            let cartVC = Scene.cart(cartVM)
            return self.sceneCoordinator.transition(to: cartVC, using: .push, animated: false).asObservable().map{ _ in }
        }
    }()
    
    lazy var wideAction: Action<UIImage, Void> = {
        return Action { [unowned self] img in
            let VM = WideViewModel(img: img, title: "wide", sceneCoordinator: self.sceneCoordinator)
            let vc = Scene.wide(VM)
            return self.sceneCoordinator.transition(to: vc, using: .modal, animated: false).asObservable().map{ _ in }
        }
    }()
    
    lazy var popAction = CocoaAction { [unowned self] in
        return self.sceneCoordinator.close(animated: true).asObservable().map { _ in }
    }
    
    deinit {
        print("itemdetailViewModel deinited")
    }
}
