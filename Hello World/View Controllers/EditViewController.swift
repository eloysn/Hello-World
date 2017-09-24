//
//  EditViewController.swift
//  Hello World
//
//  Created by eloysn on 23/9/17.
//  Copyright © 2017 eloysn. All rights reserved.
//

import UIKit


protocol UserCheck  {
    
    func createUser (user: User)
    func updateUser (user: User)

}



class EditViewController: UIViewController {

    var user: UserViewModel! = nil
    var isEdit: Bool = false
    var delegate: UserCheck?
    
    @IBOutlet weak var birthDateText: UITextField!
    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var saveUser: UIButton!
    @IBOutlet weak var cancelUser: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        
    }
    //MARK: -Actions
    @IBAction func bitrhdateTextEditing(_ sender: UITextField) {
        let datePiker = UIDatePicker()
        datePiker.datePickerMode = .date
        sender.inputView = datePiker
        datePiker.addTarget(self, action: #selector(EditViewController.datePikerValueChange(_:)), for: .valueChanged)
        
        
    }
    @objc func datePikerValueChange( _ sender: UIDatePicker)  {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        birthDateText.text = formatter.string(from: sender.date)
    }
    
    
    @IBAction func saveUserButton(_ sender: UIButton) {
        
        guard let name = nameText.text, let birthDate = birthDateText.text, name.characters.count >= 1, birthDate.characters.count >= 1  else {
            let alert = UIAlertController(title: "Campos Vacios", message: "Rellena los campos", preferredStyle: .alert)
            let acction = UIAlertAction(title: "OK", style: .cancel, handler: { _ in })
            alert.addAction(acction)
            present(alert, animated: true, completion: {
                
            })
            return
        }
        
        
        if isEdit {
            let u = User(id: user.id, name: name, birthDate: birthDate)
            delegate?.updateUser(user: u)
            
        }else{
            let u = User(name: name, birthDate: birthDate)
            delegate?.createUser(user: u)
            
        }
        navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func cancelUserButton(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    
    func configure()  {
        guard let user = user  else {
            isEdit = false
            return
        }
        isEdit = true
        bindUI(user: user)
        
    }
    
    func bindUI(user: UserViewModel)  {
        
        nameText.text = user.name
        birthDateText.text = user.birthDate
        
    }
    
    
    

    

}
