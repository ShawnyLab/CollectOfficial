import UIKit
import RxSwift
import RxCocoa
import Action
import Kingfisher

class CommonViewModel: NSObject {
    let title: Driver<String>
    let sceneCoordinator: SceneCoordinatorType
    
    init(title: String, sceneCoordinator: SceneCoordinatorType) {
        self.title = Observable.just(title).asDriver(onErrorJustReturn: "")
        self.sceneCoordinator = sceneCoordinator
        
    }
    
    lazy var commonPopAction = CocoaAction { [unowned self] in
        return self.sceneCoordinator.close(animated: false).asObservable().map { _ in }
    }
}
