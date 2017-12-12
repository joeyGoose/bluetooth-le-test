//
//  CBCentralManagerViewController.swift
//  bluetooth-le-test
//
//  Created by Joey Piro on 2017-09-09.
//  Copyright © 2017 Joey. All rights reserved.
//

import UIKit
import CoreBluetooth

class CBCentralManagerViewController: UIViewController, CBCentralManagerDelegate, UITableViewDelegate, UITableViewDataSource {
    
    var centralManager: CBCentralManager!
    
    var peripheralConnected: CBPeripheral?
    
    var foundPeripherals = [CBPeripheral]()
    
    @IBOutlet weak var peripheralTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        peripheralTable.delegate = self
        peripheralTable.dataSource = self
        
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }
    
    // MARK: - Central Manager Delegate
    func centralManagerDidUpdateState(_ central: CBCentralManager) {

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
        addToFoundPeripherals(peripheral: peripheral)
    }
    
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        print("Failed to connect to \(peripheral.name!)")
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("Successfully connected to \(peripheral.name!)")
        peripheralConnected = peripheral
        performSegue(withIdentifier: "PeripheralView", sender: nil)
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        print("Peripheral has been disconnected.")
    }
    
    private func addToFoundPeripherals(peripheral: CBPeripheral) {
        
        if let _ = peripheral.name as String! {
            if !foundPeripherals.contains(peripheral) {
            foundPeripherals.append(peripheral)
              let indexPath = IndexPath(row: foundPeripherals.count - 1, section: 0)
              peripheralTable.insertRows(at: [indexPath], with: .right)
            }
        }
        
    }
    
    // MARK: Table View
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return foundPeripherals.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "PeripheralCell") as? PeripheralCell {
            let peripheral = foundPeripherals[indexPath.row]
            cell.updateViews(peripheralName: peripheral.name!)
            return cell
        } else {
            return PeripheralCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let peripheral = foundPeripherals[indexPath.row]
        centralManager.connect(peripheral, options: nil)
    }
    

    
    // MARK: Storyboard
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let peripheralViewController = segue.destination as? PeripheralViewController {
            peripheralViewController.peripheral = peripheralConnected
            peripheralViewController.centralManager = centralManager
        }
    }


}
