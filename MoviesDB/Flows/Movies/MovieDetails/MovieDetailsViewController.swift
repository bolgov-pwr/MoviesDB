//
//  MovieDetailsViewController.swift
//  MoviesDB
//
//  Created by Ivan Bolgov on 10.12.2023.
//

import UIKit

final class MovieDetailsViewController: UIViewController {
    
    private var dataSource: BaseTableDataSource<Occurrence>?
    
    private let tableView: UITableView = {
        let tv = UITableView()
        tv.rowHeight = 44
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    private let viewModel: MovieDetailsViewModelProtocol
    
    init(viewModel: MovieDetailsViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = viewModel.title
        setupTableView()
        update()
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        tableView.register(UINib(nibName: MovieDetailCell.reuseId, bundle: nil), forCellReuseIdentifier: MovieDetailCell.reuseId)
    }
    
    private func update() {
        let occurrences = viewModel.calculateOccurrence()
        
        dataSource = MovieDetailsTableDataSource(viewModels: occurrences, cellConfigurator: { vm, cell in
            let cell = cell as? MovieDetailCell
            cell?.viewModel = vm
        })
        tableView.dataSource = dataSource
        tableView.reloadData()
    }
}
