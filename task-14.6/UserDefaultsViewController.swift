import UIKit

class UserDefaultsViewController: UIViewController {
    @IBOutlet weak var nameInput: UITextField!
    @IBOutlet weak var lastnameInput: UITextField!
    @IBOutlet weak var greetingLabel: UILabel!
    
    @IBAction func onSave(_ sender: Any) {
        UserDefaultsPersistance.shared.userName = "\(nameInput.text!) \(lastnameInput.text!)";
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        greetingLabel.text = UserDefaultsPersistance.shared.userName;
    }
    
}
