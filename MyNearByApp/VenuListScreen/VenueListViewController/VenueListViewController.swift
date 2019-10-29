//
//  VenueListViewController.swift
//  MyNearByApp
//
//  Created by Ahmed Sultan on 10/28/19.
//  Copyright © 2019 Ahmed Sultan. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

class VenueListViewController: UIViewController {
    @IBOutlet weak var locationSwitchMode: UISwitch!
    @IBOutlet weak var currentMode: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    var locationManager: CLLocationManager?
    var fetchedRegionCenter: CLLocationCoordinate2D? = nil {
        didSet{
            guard let fetchedRegionCenter = fetchedRegionCenter else {
                 return
            }
            viewModel.initFetch(around: fetchedRegionCenter)
        }
    }

    var didExitFromRegion: Bool = false {
        didSet{
            fetchedRegionCenter = nil
        }
    }
    var mode: UserMode = .realTime {
        didSet{
         if mode == .realTime && oldValue == .signle {
                fetchedRegionCenter = nil
            }
        locationSwitchMode.setOn(mode == .realTime, animated: true)
        currentMode.text = mode.rawValue
        }
    }
    // point of optimization we can use coordinator to inject this VM
    lazy var viewModel: VenueListViewModel = {
        return VenueListViewModel()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initView()
        
        initLocationSettings()

        initVM()
        
    }
    
    fileprivate func initLocationSettings() {
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        setupCoreLocation()
        if let mode = UserStore.getUserMode(){
            self.mode = UserMode(status: mode)
        }
    }
    
    func initView() {
        self.navigationItem.title = "Nearby Places"
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 200
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    func initVM() {
        
        // Naive binding
        viewModel.showWarningClosure = { [weak self] () in
            DispatchQueue.main.async {
                if let message = self?.viewModel.warningMessage {
                    self?.showWarning( message )
                }
            }
        }
        
        viewModel.updateLoadingStatus = { [weak self] () in
            DispatchQueue.main.async {
                let isLoading = self?.viewModel.isLoading ?? false
                if isLoading {
                    self?.activityIndicator.startAnimating()
                    UIView.animate(withDuration: 0.2, animations: {
                        self?.tableView.alpha = 0.0
                    })
                }else {
                    self?.activityIndicator.stopAnimating()
                    UIView.animate(withDuration: 0.2, animations: {
                        self?.tableView.alpha = 1.0
                    })
                }
            }
        }
        
        viewModel.reloadTableViewClosure = { [weak self] () in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
        viewModel.switchModeClosure = { [weak self] status in
            DispatchQueue.main.async {
                self?.mode = UserMode(status: status)
                UserStore.save(userMode: status)
            }
        }
    }
    
    private func showWarning( _ message: Message ) {
        let alert = UIAlertController(title: message.messageTxt, message: message.messageTxt, preferredStyle: .alert)
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func switchMode(_ sender: UISwitch) {
        self.viewModel.locationSwitchStatus = sender.isOn
    }
}

extension VenueListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "venueCellIdentifier", for: indexPath) as? VenueListTableViewCell else {
            fatalError("Cell not exists in storyboard")
        }
        
        let cellVM = viewModel.getCellViewModel( at: indexPath )
        cell.venueListCellViewModel = cellVM
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfCells
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200.0
    }
}
extension UITableView {
    func reloadData(completion: @escaping () -> Void) {
        UIView.animate(withDuration: 0, animations: { self.reloadData() })
        { _ in completion() }
    }
}

