import UIKit
import RealmSwift

class GalleryViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource{
    
    var currentSelectedItem:Int!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var listGalleries: Results<Gallery>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        listGalleries=RealmService.shared.realm.objects(Gallery.self)
        
        //Custom size for collection items
        let itemSize = UIScreen.main.bounds.width/3-3
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsetsMake(20, 0, 10, 0)
        layout.itemSize = CGSize(width: itemSize, height: itemSize)
        layout.minimumInteritemSpacing = 3
        layout.minimumLineSpacing = 3
        
        collectionView.collectionViewLayout = layout
        
        //Custom backItem of this screen
        let backItem = UIBarButtonItem()
        backItem.title = "Gallery"
        backItem.tintColor = UIColor.white
        
        navigationItem.backBarButtonItem = backItem
        
        navigationController?.navigationBar.tintColor = UIColor.black
        navigationItem.title = "Gallery"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listGalleries.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! GalleryImageCell
        
        if listGalleries[indexPath.row].thumbnailPath != nil{
            cell.imageView.image = UIImage(contentsOfFile: listGalleries[indexPath.row].thumbnailPath!)
            cell.imageStart.isHidden = false
        } else{
            cell.imageView.image = UIImage(contentsOfFile: listGalleries[indexPath.row].path)
            cell.imageStart.isHidden = true
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        currentSelectedItem = indexPath.row
        performSegue(withIdentifier: "showFile", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? DetailGalleryViewController{
            
            if listGalleries[currentSelectedItem].thumbnailPath != nil{
                destination.videoPath = listGalleries[currentSelectedItem].path
                destination.imagePath = listGalleries[currentSelectedItem].thumbnailPath!
            }
            else{
                destination.imagePath = listGalleries[currentSelectedItem].path
            }
            
            destination.size = listGalleries[currentSelectedItem].size
            destination.dimension = listGalleries[currentSelectedItem].dimension
            destination.creationDate = listGalleries[currentSelectedItem].creationDate
        }
    }
    
}
