import UIKit
import SceneKit
import ARKit

extension DesignAndDecorationViewController {
    
    func addTapGestureToSceneView(){
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tap(_:)))
        tapGestureRecognizer.numberOfTapsRequired=2
        sceneView.addGestureRecognizer(tapGestureRecognizer)
        let panGestureRecognizer=UIPanGestureRecognizer(target: self, action: #selector(move(_:)))
        panGestureRecognizer.maximumNumberOfTouches=1
        sceneView.addGestureRecognizer(panGestureRecognizer)
        let viewRotatedGestureRecognizer=UIRotationGestureRecognizer(target: self, action: #selector(rotate(_:)))
        sceneView.addGestureRecognizer(viewRotatedGestureRecognizer)
        let pinGestureRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(scale(_:)))
        sceneView.addGestureRecognizer(pinGestureRecognizer)
    }
    
    @objc func tap(_ recognizer: UIGestureRecognizer) {
        closeAllAnimation()
        
        let location = recognizer.location(in: sceneView)
        guard let selectedNode = getNodeRelatedRootNode(at: location) as SCNNode? else { return }
        
        let alert = UIAlertController(title: "Warning!", message: "Do you want to remove it?", preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.default, handler:{
            (action) -> Void in
            DispatchQueue.main.async {
                selectedNode.removeFromParentNode()
                if self.swtAudio.isOn{
                    self.audioConfigure(action: "delete")
                }
            }
        }
        ))
        alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.cancel, handler: nil))
        // show the alert
        self.present(alert, animated: true, completion: nil)
        
        //        let arHitTestResult = sceneView.hitTest(location, types: [.existingPlaneUsingExtent,.estimatedVerticalPlane,.estimatedHorizontalPlane,.existingPlane])
        //
        //        if !arHitTestResult.isEmpty {
        //            if deleteNode == nil{
        //                DispatchQueue.main.async {
        //                    let transform = arHitTestResult.first?.worldTransform
        //                    self.positionTmp=transform!
        //                    let newPosition = float3((transform?.columns.3.x)!, ((transform?.columns.3.y)!+0.1), (transform?.columns.3.z)!)
        //                    selectedNode.simdPosition = newPosition
        //                    self.sceneView.scene.rootNode.addChildNode(selectedNode)
        //                    self.deleteNode=selectedNode
        //                    self.toggleShowButton(true)
        //                }
        //            }else{
        //                if selectedNode == deleteNode{
        //                    DispatchQueue.main.async {
        //                        let transform = self.positionTmp
        //                        let newPosition = float3(transform.columns.3.x, transform.columns.3.y, transform.columns.3.z)
        //                        selectedNode.simdPosition = newPosition
        //                        self.sceneView.scene.rootNode.addChildNode(selectedNode)
        //                        self.deleteNode=nil
        //                        self.toggleShowButton(false)
        //                    }
        //
        //                }else{
        //                    DispatchQueue.main.async {
        //
        //                        let transform = self.positionTmp
        //                        let oldPosition = float3(transform.columns.3.x, transform.columns.3.y, transform.columns.3.z)
        //
        //                        self.deleteNode?.simdPosition = oldPosition
        //                        self.sceneView.scene.rootNode.addChildNode(self.deleteNode!)
        //
        //                        let transformNew = arHitTestResult.first?.worldTransform
        //                        self.positionTmp=transformNew!
        //                        let newPosition = float3((transformNew?.columns.3.x)!, ((transformNew?.columns.3.y)!+0.1), (transformNew?.columns.3.z)!)
        //                        selectedNode.simdPosition = newPosition
        //                        self.sceneView.scene.rootNode.addChildNode(selectedNode)
        //                        self.toggleShowButton(true)
        //                        self.deleteNode=selectedNode
        //                    }
        //                }
        //            }
        //        }
    }
    
    @objc func move(_ recognizer: UIPanGestureRecognizer) {
        closeAllAnimation()
        
        let translation = recognizer.translation(in: sceneView)
        recognizer.setTranslation(.zero, in: sceneView)
        
        let location = recognizer.location(in: sceneView)
        guard let selectedNode = getNodeRelatedRootNode(at: location) as SCNNode? else { return }
        
        let currentPositionInRederedScreen = CGPoint(sceneView.projectPoint(selectedNode.position))
        let nextPositionInRederedScreen = CGPoint(x: currentPositionInRederedScreen.x + translation.x, y: currentPositionInRederedScreen.y + translation.y)
        
        let hitTestCurrentPositionResults = sceneView.hitTest(currentPositionInRederedScreen, types: [.existingPlaneUsingExtent])
        
        let hitTestNextPositionResults = sceneView.hitTest(nextPositionInRederedScreen, types: [.existingPlaneUsingExtent])
        
        let currentARPlaneAnchor = hitTestCurrentPositionResults.first?.anchor as? ARPlaneAnchor
        let nextARPlaneAnchor = hitTestNextPositionResults.first?.anchor as? ARPlaneAnchor
        
        if currentARPlaneAnchor?.alignment != nil && currentARPlaneAnchor?.alignment != nextARPlaneAnchor?.alignment{
            return
        }
        
        if hitTestNextPositionResults.isEmpty{
            return
        }
        
        let worldTransform = hitTestNextPositionResults.first?.worldTransform
        let nextPosition = SCNVector3((worldTransform?.columns.3.x)!,(worldTransform?.columns.3.y)!,(worldTransform?.columns.3.z)!)
        selectedNode.position = nextPosition
    }
    
    @objc func rotate(_ recognizer: UIRotationGestureRecognizer) {
        closeAllAnimation()
        
        let location = recognizer.location(in: sceneView)
        guard let selectedNode = getNodeRelatedRootNode(at: location) as SCNNode? else { return }
        
        if selectedNode.eulerAngles.x != 0 || selectedNode.eulerAngles.z != 0 {
            for childNode in selectedNode.childNodes{
                childNode.eulerAngles.y -= Float(recognizer.rotation)
                childNode.eulerAngles.y = resetAngle(angle: childNode.eulerAngles.y)
            }
        }
        else{
            selectedNode.eulerAngles.y -= Float(recognizer.rotation)
            selectedNode.eulerAngles.y = resetAngle(angle: selectedNode.eulerAngles.y)
        }
        
        recognizer.rotation = 0
    }
    
    func resetAngle(angle: Float) -> Float{
        
        if angle < -Float.pi{
            return angle + 2*Float.pi
        }
        if angle > Float.pi{
            return angle - 2*Float.pi
        }
        
        return angle
    }
    
    @objc func scale(_ gesture: UIPinchGestureRecognizer) {
        let location = gesture.location(in: sceneView)
        
        guard let node = getNodeRelatedRootNode(at: location) else{return}
        switch gesture.state {
        case .began:
            self.originalScale = node.scale
            gesture.scale = CGFloat(node.scale.x)
        case .changed:
            guard var originalScale = self.originalScale else { return }
            if gesture.scale > 2.0 || gesture.scale < 0.5 {
                return
            }
            originalScale.x = Float(gesture.scale)
            originalScale.y = Float(gesture.scale)
            originalScale.z = Float(gesture.scale)
            node.scale = originalScale
        case .ended:
            guard var originalScale = self.originalScale else { return }
            if gesture.scale > 2.0 || gesture.scale < 0.5 {
                return
            }
            originalScale.x = Float(gesture.scale)
            originalScale.y = Float(gesture.scale)
            originalScale.z = Float(gesture.scale)
            node.scale = originalScale
            gesture.scale = CGFloat(node.scale.x)
        default:
            gesture.scale = 1.0
        }
    }
    
    private func getNodeRelatedRootNode(at location: CGPoint) -> SCNNode? {
        
        var hitTestOptions = [SCNHitTestOption: Any]()
        //Search all objects
        hitTestOptions[SCNHitTestOption.searchMode] = 1
        
        let results = sceneView.hitTest(location, options: hitTestOptions)
        for result in results {
            if result.node.name != "planeNode"{
                var nodeRelatedRootNode = result.node
                while true{
                    if nodeRelatedRootNode.parent == sceneView.scene.rootNode{
                        return nodeRelatedRootNode
                    }
                    nodeRelatedRootNode = nodeRelatedRootNode.parent!
                }
            }
        }
        return nil
    }
    
    func toggleShowButton(_ check: Bool){
        self.btnTakeScreen.isHidden=check
        self.btnDelete.isHidden=(!check)
        self.btnMenu.isHidden=check
        self.menuView.isHidden=check
        self.btnOption.isHidden=check
    }
}

extension CGPoint {
    /// Extracts the screen space point from a vector returned by SCNView.projectPoint(_:).
    init(_ vector: SCNVector3) {
        self.init(x: CGFloat(vector.x), y: CGFloat(vector.y))
    }
    
    /// Returns the length of a point when considered as a vector. (Used with gesture recognizers.)
    var length: CGFloat {
        return sqrt(x * x + y * y)
    }
}
extension float4x4 {
    /**
     Treats matrix as a (right-hand column-major convention) transform matrix
     and factors out the translation component of the transform.
     */
    var translation: float3 {
        get {
            let translation = columns.3
            return float3(translation.x, translation.y, translation.z)
        }
        set(newValue) {
            columns.3 = float4(newValue.x, newValue.y, newValue.z, columns.3.w)
        }
    }
    
    /**
     Factors out the orientation component of the transform.
     */
    var orientation: simd_quatf {
        return simd_quaternion(self)
    }
    
    /**
     Creates a transform matrix with a uniform scale factor in all directions.
     */
    init(uniformScale scale: Float) {
        self = matrix_identity_float4x4
        columns.0.x = scale
        columns.1.y = scale
        columns.2.z = scale
    }
}


