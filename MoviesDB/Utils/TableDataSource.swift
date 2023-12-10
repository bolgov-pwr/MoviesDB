//
//  TableDataSource.swift
//  MoviesDB
//
//  Created by Ivan Bolgov on 09.12.2023.
//

import UIKit

class BaseTableDataSource<CellVM>: NSObject, UITableViewDataSource {
    
    typealias CellConfigurator = (CellVM, UITableViewCell) -> Void
    
    let viewModels: [CellVM]
    let cellConfigurator: CellConfigurator
    
    init(viewModels: [CellVM], cellConfigurator: @escaping CellConfigurator) {
        self.viewModels = viewModels
        self.cellConfigurator = cellConfigurator
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        fatalError("Must be overrided")
    }
}
