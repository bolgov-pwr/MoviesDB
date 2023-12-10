//
//  MovieDetailsViewModelTests.swift
//  MoviesDBTests
//
//  Created by Ivan Bolgov on 10.12.2023.
//

import XCTest
@testable import MoviesDB

final class MovieDetailsViewModelTests: XCTestCase {

    private var sut: MovieListViewModel!
    private var repositoryMock: MoviesRepositoryMock!
    
    private var receivedError: Error?
    private var indicesToDelete = [Int]()
    private var indicesToInsert = [Int]()
    
    override func setUp()  {
        super.setUp()
        repositoryMock = MoviesRepositoryMock()
        sut = MovieListViewModel(moviesRepo: repositoryMock)
    }

    override func tearDown() {
        sut = nil
        repositoryMock = nil
        super.tearDown()
    }
    
    func testChangeMode() {
        // initial state
        XCTAssertTrue(sut.isOnline)
        sut.changeMode()
        // changed state
        XCTAssertFalse(sut.isOnline)
    }
    
    func testFetchTopRatedMoviesSuccess() {
        let response = MoviesResponse(results: [
            Movie(id: 1, title: "test_title1"),
            Movie(id: 2, title: "test_title2")
        ])
        
        let expectedModels = response.results.map { MoviesListCellViewModel($0, repo: repositoryMock) }
        
        repositoryMock.allMovies = .success(response)
        
        sut.stateUpdater = self
        sut.fetchTopRatedMovies()
        
        let fecthedMovies = sut.movies
        XCTAssertEqual(fecthedMovies, expectedModels)
        
        XCTAssertTrue(indicesToDelete.isEmpty)
        XCTAssertEqual(indicesToInsert, Array(expectedModels.indices))
    }
    
    func testFetchTopRatedMoviesFailure() {
        
        sut.errorReceiver = self
        
        let expectedError = "error".toError()
        
        repositoryMock.allMovies = .failure(expectedError)
        
        sut.fetchTopRatedMovies()
        XCTAssertEqual(receivedError?.localizedDescription, expectedError.localizedDescription)
    }
    
    func testSearchMoviesSuccess() {
        let response = MoviesResponse(results: [
            Movie(id: 1, title: "test_title1"),
            Movie(id: 2, title: "test_title2")
        ])
        
        let expectedModels = response.results.map { MoviesListCellViewModel($0, repo: repositoryMock) }
        
        repositoryMock.searchedMovies = .success(response)
        
        sut.searchMovies(with: "search movie")
        
        let fecthedMovies = sut.movies
        XCTAssertEqual(fecthedMovies, expectedModels)
    }
}

extension MovieDetailsViewModelTests: StateUpdaterProtocol {
    func performUpdates(delete: [Int], insert: [Int]) {
        self.indicesToDelete = delete
        self.indicesToInsert = insert
    }
}

extension MovieDetailsViewModelTests: ErrorReceiverProtocol {
    func didReceive(error: Error) {
        self.receivedError = error
    }
}
