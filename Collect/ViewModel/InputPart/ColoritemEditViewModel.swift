//
//  ColoritemEditViewModel.swift
//  Collect
//
//  Created by 박진서 on 2021/09/16.
//

import RxSwift
import RxCocoa
import Firebase
import Action

class ColoritemEditViewModel: CommonViewModel {
    var itemModel: ItemModel!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    var rootVC: UIViewController!
    var topVC: ColoritemListViewController!
    
    let colorSub = BehaviorSubject<String>(value: "")
    var colorT = ""
    let colorNameSub = BehaviorSubject<String>(value: "")
    var colorNameT = ""
    let itemCodeSub = BehaviorSubject<String>(value: "")
    var codeT = ""
    let fileNameSub = BehaviorSubject<String>(value: "")
    var fileNameT = ""
    
    let ref = Database.database().reference()
    
    init(itemModel: ItemModel, title: String, sceneCoordinator: SceneCoordinatorType) {
        self.itemModel = itemModel
        rootVC = appDelegate.window!.rootViewController
        topVC = rootVC?.children.last! as? ColoritemListViewController
        super.init(title: title, sceneCoordinator: sceneCoordinator)
        
        colorSub.subscribe(onNext: { str in
            self.colorT = str
        })
        .disposed(by: rx.disposeBag)
        
        colorNameSub.subscribe(onNext: { str in
            self.colorNameT = str
        })
        .disposed(by: rx.disposeBag)
        
        itemCodeSub.subscribe(onNext: { str in
            self.codeT = str
        })
        .disposed(by: rx.disposeBag)
        
        fileNameSub.subscribe(onNext: { str in
            self.fileNameT = str
        })
        .disposed(by: rx.disposeBag)
        
    }
    
    lazy var addAction: Action<Void, Void> = {
        return Action {
            var colorItems: [ColorItemModel] = []
            self.topVC.viewModel.colorItemSubject
                .subscribe(onNext: { itemArr in
                    colorItems = itemArr
                })
                .disposed(by: self.rx.disposeBag)
            
            let colorItem = ColorItemModel(itemName: self.itemModel.name!, fileName: self.fileNameT, colorCode: self.colorT, isEmpty: false, colorNameKor: self.colorNameT, brand: self.itemModel.brand!, code: self.codeT)
            
            colorItems.append(colorItem)
            colorItems.sort(by: {$0.fileName! < $1.fileName!})
            
            self.ref.child("1").child("Brand").child(self.itemModel.brand!).child("Item")
                .child(self.itemModel.name!).child("colorItems").child(self.fileNameT)
                .setValue(["brand": self.itemModel.brand!, "colorCode": self.colorT, "colorNameKor": self.colorNameT, "fileName": self.fileNameT, "isEmpty": false, "itemName": self.itemModel.name!, "code": self.codeT])
            
            self.topVC.viewModel.colorItemSubject.onNext(colorItems)

            return self.sceneCoordinator.close(animated: false).asObservable().map { _ in }
        }
    }()
}
