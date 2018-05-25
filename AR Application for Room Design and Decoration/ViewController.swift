import UIKit

class MainViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if RealmService.shared.realm.objects(Category.self).count == 0{
            loadData()
        }
    }
    
    func loadData(){
        
        let bundleURL = URL(fileURLWithPath: Bundle.main.bundlePath)
        let artSCNPath = bundleURL.appendingPathComponent("art.scnassets")
        
        do {
            let categories = try FileManager.default.contentsOfDirectory(atPath: artSCNPath.path)
            var idCat = 0
            var idFur = 0
            for category in categories {
                if !category.contains(".DS_Store"){
                    
                    let categoryObject = Category(id: idCat, name: category)
                    RealmService.shared.create(categoryObject)
                    
                    let categoryPath = artSCNPath.appendingPathComponent(category)
                    let furNames = try FileManager.default.contentsOfDirectory(atPath: categoryPath.path)
                    for var furName in furNames{
                        if !furName.contains(".DS_Store"){
                            var isHorizontal = false
                            var extraCharacter = ""
                            if furName.first == "_"{
                                furName = String(furName.dropFirst())
                                extraCharacter = "_"
                                isHorizontal = true
                            }
                            
                            let imagePath = "art.scnassets/\(category)/\(extraCharacter)\(furName)/\(furName).png"
                            let path = "art.scnassets/\(category)/\(extraCharacter)\(furName)/\(furName).scn"
                            
                            let furnitureObject = Furniture(id: idFur, idCat: idCat, name: furName, imagePath: imagePath, path: path, isHorizontal: isHorizontal)
                            RealmService.shared.create(furnitureObject)
                            
                            idFur += 1
                        }
                    }
                    idCat += 1
                }
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.view.backgroundColor = .clear
        
        // Hide the Navigation Bar
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Show the Navigation Bar
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    @IBAction func goGallery(_ sender: Any) {
        self.navigationItem.backBarButtonItem?.tintColor = UIColor.black
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"Home", style:.plain, target:nil, action:nil)
    }
    
    @IBAction func goDesignAndDecoration(_ sender: Any) {
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
        self.navigationItem.backBarButtonItem?.tintColor = UIColor.white
    }
    
}
