import UIKit
import CoreData

class CoreDataViewController: UIViewController {
    
    @IBOutlet weak var taskTextInput: UITextField!
    @IBOutlet weak var tasksTable: UITableView!
    var tasks: [NSManagedObject] = [];
    
    @IBAction func onAddCoreData(_ sender: Any) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return;
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext;
        let entity = NSEntityDescription.entity(forEntityName: "Task", in: managedContext)!;
        let task = NSManagedObject(entity: entity, insertInto: managedContext);
        task.setValue(taskTextInput.text, forKeyPath: "text");
        
        do {
            try managedContext.save();
            tasks.append(task);
            tasksTable.reloadData();
        } catch {
            print("Error");
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateData();
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func updateData() {
        guard let appDelegate =
          UIApplication.shared.delegate as? AppDelegate else {
            return;
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Task")
        
        do {
          tasks = try managedContext.fetch(fetchRequest)
        } catch {
          print("Could not fetch.")
        }
        tasksTable.reloadData();
    }
}

extension CoreDataViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tasks.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let task = self.tasks[indexPath.row];
        let cell =
          tableView.dequeueReusableCell(withIdentifier: "toDoCell",
                                        for: indexPath) as! ToDoTableViewCell;
        cell.textLabel?.text = task.value(forKeyPath: "text") as? String;
        cell.buttonAction = { [unowned self] in
            guard let appDelegate =
              UIApplication.shared.delegate as? AppDelegate else {
                return
            }
            
            let managedContext = appDelegate.persistentContainer.viewContext;
            let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest();
            if let result = try? managedContext.fetch(fetchRequest) {
                managedContext.delete(result[indexPath.row]);
            }
            
            do {
                try managedContext.save();
                updateData();
            } catch {
                print("Failed saving")
            }
        }
        return cell;
    }
}
