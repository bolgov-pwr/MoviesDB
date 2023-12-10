//
//  MoviesListViewController.swift
//  MoviesDB
//
//  Created by Ivan Bolgov on 09.12.2023.
//

import UIKit

protocol MoviesListViewControllerDelegate: AnyObject {
    func openDetails(of movie: Movie)
}

final class MoviesListViewController: UIViewController {
    
    weak var delegate: MoviesListViewControllerDelegate?
    
    private var dataSource: BaseTableDataSource<MoviesListCellViewModelProtocol>?
    
    private let tableView: UITableView = {
        let tv = UITableView()
        tv.rowHeight = 200
        tv.keyboardDismissMode = .onDrag
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        return searchBar
    }()
    
    private let debouncer = Debouncer(delay: 0.4)
    private let viewModel: MovieListViewModelProtocol
    
    init(viewModel: MovieListViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        viewModel.fetchTopRatedMovies()
    }
    
    private func setup() {
        setupModes()
        setupSearchBar()
        setupTableView()
        setupViewModelBinding()
    }
    
    private func setupModes() {
        let modeBtn = UIButton()
        modeBtn.addTarget(self, action: #selector(modeSelected(sender:)), for: .touchUpInside)
        modeBtn.setTitle("Network:", for: [])
        modeBtn.setTitleColor(.black, for: [])
        modeBtn.setImage(UIImage(systemName: "wifi")?.withRenderingMode(.alwaysOriginal).withTintColor(.systemGreen), for: .selected)
        modeBtn.setImage(UIImage(systemName: "wifi.slash")?.withRenderingMode(.alwaysOriginal).withTintColor(.systemRed), for: .normal)
        modeBtn.semanticContentAttribute = .forceRightToLeft
        modeBtn.isSelected = true
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: modeBtn)
    }
    
    private func setupSearchBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.white
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance

        navigationItem.titleView = searchBar
        searchBar.delegate = self
    }
    
    private func setupTableView() {
        view.backgroundColor = .white
        tableView.backgroundColor = .white
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        tableView.delegate = self
        tableView.register(UINib(nibName: MovieListCell.reuseId, bundle: nil), forCellReuseIdentifier: MovieListCell.reuseId)
        
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)
    }
    
    private func setupViewModelBinding() {
        viewModel.stateUpdater = self
        viewModel.errorReceiver = self
    }
    
    private func reloadDataSource() {
        dataSource = MoviesTableDataSource(viewModels: viewModel.movies, cellConfigurator: { vm, cell in
            let cell = cell as? MovieListCell
            cell?.viewModel = vm
        })
        tableView.dataSource = dataSource
    }
    
    private func stopLoaderIfNeeded() {
        tableView.refreshControl?.endRefreshing()
    }
    
    @objc private func modeSelected(sender: UIButton) {
        sender.isSelected.toggle()
        viewModel.changeMode()
    }
    
    @objc private func refresh() {
        searchBar.text = ""
        searchBar.resignFirstResponder()
        viewModel.fetchTopRatedMovies()
    }
}

// MARK: UISearchBarDelegate

extension MoviesListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        debouncer.debounce { [weak self] in
            let query = searchText.searchQuery
            
            if query.isEmpty {
                self?.viewModel.fetchTopRatedMovies()
            } else {
                self?.viewModel.searchMovies(with: query)
            }
        }
    }
}

// MARK: UITableViewDelegate

extension MoviesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let model = viewModel.movies[indexPath.row].movie
        delegate?.openDetails(of: model)
    }
}

// MARK: StateUpdaterProtocol

extension MoviesListViewController: StateUpdaterProtocol {
    func performUpdates(delete: [Int], insert: [Int]) {
        reloadDataSource()
        let indicesToDelete = delete.map { IndexPath(row: $0, section: 0) }
        let indicesToInsert = insert.map { IndexPath(row: $0, section: 0) }
        tableView.performBatchUpdates {
            tableView.deleteRows(at: indicesToDelete, with: .fade)
            tableView.insertRows(at: indicesToInsert, with: .fade)
        }
        stopLoaderIfNeeded()
    }
}

// MARK: ErrorReceiverProtocol

extension MoviesListViewController: ErrorReceiverProtocol {
    func didReceive(error: Error) {
        stopLoaderIfNeeded()
        // the place to show the error message
    }
}
