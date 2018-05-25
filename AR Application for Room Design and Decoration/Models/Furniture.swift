import RealmSwift

class Furniture: Object {
    @objc dynamic var id = 0
    @objc dynamic var idCat = 0
    @objc dynamic var name = ""
    @objc dynamic var imagePath = ""
    @objc dynamic var path = ""
    @objc dynamic var isHorizontal = true
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    convenience init(id: Int, idCat: Int, name: String, imagePath: String, path: String, isHorizontal: Bool){
        self.init()
        self.id = id
        self.idCat = idCat
        self.name = name
        self.imagePath = imagePath
        self.path = path
        self.isHorizontal = isHorizontal
    }
}
