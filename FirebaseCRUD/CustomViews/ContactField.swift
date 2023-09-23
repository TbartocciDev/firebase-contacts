//
//  ContactField.swift
//  FirebaseCRUD
//
//  Created by Tommy Bartocci on 9/18/23.
//

import UIKit

class ContactField: UIView, UITextFieldDelegate {
    
    let fieldNameLbl: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont(name: "Avenir Next", size: 15)
        lbl.text = "Phone Number"
        return lbl
    }()
    
    let txtField: UITextField = {
        let txt = UITextField()
        return txt
    }()
    
    func setupField() {
        self.backgroundColor = .systemGray5
        self.layer.cornerRadius = 10
        addNameLbl()
        addTextField()
    }
    
    
    private func addNameLbl(){
        self.addSubview(fieldNameLbl)
        fieldNameLbl.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            fieldNameLbl.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            fieldNameLbl.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10),
        ])
    }
    
    private func addTextField() {
        let bottomLine = UIView()
        self.txtField.addSubview(bottomLine)
        bottomLine.backgroundColor = UIColor(named: "Main") ?? .red
        bottomLine.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(txtField)
        txtField.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            txtField.topAnchor.constraint(equalTo: fieldNameLbl.bottomAnchor, constant: 10),
            txtField.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10),
            txtField.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10),
            txtField.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10),
            
            bottomLine.topAnchor.constraint(equalTo: self.txtField.bottomAnchor, constant: 3),
            bottomLine.leftAnchor.constraint(equalTo: self.txtField.leftAnchor),
            bottomLine.rightAnchor.constraint(equalTo: self.txtField.rightAnchor),
            bottomLine.heightAnchor.constraint(equalToConstant: 2)
        ])
    }
    
    
}
