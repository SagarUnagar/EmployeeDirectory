//
//  ViewController.swift
//  EmployeeDirectory
//
//  Created by Sagar Unagar on 03/06/19.
//  Copyright © 2019 Sagar's Lab. All rights reserved.
//

import UIKit
import Contacts
import ContactsUI

class EmployeeViewController: UIViewController {
    
    //MARK:- Interface Builder
    @IBOutlet weak var employeeTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!

    //MARK:- Propetries
    var viewModel = EmployeeViewModel()
    var selectedEmployee = Employee()
    
    //MARK:- ViewController's LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureUI()
    }
    
    //MARK:- Custom Methods
    /**
     This is UI configuration method that will set ui component properties at run time.
     */
    func configureUI() {
        self.addTitle(title: "Employee List")
        self.configureNavigationBar()
        self.configureSearchBar()
        self.fetchAllEmployeeFromViewModel()
        self.employeeTableView.refreshControl = self.generateRefreshControl()
    }
    
    /**
     This method set the background image to navigationbar and also set it shadow image.
     */
    func configureNavigationBar() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(color: .white, size: CGSize(width: self.view.bounds.size.width, height: 44)), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    /**
     This method configure the properites of searchbar.
     */
    func configureSearchBar() {
        self.searchBar.isTranslucent = false
        self.searchBar.backgroundImage = UIImage()
        self.searchBar.layer.borderColor = UIColor.green.cgColor
    }
    
    /**
     This method fetches all the employees from the server.
     */
    func fetchAllEmployeeFromViewModel() {
        self.showActivityIndicatorView()
        self.viewModel.fetchAllEmployee { (datasource, error) in
            if error != nil {
                let err = error as! ErrorResult
                self.showAlert(titleString: "Error!", messageString: err.localizedDescription)
                self.hideActivityIndicatorView()
            } else {
                self.hideActivityIndicatorView()
                self.employeeTableView.reloadData()
            }
        }
    }
    
    /**
     This method create refreshControl for tableview
     
     - Returns: UIRefreshControl
     */
    func generateRefreshControl() -> UIRefreshControl {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = UIColor.black
        refreshControl.addTarget(self, action: #selector(handleRefresh(_:)), for: .valueChanged)
        return refreshControl
    }
    
    /**
     This method called when table gets pull to refresh event.
     */
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        self.searchBar.text = ""
        self.fetchAllEmployeeFromViewModel()
        refreshControl.endRefreshing()
    }
}

//MARK:- TableView Delegate and Datasource Methods
extension EmployeeViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.viewModel.positions.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.employeeDatasource[self.viewModel.positions[section]]?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let headerView = Bundle.main.loadNibNamed("EmployeeTableViewHeader", owner: self, options: nil)?[0] {
            let view = headerView as! EmployeeTableViewHeader
            view.headerLabel.text = self.viewModel.positions[section] + " (\(self.viewModel.employeeDatasource[self.viewModel.positions[section]]?.count ?? 0))"
            return view
        } else {
            return nil
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EmployeeTableViewCell", for: indexPath) as! EmployeeTableViewCell
        cell.selectionStyle = .none
        guard let datasource = self.viewModel.employeeDatasource[self.viewModel.positions[indexPath.section]] else {
            return UITableViewCell()
        }
        
        cell.loadData(employee: datasource[indexPath.row], indexPath: indexPath)
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let selectedEmp = self.viewModel.employeeDatasource[self.viewModel.positions[indexPath.section]]?[indexPath.row]{
            self.selectedEmployee = selectedEmp
            self.performSegue(withIdentifier: "EmployeeListToDetail", sender: self)
        }
    }
}

//MARK:- Searchbar Delegate Methods
extension EmployeeViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            self.viewModel.employeeDatasource = self.viewModel.groupByPositions(employees: self.viewModel.backupEmployeeList)
            self.employeeTableView.reloadData()
        }
        else {
            let searchedEmployeeList = self.viewModel.backupEmployeeList.filter {
                ($0.firstName!.lowercased().contains(searchText.lowercased())) ||
                ($0.lastName!.lowercased().contains(searchText.lowercased())) ||
                ($0.contactDetail!.email!.lowercased().contains(searchText.lowercased())) ||
                ($0.position!.lowercased().contains(searchText.lowercased())) }
            self.viewModel.employeeDatasource = self.viewModel.groupByPositions(employees: searchedEmployeeList)
            self.employeeTableView.reloadData()
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

//MARK:- EmployeeTableViewCell Delegate Methods
extension EmployeeViewController: EmployeeTableViewCellDelegate {
    func didTapEmployeeContactCard(cell: EmployeeTableViewCell) {
        let indexPath = self.employeeTableView.indexPath(for: cell)
        let employee = self.viewModel.employeeDatasource[self.viewModel.positions[indexPath!.section]]![indexPath!.row]
        let nativeContactDetailVC = CNContactViewController(for: employee.contactCard!)
        self.navigationController?.pushViewController(nativeContactDetailVC, animated: true)
    }
}

//MARK:- Segue
extension EmployeeViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EmployeeListToDetail" {
            let detailVC = segue.destination as! EmployeeDetailViewController
            detailVC.selectedEmployee = self.selectedEmployee
        }
    }
}

