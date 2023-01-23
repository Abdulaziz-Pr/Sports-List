//
//  sportTableViewCell.swift
//  SportsApp
//
//  Created by admin on 12/13/22.
//

import UIKit
import CoreData

class sportTableViewCell: UITableViewCell{
    
    
 //MARK: - Outlets
    @IBOutlet weak var typesport: UILabel!
    @IBOutlet weak var image1: UIImageView!
    @IBOutlet weak var addimage: UIButton!
    

    var cellIndexPath: IndexPath?
    weak var imageCellDelegate: SetImageDelegate?
    
//MARK: - Actions
    @IBAction func addImage(_ sender: UIButton) {
       
    print("hi")
        guard let indx = cellIndexPath else {return }
       imageCellDelegate?.createSportImage(indexPath: indx)
        
    }
    
    
    func setCellInfo(sport:Sport ,indexPath: IndexPath) {
         
      print("func")
        
         cellIndexPath = indexPath
        typesport.text = sport.type

        if sport.image == nil {
            image1.isHidden = true
            addimage.isHidden = false
        }
        else {
            guard let imageData = sport.image else {return}

            image1.image = UIImage(data: imageData)
            image1.isHidden = false
            addimage.isHidden = true
        }
        
    }

        }

protocol SetImageDelegate: AnyObject {
    func createSportImage( indexPath: IndexPath)
    
}
    
    
    
    
