//
//  MovieDetailsTableDataSource.swift
//  MoviesDB
//
//  Created by Ivan Bolgov on 10.12.2023.
//

import UIKit

final class MovieDetailsTableDataSource: BaseTableDataSource<Occurrence> {
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let viewModel = viewModels[indexPath.row]
        let cell: MovieDetailCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        cellConfigurator(viewModel, cell)
        return cell
    }
}
