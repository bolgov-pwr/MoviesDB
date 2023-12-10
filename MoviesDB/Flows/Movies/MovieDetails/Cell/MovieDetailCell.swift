//
//  MovieDetailCell.swift
//  MoviesDB
//
//  Created by Ivan Bolgov on 10.12.2023.
//

import UIKit

final class MovieDetailCell: UITableViewCell, ClassIdentifiable, NibIdentifiable {
    
    @IBOutlet weak var charLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    
    var viewModel: Occurrence? {
        didSet {
            setup()
        }
    }
    
    private func setup() {
        guard let viewModel = viewModel else { return }
        charLabel.text = "\(viewModel.char):"
        countLabel.text = "\(viewModel.count)"
    }
}
