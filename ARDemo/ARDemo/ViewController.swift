//
//  ViewController.swift
//  ARDemo
//
//  Created by Fedul on 5/15/20.
//  Copyright © 2020 Fedul. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

struct CollisionCategory: OptionSet {
    let rawValue: Int
    
    static let missileCategory = CollisionCategory(rawValue: 1 << 0)
    static let targetCategory = CollisionCategory(rawValue: 1 << 1)
    static let otherCategory = CollisionCategory(rawValue: 1 << 2)
}

class ViewController: UIViewController, ARSCNViewDelegate, SCNPhysicsContactDelegate {
    
    private let colorsArray: [UIColor] = [UIColor.red, UIColor.green, UIColor.white, UIColor.blue, UIColor.yellow, UIColor.orange]
    private var choosenColor: UIColor!
    var choose = 1
    
    @IBOutlet weak var fireButton: UIButton!
    @IBOutlet var sceneView: ARSCNView!
    @IBAction func fireButtonWhite(_ sender: Any) {
        fireMissile(type: choosenColor)
    }
    
    @IBAction func nextColor(_ sender: Any) {
        choose += 1
        if choose == colorsArray.count {
            choose = 0
        }
        choosenColor = colorsArray[choose]
        fireButton.backgroundColor = choosenColor
    }
    
    @IBAction func previousColor(_ sender: Any) {
        choose -= 1
        if choose < 0 {
            choose = 5
        }
        choosenColor = colorsArray[choose]
        fireButton.backgroundColor = choosenColor
    }
    
    
    func getUserVector() -> (SCNVector3, SCNVector3) {
        if let frame = self.sceneView.session.currentFrame {
            let mat = SCNMatrix4(frame.camera.transform)
            let dir = SCNVector3(-1 * mat.m31, -1 * mat.m32, -1 * mat.m33)
            let pos = SCNVector3(mat.m41, mat.m42, mat.m43)
            
            return (dir, pos)
        }
        return (SCNVector3(0, 0, -1), SCNVector3(0, 0, -0.2))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        choosenColor = colorsArray[1]
        fireButton.backgroundColor = choosenColor
        sceneView.delegate = self
        sceneView.scene.physicsWorld.contactDelegate = self
        addTargetNotes()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let configuration = ARWorldTrackingConfiguration()
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }
    
    func addTargetNotes() {
        for _ in 1...100 {
            let rand = Int.random(in: 1...6)
            var node = SCNNode()
            switch rand {
            case 1:
                let scene = SCNScene(named: "art.scnassets/ship.scn")
                node = (scene?.rootNode.childNode(withName: "box", recursively: true)!)!
                node.scale = SCNVector3(0.3, 0.3, 0.3)
                node.name = "cube"
                node.geometry?.materials.first?.diffuse.contents = UIColor.red
            case 2:
                let scene = SCNScene(named: "art.scnassets/ship.scn")
                node = (scene?.rootNode.childNode(withName: "box", recursively: true)!)!
                node.scale = SCNVector3(0.3, 0.3, 0.3)
                node.name = "cube"
                node.geometry?.materials.first?.diffuse.contents = UIColor.blue
            case 3:
                let scene = SCNScene(named: "art.scnassets/ship.scn")
                node = (scene?.rootNode.childNode(withName: "box", recursively: true)!)!
                node.scale = SCNVector3(0.3, 0.3, 0.3)
                node.name = "cube"
                node.geometry?.materials.first?.diffuse.contents = UIColor.orange
            case 4:
                let scene = SCNScene(named: "art.scnassets/ship.scn")
                node = (scene?.rootNode.childNode(withName: "box", recursively: true)!)!
                node.scale = SCNVector3(0.3, 0.3, 0.3)
                node.name = "cube"
                node.geometry?.materials.first?.diffuse.contents = UIColor.yellow
            case 5:
                let scene = SCNScene(named: "art.scnassets/ship.scn")
                node = (scene?.rootNode.childNode(withName: "box", recursively: true)!)!
                node.scale = SCNVector3(0.3, 0.3, 0.3)
                node.name = "cube"
                node.geometry?.materials.first?.diffuse.contents = UIColor.green
            case 6:
                let scene = SCNScene(named: "art.scnassets/ship.scn")
                node = (scene?.rootNode.childNode(withName: "box", recursively: true)!)!
                node.scale = SCNVector3(0.3, 0.3, 0.3)
                node.name = "cube"
                node.geometry?.materials.first?.diffuse.contents = UIColor.white
            default:
                continue
            }
            
            node.physicsBody = SCNPhysicsBody(type: .dynamic, shape: nil)
            node.physicsBody?.isAffectedByGravity = false
            
            node.position = SCNVector3(randomFloat(min: -10, max: 10), randomFloat(min: -4, max: 5), randomFloat(min: -10, max: 10))
            
            let action: SCNAction = SCNAction.rotate(by: .pi, around: SCNVector3(0, 1, 0), duration: 1.0)
            let forever = SCNAction.repeatForever(action)
            node.runAction(forever)
            
            node.physicsBody?.categoryBitMask = CollisionCategory.targetCategory.rawValue
            node.physicsBody?.contactTestBitMask = CollisionCategory.missileCategory.rawValue
                        
            sceneView.scene.rootNode.addChildNode(node)
        }
    }
    
    func randomFloat(min: Float, max: Float) -> Float {
        return (Float(arc4random()) / 0xFFFFFFFF) * (max - min) + min
    }
    
    func createMissile(type: UIColor) -> SCNNode {
        var node = SCNNode()
        
        switch type {
        case UIColor.white:
            let scene = SCNScene(named: "art.scnassets/ship.scn")
            node = (scene?.rootNode.childNode(withName: "sphere", recursively: true)!)!
            node.scale = SCNVector3(0.2, 0.2, 0.2)
            node.name = "sphere"
            node.geometry?.materials.first?.diffuse.contents = UIColor.white
        case UIColor.red:
            let scene = SCNScene(named: "art.scnassets/ship.scn")
            node = (scene?.rootNode.childNode(withName: "sphere", recursively: true)!)!
            node.scale = SCNVector3(0.2, 0.2, 0.2)
            node.name = "sphere"
            node.geometry?.materials.first?.diffuse.contents = UIColor.red
        case UIColor.green:
            let scene = SCNScene(named: "art.scnassets/ship.scn")
            node = (scene?.rootNode.childNode(withName: "sphere", recursively: true)!)!
            node.scale = SCNVector3(0.2, 0.2, 0.2)
            node.name = "sphere"
            node.geometry?.materials.first?.diffuse.contents = UIColor.green
        case UIColor.yellow:
            let scene = SCNScene(named: "art.scnassets/ship.scn")
            node = (scene?.rootNode.childNode(withName: "sphere", recursively: true)!)!
            node.scale = SCNVector3(0.2, 0.2, 0.2)
            node.name = "sphere"
            node.geometry?.materials.first?.diffuse.contents = UIColor.yellow
        case UIColor.orange:
            let scene = SCNScene(named: "art.scnassets/ship.scn")
            node = (scene?.rootNode.childNode(withName: "sphere", recursively: true)!)!
            node.scale = SCNVector3(0.2, 0.2, 0.2)
            node.name = "sphere"
            node.geometry?.materials.first?.diffuse.contents = UIColor.orange
        case UIColor.blue:
            let scene = SCNScene(named: "art.scnassets/ship.scn")
            node = (scene?.rootNode.childNode(withName: "sphere", recursively: true)!)!
            node.scale = SCNVector3(0.2, 0.2, 0.2)
            node.name = "sphere"
            node.geometry?.materials.first?.diffuse.contents = UIColor.blue
        default:
            fatalError()
        }
        
        
        node.physicsBody = SCNPhysicsBody(type: .dynamic, shape: nil)
        node.physicsBody?.isAffectedByGravity = false
        
        node.physicsBody?.categoryBitMask = CollisionCategory.missileCategory.rawValue
        node.physicsBody?.contactTestBitMask = CollisionCategory.targetCategory.rawValue
        
        return node
    }
    
    func fireMissile(type: UIColor) {
        var node = SCNNode()
        
        node = createMissile(type: type)
        
        let (direction, position) = self.getUserVector()
        node.position = position
        var nodeDirection = SCNVector3()
        nodeDirection = SCNVector3(direction.x*4, direction.y*4, direction.z*4)
        node.physicsBody?.applyForce(SCNVector3(direction.x, direction.y, direction.z), at: SCNVector3(0, 0, 0.1), asImpulse: true)
        node.physicsBody?.applyForce(nodeDirection, asImpulse: true)
        sceneView.scene.rootNode.addChildNode(node)
    }
    
    
    
    
    func physicsWorld(_ world: SCNPhysicsWorld, didBegin contact: SCNPhysicsContact) {
        let nodeA = contact.nodeA.geometry?.materials.first?.diffuse.contents
        let nodeB = contact.nodeB.geometry?.materials.first?.diffuse.contents
        
        if contact.nodeA.physicsBody?.categoryBitMask == CollisionCategory.targetCategory.rawValue || contact.nodeB.physicsBody?.categoryBitMask == CollisionCategory.targetCategory.rawValue {
            if nodeA as! UIColor? == nodeB as! UIColor? {
                DispatchQueue.main.async {
                    contact.nodeA.removeFromParentNode()
                    contact.nodeB.removeFromParentNode()
                }
            }
            else {
                DispatchQueue.main.async {
                    contact.nodeB.removeFromParentNode()
                }
            }
        }
    }
}
