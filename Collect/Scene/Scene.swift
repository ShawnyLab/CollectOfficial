import UIKit

enum Scene {
    case first(FirstViewModel)
    case select(SelectViewModel)
    case banner(BannerViewModel)
    case brandmain(BrandMainViewModel)
    case itemdetail(ItemDetailViewModel)
    case wide(WideViewModel)
    
    case cart(CartViewModel)
    case cartSelect(CartSelectViewModel)
    case cartKakao(CartKakaoViewModel)
    case allEmpty(AllemptyViewModel)
    
    case access(AccessViewModel)
    
    case final(FinalViewModel)
    case finalTwo(FinalTwoViewModel)
    case finalThree(FinalThreeViewModel)
    
    case sort(SortViewModel)
    case userinfo(UserinfoViewModel)
    
    case notice(NoticeViewModel)
    case noticeDone(DoneNoticeViewModel)
    
    case brandList(BrandListViewModel)
    case itemList(ItemListViewModel)
    case coloritemList(ColoritemListViewModel)
    
    case brandEdit(BrandEditViewModel)
    case itemEdit(ItemEditViewModel)
    case coloritemEdit(ColoritemEditViewModel)
    
    case code(CodeViewModel)
}

extension Scene {
    func instantiate() -> UIViewController {
        let mainSB = UIStoryboard(name: "Main", bundle: nil)
        let cartSB = UIStoryboard(name: "Cart", bundle: nil)
        let inputSB = UIStoryboard(name: "Input", bundle: nil)
        
        switch self {
        case .first(let firstVM):
            guard let nav = mainSB.instantiateViewController(identifier: "firstNav") as? UINavigationController else { fatalError() }
            guard var vc = nav.viewControllers.first as? FirstViewController else { fatalError() }
            vc.bind(viewModel: firstVM)
            return nav
            
        case .banner(let bannerVM):
            guard var vc = mainSB.instantiateViewController(identifier: "bannerVC") as? BannerViewController else { fatalError() }
            vc.modalPresentationStyle = .overCurrentContext
            vc.bind(viewModel: bannerVM)
            return vc
        
        case .select(let selectVM):
            guard let nav = mainSB.instantiateViewController(identifier: "selectNav") as? UINavigationController else { fatalError() }
            guard var selectVC = nav.viewControllers.first as? SelectViewController else { fatalError() }
            selectVC.bind(viewModel: selectVM)
            return selectVC

        case .brandmain(let bmVM):
            guard let nav = mainSB.instantiateViewController(identifier: "brandmainNav") as? UINavigationController else { fatalError() }
            guard var vc = nav.viewControllers.first as? BrandMainViewController else { fatalError() }
            vc.bind(viewModel: bmVM)
            return vc
            
        case .itemdetail(let idVM):
            guard let nav = mainSB.instantiateViewController(identifier: "itemdetailNav") as? UINavigationController else { fatalError() }
            guard var vc = nav.viewControllers.first as? ItemDetailViewController else { fatalError() }
            vc.bind(viewModel: idVM)
            return vc
            
        case .wide(let VM):
            guard var vc = mainSB.instantiateViewController(identifier: "wideVC") as? WideViewController else { fatalError() }
            vc.modalPresentationStyle = .overCurrentContext
            vc.view.backgroundColor = .black.withAlphaComponent(0.4)
            vc.bind(viewModel: VM)
            return vc
            
        /*
         ** Cart Part
         */
            
        case .cart(let cartVM):
            guard let nav = cartSB.instantiateViewController(identifier: "cartNav") as? UINavigationController else { fatalError() }
            guard var vc = nav.viewControllers.first as? CartViewController else { fatalError() }
            vc.modalPresentationStyle = .fullScreen
            vc.bind(viewModel: cartVM)
            return vc
            
        case .cartSelect(let VM):
            guard let nav = cartSB.instantiateViewController(identifier: "cartselectNav") as? UINavigationController else { fatalError() }
            guard var vc = nav.viewControllers.first as? CartSelectViewController else { fatalError() }
            vc.bind(viewModel: VM)
            vc.modalPresentationStyle = .overCurrentContext
            vc.view.backgroundColor = .black.withAlphaComponent(0.4)
            return vc
            
        case .cartKakao(let VM):
            guard let nav = cartSB.instantiateViewController(identifier: "cartkakaoNav") as? UINavigationController else { fatalError() }
            guard var vc = nav.viewControllers.first as? CartKakaoViewController else { fatalError() }
            vc.bind(viewModel: VM)
            vc.modalPresentationStyle = .overCurrentContext
            return vc
            
        case .allEmpty(let VM):
            guard let nav = cartSB.instantiateViewController(identifier: "allemptyNav") as? UINavigationController else { fatalError() }
            guard var vc = nav.viewControllers.first as? AllemptyViewController else { fatalError() }
            vc.bind(viewModel: VM)
            vc.modalPresentationStyle = .overCurrentContext
            return vc
            
        case .access(let VM):
            guard var vc = cartSB.instantiateViewController(identifier: "accessVC") as? AccessViewController else { fatalError() }
            vc.bind(viewModel: VM)
            vc.modalPresentationStyle = .overCurrentContext
            vc.view.backgroundColor = .black.withAlphaComponent(0.4)
            return vc
            
            
        case .sort(let sortVM):
            guard var vc = mainSB.instantiateViewController(identifier: "sortVC") as? SortViewController else { fatalError() }
            vc.bind(viewModel: sortVM)
            vc.modalPresentationStyle = .overCurrentContext
            vc.view.backgroundColor = .black.withAlphaComponent(0.4)
            return vc
            
        case .userinfo(let uiVM):
            guard let nav = cartSB.instantiateViewController(identifier: "userinfoNav") as? UINavigationController else { fatalError() }
            guard var vc = nav.viewControllers.first as? UserinfoViewController else { fatalError() }
            vc.bind(viewModel: uiVM)
            return vc
            
        case .final(let VM):
            guard let nav = cartSB.instantiateViewController(identifier: "finalNav") as? UINavigationController else { fatalError() }
            guard var vc = nav.viewControllers.first as? FinalViewController else { fatalError() }
            vc.bind(viewModel: VM)
            return vc
            
        case .finalTwo(let VM):
            guard let nav = cartSB.instantiateViewController(identifier: "finaltwoNav") as? UINavigationController else { fatalError() }
            guard var vc = nav.viewControllers.first as? FinalTwoViewController else { fatalError() }
            vc.bind(viewModel: VM)
            return vc
            
        case .finalThree(let VM):
            guard let nav = cartSB.instantiateViewController(identifier: "finalthreeNav") as? UINavigationController else { fatalError() }
            guard var vc = nav.viewControllers.first as? FinalThreeViewController else { fatalError() }
            vc.bind(viewModel: VM)
            return vc
            
            
        /*
         ** Input Part
         */
            
            
        case .notice(let noticeVM):
            guard let nav = inputSB.instantiateViewController(identifier: "noticeNav") as? UINavigationController else { fatalError() }
            guard var vc = nav.viewControllers.first as? NoticeViewController else { fatalError() }
            vc.bind(viewModel: noticeVM)
            return vc
            
        case .noticeDone(let VM):
            guard let nav = inputSB.instantiateViewController(identifier: "donenoticeNav") as? UINavigationController else { fatalError() }
            guard var vc = nav.viewControllers.first as? DoneNoticeViewController else { fatalError() }
            vc.bind(viewModel: VM)
            return vc
            
        case .brandList(let vm):
            guard let nav = inputSB.instantiateViewController(identifier: "brandlistNav") as? UINavigationController else { fatalError() }
            guard var vc = nav.viewControllers.first as? BrandListViewController else { fatalError() }
            vc.bind(viewModel: vm)
            return vc
            
        case .itemList(let vm):
            guard let nav = inputSB.instantiateViewController(identifier: "itemlistNav") as? UINavigationController else { fatalError() }
            guard var vc = nav.viewControllers.first as? ItemListViewController else { fatalError() }
            vc.bind(viewModel: vm)
            return vc
            
        case .coloritemList(let vm):
            guard let nav = inputSB.instantiateViewController(identifier: "coloritemlistNav") as? UINavigationController else { fatalError() }
            guard var vc = nav.viewControllers.first as? ColoritemListViewController else { fatalError() }
            vc.bind(viewModel: vm)
            return vc
            
        case .brandEdit(let vm):
            guard let nav = inputSB.instantiateViewController(identifier: "brandeditNav") as? UINavigationController else { fatalError() }
            guard var vc = nav.viewControllers.first as? BrandEditViewController else { fatalError() }
            vc.bind(viewModel: vm)
            return vc
            
        case .itemEdit(let vm):
            guard let nav = inputSB.instantiateViewController(identifier: "itemeditNav") as? UINavigationController else { fatalError() }
            guard var vc = nav.viewControllers.first as? ItemEditViewController else { fatalError() }
            vc.bind(viewModel: vm)
            return vc
            
        case .coloritemEdit(let vm):
            guard let nav = inputSB.instantiateViewController(identifier: "coloritemeditNav") as? UINavigationController else { fatalError() }
            guard var vc = nav.viewControllers.first as? ColoritemEditViewController else { fatalError() }
            vc.bind(viewModel: vm)
            return vc
            
        case .code(let vm):
            guard let nav = inputSB.instantiateViewController(identifier: "codeNav") as? UINavigationController else { fatalError() }
            guard var vc = nav.viewControllers.first as? CodeViewController else { fatalError() }
            vc.bind(viewModel: vm)
            return vc
        }
    }
}
