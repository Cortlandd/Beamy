//
//  Beamy.swift
//  Beamy
//
//  Created by Rudd Fawcett on 1/26/18.
//  Copyright © 2018 Beamy. All rights reserved.
//

import Foundation
import CoreBluetooth

private class BeamySingleton {
    var UUID: String?
}

public class Beamy: NSObject  {
    static let sharedInstance = Beamy()
    private static let setup = BeamySingleton()
    
    /// The BeamyManager which handles the Bluetooth discovery and connections.
    let manager: BeamyManager?
    /// The UUID to broadcast/listen for.
    let UUID: String!
    /// A different identifier to listen for.
    private var _identifier: String?
    var identifier: String? {
        set(newValue) {
            self._identifier = newValue
            manager?.identifier = newValue
        }
        get {
            return self._identifier
        }
    }
    /// A list of discovered devices.
    var devices: [BeamyDevice] = []
    
    /// Creates a new Beamy object.
    ///
    /// - Parameter UUID: The UUID upon which to listen/advertise for.
    class func initiate(UUID: String) {
        Beamy.setup.UUID = UUID
        _ = Beamy.sharedInstance
    }
    
    override init() {
        self.UUID = Beamy.setup.UUID
        guard UUID != nil else {
            fatalError("Use initiate first in order to create a new Beamy instance.")
        }
        
        manager = BeamyManager(CBUUID(string: self.UUID))
        super.init()
        manager?.delegate = self
    }
    
    /// Braodcasts a message to all devices listening for the same UUID.
    ///
    /// - Parameter message: The BeamyMessage to broadcast.
    func broadcast(message: BeamyMessage) {
        self.manager?.advertise(message: message)
    }
    
    /// Sends a message to a single device based upon a CBPeripheral.
    ///
    /// - Parameters:
    ///   - message: The BeamyMessage to send.
    ///   - peripheral: The  BeamyDevice to send it to.
    func send(message: BeamyMessage, to peripheral: BeamyDevice)  {
        self.manager?.advertise(message: message, forTarget: peripheral)
    }
}

extension Beamy: BeamyManagerDelegate {
    func manager(didDiscover device: BeamyDevice) {
        self.devices.append(device)
    }
    
    func manager(didDiscover message: BeamyMessage, fromDevice device: BeamyDevice) {
        return
    }
    
    func manager(didReceiveMessage message: BeamyMessage, fromDevice device: BeamyDevice) {
        return
    }
    
    func manager(didBeginAdvertising advertising: Bool, withError error: Error?) {
        return
    }
    
    func manager(didUpdateState state: CBManagerState, fromPeripheral peripheral: CBPeripheralManager) {
        return
    }
}
