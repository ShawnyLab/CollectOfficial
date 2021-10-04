//
//  FirstViewModel.swift
//  Collect
//
//  Created by 박진서 on 2021/09/06.
//

import Action
import RxSwift
import RxCocoa

class FirstViewModel: CommonViewModel {
    
    override init(title: String, sceneCoordinator: SceneCoordinatorType) {
        super.init(title: title, sceneCoordinator: sceneCoordinator)
        
    }
    
    func selectButton() -> CocoaAction {
        return CocoaAction { [unowned self] _ in
            let selectVM = SelectViewModel(title: "select", sceneCoordinator: self.sceneCoordinator)
            let scene = Scene.select(selectVM)
            return self.sceneCoordinator.transition(to: scene, using: .push, animated: true).asObservable().map { _ in }
        }
    }
    
    func editorButton() -> CocoaAction {
        return CocoaAction { [unowned self] _ in
            let VM = CodeViewModel(title: "Code", sceneCoordinator: self.sceneCoordinator)
            let scene = Scene.code(VM)
            return self.sceneCoordinator.transition(to: scene, using: .push, animated: true).asObservable().map { _ in }
        }
    }
}
