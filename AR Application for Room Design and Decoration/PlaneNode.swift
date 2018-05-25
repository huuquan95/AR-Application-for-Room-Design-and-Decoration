
import UIKit
import ARKit

class Plane: SCNNode {
    
    var planeGeometry: SCNPlane?
    var anchor: ARPlaneAnchor?
    
    init(anchor: ARPlaneAnchor) {
        super.init()
        // dimensions
        let width = CGFloat(anchor.extent.x)
        let height = CGFloat(anchor.extent.z)
        self.planeGeometry = SCNPlane(width: width, height: height)
        // meterial : grid image
        let material = SCNMaterial()
        let image = UIImage(named: "hexgrid.png")
        material.diffuse.contents = image

        // assign material
        self.planeGeometry?.materials = [material]
        
        let planeNode = SCNNode(geometry: self.planeGeometry)
         planeNode.position = SCNVector3(x: anchor.center.x, y:0, z: anchor.center.z)
        
        planeNode.eulerAngles.x = (-Float.pi*0.5)
        planeNode.physicsBody = SCNPhysicsBody(type: .static, shape: nil)
        planeNode.name="planeNode"
        
        self.addChildNode(planeNode)
    }
    
    // update plane with updated anchor
    func updateAnchor(_ anchor: ARPlaneAnchor) {
        // update height, length
        self.planeGeometry?.width = CGFloat(anchor.extent.x)
        self.planeGeometry?.height = CGFloat(anchor.extent.z)
        
        self.position = SCNVector3(anchor.center.x, 0, anchor.center.z)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
