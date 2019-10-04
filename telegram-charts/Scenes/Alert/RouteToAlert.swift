import UIKit

protocol RouteToAlertProtocol {
    func presentAlert(_ title: String, message: String)
}

class RouteToAlert: RouteToAlertProtocol {
    weak var presentingViewController: UIViewController?
    
    init(from presentingViewController: UIViewController) {
        self.presentingViewController = presentingViewController
    }
    
    func presentAlert(_ title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        presentingViewController?.present(alertController, animated: true, completion: nil)
    }
}
