//
//  BannerViewModel.swift
//  Collect
//
//  Created by 박진서 on 2021/09/14.
//

import RxCocoa
import Action
import RxSwift

class BannerViewModel: CommonViewModel {
    var imgURL: URL!
    
    init(url: URL, title: String, sceneCoordinator: SceneCoordinatorType) {
        self.imgURL = url
        super.init(title: title, sceneCoordinator: sceneCoordinator)
    }
    
    lazy var popAction = CocoaAction { [unowned self] in
        return self.sceneCoordinator.close(animated: false).asObservable().map { _ in }
    }
}
