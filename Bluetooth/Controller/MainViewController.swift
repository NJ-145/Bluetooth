//
//  MainViewController.swift
//  Bluetooth
//
//  Created by imac-2626 on 2024/9/18.
//

import UIKit
import CoreBluetooth

class MainViewController: UIViewController {
    
    // MARK: - IBOutlet
    
    @IBOutlet var tbvBluetooth: UITableView!
    
    @IBOutlet var lbLight: UILabel!
    
    // MARK: - Property
    
    var foundPeripherals: [CBPeripheral] = []
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        BluetoothService.shared.delegate = self
        setUi()
    }
    
    // MARK: - UI Settings
    
    func setUi() {
        tbvBluetooth.register(UINib(nibName: "MainTableViewCell", bundle: nil),
                              forCellReuseIdentifier: MainTableViewCell.identifier)
        tbvBluetooth.delegate = self
        tbvBluetooth.dataSource = self
    }
}

// MARK: - Extensions

extension MainViewController: BluetoothServiceDelegate, CBPeripheralDelegate {
    func getBLEPeripherals(peripherals: [CBPeripheral]) {
        self.foundPeripherals = peripherals
        DispatchQueue.main.async {
            self.tbvBluetooth.reloadData()
        }
    }
    
    func getBLEPeripheralsVlaue(value: String) {
        DispatchQueue.main.async {
            self.lbLight.text = value
        }
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return foundPeripherals.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MainTableViewCell",
                                                 for: indexPath) as! MainTableViewCell
        let peripheral = foundPeripherals[indexPath.row]
        print(peripheral)
        cell.lbBluetooth.text = peripheral.name ?? "未知裝置"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedPeripheral = foundPeripherals[indexPath.row]
        BluetoothService.shared.connectPeripheral(peripheral: selectedPeripheral)
        print("正在連接: \(selectedPeripheral.name ?? "未知裝置")")
    }
}
