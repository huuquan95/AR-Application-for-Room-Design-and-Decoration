import RealmSwift

class Gallery: Object {
    @objc dynamic var path = ""
    @objc dynamic var dimension = ""
    @objc dynamic var size = ""
    @objc dynamic var creationDate = ""
    @objc dynamic var thumbnailPath: String? = nil
    
    override static func primaryKey() -> String? {
        return "path"
    }
    
    convenience init(path: String,dimension: String, size: String, creationDate: String, thumbnailPath: String?){
        self.init()
        self.path = path
        self.dimension = dimension
        self.size = size
        self.creationDate = creationDate
        self.thumbnailPath = thumbnailPath
    }
}
