//
//  PlayerViewController.swift
//  SportsApp
//
//  Created by admin on 12/13/22.
//

import UIKit
import CoreData

class PlayerViewController: UIViewController, UITableViewDelegate,UITableViewDataSource {
    
//MARK: - Outlets
    @IBOutlet weak var playerTable: UITableView!
    
//MARK: - Vars
    var changeTextName: UITextField?
    var changeTextAge: UITextField?
    var changeTextHeight: UITextField?
    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    var playersSport:Sport?
    var namePl = String()
    var agePl = String()
    var heightPl = String()
    weak var playerDelegate: PlayersSetDelegate?
    var playersName = [Player]()
    
    
//MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
     playersToSport()
    }

//MARK: - Actions
    // add Player
    @IBAction func addPlayer(_ sender: Any) {
        let alertController = UIAlertController(title: "New Player", message: "Add New Player", preferredStyle: .alert)
        alertController.addTextField { (textField: UITextField! ) -> Void in
            textField.placeholder = "Enter Name"
        }
        alertController.addTextField { (textField: UITextField! ) -> Void in
            textField.placeholder = "Enter Age"
        }
        alertController.addTextField { (textField: UITextField! ) -> Void in
            textField.placeholder = "Enter Height"
        }
        
        let saveAction = UIAlertAction(title: "Save", style: .default, handler: { alert -> Void in
            let itemTextField = alertController.textFields![0] as UITextField
            let itemTextField2 = alertController.textFields![1] as UITextField
            let itemTextField3 = alertController.textFields![2] as UITextField
            
            guard let name = itemTextField.text else{return}
            let age = Int32(itemTextField2.text!)
            let height = Double(itemTextField3.text!)
            let result = "\(name) - Age:\(age!), Height:\(height!)"
           // self.namePl = name!
          //  self.agePl = age!
            //self.heightPl = height!
             if name != "" && age != nil && height != nil{
                 let newPlayer = Player(context: self.managedObjectContext)
                 newPlayer.name = name
                 newPlayer.age = age!
                 newPlayer.hight = height!
                    self.playersName.append(newPlayer)
            }
            do{
                try self.managedObjectContext.save()
            }catch{
                print(error)
            }

            
            self.playerTable.reloadData()
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true)
    }
    private func playersToSport(){
        guard let play = playersSport?.players?.array as? [Player] else {return}
        playersName = play
        self.navigationItem.title = playersSport?.type
        
        
    }
    
    
//MARK: - Table View Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return playersName.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = playerTable.dequeueReusableCell(withIdentifier: "playerCell", for: indexPath) as! playerTableViewCell
        let player = playersName[indexPath.row]
        let result = ("\(player.name ?? "") age:\(player.age) Height:\(player.hight)")
        cell.player.text = result
        playerDelegate?.setPlayersToSport(player: player, indexPath: indexPath)
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
//        let alert = UIAlertController(title: "Edit Player", message: "Edit Player", preferredStyle: .alert)
//                let update = UIAlertAction(title: "Update", style: .default) {_ in
        let alertController = UIAlertController(title: "Edit Player", message: "Edit Player", preferredStyle: .alert)
        alertController.addTextField { (textField: UITextField! ) -> Void in
            textField.text = self.playersName[indexPath.row].name        }
        alertController.addTextField { (textField: UITextField! ) -> Void in
            textField.text = ("\(self.playersName[indexPath.row].age)")        }
        alertController.addTextField { (textField: UITextField! ) -> Void in
            textField.text = ("\(self.playersName[indexPath.row].hight)")
        }
        let update = UIAlertAction(title: "Update", style: .default) {_ in
//            let newPlayer = Player(context: self.managedObjectContext)
//            self.changeTextName?.text = self.playersName[indexPath.row].name
//            self.changeTextAge?.text = ("\(self.playersName[indexPath.row].age)")
//            self.changeTextHeight?.text = ("\(self.playersName[indexPath.row].hight)")
            
            
            guard let age = Int32((alertController.textFields?[1].text)!) else{return}
            guard let height = Double((alertController.textFields?[2].text)!) else{return}
            self.playersName[indexPath.row].name = alertController.textFields?[0].text
            self.playersName[indexPath.row].age = age
            self.playersName[indexPath.row].hight = height

            do{
                try self.managedObjectContext.save()
            }catch{
                print(error)
            }
            
            self.playerTable.reloadData()
            
        }
                 let cancel = UIAlertAction(title: "Cancel", style: .cancel) { action in
                     print("Canceled")
                 }
        
                 alertController.addAction(update)
                  alertController.addAction(cancel)

                 
        
        
        present(alertController, animated: true, completion: nil)
    }


}
