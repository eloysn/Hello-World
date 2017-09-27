//
//  ListUsersTableViewController.swift
//  Hello World
//
//  Created by eloysn on 23/9/17.
//  Copyright © 2017 eloysn. All rights reserved.
//

import UIKit
import RxSwift

class ListUsersTableViewController: UITableViewController {
    
    
    let session = ManagerSession()
    var usersViewModel = UsersViewmodel(users: [UserViewModel]())
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getUsers()
       
    }
    func getUsers (){
        
        session.getAllUsers().subscribe(onNext: { usersOpti in
            let arrUser = usersOpti.flatMap{return $0 }
            self.usersViewModel.users = arrUser.map({ user in
                return UserViewModel(user: user)
            })
            self.usersViewModel.users.sort(by: {  return ($0.name < $1.name) })
            self.updateUI()
            
        }, onError: { err in
            
        }, onCompleted: {
            
        }) {
            
        }.addDisposableTo(disposeBag)
       
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

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            let user = usersViewModel[indexPath.row]
            let id = user.id
            session.removeUser(id: id, completed: {
                DispatchQueue.main.async {
                    self.usersViewModel.users.remove(at: indexPath.row)
                    self.tableView.deleteRows(at: [indexPath], with: .fade)
                    self.getUsers()
                    self.showMessage(title: "Usuario eliminado", message: "")
                    self.tableView.reloadData()
                    
                }
            })
            
        }
        
    }
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
        session.createUser(user: user).subscribe(onNext: { user in
            if let user = user {
                self.showMessage(title: "Usuario: \(user.name.description) ", message: "Creado correctamente")
                self.getUsers()
            }else{
                self.showMessage(title: "El usuario ", message: "No se pudo crear")
            }
        }, onError: { err in
            self.showMessage(title: "El usuario ", message: "No se pudo crear")
        }, onCompleted: {
            
        }) {
            
        }.addDisposableTo(disposeBag)
      
    }
    
    func updateUser(user: User) {
        
        session.updateUser(user: user).subscribe(onNext: { user in
            if let user = user {
                self.showMessage(title: "Usuario: \(user.name) ", message: "Actualizado correctamente")
                self.getUsers()
            }else{
                self.showMessage(title: "El usuario ", message: "No se pudo crear")
            }
        }, onError: { err in
            self.showMessage(title: "El usuario ", message: "No se pudo crear")
        }, onCompleted: {
            
        }) {
            
        }.addDisposableTo(disposeBag)
        
    }
    
    
}




