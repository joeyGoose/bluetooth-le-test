//
//  CBCentralManagerViewController.swift
//  bluetooth-le-test
//
//  Created by Joey Piro on 2017-09-09.
//  Copyright © 2017 Joey. All rights reserved.
//

import UIKit
import CoreBluetooth

class CBCentralManagerViewController: UIViewController, CBCentralManagerDelegate {

    @IBOutlet weak var deviceButton: UIButton!
    
    var centralManager : CBCentralManager!
    
    var peripheralConnected : CBPeripheral?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }
    
    // MARK: - Central Manager Delegate
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        //do something
        
        switch central.state {
            
        case .unknown:
            break
        case .resetting:
            break
        case .unsupported:
            break
        case .unauthorized:
            break
        case .poweredOff:
            break
        case .poweredOn:
            print("Central Powered On")
            centralManager.scanForPeripherals(withServices: nil, options: nil)
            break
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        
        if peripheral.name == "SensorTag 2.0" && peripheral.name != nil {
            print("Peripheral Discovered: \(peripheral.name!)")
            centralManager.stopScan()
            deviceButton.isHidden = false
            deviceButton.titleLabel?.text = peripheral.name!
            deviceButton.isEnabled = true
            
            //connect to the periphal
            centralManager.connect(peripheral, options: nil)
            peripheralConnected = peripheral
        }
    }
    
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        print("Failed to connect to \(peripheral.name!)")
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("Successfully connected to \(peripheral.name!)")
        peripheralConnected = peripheral
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        print("Peripheral has been disconnected.")
    }
    
    // Storyboard
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let peripheralViewController = segue.destination as? PeripheralViewController {
            peripheralViewController.peripheral = peripheralConnected
            peripheralViewController.centralManager = centralManager
        }
    }


}
