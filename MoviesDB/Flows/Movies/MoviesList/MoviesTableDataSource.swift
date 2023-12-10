//
//  MoviesTableDataSource.swift
//  MoviesDB
//
//  Created by Ivan Bolgov on 09.12.2023.
//

import UIKit

final class MoviesTableDataSource: BaseTableDataSource<MoviesListCellViewModelProtocol> {
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let viewModel = viewModels[indexPath.row]
        let cell: MovieListCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        cellConfigurator(viewModel, cell)
        return cell
    }
}
