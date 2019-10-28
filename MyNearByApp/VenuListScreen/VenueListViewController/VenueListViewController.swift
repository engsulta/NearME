//
//  VenueListViewController.swift
//  MyNearByApp
//
//  Created by Ahmed Sultan on 10/28/19.
//  Copyright © 2019 Ahmed Sultan. All rights reserved.
//

import Foundation
import UIKit

class VenueListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

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
    
    func initView() {
        self.navigationItem.title = "Nearby Places"
        
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
        /// start view model fetching
        viewModel.initFetch()
        
    }
    
    func showWarning( _ message: Message ) {
        let alert = UIAlertController(title: "Alert", message: message.messageTxt, preferredStyle: .alert)
        alert.addAction( UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
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
