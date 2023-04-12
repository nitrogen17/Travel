//
//  ViewController.swift
//  Travel
//
//  Created by Jonorsky Navarrete on 4/12/23.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var regionTextField: UITextField!
    @IBOutlet weak var countryTextField: UITextField!
    @IBOutlet weak var nameErrorLabel: UILabel!

    @IBOutlet weak var regionDropdown: UIPickerView!

    var countries: [Country] = []

    var selectedCountry: Country?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTextfield()
        setupCountriesDropdown()

        fetchCountries()
    }


    @IBAction func didTapSubmitButton(_ sender: UIButton) {
        performSegue(withIdentifier: "goToProfileViewController", sender: nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToProfileViewController" {
            if let destinationVC = segue.destination as? ProfileViewController {
                destinationVC.name = nameTextField.text
                destinationVC.regionValue  = selectedCountry?.region ?? ""
                destinationVC.countryValue = ""
                destinationVC.capitalCity = ""

                destinationVC.selectedCountry = selectedCountry
            }
        }
    }

}

extension LoginViewController {
    private func setupCountriesDropdown() {
        regionDropdown.delegate = self
        regionDropdown.dataSource = self
    }

    private func setupTextfield() {
        nameTextField.delegate = self
    }
}

// MARK: - UITextFieldDelegate

extension LoginViewController: UITextFieldDelegate {

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        let allowedCharacters = CharacterSet.letters
        let characterSet = CharacterSet(charactersIn: string)
        if allowedCharacters.isSuperset(of: characterSet) == false {
            nameErrorLabel.text = "Cannot Contain Alphanumeric Characters"
            nameErrorLabel.isHidden = false
            return false
        } else {
            nameErrorLabel.isHidden = true
            return true
        }

    }
}

extension LoginViewController {

    func fetchCountries() {

        let request = URLRequest(url: URL(string: "https://restcountries.com/v3.1/all")!)

        let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            if error != nil { return }

            if let data = data {
                do {
                    let countries = try JSONDecoder().decode([Country].self, from: data)

                    // Display unique region values & alphabetical order
                    for country in countries {
                        // need high order function .map
                    }

                    DispatchQueue.main.async { [weak self] in
                        self?.countries = countries
                        self?.regionDropdown.reloadAllComponents()
                    }
                } catch {

                }
            }
        }

        task.resume()
    }
}

// MARK: - UIPickerViewDataSource

extension LoginViewController: UIPickerViewDataSource {

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return countries[row].region
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        countryTextField.text = countries[row].region
        selectedCountry = countries[row]
    }
}

// MARK: - UIPickerViewDelegate

extension LoginViewController: UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return countries.count
    }
}
