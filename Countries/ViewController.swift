//
//  ViewController.swift
//  Countries
//
//  Created by Apple on 29/11/18.
//  Copyright © 2018 Dony. All rights reserved.
//

import UIKit
import Reachability
import RealmSwift

class ViewController: UIViewController {

    @IBOutlet weak var countrySearchBar: UISearchBar!
    @IBOutlet weak var countryDetailTableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var countryObjects = [CountryDataModel]()
    let realm = try! Realm()
    var countryArray: Results<CountryData>!
    let reachability = Reachability()!
    var isInternetAvailable = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if !ApiHelper.isInternetAvailable() {
            isInternetAvailable = false
            countryArray = realm.objects(CountryData.self)
            countryDetailTableView.reloadData()
        } else {
            // Hiding both tableview and Indicatorview
            countryDetailTableView.isHidden = true
            activityIndicator.isHidden = true
            
            //Opening Searchbar Keyboard
            countrySearchBar.becomeFirstResponder()
        }
        // Do any additional setup after loading the view, typically from a nib.
    }


    //MARK: Getting Data from API
    func getDataFromApi(_ searchString: String) {
        self.view.isUserInteractionEnabled = false
        countryDetailTableView.isHidden = true
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        let apiString = "https://restcountries.eu/rest/v2/name/"+searchString
        ApiHelper.requestGetApi(apiString: apiString, success: { [weak self] (response) in
            guard let strongSelf = self else { return }
            strongSelf.countryObjects.removeAll()
            if let countries = response {
                strongSelf.countryObjects = countries
            }
            DispatchQueue.main.async {
                strongSelf.activityIndicator.stopAnimating()
                strongSelf.activityIndicator.isHidden = true
                strongSelf.countryDetailTableView.isHidden = false
                strongSelf.countryDetailTableView.reloadData()
                if strongSelf.countryObjects.count > 0 {
                    strongSelf.countryDetailTableView.scrollToRow(at: IndexPath.init(row: 0, section: 0), at: .top, animated: false)
                }
                strongSelf.view.isUserInteractionEnabled = true
            }
        }) { (error) in
            DispatchQueue.main.async {
                self.view.isUserInteractionEnabled = true
                self.activityIndicator.stopAnimating()
                self.activityIndicator.isHidden = true
                self.showAlert(title: "Alert!", message: error)
            }
        }
    }
    
}

//MARK: SerachBar Delegates
extension ViewController: UISearchBarDelegate {
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.text = nil
        searchBar.showsCancelButton = true
        return true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if isInternetAvailable == false {
            countryArray = realm.objects(CountryData.self).filter("name contains[c] %@", searchText)
            countryDetailTableView.reloadData()
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBar.showsCancelButton = false
        if isInternetAvailable == true {
            guard let searchString = searchBar.text, searchString.count > 0 else {
                return
            }
            searchBar.text = nil
            getDataFromApi(searchString)
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = nil
        searchBar.showsCancelButton = false
        searchBar.resignFirstResponder()
    }
}

//MARK: Tableview Delegate and Datasource
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isInternetAvailable == false {
            return countryArray.count
        }
        return countryObjects.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CountryDetailTableViewCell") as! CountryDetailTableViewCell
        if isInternetAvailable {
            cell.countryObject = countryObjects[indexPath.row]
        } else {
            cell.offlineCountry = countryArray[indexPath.row]
        }
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let countryDetailVC = self.storyboard?.instantiateViewController(withIdentifier: "CountryDetailViewController") as! CountryDetailViewController
        if isInternetAvailable == true {
            countryDetailVC.countryData = self.countryObjects[indexPath.row]
            countryDetailVC.isOfflineData = false
        } else {
            countryDetailVC.offlineCountry = countryArray[indexPath.row]
            countryDetailVC.isOfflineData = true
        }
        present(countryDetailVC, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
}
