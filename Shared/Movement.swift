//
//  Movement.swift
//  learning-metal
//
//  Created by Alexander Balaban.
//

enum Settings {
    static var rotationSpeed: Float { 2.0 }
    static var translationSpeed: Float { 3.0 }
    static var mouseScrollSensitivity: Float { 0.1 }
    static var mousePanSensitivity: Float { 0.008 }
}

protocol InputConsumer {
    var input: InputController { get }
}

protocol Movement where Self: Transformable & InputConsumer { }

extension Movement {
    var forwardVector: float3 {
        normalize([sin(rotation.y), 0, cos(rotation.y)])
    }
    var rightVector: float3 {
        [forwardVector.z, forwardVector.y, -forwardVector.x]
    }
    
    func updateInput(deltaTime: Float) -> Transform {
        var transform = Transform()
        let rotation = deltaTime * Settings.rotationSpeed
        if input.keysPressed.contains(.leftArrow) {
            transform.rotation.y -= rotation
        }
        if input.keysPressed.contains(.rightArrow) {
            transform.rotation.y += rotation
        }
        
        var direction: float3 = .zero
        if input.keysPressed.contains(.keyW) {
            direction.z += 1
        }
        if input.keysPressed.contains(.keyS) {
            direction.z -= 1
        }
        if input.keysPressed.contains(.keyA) {
            direction.x -= 1
        }
        if input.keysPressed.contains(.keyD) {
            direction.x += 1
        }
        if direction != .zero {
            let translation = deltaTime * Settings.translationSpeed
            direction = normalize(direction)
            transform.position += (direction.z * forwardVector + direction.x * rightVector) * translation
        }
        
        return transform
    }
}
