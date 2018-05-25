import ARKit
import AVFoundation
import AVKit

extension DesignAndDecorationViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func audioConfigure(action:String){
        // configure audio
        do{
            var audio=""
            if action=="add"{
                audio=Bundle.main.path(forResource: "add", ofType: "mp3")!
            }else{
                audio=Bundle.main.path(forResource: "delete", ofType: "mp3")!
            }
            audioPlayer = try AVAudioPlayer(contentsOf: NSURL(fileURLWithPath: audio) as URL)
            audioPlayer.play()
        }catch{
            
        }
    }
    
    @IBAction func btnDeleteEvent() {
        // create the alert
        let alert = UIAlertController(title: "Warning!", message: "Do you want to remove it?", preferredStyle: UIAlertControllerStyle.alert)
        
        // add the actions (buttons)
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.default, handler:{
            (action) -> Void in
            DispatchQueue.main.async {
                self.deleteNode.removeFromParentNode()
                if self.swtAudio.isOn{
                    self.audioConfigure(action: "delete")
                }
                self.deleteNode=nil
                self.toggleShowButton(false)
            }
        }
        ))
        alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.cancel, handler: nil))
        // show the alert
        self.present(alert, animated: true, completion: nil)
        
    }
    
    @IBAction func btnTakeScreendEvent() {
        closeAllAnimation()
        let snapshot = sceneView.snapshot()
        let dimension = "\(snapshot.size.width) x \(snapshot.size.height)"
        imgView.isHidden=false
        btnCancel.isHidden=false
        btnShare.isHidden=false
        isVideo=false
        imgView.image = snapshot
        
        let imageData: Data = UIImageJPEGRepresentation(snapshot, 0.50)!
        let imagePath = documentDirectoryPath.appending("/\(arc4random()).jpg")
        removeItemIfExist(path: imagePath)
        
        try! imageData.write(to: URL.init(fileURLWithPath: imagePath), options: .atomicWrite)
        
        do{
            let imageAttributes = try fileManager.attributesOfItem(atPath: imagePath)
            let creationDate = self.convertToLocalDate(date: imageAttributes[FileAttributeKey.creationDate] as! Date)
            let size = self.convertToFileSize(size: imageAttributes[FileAttributeKey.size] as! Float)
            
            let image = Gallery(path: imagePath, dimension: dimension, size: size, creationDate: creationDate, thumbnailPath: nil)
            RealmService.shared.create(image)
        }catch{
            print(error)
        }
    }
    
    func convertToFileSize(size: Float) ->String{
        if size <= 0 {
            return "Unknown"
        }
        else if size > 1024*1024*1024 {
            return  "\((size/(1024*1024*1024)).round1()) GB"
        }
        else if size > 1024*1024 {
            return  "\((size/(1024*1024)).round1()) MB"
        }
        else if size > 1024 {
            return  "\((size/1024).round1()) KB"
        }
        return "\(size) bytes"
    }
    
    func convertToLocalDate(date: Date) ->String{
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
        dateFormatter.timeZone = TimeZone.current
        
        return dateFormatter.string(from: date)
    }
    
    @IBAction func btnShareEvent() {
        let image = imgView.image
        if !btnShare.isHidden{
            if isVideo{
                let activity=UIActivityViewController(activityItems: [pathVideo], applicationActivities: nil)
                activity.popoverPresentationController?.sourceView=self.view
                self.present(activity, animated: true, completion: nil)
            }
            else{
                let activity=UIActivityViewController(activityItems: [image ?? ""], applicationActivities: nil)
                activity.popoverPresentationController?.sourceView=self.view
                self.present(activity, animated: true, completion: nil)
            }
        }
    }
    @IBAction func btnCancelEvent() {
        if !btnCancel.isHidden{
            imgView.isHidden=true
            btnCancel.isHidden=true
            btnShare.isHidden=true
            isPlay.isHidden=true
            btnTakeScreen.isHidden=false
        }
    }
    
    @IBAction func btnResetEvent(){
        self.sceneView.scene.rootNode.enumerateChildNodes{(node, _) in
            node.removeFromParentNode()
        }
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = [.horizontal, .vertical]
        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
        session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
        btnMenu.isHidden=true
        menuView.isHidden=true
        UIView.animate(withDuration: 0.3, animations: {
            self.closeMenu()
            self.btnMenu.transform = .identity
            self.closeOption()
            self.btnOption.transform = .identity
        })
    }
    
    
    @IBAction func startRecord(sender: UIButton){
        isRecord.isHidden=false
        btnTakeScreen.isHidden=true
        UIView.animate(withDuration: 0.3, animations: {
            self.closeMenu()
            self.btnMenu.transform = .identity
            self.closeOption()
            self.btnOption.transform = .identity
        })
        self.recorder?.startWriting().onSuccess {
        }
    }
    
    @IBAction func stopRecord(sender: UIButton){
        self.recorder?.finishWriting().onSuccess { [weak self] url in
            self?.isVideo=true
            self?.isPlay.isHidden=false
            self?.isRecord.isHidden=true
            self?.imgView.isHidden=false
            self?.btnCancel.isHidden=false
            self?.btnShare.isHidden=false
            
            let videoPath = documentDirectoryPath.appending("/\(arc4random()).mp4")
            self?.removeItemIfExist(path: videoPath)
            let imagePath = self?.getThumbnailOfVideo(videoPath: url.absoluteString)

            self?.imgView.image = UIImage(contentsOfFile: imagePath!)
            self?.pathVideo = URL(fileURLWithPath: videoPath)
            
            let videoData = try! Data(contentsOf: url as URL)
            try! videoData.write(to: URL.init(fileURLWithPath: videoPath), options: .atomicWrite)
            
            do{
                let videoAttributes = try self?.fileManager.attributesOfItem(atPath: videoPath)
                let creationDate = self?.convertToLocalDate(date: videoAttributes![FileAttributeKey.creationDate] as! Date)
                let size = self?.convertToFileSize(size: videoAttributes![FileAttributeKey.size] as! Float)
                
                let image = Gallery(path: videoPath, dimension: "", size: size!, creationDate: creationDate!, thumbnailPath: imagePath)
                RealmService.shared.create(image)
            }catch{
                print(error)
            }
        }
    }
    
    func removeItemIfExist(path: String){
        if (fileManager.fileExists(atPath: path)){
            try!  fileManager.removeItem(atPath: path)
        }
    }
    
    //Create thumbnail, save to documentDirectory and return a path
    func getThumbnailOfVideo(videoPath: String) ->String{
        
        let asset = AVAsset(url: URL(fileURLWithPath: videoPath))
        let assetImgGenerate : AVAssetImageGenerator = AVAssetImageGenerator(asset: asset)
        assetImgGenerate.appliesPreferredTrackTransform = true
        
        let time = CMTimeMake(1, 2)
        let image = try? assetImgGenerate.copyCGImage(at: time, actualTime: nil)
        
        if image != nil {
            
            let frameImage  = UIImage(cgImage: image!)
            let imageData: Data = UIImageJPEGRepresentation(frameImage, 0.30)!
            let imagePath = documentDirectoryPath.appending("/\(arc4random()).jpg")
            
            if (fileManager.fileExists(atPath: imagePath)){
                try!  fileManager.removeItem(atPath: imagePath)
            }
            
            try! imageData.write(to: URL.init(fileURLWithPath: imagePath), options: .atomicWrite)
            return imagePath
        }
        return ""
    }
    
    @IBAction func playVideo(sender: UIButton){
        if !isPlay.isHidden{
            self.playVideoAsFullScreen()
        }
    }
    
    func playVideoAsFullScreen(){
        let player = AVPlayer(url: pathVideo)
        let playerController = AVPlayerViewController()
        playerController.player = player
        player.play()
        self.present(playerController, animated: true) {}
    }
    
    func closeAllAnimation(){
        UIView.animate(withDuration: 0.3, animations: {
            self.closeMenu()
            self.btnMenu.transform = .identity
            self.closeOption()
            self.btnOption.transform = .identity
        })
    }
}

extension Float{
    func round1() ->Float{
        return roundf(self*10)/10
    }
}
