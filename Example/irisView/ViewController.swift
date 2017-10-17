//
//  ViewController.swift
//  iris
//
//  Created by ubeat0n on 2017/10/05.
//  Copyright © 2017 Kodai Ozawa. All rights reserved.
//

import UIKit
import irisView

class ViewController: UIViewController {
    
    let irisView = IrisView(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
    let irisView2 = IrisView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
    let irisView3 = IrisView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(hex: 0x333333)
        
        irisView.colors = [
            UIColor.iris.red.x500,
            UIColor.iris.pink.x500,
            UIColor.iris.purple.x500,
            UIColor.iris.deepPurple.x500,
            UIColor.iris.indigo.x500,
            UIColor.iris.blue.x500,
            UIColor.iris.lightBlue.x500,
            UIColor.iris.Cyan.x500,
            UIColor.iris.Teal.x500,
            UIColor.iris.green.x500,
            UIColor.iris.lightGreen.x500,
            UIColor.iris.lime.x500,
            UIColor.iris.yellow.x500,
            UIColor.iris.amber.x500,
            UIColor.iris.orange.x500,
            UIColor.iris.deepOrange.x500
        ]
        irisView.center = CGPoint(x: view.frame.width/2, y: view.frame.height/2)
        irisView.radius = irisView.frame.width/2
        irisView.isShadowed = true
        
        irisView2.colors = [
            UIColor.iris.red.x300,
            UIColor.iris.pink.x300,
            UIColor.iris.purple.x300,
            UIColor.iris.deepPurple.x300,
            UIColor.iris.indigo.x300,
            UIColor.iris.blue.x300,
            UIColor.iris.lightBlue.x300,
            UIColor.iris.Cyan.x300,
            UIColor.iris.Teal.x300,
            UIColor.iris.green.x300,
            UIColor.iris.lightGreen.x300,
            UIColor.iris.lime.x300,
            UIColor.iris.yellow.x300,
            UIColor.iris.amber.x300,
            UIColor.iris.orange.x300,
            UIColor.iris.deepOrange.x300
        ]
        irisView2.center = CGPoint(x: view.frame.width/2, y: view.frame.height/2)
        irisView2.radius = irisView2.frame.width/2
        irisView2.isShadowed = true
        
        irisView3.colors = [
            UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.5)
        ]
        irisView3.center = CGPoint(x: view.frame.width/2, y: view.frame.height/2)
        irisView3.radius = irisView3.frame.width/2
        irisView3.isShadowed = true
        
        view.addSubview(irisView)
        view.addSubview(irisView2)
        view.addSubview(irisView3)
    }
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        irisView.detect(touches, with: event)
        irisView2.detect(touches, with: event)
        irisView3.detect(touches, with: event)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        irisView.detect(touches, with: event)
        irisView2.detect(touches, with: event)
        irisView3.detect(touches, with: event)
        do {
            let obj = try irisView.detected()
            print("i: \(obj.0), layer: \(obj.1)")
        } catch {}
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        irisView.detect(touches, with: event, end: true)
        irisView2.detect(touches, with: event, end: true)
        irisView3.detect(touches, with: event, end: true)
    }
    
}

