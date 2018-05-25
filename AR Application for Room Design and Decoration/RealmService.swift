import Foundation
import RealmSwift

class RealmService {
    private init(){}
    static let shared = RealmService()
    var realm = try! Realm()
    
    func create<T: Object>(_ object: T){
        do{
            try realm.write{
                realm.add(object)
            }
        }catch {
            print("REALM Error occurs when create a new object: \(error.localizedDescription)")
        }
    }
    
    func update<T: Object>(_ object: T){
        do{
            try realm.write{
                realm.add(object, update: true)
            }
        }catch{
            print("REALM Error occurs when update a object: \(error.localizedDescription)")
        }
    }
    
    func delete<T: Object>(_ object: T){
        do{
            try realm.write{
                realm.delete(object)
            }
        }catch{
            print("REALM Error occurs when delete a object: \(error.localizedDescription)")
        }
    }
    
    
    func post(_ err: Error){
        NotificationCenter.default.post(name: NSNotification.Name("RealmErr"), object: err)
    }
    
    func observeRealmErrors(in vc: UIViewController, completion: @escaping (Error?) -> Void){
        NotificationCenter.default.addObserver(forName: NSNotification.Name("RealmError"), object: nil, queue: nil) { (notification) in
            completion(notification.object as? Error)
        }
    }
    
    func stopObservingErrors(in vc: UIViewController){
        NotificationCenter.default.removeObserver(vc, name: NSNotification.Name("RealmError"), object: nil)
    }
}
