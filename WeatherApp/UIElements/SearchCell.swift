//
//  SearchCell.swift
//  WeatherApp
//
//  Created by Никита Пивоваров on 24.03.2024.
//

import Foundation
import UIKit

class SearchCell: UITableViewCell {
    
    private let stackView = {
        let stackView = UIStackView()
        stackView.distribution = .fillProportionally
        stackView.axis = .vertical
        stackView.alignment = .center
        return stackView
    }()
    
    private let title = {
        let lbl = UILabel()
        lbl.numberOfLines = 1
        lbl.textColor = .vkForeground
        lbl.font = .preferredFont(forTextStyle: .title3)
        lbl.adjustsFontSizeToFitWidth = true
        return lbl
    }()
    
    private let subtitle = {
        let lbl = UILabel()
        lbl.numberOfLines = 1
        lbl.textColor = .secondaryLabel
        lbl.font = .preferredFont(forTextStyle: .body)
        lbl.adjustsFontSizeToFitWidth = true
        return lbl
    }()
    
    static let identifier = "SearchCellId"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        backgroundColor = .clear
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(stackView)
        stackView.addArrangedSubview(title)
        stackView.addArrangedSubview(subtitle)
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
        ])
    }
    
    public func configure(title: String, subtitle: String) {
        self.title.text = title
        self.subtitle.text = subtitle
    }
}
