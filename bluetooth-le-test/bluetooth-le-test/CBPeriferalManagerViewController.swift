import UIKit
import CoreBluetooth

class CBPeripheralManagerViewController: UIViewController, CBPeripheralManagerDelegate {

    var peripheralManager : CBPeripheralManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        peripheralManager = CBPeripheralManager(delegate: self, queue: nil)
    }
    
    func setupService() {
        let characteristicUUID = "d53b80f2-ff08-4ee6-82d1-c30ed0cf3feb"
        let serviceUUID = "e9972002-612e-4efa-afb4-a6dbae21ad98"
        
        let cbuuidCharacteristic = CBUUID(string: characteristicUUID)
        let cbuuidService = CBUUID(string: serviceUUID)
        
        //setup characteristic and service
        let mutableCharacteristic = CBMutableCharacteristic(type: cbuuidCharacteristic, properties: .notify, value: nil, permissions: .readable)
        
        let mutableService = CBMutableService(type: cbuuidService, primary: true)
        mutableService.characteristics = [mutableCharacteristic]
        
        peripheralManager.add(mutableService)
    }
    
    func advertise() {
        let serviceUUID = "e9972002-612e-4efa-afb4-a6dbae21ad98"
        let cbuuidService = CBUUID(string: serviceUUID)
        
        let services = [cbuuidService]
        
        let advertisingDict = ["SomeString" : services]
        
        //start advertising
        peripheralManager.startAdvertising(advertisingDict)
    }
    
// -- Peripheral Manager Delegate
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        
        //deal with state; must be extensive
        switch (peripheral.state) {
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
            //setup service
            setupService()
            break
        }
    }

}

