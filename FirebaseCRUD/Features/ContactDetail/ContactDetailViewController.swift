//
//  ContactDetailViewController.swift
//  FirebaseCRUD
//
//  Created by Tommy Bartocci on 9/18/23.
//

import UIKit

class ContactDetailViewController: UIViewController {
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isScrollEnabled = true
        return scrollView
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        return view
    }()
    
    private let saveBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("Save", for: .normal)
        btn.backgroundColor = UIColor(named: "Main") ?? .red
        btn.layer.cornerRadius = 5
        return btn
    }()
    
    private let profilePic: UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFit
        return img
    }()
    
    private let editBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(systemName: "pencil"), for: .normal)
        return btn
    }()
    
    private let nameLbl: UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 0
        lbl.font = UIFont(name: "Avenir Next Bold", size: 35)
        lbl.minimumScaleFactor = 0.3
        lbl.textAlignment = .center
        return lbl
    }()
    
    private let actionsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 20
        return stackView
    }()
    
    let firstNameField: ContactField = {
        let txt = ContactField()
        txt.txtField.placeholder = "enter first name..."
        txt.txtField.keyboardType = .default
        txt.fieldNameLbl.text = "First Name:"
        return txt
    }()
    
    let lastNameField: ContactField = {
        let txt = ContactField()
        txt.txtField.placeholder = "enter last name..."
        txt.txtField.keyboardType = .default
        txt.fieldNameLbl.text = "Last Name:"
        return txt
    }()
    
    let phoneNumField: ContactField = {
        let txt = ContactField()
        txt.txtField.placeholder = "enter a phone number..."
        txt.fieldNameLbl.text = "Phone Number:"
        txt.txtField.keyboardType = .phonePad
        return txt
    }()
    
    let emailField: ContactField = {
        let txt = ContactField()
        txt.txtField.placeholder = "enter an email..."
        txt.txtField.keyboardType = .emailAddress
        txt.fieldNameLbl.text = "Email:"
        return txt
    }()
    
    let deleteBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("Delete Contact", for: .normal)
        btn.backgroundColor = .red
        btn.layer.cornerRadius = 5
        return btn
    }()
    
    var currentContact: Contact?
    
    var firstNameStr: String = ""
    var lastNameStr: String = ""
    var phoneNumStr: String = ""
    var emailStr: String = ""
    var img: Data = Data()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        initializeStrings()
    }
    
    private func setupView() {
        addScrollView()
        addProfilePic()
        addEditBtn()
        addNameLbl()
        addStackView()
        addTextFields()
        addSaveBtn()
        addDeleteBtn()
        if (currentContact == nil) {
            actionsStackView.heightAnchor.constraint(equalToConstant: 0).isActive = true
            saveBtn.setTitle("Create", for: .normal)
            deleteBtn.heightAnchor.constraint(equalToConstant: 0).isActive = true
        }
        guard let contact = currentContact else { return }
        updateUI(with: contact)
    }
    
    private func initializeStrings() {
        guard let contact = currentContact else { return }
        firstNameStr = contact.firstName
        lastNameStr = contact.lastName
        phoneNumStr = contact.phoneNum
        emailStr = contact.email
    }
    
    private func updateUI(with contact: Contact) {
        nameLbl.text = "\(contact.firstName) \(contact.lastName)"
        
        firstNameField.txtField.delegate = self
        lastNameField.txtField.delegate = self
        phoneNumField.txtField.delegate = self
        emailField.txtField.delegate = self
        
        firstNameField.txtField.text = contact.firstName
        lastNameField.txtField.text = contact.lastName
        phoneNumField.txtField.text = contact.phoneNum
        emailField.txtField.text = contact.email
        
        if ((contact.imgData) != nil) {
            profilePic.image = UIImage(data: contact.imgData!)
        } else {
            profilePic.image = UIImage(named: "male")
        }
    }
    
    private func addTextFields() {
        addFirstNameField()
        addLastNameField()
        addPhoneNumField()
        addEmailField()
    }
    
    private func addScrollView() {
        self.view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        scrollView.delegate = self
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        let contentHAnchor = contentView.heightAnchor.constraint(equalTo: scrollView.heightAnchor)
        contentHAnchor.isActive = true
        contentHAnchor.priority = UILayoutPriority(50)
          
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            scrollView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            scrollView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: self.scrollView.topAnchor),
            contentView.leftAnchor.constraint(equalTo: self.scrollView.leftAnchor),
            contentView.rightAnchor.constraint(equalTo: self.scrollView.rightAnchor),
            contentView.bottomAnchor.constraint(equalTo: self.scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: self.scrollView.widthAnchor),
        ])
    }
    
    private func addStackView() {
        let btnTint: UIColor = .white
        let btnColor: UIColor = UIColor(named: "Main") ?? .red
        
        let callBtn: UIButton = {
            let btn = UIButton()
            btn.tintColor = btnTint
            btn.setImage(UIImage(systemName: "phone.fill"), for: .normal)
            btn.backgroundColor = btnColor
            btn.layer.cornerRadius = 5
            btn.addTarget(self, action: #selector(call), for: .touchUpInside)
            return btn
        }()
        
        let textBtn: UIButton = {
            let btn = UIButton()
            btn.tintColor = btnTint
            btn.setImage(UIImage(systemName: "bubble.left.fill"), for: .normal)
            btn.backgroundColor = btnColor
            btn.layer.cornerRadius = 5
            btn.addTarget(self, action: #selector(message), for: .touchUpInside)
            return btn
        }()
        
        let emailBtn: UIButton = {
            let btn = UIButton()
            btn.tintColor = btnTint
            btn.setImage(UIImage(systemName: "envelope.fill"), for: .normal)
            btn.backgroundColor = btnColor
            btn.layer.cornerRadius = 5
            btn.addTarget(self, action: #selector(email), for: .touchUpInside)
            return btn
        }()
        
        self.contentView.addSubview(actionsStackView)
        actionsStackView.translatesAutoresizingMaskIntoConstraints = false
        actionsStackView.addArrangedSubview(callBtn)
        actionsStackView.addArrangedSubview(textBtn)
        actionsStackView.addArrangedSubview(emailBtn)
        
        NSLayoutConstraint.activate([
            actionsStackView.topAnchor.constraint(equalTo: self.nameLbl.bottomAnchor, constant: 10),
            actionsStackView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            actionsStackView.heightAnchor.constraint(equalToConstant: self.view.frame.height * 0.05),
            actionsStackView.widthAnchor.constraint(equalToConstant: self.view.frame.width * 0.8),
        ])
    }
    
    private func addProfilePic() {
        self.contentView.addSubview(profilePic)
        profilePic.translatesAutoresizingMaskIntoConstraints = false
        profilePic.layer.cornerRadius = 65
        profilePic.clipsToBounds = true
        NSLayoutConstraint.activate([
            profilePic.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 20),
            profilePic.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0),
            profilePic.heightAnchor.constraint(equalToConstant: self.view.frame.height * 0.15),
            profilePic.widthAnchor.constraint(equalTo: profilePic.heightAnchor, multiplier: 1),
        ])
        profilePic.layer.borderWidth = 2
        
    }
    
    private func addEditBtn() {
        self.contentView.addSubview(editBtn)
        editBtn.translatesAutoresizingMaskIntoConstraints = false
        editBtn.tintColor = .black
        editBtn.addTarget(self, action: #selector(editPhoto), for: .touchUpInside)
        NSLayoutConstraint.activate([
            editBtn.leftAnchor.constraint(equalTo: profilePic.rightAnchor, constant: 10),
            editBtn.centerYAnchor.constraint(equalTo: profilePic.centerYAnchor, constant: 0),
        ])
    }
    
    private func addNameLbl() {
        self.contentView.addSubview(nameLbl)
        nameLbl.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            nameLbl.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            nameLbl.topAnchor.constraint(equalTo: profilePic.bottomAnchor, constant: 10),
            nameLbl.widthAnchor.constraint(equalToConstant: self.view.frame.width * 0.6),
        ])
    }
    
    private func addFirstNameField() {
        self.contentView.addSubview(firstNameField)
        firstNameField.translatesAutoresizingMaskIntoConstraints = false
        firstNameField.setupField()
        firstNameField.txtField.delegate = self
        let padding: CGFloat = 20
        
        NSLayoutConstraint.activate([
            firstNameField.topAnchor.constraint(equalTo: actionsStackView.bottomAnchor, constant: padding),
            firstNameField.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: padding),
            firstNameField.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -padding),
            firstNameField.heightAnchor.constraint(equalToConstant: 70),
        ])
    }
    
    private func addLastNameField() {
        self.contentView.addSubview(lastNameField)
        lastNameField.translatesAutoresizingMaskIntoConstraints = false
        lastNameField.setupField()
        lastNameField.txtField.delegate = self
        let padding: CGFloat = 20
        
        NSLayoutConstraint.activate([
            lastNameField.topAnchor.constraint(equalTo: firstNameField.bottomAnchor, constant: padding),
            lastNameField.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: padding),
            lastNameField.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -padding),
            lastNameField.heightAnchor.constraint(equalToConstant: 70),
        ])
    }
    
    private func addPhoneNumField() {
        self.contentView.addSubview(phoneNumField)
        phoneNumField.translatesAutoresizingMaskIntoConstraints = false
        phoneNumField.setupField()
        phoneNumField.txtField.delegate = self
        let padding: CGFloat = 20
        
        NSLayoutConstraint.activate([
            phoneNumField.topAnchor.constraint(equalTo: lastNameField.bottomAnchor, constant: padding),
            phoneNumField.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: padding),
            phoneNumField.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -padding),
            phoneNumField.heightAnchor.constraint(equalToConstant: 70),
        ])
    }
    
    private func addEmailField() {
        self.contentView.addSubview(emailField)
        emailField.translatesAutoresizingMaskIntoConstraints = false
        emailField.setupField()
        emailField.txtField.delegate = self
        let padding: CGFloat = 20
        
        NSLayoutConstraint.activate([
            emailField.topAnchor.constraint(equalTo: self.phoneNumField.bottomAnchor, constant: padding),
            emailField.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: padding),
            emailField.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -padding),
            emailField.heightAnchor.constraint(equalToConstant: 70)
        ])
    }
    
    private func addSaveBtn() {
        self.contentView.addSubview(saveBtn)
        saveBtn.translatesAutoresizingMaskIntoConstraints = false
        saveBtn.disable()
        
        if (currentContact != nil) {
            saveBtn.addTarget(self, action: #selector(updateContact), for: .touchUpInside)
        } else {
            saveBtn.addTarget(self, action: #selector(createContact), for: .touchUpInside)
        }
        
        NSLayoutConstraint.activate([
            saveBtn.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 10),
            saveBtn.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -10),
            saveBtn.heightAnchor.constraint(equalToConstant: 40),
            saveBtn.widthAnchor.constraint(equalToConstant: 75)
        ])
    }
    
    private func addDeleteBtn() {
        self.contentView.addSubview(deleteBtn)
        deleteBtn.translatesAutoresizingMaskIntoConstraints = false
        deleteBtn.addTarget(self, action: #selector(deleteContact), for: .touchUpInside)
        deleteBtn.isEnabled = true
        
        NSLayoutConstraint.activate([
            deleteBtn.topAnchor.constraint(equalTo: self.emailField.bottomAnchor, constant: 20),
            deleteBtn.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor),
            deleteBtn.widthAnchor.constraint(equalToConstant: 200),
            deleteBtn.heightAnchor.constraint(equalToConstant: 50),
            deleteBtn.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: 20)
        ])
    }
    
    @objc private func updateContact() {
        guard var updatedContact = currentContact else { return }
        guard let fName = firstNameField.txtField.text else { return }
        guard let lName = lastNameField.txtField.text else { return }
        guard let phoneN = phoneNumField.txtField.text else { return }
        guard let emailAddress = emailField.txtField.text else { return }
        
        updatedContact.firstName = fName
        updatedContact.lastName = lName
        updatedContact.phoneNum = phoneN
        updatedContact.email = emailAddress
        if !img.isEmpty {
            updatedContact.imgData = img
        }
        FirebaseService.shared.update(for: updatedContact, in: .contacts)
        self.view.endEditing(true)
        self.saveBtn.disable()
        self.updateUI(with: updatedContact)
    }
    
    @objc private func createContact() {
        guard let fName = firstNameField.txtField.text else { return }
        guard let lName = lastNameField.txtField.text else { return }
        guard let phoneN = phoneNumField.txtField.text else { return }
        guard let emailAddress = emailField.txtField.text else { return }
        
        var contact = Contact(firstName: fName, lastName: lName, phoneNum: phoneN, email: emailAddress)
        
        if !img.isEmpty {
            contact.imgData = img
        }
        
        FirebaseService.shared.create(for: contact, in: .contacts)
        self.view.endEditing(true)
        self.saveBtn.disable()
        self.dismiss(animated: true)
    }
    
    @objc private func deleteContact() {
        guard let contact = currentContact else { return }
        
        FirebaseService.shared.delete(contact, in: .contacts)
        self.view.endEditing(true)
        self.saveBtn.disable()
        self.dismiss(animated: true)
    }
    
    @objc private func editPhoto() {
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
    }

    @objc private func call() {
        guard let contact = currentContact else { return }
        if let url = URL(string: "tel://\(contact.phoneNum)") {
            UIApplication.shared.open(url)
        }
    }
    
    @objc private func message() {
        guard let contact = currentContact else { return }
        if let url = URL(string: "sms:+\(contact.phoneNum)") {
            UIApplication.shared.open(url)
        }
    }
    
    @objc private func email() {
        guard let contact = currentContact else { return }
        if let url = URL(string: "mailto:\(contact.email)") {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    private func resignFirstResponderKeyFields() {
        self.phoneNumField.resignFirstResponder()
        self.emailField.resignFirstResponder()
    }
  
}

extension ContactDetailViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIScrollViewDelegate, UITextFieldDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerEditedImage")] as? UIImage {
            self.profilePic.image = image
            img = image.jpegData(compressionQuality: 0.5)!
            saveBtn.enable()
        }
        picker.dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        saveBtn.enable()
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
}
