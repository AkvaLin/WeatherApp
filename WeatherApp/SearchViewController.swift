//
//  SearchViewController.swift
//  WeatherApp
//
//  Created by Никита Пивоваров on 24.03.2024.
//

import UIKit
import Combine

protocol DataDelegate: AnyObject {
    func sendData(data: LocalSearchModel)
}

class SearchViewController: UIViewController {

    private let viewModel = SearchViewModel()
    
    private let searchController = UISearchController()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.register(SearchCell.self, forCellReuseIdentifier: SearchCell.identifier)
        return tableView
    }()
    
    weak var delegate: DataDelegate?
    private var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        view.backgroundColor = .vkBackgroundDark
        
        bind()
        setupViews()
        setupSearchController()
    }
    
    private func setupViews() {
        view.addSubview(tableView)
        
        tableView.frame = view.bounds
    }
    
    private func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "City"
        
        navigationItem.searchController = searchController
        definesPresentationContext = false
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    private func bind() {
        viewModel.$viewData
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.tableView.reloadData()
            }
            .store(in: &cancellables)
    }
}

extension SearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        viewModel.cityText = searchController.searchBar.text ?? ""
    }
}

extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.viewData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchCell.identifier, for: indexPath) as? SearchCell else {
            fatalError("TableView couldn't dequeue SearchCell")
        }
        let data = viewModel.viewData[indexPath.row]
        cell.configure(title: data.title, subtitle: data.subtitle)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.sendData(data: viewModel.viewData[indexPath.row])
        navigationController?.popViewController(animated: true)
    }
}

@available(iOS 17, *)
#Preview {
    SearchViewController()
}
