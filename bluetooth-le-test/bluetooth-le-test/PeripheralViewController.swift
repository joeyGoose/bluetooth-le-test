import UIKit
import CoreBluetooth


class PeripheralViewController: UIViewController, CBPeripheralDelegate {

    //the peripheral we want to work with
    var peripheral: CBPeripheral!
    var centralManager: CBCentralManager!
    
    //the characteristic we want to work with
    //IO
    var ioDataCharacteristic: CBCharacteristic?

    @IBOutlet weak var ioButton: UIButton!
    
    //services
    let ioServiceCBUUID = CBUUID(string: "F000AA64-0451-4000-B000-000000000000")
    
    //characteristics
    let ioDataCharacteristicCBUUID = CBUUID(string: "F000AA65-0451-4000-B000-000000000000")
    let ioConfigurationCharacteristicCBUUID = CBUUID(string:"F000AA66-0451-4000-B000-000000000000")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //set delegate to self
        peripheral.delegate = self
        
        //setup services array
        let services = [ioServiceCBUUID]
        peripheral.discoverServices(services)
    }
    
    @IBAction func touchUpInsideOnBuzzerButton(_ sender: Any) {
        if ioDataCharacteristic != nil {
        var valueToWrite = 0
        let writeValueIO = Data(bytes: &valueToWrite, count: MemoryLayout<UInt8>.size)
            peripheral.writeValue(writeValueIO, for: ioDataCharacteristic!, type:CBCharacteristicWriteType.withResponse)
        }
    }
    
    @IBAction func touchDownOnBuzzerButton(_ sender: Any) {
        if ioDataCharacteristic != nil {
            var valueToWrite = 1
            let writeValueIO = Data(bytes: &valueToWrite, count: MemoryLayout<UInt8>.size)
            peripheral.writeValue(writeValueIO, for: ioDataCharacteristic!, type:CBCharacteristicWriteType.withResponse)
        }
    }
    
    
    
  // Peripheral Delegate
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        for service in peripheral.services! {
            if service.uuid == ioServiceCBUUID {
            //setup characteristics
            let characteristics = [ioDataCharacteristicCBUUID, ioConfigurationCharacteristicCBUUID]
            peripheral.discoverCharacteristics(characteristics, for: service)
            print("IO Service Discovered")
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        for characteristic in service.characteristics!{
            
            if characteristic.uuid == ioDataCharacteristicCBUUID {
                ioDataCharacteristic = characteristic
                var remoteModeBitInt = 0
                let remoteModeBytes = NSData(bytes: &remoteModeBitInt, length: MemoryLayout<UInt8>.size)
                peripheral.writeValue(remoteModeBytes as Data, for: characteristic, type: CBCharacteristicWriteType.withResponse)
            }
            
            if characteristic.uuid == ioConfigurationCharacteristicCBUUID {
                var remoteModeBitInt = 1
                let remoteModeBytes = NSData(bytes: &remoteModeBitInt, length: MemoryLayout<UInt8>.size)
                peripheral.writeValue(remoteModeBytes as Data, for: characteristic, type: CBCharacteristicWriteType.withResponse)
            }
        }
    }
    
   



}
