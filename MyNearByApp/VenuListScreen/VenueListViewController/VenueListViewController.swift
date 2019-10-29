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

enum UserMode {
    case signle
    case realTime
}
class VenueListViewController: UIViewController {
    @IBOutlet weak var currentMode: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    var locationManager: CLLocationManager?
    var coordinate2D = CLLocationCoordinate2DMake(37.44422039,-122.25925044)
    var fetchedRegionCenter: CLLocationCoordinate2D? = nil {
        didSet{
            guard let fetchedRegionCenter = fetchedRegionCenter else {
                 return
            }
            viewModel.initFetch(around: fetchedRegionCenter)
        }
    }
    let sectionHeaderAndFooterHeight: CGFloat = 40
    

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
        }
    }
    // point of optimization we can use coordinator to inject this VM
    lazy var viewModel: VenueListViewModel = {
        return VenueListViewModel()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initView()
        
        initVM()
        
        // todo : setup mode single or real time default and show handle user permission and save it in user store
        
        // optimize register cell instead of manual identifier
    }
    
    fileprivate func setupUserLocation() {
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        setupCoreLocation()
        if let mode = UserDefaults.standard.object(forKey: "UserModeKey") as? UserMode{
            self.mode = mode
        }
    }
    
    func initView() {
        self.navigationItem.title = "Nearby Places"
        
        setupUserLocation()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 150
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
                //optimize
                self?.tableView.reloadData()
            }
        }
        
    }
    
    func showWarning( _ message: Message ) {
        let view = UIView(frame: self.view.frame)
        view.backgroundColor = .white
        let alert = UIAlertController(title: message.messageTxt, message: message.messageTxt, preferredStyle: .alert)
        self.present(alert, animated: true, completion: nil)
    }
    func hideWarning(){
       self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func switchMode(_ sender: UISwitch) {
        if sender.isOn {
            currentMode.text = "Real Time"
            mode = .realTime
        }else {
            currentMode.text = "Single "
            mode = .signle
            // stop updating location
        }
    }
}

extension VenueListViewController: UITableViewDelegate, UITableViewDataSource {
    // optimization use inline loading instead

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
        //point of optimization change it to automatic

        return 150.0
    }
     // point of optimization handle user pressed action
}
extension VenueListViewController: CLLocationManagerDelegate {
    func setupCoreLocation(){
        switch CLLocationManager.authorizationStatus(){
        case .notDetermined:
            locationManager?.requestAlwaysAuthorization()
            break
        case .authorizedAlways, .authorizedWhenInUse:
            enableLocationServices()
        case .restricted, .denied:
            handleNonAuthorizedLocation()
        @unknown default:
            break
        }
    }
    
    fileprivate func setupNewRegion() {
        if CLLocationManager.authorizationStatus() == .authorizedAlways || CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            if CLLocationManager.isMonitoringAvailable(for: CLCircularRegion.self){
                let region = CLCircularRegion(center: coordinate2D, radius: 50, identifier: "id")
                region.notifyOnExit = true
                locationManager?.startMonitoring(for: region)
                
            }
        }
    }
    
    func enableLocationServices(){
        if CLLocationManager.locationServicesEnabled(){
            locationManager?.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager?.startUpdatingLocation()
        }
        
    }
    
    func disableLocationServies(){
        locationManager?.stopUpdatingLocation()
    }
    
    fileprivate func handleNonAuthorizedLocation() {
        print("not authorized")
        let alert = UIAlertController(title: "Location Needed", message: "Sorry App can not detect your location please give location permission", preferredStyle: .alert)
        alert.addAction( UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    /// location delegate methods
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        if presentedViewController == nil {
            let alertController = UIAlertController(title: "Interesting Location Nearby", message: "You need to refresh you are out of \(region.identifier). Check it out!", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "OK", style: .default) {
                [weak self] action in
                self?.dismiss(animated: true, completion: nil)
            }
            alertController.addAction(alertAction)
            present(alertController, animated: false, completion: nil)
        }
        didExitFromRegion = true
    }
    
    func locationManager(_ manager: CLLocationManager, monitoringDidFailFor region: CLRegion?, withError error: Error) {
        print(error.localizedDescription)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .denied, .restricted:
            handleNonAuthorizedLocation()
        case .notDetermined:
            locationManager?.requestAlwaysAuthorization()
        default:
            break
        }
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
//        let locationLatLong = "\(String(describing: location.coordinate.latitude)),\(String(describing: location.coordinate.longitude))"
//        print(locationLatLong)
        
        let location = locations.first!
        if fetchedRegionCenter == nil {
            fetchedRegionCenter = location.coordinate
            if self.mode == .signle {
                UserDefaults.standard.set(mode, forKey: "UserModeKey")
                disableLocationServies()
            }else if mode == .realTime{
                setupNewRegion()
            }

        }
    }
}

extension UITableView {
    func reloadData(completion: @escaping () -> Void) {
        UIView.animate(withDuration: 0, animations: { self.reloadData() })
        { _ in completion() }
    }
}

