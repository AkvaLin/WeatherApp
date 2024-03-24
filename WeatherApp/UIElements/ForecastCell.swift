//
//  ForecastCell.swift
//  WeatherApp
//
//  Created by Никита Пивоваров on 23.03.2024.
//

import UIKit

class ForecastCell: UITableViewCell {
    
    private let dayOfWeekLabel = {
        let lbl = UILabel()
        lbl.textColor = .vkForeground
        lbl.font = .preferredFont(forTextStyle: .title2)
        return lbl
    }()
    
    private let minTemperatureLabel = {
        let lbl = UILabel()
        lbl.textColor = .secondaryLabel
        lbl.font = .preferredFont(forTextStyle: .body)
        lbl.textAlignment = .right
        return lbl
    }()
    
    private let dashLabel = {
        let lbl = UILabel()
        lbl.textColor = .secondaryLabel
        lbl.font = .preferredFont(forTextStyle: .body)
        lbl.textAlignment = .center
        return lbl
    }()
    
    private let maxTemperatureLabel = {
        let lbl = UILabel()
        lbl.textColor = .secondaryLabel
        lbl.font = .preferredFont(forTextStyle: .body)
        lbl.textAlignment = .left
        return lbl
    }()
    
    private let weatherView = UIView()
    
    private let weatherStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fillProportionally
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 4
        return stackView
    }()
    
    private let verticalStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        stackView.alignment = .center
        return stackView
    }()
    
    private let horizontalStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fillEqually
        stackView.axis = .horizontal
        stackView.alignment = .center
        return stackView
    }()
    
    static let identifier = "ForecastCellId"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        
        contentView.addSubview(verticalStackView)
        weatherView.addSubview(weatherStackView)
        
        verticalStackView.translatesAutoresizingMaskIntoConstraints = false
        weatherStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            verticalStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            verticalStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            verticalStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            verticalStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            weatherStackView.leadingAnchor.constraint(equalTo: weatherView.leadingAnchor, constant: 8),
            weatherStackView.trailingAnchor.constraint(equalTo: weatherView.trailingAnchor, constant: -8),
            weatherStackView.topAnchor.constraint(equalTo: weatherView.topAnchor),
            weatherStackView.bottomAnchor.constraint(equalTo: weatherView.bottomAnchor)
        ])
        
        horizontalStackView.addArrangedSubview(dayOfWeekLabel)
        horizontalStackView.addArrangedSubview(minTemperatureLabel)
        horizontalStackView.addArrangedSubview(dashLabel)
        horizontalStackView.addArrangedSubview(maxTemperatureLabel)
        
        verticalStackView.addArrangedSubview(horizontalStackView)
        verticalStackView.addArrangedSubview(weatherView)
    }
    
    public func configure(dayOfWeek: String, minTemperature: String, maxTemperature: String, forecast: [ForecastModel.ForecastWeatherModel]) {
        dashLabel.text = "-"
        dayOfWeekLabel.text = dayOfWeek
        minTemperatureLabel.text = minTemperature
        maxTemperatureLabel.text = maxTemperature
        weatherStackView.subviews.forEach { subview in
            subview.removeFromSuperview()
        }
        forecast.forEach { weather in
            let subview = WeatherDetailedDataView()
            subview.setupLabel(image: UIImage(systemName: weather.weatherIconName))
            subview.setupData(text: weather.time)
            weatherStackView.addArrangedSubview(subview)
        }
    }
}
