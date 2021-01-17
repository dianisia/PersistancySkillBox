import UIKit
import RealmSwift

class RealmTask: Object {
    @objc dynamic var text = "";
}

class ToDoViewController: UIViewController {
    
    @IBOutlet weak var tasksTable: UITableView!
    @IBOutlet weak var textInput: UITextField!
    private let realm = try! Realm();
    private var tasks: [RealmTask] = [];
    
    @IBAction func onAdd(_ sender: Any) {
        let task = RealmTask();
        task.text = textInput.text!;
        try! realm.write {
            self.realm.add(task);
        }
        updateData();
    }
    
    override func viewDidLoad() {
        super.viewDidLoad();
        updateData();
    }
    
    func updateData() {
        self.tasks = Array(realm.objects(RealmTask.self));
        tasksTable.reloadData();
    }
}

extension ToDoViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tasks.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "toDoCell") as! ToDoTableViewCell;
        cell.taskTextFiled.text = self.tasks[indexPath.row].text;
        
        cell.buttonAction = { [unowned self] in
            try! realm.write {
                self.realm.delete(realm.objects(RealmTask.self)[indexPath.row])
                updateData();
            }
        }
        
        return cell;
    }
}
