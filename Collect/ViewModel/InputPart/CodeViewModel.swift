//
//  CodeViewModel.swift
//  Collect
//
//  Created by 박진서 on 2021/09/23.
//

import Action
import RxCocoa
import RxSwift

class CodeViewModel: CommonViewModel {
    
    func editorButton() -> CocoaAction {
        return CocoaAction { _ in
            let noticeVM = NoticeViewModel(title: "notice", sceneCoordinator: self.sceneCoordinator)
            let scene = Scene.notice(noticeVM)
            return self.sceneCoordinator.transition(to: scene, using: .push, animated: true).asObservable().map { _ in }
        }
    }
}
