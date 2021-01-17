import UIKit

class ToDoTableViewCell: UITableViewCell {

    @IBOutlet weak var taskTextFiled: UILabel!
    
    var buttonAction: (() -> ())?
    
    @IBAction func buttonTapped(_ sender: Any) {
        buttonAction?();
    }
    
    override func awakeFromNib() {
        super.awakeFromNib();
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
