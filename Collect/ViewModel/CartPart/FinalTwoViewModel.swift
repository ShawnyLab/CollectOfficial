//
//  FinalTwoViewModel.swift
//  Collect
//
//  Created by 박진서 on 2021/09/17.
//

import Action
import Firebase

class FinalTwoViewModel: CommonViewModel {
    
    var name: String!
    var phoneNum: String!
    
    let cart = CartModel.shared
    
    init(phoneNum: String, name: String, title: String, sceneCoordinator: SceneCoordinatorType) {
        self.name = name
        self.phoneNum = phoneNum
        super.init(title: title, sceneCoordinator: sceneCoordinator)
        
        var finalItems: [String] = []
        
        cart.colorItemSubject
            .subscribe(onNext: { items in
                for item in items {
                    if item.itemName! != "default" {
                        if item.isEmpty == true {
                            finalItems.append("\(item.code!) (X)")
                        } else {
                            finalItems.append(item.code!)
                        }
                    }
                }
            })
            .disposed(by: rx.disposeBag)
        
        let key = Database.database().reference().childByAutoId().key
        
        Database.database().reference().child("1").child("Notice")
            .child(key!).setValue(["timestamp": ServerValue.timestamp(), "name": name, "phoneNum": phoneNum, "key": key!, "type": 2])
        
        for str in finalItems {
            Database.database().reference().child("1").child("Notice")
                .child(key!).child("Item").child(str).setValue(str)
        }
    }
    
    deinit {
        print("Final Two deinited")
    }
}
