//
//  WeatherDetailedDataView.swift
//  WeatherApp
//
//  Created by Никита Пивоваров on 22.03.2024.
//

import UIKit

final class WeatherDetailedDataView: UIView {
    
    private let imageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .secondaryLabel
        return imageView
    }()
    
    private let detailsLabel = {
        let lbl = UILabel()
        lbl.font = .preferredFont(forTextStyle: .body)
        lbl.adjustsFontSizeToFitWidth = true
        lbl.numberOfLines = 1
        lbl.textAlignment = .center
        lbl.textColor = .vkForeground
        return lbl
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    private func setupViews() {
        clipsToBounds = true
        addSubview(imageView)
        addSubview(detailsLabel)
        setupConstraints()
    }
    
    private func setupConstraints() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        detailsLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.4),
            
            detailsLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            detailsLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            detailsLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            detailsLabel.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.6)
        ])
    }
    
    public func setupLabel(image: UIImage?) {
        imageView.image = image
    }
    
    public func setupData(text: String) {
        detailsLabel.text = text
    }
}
