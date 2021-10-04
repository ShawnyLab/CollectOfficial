//
//  Extensions.swift
//  Collect
//
//  Created by 박진서 on 2021/09/07.
//

import UIKit
import Kingfisher

extension UIColor {
    
    convenience init(red: Int, green: Int, blue: Int, a: Int = 0xFF) {
        
        self.init(
            
            red: CGFloat(red) / 255.0,
            
            green: CGFloat(green) / 255.0,
            
            blue: CGFloat(blue) / 255.0,
            
            alpha: CGFloat(a) / 255.0
            
        )
        
    }
    
    
    
    convenience init(rgb: Int) {
        
        self.init(
            
            red: (rgb >> 16) & 0xFF,
            
            green: (rgb >> 8) & 0xFF,
            
            blue: rgb & 0xFF
            
        )
        
    }
    
    
    
    // let's suppose alpha is the first component (ARGB)
    
    convenience init(argb: Int) {
        
        self.init(
            
            red: (argb >> 16) & 0xFF,
            
            green: (argb >> 8) & 0xFF,
            
            blue: argb & 0xFF,
            
            a: (argb >> 24) & 0xFF
            
        )
        
    }
    
}

extension Int{
    var todayTime: String{
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.dateFormat = "yyyy.MM.dd HH:mm"
        let date = Date(timeIntervalSince1970: Double(self)/1000)
        return dateFormatter.string(from: date)
    }
}

extension UIViewController {
    func presentAlert(message: String) {
        let alert = UIAlertController(title: "알림", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "확인", style: UIAlertAction.Style.default, handler: { (UIAlertAction) in
        }))
        self.present(alert, animated: true, completion: nil)
    }
}

extension UIViewController : UIGestureRecognizerDelegate {
    public func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
        
    }
    
}

extension UIView {
    enum VerticalLocation {
        case bottom
        case top
        case left
        case right
    }

    func addShadow(location: VerticalLocation, color: UIColor = .black, opacity: Float = 0.8, radius: CGFloat = 5.0) {
        switch location {
        case .bottom:
             addShadow(offset: CGSize(width: 0, height: 10), color: color, opacity: opacity, radius: radius)
        case .top:
            addShadow(offset: CGSize(width: 0, height: -10), color: color, opacity: opacity, radius: radius)
        case .left:
            addShadow(offset: CGSize(width: -10, height: 0), color: color, opacity: opacity, radius: radius)
        case .right:
            addShadow(offset: CGSize(width: 10, height: 0), color: color, opacity: opacity, radius: radius)
        }
    }

    func addShadow(offset: CGSize, color: UIColor = .black, opacity: Float = 0.1, radius: CGFloat = 3.0) {
        self.layer.masksToBounds = false
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOffset = offset
        self.layer.shadowOpacity = opacity
        self.layer.shadowRadius = radius
    }
}

public enum DeallocShowType {
    case alert
    case assert
    case log
    
}
extension UIViewController {
    public func dch_checkDeallocation(showType: DeallocShowType = .alert, afterDelay delay: TimeInterval = 2.0) {
        let rootParentViewController = dch_rootParentViewController
        if isMovingFromParent || rootParentViewController.isBeingDismissed {
            let t = type(of: self)
            let disappearanceSource: String = isMovingFromParent ? "removed from its parent" : "dismissed"
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [weak self] in
                let message = "\(t) not deallocated after being \(disappearanceSource)"
                switch showType {
                case .alert:
                    let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    UIApplication.topViewController()?.present(alert, animated: true, completion: nil)
                case .assert:
                    assert(self == nil, message)
                case .log:
                    NSLog("%@", message)
                }
            }
        }
    }
    private var dch_rootParentViewController: UIViewController {
        var root = self
        while let parent = root.parent {
            root = parent
        }
        return root
    }
    
    func removeAllCache() {
        let cache = ImageCache.default
        cache.clearCache()
    }
}
extension UIApplication {
    class func topViewController(base: UIViewController? = UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topViewController(base: nav.visibleViewController)
        } else if let tab = base as? UITabBarController, let selected = tab.selectedViewController {
            return topViewController(base: selected)
        } else if let presented = base?.presentedViewController {
            return topViewController(base: presented)
        }
        return base
        
    }
    
}
