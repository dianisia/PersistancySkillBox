import UIKit

class ForecastCell: UITableViewCell {
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var windInfo: UILabel!
    @IBOutlet weak var minMaxTempLabel: UILabel!
    @IBOutlet weak var pressureLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib();
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated);
    }
}
