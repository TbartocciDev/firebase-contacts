//
//  ContactTableViewCell.swift
//  FirebaseCRUD
//
//  Created by Tommy Bartocci on 9/17/23.
//

import UIKit

class ContactTableViewCell: UITableViewCell {
    
    let imgScale: CGFloat = 0.7
    let fontSize: CGFloat = 20
    let fontColor: UIColor = .black
    
    let profilePicView: UIImageView = {
        let imgView = UIImageView()
        imgView.contentMode = .scaleAspectFit
//        imgView.backgroundColor = .blue
        imgView.image = UIImage(named: "male")
        imgView.tintColor = .systemPurple
        imgView.translatesAutoresizingMaskIntoConstraints = false
        return imgView
    }()
    
    let firstNameLbl: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()

    let lastNameLbl: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    func configure(with contact: Contact) {
        addProfilePic()
        addLabels()
        firstNameLbl.text = contact.firstName
        lastNameLbl.text = contact.lastName
        if (contact.imgData != nil) {
            profilePicView.image = UIImage(data: contact.imgData!)
        }
        profilePicView.layer.cornerRadius = 10
        profilePicView.clipsToBounds = true
    }

    
    private func addProfilePic() {
        self.addSubview(profilePicView)
        NSLayoutConstraint.activate([
            profilePicView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10),
            profilePicView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            profilePicView.heightAnchor.constraint(equalToConstant: self.frame.height * imgScale),
            profilePicView.widthAnchor.constraint(equalTo: profilePicView.heightAnchor, multiplier: 1)
        ])
    }
    private func addLabels() {
        self.addSubview(firstNameLbl)
        self.addSubview(lastNameLbl)
        firstNameLbl.font = UIFont(name: "Avenir Next", size: fontSize)
        firstNameLbl.textColor = fontColor
        lastNameLbl.font = UIFont(name: "Avenir Next Demi Bold", size: fontSize)
        lastNameLbl.textColor = fontColor
        NSLayoutConstraint.activate([
            firstNameLbl.leftAnchor.constraint(equalTo: profilePicView.rightAnchor, constant: 10),
            firstNameLbl.bottomAnchor.constraint(equalTo: profilePicView.bottomAnchor),
            lastNameLbl.leftAnchor.constraint(equalTo: firstNameLbl.rightAnchor, constant: 5),
            lastNameLbl.bottomAnchor.constraint(equalTo: profilePicView.bottomAnchor),
        ])
    }
}
