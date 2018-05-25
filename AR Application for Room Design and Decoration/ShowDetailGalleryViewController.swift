import UIKit

class ShowDetailGalleryViewController: UIViewController {

    var fileName: String = ""
    var size: String = ""
    var dimension: String = ""
    var creationDate: String = ""
    
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblFileName: UILabel!
    @IBOutlet weak var lblSizeAndDimension: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let directories = fileName.split(separator: "/")
        let dateTime = creationDate.split(separator: " ")
        
        lblDate.text = String(creationDate.prefix(10))
        lblTime.text! = "\(dateTime[1])"
        lblFileName.text = "\(directories[directories.count-1])"
        lblSizeAndDimension.text = dimension + " " + size
    }

    @IBAction func dimiss(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
