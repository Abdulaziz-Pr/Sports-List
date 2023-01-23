//
//  ViewController.swift
//  SportsApp
//
//  Created by admin on 12/13/22.
//

import UIKit
import CoreData

class SportViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, PlayersSetDelegate {
    func setPlayersToSport(player: Player, indexPath: IndexPath?) {
        sportType[indexPath!.row].addToPlayers(player)
        do{
            try managedObjectContext.save()
        }catch{
            print(error)
        }
    }
    
    
//MARK: - Vars
    var sportType = [Sport]()
    var changeText: UITextField?
    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var imageSport: UIImage?
    var imagePicker = UIImagePickerController()
    
    var cellIndexPath: IndexPath?
   // let user = Sport(context: managedObjectContext)

    
//MARK: - Outlets
    
    @IBOutlet weak var sportTable: UITableView!
    

//MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        fetchAllData()
        
    }
    func fetchAllData(){
        //newSport(context: managedContext)
        
        do {
            sportType = try managedObjectContext.fetch(Sport.fetchRequest())
            //try managedContext.save()
        }
        catch{
            print(error)
        }
       
        
    }
    
    
// MARK: - Adding Sports
    @IBAction func addSport(_ sender: Any) {
        
        let alertController = UIAlertController(title: "New Sport", message: "Add New Sport", preferredStyle: .alert)
        alertController.addTextField { (textField: UITextField! ) -> Void in
        }
        
        let saveAction = UIAlertAction(title: "Save", style: .default, handler: { alert -> Void in
            let itemTextField = alertController.textFields![0] as UITextField
            
            if let name = itemTextField.text {
                if name != "" {
                    let newSport = Sport(context: self.managedObjectContext)
                    newSport.type = name
                    self.sportType.append(newSport)
                    do{
                        try self.managedObjectContext.save()
                        
                        self.sportTable.reloadData()

                    }catch{
                        print(error)
                    }
                }
            }
                       
            
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true)
    }
    
    
// MARK: - Table View Methods

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sportType.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = sportTable.dequeueReusableCell(withIdentifier: "sportCell", for: indexPath) as! sportTableViewCell
        cell.typesport.text = sportType[indexPath.row].type
        cell.imageCellDelegate = self
        cell.setCellInfo(sport: sportType[indexPath.row] ,indexPath: indexPath)
        return cell
    }
    
    
    // Transferring to the palyer view controller
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let playersDetalise_VC = self.storyboard!.instantiateViewController(withIdentifier:"PlayerViewController") as! PlayerViewController
        
        playersDetalise_VC.title = sportType[indexPath.row].type
        playersDetalise_VC.playersSport = sportType[indexPath.row]
        self.navigationController?.pushViewController( playersDetalise_VC, animated: true)
        playersDetalise_VC.playerDelegate = self
    }
    
    //MARK: - Editing Sports
    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        let alert = UIAlertController(title: "Edit sport", message: "Edit sport", preferredStyle: .alert)
                 let update = UIAlertAction(title: "Update", style: .default) {_ in
                     let updateName = self.changeText?.text
                     self.sportType[indexPath.row].type = updateName!
                     do{
                         try self.managedObjectContext.save()
                     }catch{
                         print(error)
                     }
                         self.sportTable.reloadData()
                 }
        
                 let cancel = UIAlertAction(title: "Cancel", style: .cancel) { action in
                     print("Canceled")
                 }
        
                 alert.addAction(update)
                 alert.addAction(cancel)
                 alert.addTextField { textField in
                     self.changeText = textField
                     self.changeText?.text = self.sportType[indexPath.row].type
                     self.changeText?.placeholder = "Enter your new task"
                 }
        
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: - Deleting Sports
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
       let deleteAction = UIContextualAction(style: .normal, title: "Delete") { [self]  (contextualAction, view, boolValue) in
          
           let item = sportType[indexPath.row]
           managedObjectContext.delete(item)
           self.sportType.remove(at: indexPath.row)
           do{
               try self.managedObjectContext.save()
           }catch{
               print(error)
           }

               sportTable.reloadData()
           }
        deleteAction.backgroundColor = .red
      let swipeActions = UISwipeActionsConfiguration(actions: [deleteAction])

      return swipeActions
  }
    



}
extension SportViewController: UIImagePickerControllerDelegate , UINavigationControllerDelegate, SetImageDelegate{
    func createSportImage(indexPath: IndexPath) {
        cellIndexPath = indexPath
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true)
        
        print("Image")
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        else {
            
            print("no image Found")
            return
        }
        
        imageSport = image
   //     self.sportCellImage = image
        dismiss(animated: true)
        setImage(indexPath: cellIndexPath)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
    
    func setImage(indexPath: IndexPath?){
        sportType[indexPath!.row].image = imageSport?.jpegData(compressionQuality: 1.0)
        do{
            try self.managedObjectContext.save()
        }catch{
            print(error)
        }

        self.sportTable.reloadData()
    }
    
    
}


protocol PlayersSetDelegate: AnyObject {
    
    func setPlayersToSport(player:Player,indexPath: IndexPath?)
    
}




