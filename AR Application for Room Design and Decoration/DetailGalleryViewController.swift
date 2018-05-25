import UIKit
import AVFoundation
import AVKit


class DetailGalleryViewController: UIViewController {
    
    var fileManager = FileManager.default
    var imagePath: String = ""
    var videoPath: String? = nil
    var size: String = ""
    var dimension: String = ""
    var creationDate: String = ""
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var btnPlay: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.image = UIImage(contentsOfFile: imagePath)
        
        if videoPath == nil{
            btnPlay.isHidden = true
        } else{
            btnPlay.isHidden = false
        }
    }
 
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? ShowDetailGalleryViewController{
            destination.fileName = self.videoPath != nil ? self.videoPath! : self.imagePath
            destination.creationDate = self.creationDate
            destination.size = self.size
            destination.dimension = self.dimension
        }
    }
    
    @IBAction func playVideo(_ sender: Any) {
        let player = AVPlayer(url: URL(fileURLWithPath: videoPath!))
        let playerController = AVPlayerViewController()
        playerController.player = player
        player.play()
        self.present(playerController, animated: true) {}
    }
    
    @IBAction func deleteFile(_ sender: Any) {
        
        let alert = UIAlertController(title: "Delete", message: "Are you sure that you want to delete this file?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .`default`, handler: { _ in
            
            var gallery: Gallery!
            
            if self.videoPath != nil{
                gallery = RealmService.shared.realm.objects(Gallery.self).filter("path = \"\(self.videoPath!)\"")[0]
            } else{
                gallery = RealmService.shared.realm.objects(Gallery.self).filter("path = \"\(self.imagePath)\"")[0]
            }
            
            RealmService.shared.delete(gallery)
            
            if self.videoPath != nil{
                self.removeItemIfExist(path: self.videoPath!)
            }
            self.removeItemIfExist(path: self.imagePath)
            
            self.navigationController?.popViewController(animated: true)
        }))
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: "Default action"), style: .`default`, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func removeItemIfExist(path: String){
        if (fileManager.fileExists(atPath: path)){
            try!  fileManager.removeItem(atPath: path)
        }
    }
}
