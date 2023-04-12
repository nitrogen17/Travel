//
//  ProfileViewController.swift
//  Travel
//
//  Created by Jonorsky Navarrete on 4/12/23.
//

import UIKit

class ProfileViewController: UIViewController {

    var name: String?
    var regionValue: String?
    var countryValue: String?
    var capitalCity: String?

    var selectedCountry: Country?

    @IBOutlet weak var profileTextView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()

        profileTextView.text = "Hi \(name ?? ""),\n\nYou are from,\n \(regionValue ?? ""),\n\(countryValue ?? "")\n\nYour Capital City is: \n\(capitalCity ?? "")"
    }
}
