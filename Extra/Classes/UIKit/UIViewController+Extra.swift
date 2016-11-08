//
//  UIViewController+Extra.swift
//  Pods
//
//  Created by Jean-Charles SORIN on 07/11/2016.
//
//

extension UIViewController {
  
  /// Returns the current application's top most view controller.
  open class var ex_topMost: UIViewController? {
    let rootViewController = UIApplication.shared.windows.first?.rootViewController
    return self.ex_topMost(of: rootViewController)
  }
  
  /// Returns the top most view controller from given view controller's stack.
  open class func ex_topMost(of viewController: UIViewController?) -> UIViewController? {
    // UITabBarController
    if let tabBarController = viewController as? UITabBarController,
      let selectedViewController = tabBarController.selectedViewController {
      return self.ex_topMost(of: selectedViewController)
    }
    
    // UINavigationController
    if let navigationController = viewController as? UINavigationController,
      let visibleViewController = navigationController.visibleViewController {
      return self.ex_topMost(of: visibleViewController)
    }
    
    // presented view controller
    if let presentedViewController = viewController?.presentedViewController {
      return self.ex_topMost(of: presentedViewController)
    }
    
    // child view controller
    for subview in viewController?.view?.subviews ?? [] {
      if let childViewController = subview.next as? UIViewController {
        return self.ex_topMost(of: childViewController)
      }
    }
    
    return viewController
  }
  
  
  open func ex_addChildViewController(_ childController: UIViewController, in container: UIView, insets: UIEdgeInsets = .zero) {
    
    if let childView = childController.view {
      self.addChildViewController(childController)
      container.ex_addSubview(childView, insets: insets)
    } else {
      fatalError("Your view controller \(childController) does not contain any view")
    }
    
  }
  
  open func ex_switchChilds(from originController: UIViewController?,
                         to destinationController: UIViewController,
                         in viewContainer: UIView,
                         duration: TimeInterval = 0,
                         animations: UIViewAnimationOptions = .transitionCrossDissolve) {
    originController?.willMove(toParentViewController: nil)
    self.addChildViewController(destinationController)
    
    if let childView = destinationController.view {
      viewContainer.ex_addSubview(childView, insets: .zero)
    }
    
    if let originController = originController {
      self.transition(from: originController,
                      to: destinationController,
                      duration: duration,
                      options: animations,
                      animations: nil,
                      completion: { (completed) in
                        originController.removeFromParentViewController()
                        destinationController.didMove(toParentViewController: self)
                        
      })
    } else {
      destinationController.view.alpha = 0
      UIView.animate(withDuration: duration, animations: { 
        destinationController.view.alpha = 1
        }, completion: { (finished) in
          destinationController.didMove(toParentViewController: self)
      })
    }
  }
  
}