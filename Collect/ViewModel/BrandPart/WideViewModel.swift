//
//  WideViewModel.swift
//  Collect
//
//  Created by 박진서 on 2021/09/23.
//

import Action

class WideViewModel: CommonViewModel {
    
    var imgURL: UIImage!
    
    init(img: UIImage, title: String, sceneCoordinator: SceneCoordinatorType) {
        self.imgURL = img
        super.init(title: title, sceneCoordinator: sceneCoordinator)
    }
    
    lazy var popAction = CocoaAction { [unowned self] in
        return self.sceneCoordinator.close(animated: false).asObservable().map{ _ in }
    }
    
    deinit {
        print("wide VM deinited")
    }
}
