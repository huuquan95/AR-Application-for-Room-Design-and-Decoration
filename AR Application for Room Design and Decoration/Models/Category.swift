import RealmSwift

class Category: Object {
    @objc dynamic var id = 0
    @objc dynamic var name = ""

    override static func primaryKey() -> String? {
        return "id"
    }

    convenience init(id: Int, name: String){
        self.init()
        self.id = id
        self.name = name
    }
    
}
