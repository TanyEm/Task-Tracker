//
//  Emitter.swift
//  Task Tracker
//
//  Created by Tatiana Podlesnykh on 14.12.2020.
//

import UIKit

enum Emojis {
    static let done =  #imageLiteral(resourceName: "done")
    static let notDone = #imageLiteral(resourceName: "notDone")
    static let time = #imageLiteral(resourceName: "clock")
    static let star = #imageLiteral(resourceName: "star")
}

class Emitter {
    
    static var emojis:[UIImage] = [
        Emojis.done,
        Emojis.notDone,
        Emojis.time,
        Emojis.star,
    ]
    
    static var velocities:[Int] = [
            80,
            25,
            55,
            10
    ]

        
    static func get () -> CAEmitterLayer {
        let emitter = CAEmitterLayer()
        emitter.emitterShape = CAEmitterLayerEmitterShape.line
        emitter.emitterCells = generateEmitterCells()
        return emitter
    }
    
    static func generateEmitterCells() -> [CAEmitterCell] {
        var cells:[CAEmitterCell] = [CAEmitterCell]()
        for index in 0..<4 {
        let cell = CAEmitterCell()
        cell.contents = getNextImage(i: index)
        // birthRate - how many images appear at one time
        cell.birthRate = 0.3
        cell.lifetime = 50
        cell.velocity = CGFloat(getRandomVelocity())
        
        // make it flying with range
        cell.emissionRange = (60*(.pi/180))
                
        // make different size of emoji
        cell.scale = 0.4
        cell.scaleRange = 0.3
        
        cells.append(cell)
        }
        return cells
    }
    
    static func getNextImage(i:Int) -> CGImage {
        return emojis[i % 4].cgImage!
    }
    
    static func getRandomVelocity() -> Int {
        return velocities[getRandomNumber()]
    }
    
    static func getRandomNumber() -> Int {
        return Int(arc4random_uniform(4))
    }

}

