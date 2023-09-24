//
//  ContactsViewController.swift
//  FirebaseCRUD
//
//  Created by Tommy Bartocci on 9/17/23.
//

import UIKit

class ContactsViewController: UIViewController {
    
    let navBar: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "Main") ?? .red
        return view
    }()
    
    let navTitle: UILabel = {
        let lbl = UILabel()
        lbl.textColor = UIColor(named: "FontColor") ?? .red
        return lbl
    }()
    
    let addBtn: UIButton = {
        let btn = UIButton()
        btn.tintColor = UIColor(named: "FontColor") ?? .red
        return btn
    }()
    
    let searchBar: UITextField = {
        let txt = CustomSearchBar()
        txt.backgroundColor = UIColor(named: "FontColor") ?? .red
        txt.attributedPlaceholder = NSAttributedString(
            string: "search contacts...",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray3])
        return txt
    }()
    
    let contactsTableView: UITableView = {
        let tableView = UITableView()
        return tableView
    }()
    
    var contacts: [Contact] = []
    var filteredContacts: [Contact] = []
    var selectedContact: Contact!
    
    var actionType: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        configureTableView()
    }
    
    private func configureTableView() {
        setupTableView()
        FirebaseService.shared.read(from: .contacts, returning: Contact.self) { contacts in
            self.contacts = contacts
            self.filteredContacts = contacts
            self.filteredContacts.sort { $0.lastName < $1.lastName }
            self.contactsTableView.reloadData()
        }
    }
    
    
    // actions
    @objc func addContactTapped() {
        actionType = "add"
        performSegue(withIdentifier: "contactDetail", sender: self)
    }
    
    // ui section
    private func setupNavBar() {
        self.view.addSubview(navBar)
        navBar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            navBar.topAnchor.constraint(equalTo: self.view.topAnchor),
            navBar.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            navBar.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            navBar.heightAnchor.constraint(equalToConstant: self.view.frame.height * 0.2)
        ])
        addSearchBar()
        addNavBarTitle(title: "Contacts")
        addNavBarBtn()
    }
    
    private func addSearchBar() {
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.font = UIFont(name: "Avenir Next", size: 20)
        searchBar.layer.cornerRadius = 5
        searchBar.delegate = self
        searchBar.addTarget(self, action: #selector(searchValueChanged), for: .editingChanged)
        navBar.addSubview(searchBar)
        NSLayoutConstraint.activate([
            searchBar.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 10),
            searchBar.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -10),
            searchBar.bottomAnchor.constraint(equalTo: navBar.bottomAnchor, constant: -15)
        ])
    }

    private func addNavBarTitle(title: String) {
        navTitle.translatesAutoresizingMaskIntoConstraints = false
        navTitle.text = title
        navTitle.font = UIFont(name: "Avenir Next Bold", size: 50)
        navBar.addSubview(navTitle)
        NSLayoutConstraint.activate([
            navTitle.leftAnchor.constraint(equalTo: navBar.leftAnchor, constant: 10),
            navTitle.bottomAnchor.constraint(equalTo: searchBar.topAnchor, constant: 0)
        ])
    }
    
    private func addNavBarBtn(){
        addBtn.translatesAutoresizingMaskIntoConstraints = false
        addBtn.setImage(UIImage(systemName: "plus"), for: .normal)
        addBtn.addTarget(self, action: #selector(addContactTapped), for: .touchUpInside)
        navBar.addSubview(addBtn)
        NSLayoutConstraint.activate([
            addBtn.rightAnchor.constraint(equalTo: navBar.rightAnchor, constant: -20),
            addBtn.centerYAnchor.constraint(equalTo: navTitle.centerYAnchor),
            addBtn.heightAnchor.constraint(equalToConstant: 60),
            addBtn.widthAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    private func setupTableView(){
        contactsTableView.delegate = self
        contactsTableView.dataSource = self
        contactsTableView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(contactsTableView)
        NSLayoutConstraint.activate([
            contactsTableView.topAnchor.constraint(equalTo: navBar.bottomAnchor),
            contactsTableView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            contactsTableView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            contactsTableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! ContactDetailViewController
        if actionType == "update" {
            destination.currentContact = selectedContact
        } else {
            destination.currentContact = nil
        }
    }
    
    @objc func searchValueChanged() {
        if (searchBar.text == "") {
            print("match")
            filteredContacts = contacts
            
        } else {
            guard let text = searchBar.text?.lowercased() else { return }
            print(text)
            filteredContacts = contacts.filter { $0.firstName.lowercased().contains(text) || $0.lastName.lowercased().contains(text)}
        }
        filteredContacts.sort { $0.lastName < $1.lastName }
        contactsTableView.reloadData()
    }
    
}


extension ContactsViewController: UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        filteredContacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let contact = filteredContacts[indexPath.row]
        let cell = ContactTableViewCell()
        cell.configure(with: contact)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedContact = filteredContacts[indexPath.row]
        actionType = "update"
        performSegue(withIdentifier: "contactDetail", sender: self)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        tableView.frame.height / 10
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
}
