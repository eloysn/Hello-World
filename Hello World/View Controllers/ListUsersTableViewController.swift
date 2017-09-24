//
//  ListUsersTableViewController.swift
//  Hello World
//
//  Created by eloysn on 23/9/17.
//  Copyright © 2017 eloysn. All rights reserved.
//

import UIKit

class ListUsersTableViewController: UITableViewController {
    
    
    let session = ManagerSession()
    var usersViewModel = UsersViewmodel(users: [UserViewModel]())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getUsers()
        updateUI()
        
        
    }
    func getUsers (){
        
        session.getAllUsers(resource: Session.getAllUser) { users in
            self.usersViewModel.users = users.map { UserViewModel(user: $0 )  }
            self.updateUI()
        }
    }
    func updateUI()  {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
}




//MARK: - DataSource
extension ListUsersTableViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return usersViewModel.numberOfUsers ?? 0
    }


    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        let user = usersViewModel.users[indexPath.row]
        cell.textLabel?.text = user.name
        cell.detailTextLabel?.text = user.birthDate ?? "N/A"
        
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            let user = usersViewModel[indexPath.row]
            let id = user.id
            session.removeUser(resource: Session.remove(id: id), completion: {
                print("completado")
                DispatchQueue.main.async {
                    self.usersViewModel.users.remove(at: indexPath.row)
                    self.tableView.deleteRows(at: [indexPath], with: .fade)
                    self.getUsers()
                    self.tableView.reloadData()
                    
                    
                }
            })
            
            
        }
//        }else if editingStyle == .insert {
//            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
//        }
    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    }
    
    
    
// MARK: - Navigation
extension ListUsersTableViewController {
    
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "edit" {
            guard let editVC = segue.destination as? EditViewController, let indexPath = tableView.indexPathForSelectedRow else {
                return
            }
            
             editVC.user = usersViewModel[indexPath.row]
             editVC.delegate = self
        }
        if segue.identifier == "add" {
            guard let editVC = segue.destination as? EditViewController else{
                return
            }
            editVC.delegate = self
        }
        
    }
}
//MARK: -Protocol UserCheck
extension ListUsersTableViewController: UserCheck {
    func createUser(user: User) {
        
        session.createUser(resource: Session.create(user: user)) { user in
            if let user = user {
                 self.getUsers()
            }else{
                
            }
            
        }
       
    }
    
    func updateUser(user: User) {
        
        session.updateUser(resource: Session.update(user: user)) { user in
            
            if let user = user {
                 self.getUsers()
            }else{
                
            }
        }
        
    }
    
    
}




