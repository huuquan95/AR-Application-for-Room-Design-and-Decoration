
import UIKit

protocol DesignAndDecorationDelegate {
    func putItem(fur: Furniture)
}

var idItem: String = ""

class TableFurnitureViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    var idCat = -1
    var furs: [Furniture] = []
    var delegate:DesignAndDecorationDelegate?
    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var bigView: UIView!
    @IBOutlet weak var lblTabItem: UILabel!
    @IBOutlet weak var coll: UICollectionView!
    
    override func viewDidLoad() {
        view.backgroundColor = UIColor.clear
        super.viewDidLoad()
        coll.dataSource = self
        coll.delegate = self
        btnClose.layer.borderWidth = 0.5
        btnClose.layer.borderColor = #colorLiteral(red: 0.6863, green: 0.6863, blue: 0.6863, alpha: 1) /* #afafaf */
        btnClose.layer.cornerRadius = btnClose.frame.width/2
        btnClose.layer.backgroundColor = #colorLiteral(red: 0.6863, green: 0.6863, blue: 0.6863, alpha: 1) /* #afafaf */
        bigView.roundCorners(corners: [.topLeft, .topRight], radius: bigView.frame.width/20)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
      
        if idCat == -1 {
            return 0
        }
        
        lblTabItem.text = categories.filter("id = \(idCat)").first?.name.uppercased()
        
        furs = furnitures.filter("idCat = \(idCat)").sorted(byKeyPath: "name").compactMap({ (fur) -> Furniture? in
            return Furniture(id: fur.id, idCat: fur.idCat, name: fur.name, imagePath: fur.imagePath, path: fur.path, isHorizontal: fur.isHorizontal)
        })
        
       return furs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! FurnitureCell
        cell.backgroundColor = #colorLiteral(red: 0.9882, green: 0.9882, blue: 0.9882, alpha: 1) /* #fcfcfc */
        cell.layer.cornerRadius = 10
        cell.layer.borderWidth = 0.5
        cell.layer.borderColor = #colorLiteral(red: 0.6863, green: 0.6863, blue: 0.6863, alpha: 1) /* #afafaf */
        cell.imgItem.image = UIImage(named: furs[indexPath.row].imagePath)
        cell.lblItem.text = furs[indexPath.row].name
       
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        dismiss(animated: true) {
            self.delegate?.putItem(fur: self.furs[indexPath.row])
        }
    }
   
}

extension UIView {
    func roundCorners(corners:UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
}
