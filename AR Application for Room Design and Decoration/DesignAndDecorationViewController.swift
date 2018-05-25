import UIKit
import SceneKit
import ARKit
import SceneKitVideoRecorder
import RealmSwift

var ID:Int = 0
var verticalItems = ["Vase", "WallClock", "BlackClock", "BookAndPot", "FramePicture", "FramePottery", "SquareShape", "TV"]
var categories = RealmService.shared.realm.objects(Category.self).sorted(byKeyPath: "name")
var furnitures = RealmService.shared.realm.objects(Furniture.self)

class DesignAndDecorationViewController: UIViewController, ARSCNViewDelegate, ARSessionDelegate, DesignAndDecorationDelegate, UIGestureRecognizerDelegate{
    
    
    var fileManager = FileManager.default
    @IBOutlet weak var menuView: UIViewX!
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var btnShare: UIButton!
    
    @IBOutlet weak var btnTakeScreen: UIButton!
    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var btnMenu: UIButton!
    @IBOutlet weak var btnOption: UIButton!
    
    @IBOutlet weak var optionView: UIView!
    
    var btnCategories = [UIButtonX](repeating: UIButtonX(), count: 8)
    @IBOutlet weak var btn1: UIButtonX!
    @IBOutlet weak var btn2: UIButtonX!
    @IBOutlet weak var btn3: UIButtonX!
    @IBOutlet weak var btn4: UIButtonX!
    @IBOutlet weak var btn5: UIButtonX!
    @IBOutlet weak var btn6: UIButtonX!
    @IBOutlet weak var btn7: UIButtonX!
    @IBOutlet weak var btn8: UIButtonX!
    
    @IBOutlet weak var sceneView: ARSCNView!
    
    @IBOutlet weak var swtAudio: UISwitch!
    @IBOutlet weak var btnReset: UIButton!
    @IBOutlet weak var isRecord: UIButton!
    @IBOutlet weak var isPlay: UIButton!
    
    // planes
    var dictPlanes = [ARPlaneAnchor: Plane]()
    //    var sceneLight:SCNLight!
    var deleteNode : SCNNode!
    var positionTmp=matrix_float4x4()
    var audioPlayer:AVAudioPlayer = AVAudioPlayer()
    var originalRotation: SCNVector3?
    
    var recorder: SceneKitVideoRecorder?
    var isVideo: Bool!
    var pathVideo: URL!
    var originalScale:SCNVector3?
    
    var x: Float!
    var z: Float!
    
    override func viewDidLoad() {
        
        btn1.imageView?.image = UIImage(named: categories[0].name)!
        super.viewDidLoad()
        collectBtnCategories()
        imageForBtnCategory()
        
        sceneView.delegate = self
        sceneView.autoenablesDefaultLighting = true
        // environment change make objects are not changed
        sceneView.automaticallyUpdatesLighting = false
        // control gesture: tap, drag and rotate
        addTapGestureToSceneView()
        // set default for menu view and option view
        closeMenu()
        closeOption()
        
        recorder = try! SceneKitVideoRecorder(withARSCNView: sceneView)
        navigationItem.title = ""
    }
    
    func collectBtnCategories(){
        btnCategories[0] =  btn1
        btnCategories[1] =  btn2
        btnCategories[2] =  btn3
        btnCategories[3] =  btn4
        btnCategories[4] =  btn5
        btnCategories[5] =  btn6
        btnCategories[6] =  btn7
        btnCategories[7] =  btn8
        
        for i in 0...7{
            btnCategories[i].tag = categories[i].id
        }
    }
    
    func imageForBtnCategory(){
        for i in 0...7{
            btnCategories[i].setImage(UIImage(named: categories[i].name), for: .normal)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection=[.horizontal,.vertical]
        // Run the view's session
        sceneView.session.run(configuration)
        configuration.isLightEstimationEnabled = true
        sceneView.debugOptions=[ARSCNDebugOptions.showFeaturePoints]
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Pause the view's session
        sceneView.session.pause()
    }
    // When tap background -> close all
    @IBAction func tapBackground(_ sender: Any) {
        UIView.animate(withDuration: 0.3, animations: {
            self.closeMenu()
            self.btnMenu.transform = .identity
            self.closeOption()
            self.btnOption.transform = .identity
        })
    }
    
    // Action for menu -> rotation menu button and show menu view
    @IBAction func menuTapper(_ sender: FloatingActionButton) {
        UIView.animate(withDuration: 0.3, animations: {
            if self.menuView.transform == .identity{
                self.closeMenu()
            } else {
                self.closeOption()
                self.menuView.transform = .identity
            }
        })
        
        UIView.animate(withDuration: 0.6, delay: 0.2, usingSpringWithDamping: 0.3, initialSpringVelocity: 0, options: [], animations: {
            if self.menuView.transform == .identity {
                self.btn2.transform = .identity
                self.btn6.transform = .identity
                self.btn5.transform = .identity
                self.btn4.transform = .identity
                self.btn3.transform = .identity
                self.btn1.transform = .identity
                self.btn8.transform = .identity
                self.btn7.transform = .identity
            }
        })
    }
    
    @IBAction func showTableFurniture(_ sender: Any) {
        
        let button = sender as! UIButtonX
        let destination = storyboard?.instantiateViewController(withIdentifier: "TableFurniture") as! TableFurnitureViewController
        
        destination.idCat = button.tag
        destination.delegate = self
        
        present(destination, animated: true, completion: nil)
    }
    
    // Action for option -> rotation option button and show option view
    @IBAction func optionTapper(_ sender: OptionActionButton) {
        UIView.animate(withDuration: 0.3, animations: {
            
            // if menu is opening -> close menu
            self.closeMenu()
            self.btnMenu.transform = .identity
            
            if self.optionView.transform == .identity{
                self.closeOption()
            } else {
                self.optionView.transform = .identity
            }
        })
    }
    
    //Animation buttons in menu view
    func closeMenu(){
        self.menuView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        btn2.transform = CGAffineTransform(translationX: -6, y: 0)
        btn6.transform = CGAffineTransform(translationX: -6, y: -2)
        btn5.transform = CGAffineTransform(translationX: -6, y: -5)
        btn4.transform = CGAffineTransform(translationX: 0, y: -6)
        btn3.transform = CGAffineTransform(translationX: 0, y: -6)
        btn1.transform = CGAffineTransform(translationX: 6, y: -5)
        btn8.transform = CGAffineTransform(translationX: 6, y: -2)
        btn7.transform = CGAffineTransform(translationX: 6, y: 0)
    }
    
    // Close option
    func closeOption(){
        self.optionView.transform = CGAffineTransform(translationX: 0 , y: 400)
    }
    
    @IBAction func returned(segue: UIStoryboardSegue) {
        closeMenu()
        btnMenu.transform = .identity
    }
    
    func putItem(fur: Furniture) {
        var hitTestOptions = [SCNHitTestOption: Any]()
        hitTestOptions[SCNHitTestOption.boundingBoxOnly] = true
        
        var firstNodeHitTest = sceneView.hitTest(view.center, options: hitTestOptions).first?.node
        
        let hit = sceneView.hitTest(view.center, types: .existingPlaneUsingExtent)
        
        if hit.isEmpty || firstNodeHitTest == nil{
            return
        }
        
        while true {
            if firstNodeHitTest?.parent == sceneView.scene.rootNode {
                break
            }
            firstNodeHitTest = firstNodeHitTest?.parent!
        }
        
        let material = SCNMaterial()
        let image = UIImage(named: "transparent")
        material.diffuse.contents = image
        firstNodeHitTest?.childNode(withName: "planeNode", recursively: true)?.geometry?.materials = [material]
        
        let node = SCNNode()
        
        if let planeAnchor = hit.first?.anchor as? ARPlaneAnchor{
            if planeAnchor.alignment == .vertical{
                
                if fur.isHorizontal {
                    node.eulerAngles = (firstNodeHitTest?.eulerAngles)!
                }else{
                    closeAllAnimation()
                    
                    let alert = UIAlertController(title: "Warning", message: "Can not put this item on the vertical plane.", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil))
                    
                    self.present(alert, animated: true)
                    return
                }
            }
            
            let worldTransform = hit.first?.worldTransform
            
            chooseItem(path: fur.path,worldTransform: worldTransform!, node)
        }
    }
    
    func chooseItem( path: String,  worldTransform: matrix_float4x4,_ node: SCNNode){
        
        let scene=SCNScene(named: path)
        let nodeArray = scene?.rootNode.childNodes
        for childNode in nodeArray! {
            node.addChildNode(childNode)
        }
        
        node.position = SCNVector3((worldTransform.columns.3.x), worldTransform.columns.3.y, (worldTransform.columns.3.z))
        
        DispatchQueue.main.async {
            self.sceneView.scene.rootNode.addChildNode(node)
            if self.swtAudio.isOn{
                self.audioConfigure(action: "add")
            }
        }
        closeMenu()
        btnMenu.transform = .identity
    }
}
