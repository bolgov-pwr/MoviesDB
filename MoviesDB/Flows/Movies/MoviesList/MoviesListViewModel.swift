//
//  MoviesListViewModel.swift
//  MoviesDB
//
//  Created by Ivan Bolgov on 09.12.2023.
//

import Foundation

protocol MovieListViewModelProtocol: AnyObject {
    var errorReceiver: ErrorReceiverProtocol? { get set }
    var stateUpdater: StateUpdaterProtocol? { get set }
    var movies: [MoviesListCellViewModel] { get }
    
    func changeMode()
    func fetchTopRatedMovies()
    func searchMovies(with query: String)
}

final class MovieListViewModel: MovieListViewModelProtocol {
    
    weak var errorReceiver: ErrorReceiverProtocol?
    weak var stateUpdater: StateUpdaterProtocol?
        
    var movies: [MoviesListCellViewModel] {
        fetchedMovies.map { MoviesListCellViewModel($0, repo: moviesRepo) }
    }
    
    private var fetchedMovies: [Movie] = []
    private(set) var isOnline: Bool = true
    
    private let moviesRepo: MoviesRepositoryProtocol
    
    init(moviesRepo: MoviesRepositoryProtocol) {
        self.moviesRepo = moviesRepo
    }
    
    func changeMode() {
        self.isOnline.toggle()
    }
    
    func fetchTopRatedMovies() {
        moviesRepo.getMovies(isOnline: isOnline) { [weak self] result in
            DispatchQueue.executeOnMain {
                self?.handleData(result)
            }
        }
    }
    
    func searchMovies(with query: String) {
        moviesRepo.searchMovies(isOnline: isOnline, by: query) { [weak self] result in
            DispatchQueue.executeOnMain {
                self?.handleData(result)
            }
        }
    }
    
    private func handleData(_ result: Result<MoviesResponse, Error>) {
        switch result {
        case .success(let movieResult):
            let delete = Array(0..<fetchedMovies.count)
            fetchedMovies = movieResult.results
            let insert = Array(0..<fetchedMovies.count)
            stateUpdater?.performUpdates(delete: delete, insert: insert)
        case .failure(let error):
            errorReceiver?.didReceive(error: error)
            break
        }
    }
}
