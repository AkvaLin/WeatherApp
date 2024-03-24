//
//  ViewController.swift
//  WeatherApp
//
//  Created by Никита Пивоваров on 20.03.2024.
//

import UIKit
import Combine

class ViewController: UIViewController {
    
    private let gradientLayer = CAGradientLayer()
    private let cityLabel = {
        let lbl = UILabel()
        lbl.font = .preferredFont(forTextStyle: .largeTitle)
        lbl.textColor = .vkForeground
        lbl.adjustsFontSizeToFitWidth = true
        return lbl
    }()
    private let countryLabel = {
        let lbl = UILabel()
        lbl.font = .preferredFont(forTextStyle: .title2)
        lbl.textColor = .vkForeground
        lbl.adjustsFontSizeToFitWidth = true
        return lbl
    }()
    private let weatherImageView = {
        let imgView = UIImageView()
        imgView.contentMode = .scaleAspectFit
        imgView.tintColor = .vkForeground
        return imgView
    }()
    private let weatherMainDataView = {
        let view = UIView()
        view.clipsToBounds = true
        view.layer.cornerRadius = 25
        view.backgroundColor = .systemBackground.withAlphaComponent(0.5)
        return view
    }()
    private let temperatureLabel = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: 64, weight: .bold)
        lbl.adjustsFontSizeToFitWidth = true
        lbl.numberOfLines = 1
        lbl.textColor = .vkForeground
        return lbl
    }()
    private let weatherLabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 1
        lbl.font = .preferredFont(forTextStyle: .title2)
        lbl.adjustsFontSizeToFitWidth = true
        lbl.textColor = .vkForeground
        return lbl
    }()
    private let highTemperatureLabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 1
        lbl.font = .preferredFont(forTextStyle: .body)
        lbl.adjustsFontSizeToFitWidth = true
        lbl.textColor = .secondaryLabel
        return lbl
    }()
    private let lowTemperatureLabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 1
        lbl.font = .preferredFont(forTextStyle: .body)
        lbl.adjustsFontSizeToFitWidth = true
        lbl.textColor = .secondaryLabel
        return lbl
    }()
    private let weatherDetailsDataView = {
        let view = UIView()
        view.clipsToBounds = true
        view.layer.cornerRadius = 25
        view.backgroundColor = .systemBackground.withAlphaComponent(0.5)
        return view
    }()
    private let weatherDetailsStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.spacing = 4
        view.distribution = .fillEqually
        return view
    }()
    private let feelsLike = {
        let view = WeatherDetailedDataView()
        view.setupLabel(image: UIImage(systemName: "thermometer.medium"))
        return view
    }()
    private let pressure = {
        let view = WeatherDetailedDataView()
        view.setupLabel(image: UIImage(systemName: "barometer"))
        return view
    }()
    private let humidity = {
        let view = WeatherDetailedDataView()
        view.setupLabel(image: UIImage(systemName: "humidity.fill"))
        return view
    }()
    private let cloudiness = {
        let view = WeatherDetailedDataView()
        view.setupLabel(image: UIImage(systemName: "cloud.fill"))
        return view
    }()
    private let weatherWindDataView = {
        let view = UIView()
        view.clipsToBounds = true
        view.layer.cornerRadius = 25
        view.backgroundColor = .systemBackground.withAlphaComponent(0.5)
        return view
    }()
    private let weatherWindStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.spacing = 8
        view.distribution = .fillEqually
        return view
    }()
    private let windSpeedDataView = {
        let view = WeatherDetailedDataView()
        view.setupLabel(image: UIImage(systemName: "gauge.open.with.lines.needle.33percent"))
        return view
    }()
    private let windDirectionDataView = {
        let view = WeatherDetailedDataView()
        view.setupLabel(image: UIImage(systemName: "safari"))
        return view
    }()
    private let forecastTableView = {
        let tableView = UITableView()
        tableView.layer.cornerRadius = 25
        tableView.backgroundColor = .systemBackground.withAlphaComponent(0.5)
        tableView.separatorInset = .zero
        tableView.showsVerticalScrollIndicator = false
        tableView.allowsSelection = false
        return tableView
    }()
    
    private let viewModel = ViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        forecastTableView.dataSource = self
        forecastTableView.register(ForecastCell.self, forCellReuseIdentifier: ForecastCell.identifier)
        
        bind()
        setupNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupViews()
        viewModel.onAppear()
    }
    
    private func setupConstraints() {
        gradientLayer.frame = view.bounds
        
        cityLabel.translatesAutoresizingMaskIntoConstraints = false
        countryLabel.translatesAutoresizingMaskIntoConstraints = false
        weatherImageView.translatesAutoresizingMaskIntoConstraints = false
        weatherMainDataView.translatesAutoresizingMaskIntoConstraints = false
        temperatureLabel.translatesAutoresizingMaskIntoConstraints = false
        weatherLabel.translatesAutoresizingMaskIntoConstraints = false
        highTemperatureLabel.translatesAutoresizingMaskIntoConstraints = false
        lowTemperatureLabel.translatesAutoresizingMaskIntoConstraints = false
        weatherDetailsDataView.translatesAutoresizingMaskIntoConstraints = false
        weatherDetailsStackView.translatesAutoresizingMaskIntoConstraints = false
        weatherWindDataView.translatesAutoresizingMaskIntoConstraints = false
        weatherWindStackView.translatesAutoresizingMaskIntoConstraints = false
        forecastTableView.translatesAutoresizingMaskIntoConstraints = false
        
        let weatherDataViewHeightWidth = (view.bounds.width - 90) / 2
        
        NSLayoutConstraint.activate([
            cityLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            cityLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            cityLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            
            countryLabel.leadingAnchor.constraint(equalTo: cityLabel.leadingAnchor),
            countryLabel.trailingAnchor.constraint(equalTo: cityLabel.trailingAnchor),
            countryLabel.topAnchor.constraint(equalTo: cityLabel.bottomAnchor),
            
            weatherImageView.topAnchor.constraint(equalTo: countryLabel.bottomAnchor, constant: 30),
            weatherImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30),
            weatherImageView.widthAnchor.constraint(equalToConstant: weatherDataViewHeightWidth),
            weatherImageView.heightAnchor.constraint(equalToConstant: weatherDataViewHeightWidth),
            
            weatherMainDataView.topAnchor.constraint(equalTo: weatherImageView.topAnchor),
            weatherMainDataView.leadingAnchor.constraint(equalTo: weatherImageView.trailingAnchor, constant: 30),
            weatherMainDataView.widthAnchor.constraint(equalToConstant: weatherDataViewHeightWidth),
            weatherMainDataView.heightAnchor.constraint(equalToConstant: weatherDataViewHeightWidth),
            
            temperatureLabel.topAnchor.constraint(equalTo: weatherMainDataView.topAnchor, constant: 8),
            temperatureLabel.leadingAnchor.constraint(equalTo: weatherMainDataView.leadingAnchor, constant: 8),
            temperatureLabel.trailingAnchor.constraint(equalTo: weatherMainDataView.trailingAnchor, constant: -8),
            
            weatherLabel.topAnchor.constraint(equalTo: temperatureLabel.bottomAnchor),
            weatherLabel.leadingAnchor.constraint(equalTo: temperatureLabel.leadingAnchor),
            weatherLabel.trailingAnchor.constraint(equalTo: temperatureLabel.trailingAnchor),
            
            highTemperatureLabel.topAnchor.constraint(equalTo: weatherLabel.bottomAnchor, constant: 4),
            highTemperatureLabel.leadingAnchor.constraint(equalTo: weatherLabel.leadingAnchor),
            highTemperatureLabel.widthAnchor.constraint(equalToConstant: (weatherDataViewHeightWidth - 16) / 2),
            
            lowTemperatureLabel.topAnchor.constraint(equalTo: highTemperatureLabel.topAnchor),
            lowTemperatureLabel.leadingAnchor.constraint(equalTo: highTemperatureLabel.trailingAnchor),
            lowTemperatureLabel.widthAnchor.constraint(equalToConstant: (weatherDataViewHeightWidth - 16) / 2),
            
            weatherDetailsDataView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30),
            weatherDetailsDataView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -30),
            weatherDetailsDataView.topAnchor.constraint(equalTo: weatherImageView.bottomAnchor, constant: 30),
            weatherDetailsDataView.heightAnchor.constraint(equalToConstant: weatherDataViewHeightWidth / 2),
            
            weatherDetailsStackView.leadingAnchor.constraint(equalTo: weatherDetailsDataView.leadingAnchor, constant: 8),
            weatherDetailsStackView.trailingAnchor.constraint(equalTo: weatherDetailsDataView.trailingAnchor, constant: -8),
            weatherDetailsStackView.topAnchor.constraint(equalTo: weatherDetailsDataView.topAnchor, constant: 8),
            weatherDetailsStackView.bottomAnchor.constraint(equalTo: weatherDetailsDataView.bottomAnchor, constant: -8),
            
            weatherWindDataView.topAnchor.constraint(equalTo: weatherDetailsDataView.bottomAnchor, constant: 15),
            weatherWindDataView.leadingAnchor.constraint(equalTo: weatherDetailsDataView.leadingAnchor),
            weatherWindDataView.trailingAnchor.constraint(equalTo: weatherDetailsDataView.trailingAnchor),
            weatherWindDataView.heightAnchor.constraint(equalToConstant: weatherDataViewHeightWidth / 2),
            
            weatherWindStackView.leadingAnchor.constraint(equalTo: weatherWindDataView.leadingAnchor, constant: 8),
            weatherWindStackView.trailingAnchor.constraint(equalTo: weatherWindDataView.trailingAnchor, constant: -8),
            weatherWindStackView.topAnchor.constraint(equalTo: weatherWindDataView.topAnchor, constant: 8),
            weatherWindStackView.bottomAnchor.constraint(equalTo: weatherWindDataView.bottomAnchor, constant: -8),
            
            forecastTableView.topAnchor.constraint(equalTo: weatherWindDataView.bottomAnchor, constant: 15),
            forecastTableView.leadingAnchor.constraint(equalTo: weatherWindDataView.leadingAnchor),
            forecastTableView.trailingAnchor.constraint(equalTo: weatherWindDataView.trailingAnchor),
            forecastTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
        
    }
    
    private func setupColors() {
        gradientLayer.colors = [
            UIColor(resource: .vkBackgroundLight).cgColor,
            UIColor(resource: .vkBackgroundDark).cgColor
        ]
    }
    
    private func setupViews() {
        setupColors()
        
        view.layer.addSublayer(gradientLayer)
        view.addSubview(cityLabel)
        view.addSubview(countryLabel)
        view.addSubview(weatherImageView)
        view.addSubview(weatherMainDataView)
        view.addSubview(weatherDetailsDataView)
        view.addSubview(weatherWindDataView)
        view.addSubview(forecastTableView)
        
        weatherMainDataView.addSubview(temperatureLabel)
        weatherMainDataView.addSubview(weatherLabel)
        weatherMainDataView.addSubview(highTemperatureLabel)
        weatherMainDataView.addSubview(lowTemperatureLabel)
        
        weatherDetailsDataView.addSubview(weatherDetailsStackView)
        
        weatherWindDataView.addSubview(weatherWindStackView)
        weatherWindStackView.addArrangedSubview(windSpeedDataView)
        weatherWindStackView.addArrangedSubview(windDirectionDataView)
        
        setupConstraints()
        setupArrangedSubviews()
    }
    
    private func setupArrangedSubviews() {
        weatherDetailsStackView.addArrangedSubview(feelsLike)
        weatherDetailsStackView.addArrangedSubview(pressure)
        weatherDetailsStackView.addArrangedSubview(humidity)
        weatherDetailsStackView.addArrangedSubview(cloudiness)
    }
    
    private func setupNavigationBar() {
        
        navigationController?.navigationBar.tintColor = .vkForeground
        
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(search)),
            UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(updateData))
        ]
    }
    
    private func bind() {
        viewModel.$weatherModel
            .receive(on: RunLoop.main)
            .sink { [weak self] weather in
                guard let weather = weather, let self = self else { return }
                self.temperatureLabel.text = weather.temp
                self.weatherLabel.text = weather.weather
                self.highTemperatureLabel.text = weather.tempMax
                self.lowTemperatureLabel.text = weather.tempMin
                self.feelsLike.setupData(text: weather.feelsLike)
                self.pressure.setupData(text: weather.pressure)
                self.humidity.setupData(text: weather.humidity)
                self.cloudiness.setupData(text: weather.cloudiness)
                self.weatherImageView.image = UIImage(systemName: weather.weatherImageName)
                self.windSpeedDataView.setupData(text: weather.windSpeed)
                self.windDirectionDataView.setupData(text: weather.windDeg)
            }.store(in: &cancellables)
        
        viewModel.$forecastModel
            .receive(on: RunLoop.main)
            .sink { [weak self] forecast in
                self?.forecastTableView.reloadData()
            }.store(in: &cancellables)
        
        viewModel.$cityTitleText
            .receive(on: RunLoop.main)
            .sink { [weak self] text in
                self?.cityLabel.text = text
            }.store(in: &cancellables)
        
        viewModel.$countryTitleText
            .receive(on: RunLoop.main)
            .sink { [weak self] text in
                self?.countryLabel.text = text
            }.store(in: &cancellables)
    }
    
    @objc private func updateData() {
        viewModel.updateCurrentData()
    }
    
    @objc private func search() {
        let vc = SearchViewController()
        vc.delegate = self
        navigationController?.pushViewController(vc, animated: true)
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        setupColors()
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.forecastModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ForecastCell.identifier, for: indexPath) as? ForecastCell else { fatalError("TableView couldn't dequeue ForecastCell") }
        
        let data = viewModel.forecastModel[indexPath.row]
        
        cell.configure(dayOfWeek: data.dayOfWeek,
                   minTemperature: data.tempMin,
                   maxTemperature: data.tempMax,
                   forecast: data.weather)
        return cell
    }
}

extension ViewController: DataDelegate {
    func sendData(data: LocalSearchModel) {
        viewModel.model = data
    }
}

@available(iOS 17, *)
#Preview {
    ViewController()
}
