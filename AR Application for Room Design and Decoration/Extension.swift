//import ARKit
//import SceneKit
//
//extension DesignAndDecorationViewController{
//    var session: ARSession {
//        return sceneView.session
//    }
//
//    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
//        // If light estimation is enabled, update the intensity of the model's lights and the environment map
//        let baseIntensity: CGFloat = 40
//        let lightingEnvironment = sceneView.scene.lightingEnvironment
//        if let lightEstimate = session.currentFrame?.lightEstimate {
//            lightingEnvironment.intensity = lightEstimate.ambientIntensity / baseIntensity
//        } else {
//            lightingEnvironment.intensity = baseIntensity
//        }
//    }
//
//    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
//        guard let planeAnchor = anchor as? ARPlaneAnchor else {
//            print("Can't find plane")
//            return
//        }
////        sceneView.debugOptions=[]
//        DispatchQueue.main.async { // Make sure you're on the main thread here
//            self.menuView.isHidden=false
//            self.btnMenu.isHidden=false
//        }
//        if anchor is ARPlaneAnchor {
//            // create Plane
//
//            print("align",planeAnchor.alignment)
//            print("extent",planeAnchor.extent)
//            let planeGeometry = SCNPlane(width: CGFloat(planeAnchor.extent.x), height: CGFloat(planeAnchor.extent.z))
//            let material = SCNMaterial()
//            material.diffuse.contents=UIImage(named: "tron_grid.png")
//            planeGeometry.materials=[material]
//            let planeNode = SCNNode(geometry: planeGeometry)
//            planeNode.position = SCNVector3(x: planeAnchor.center.x, y:0, z: planeAnchor.center.z)
////             planeNode.physicsBody = SCNPhysicsBody(type: SCNPhysicsBodyType.kinematic, shape: SCNPhysicsShape(geometry: planeGeometry, options: nil))
//
//            planeNode.transform = SCNMatrix4MakeRotation(-Float.pi / 2, 1, 0, 0)
//            planeNode.name="planeNode"
//            node.addChildNode(planeNode)
//            anchors.append(planeAnchor)
//        }
//    }
//    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
//        if let planeAnchor = anchor as? ARPlaneAnchor {
//            if anchors.contains(planeAnchor) {
//                if node.childNodes.count > 0 {
//                    let planeNode = node.childNodes.first!
//                    planeNode.position = SCNVector3(x: planeAnchor.center.x, y: 0, z: planeAnchor.center.z)
//                    if let plane = planeNode.geometry as? SCNPlane {
//                        plane.width = CGFloat(planeAnchor.extent.x)
//                        plane.height = CGFloat(planeAnchor.extent.z)
//                    }
//                }
//            }
//        }
//    }
//
//}
