import UIKit

var taskMgr: TaskManager = TaskManager()

struct Task {
    var name = "Name"
    var description = "Description"
}

class TaskManager: NSObject {
    
    var tasks = [Task]()
    var persistenceHelper: PersistenceHelper = PersistenceHelper()
    
    override init(){
        
        let tempTasks:NSArray = persistenceHelper.list("Task")
        for res:AnyObject in tempTasks{
            tasks.append(Task(name:res.valueForKey("name")as! String,description:res.valueForKey("desc") as! String))
        }
    }
    
    
    func addTask(name:String, desc: String){
        
        var dicTask: Dictionary<String, String> = Dictionary<String,String>()
        dicTask["name"] = name
        dicTask["desc"] = desc
        
        if(persistenceHelper.save("Task", parameters: dicTask)){
            tasks.append(Task(name: name, description:desc))
        }
    }
    
    func removeTask(index:Int){
        
        let value:String = tasks[index].name
        
        if(persistenceHelper.remove("Task", key: "name", value: value)){
            tasks.removeAtIndex(index)
        }
    }

    
}