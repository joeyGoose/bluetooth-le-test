//
//  PeripheralCell.swift
//  bluetooth-le-test
//
//  Created by Joey Piro on 2017-09-21.
//  Copyright © 2017 Joey. All rights reserved.
//

import UIKit

class PeripheralCell: UITableViewCell {

    @IBOutlet weak var peripheralNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func updateViews(peripheralName: String) {
        self.peripheralNameLabel.text = peripheralName
    }

}
