//
//  VenueListTableViewCell.swift
//  MyNearByApp
//
//  Created by Ahmed Sultan on 10/28/19.
//  Copyright © 2019 Ahmed Sultan. All rights reserved.
//

import Foundation
import UIKit
import SDWebImage

class VenueListTableViewCell: UITableViewCell {
    @IBOutlet weak var tcActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descContainerHeightConstraint: NSLayoutConstraint!
    var cellImage : UIImage?{
        didSet{
            if let cellImage = cellImage{
                updateCellImage(with: cellImage)
            }
        }
    }
    var venueListCellViewModel : VenueListCellViewModel? {
        didSet {
            nameLabel.text = venueListCellViewModel?.titleText
            addressLabel.text = venueListCellViewModel?.addressText
            updateCellImage(with: nil)
//            mainImageView?.sd_setImage(with: URL(string: "https://fastly.4sqi.net/img/general/500x500/379781209_XsgqUBnFSSYrFtvEGO6L8FF5Tong_YodCtmGtkT997k.jpg" ),
//                                       completed: nil)
        }
    }
    func updateCellImage(with image : UIImage?){
           
           if let image = image {
               mainImageView.image = image
               mainImageView.alpha = 0
               
               UIView.animate(withDuration: 0.2) {
                   self.mainImageView.alpha = 1
                   self.tcActivityIndicator.alpha = 0
               }
               
               tcActivityIndicator.stopAnimating()
               
           }else {
               mainImageView.image = nil
               mainImageView.alpha = 0
               tcActivityIndicator.alpha = 1
               tcActivityIndicator.startAnimating()
           }
       }
}
