import UIKit

class WeatherViewController: UIViewController {
    @IBOutlet weak var currentWeatherView: UIView!
    @IBOutlet weak var forecastTable: UITableView!
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var feelsLikeLabel: UILabel!
    
    var weather: Weather = Weather();
    
    override func viewDidLoad() {
        super.viewDidLoad();
        currentWeatherView.layer.cornerRadius = 7;
        if let savedWeather = UserDefaults.standard.object(forKey: "Weather") as? Data {
            let decoder = JSONDecoder();
            if let loadedWeather = try? decoder.decode(Weather.self, from: savedWeather) {
                setData(weather: loadedWeather);
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated);
        WeatherLoader().loadWeatherAlamofire { weather in
            self.setData(weather: weather);
       }
    }
    
    func setData(weather: Weather) {
        self.weather = weather;
        self.forecastTable.reloadData();
        self.cityNameLabel.text = "Moscow";
        self.tempLabel.text = self.formateTemp(temp: weather.temp);
        self.feelsLikeLabel.text = self.formateTemp(temp: weather.feelsLike);
    }

    func formateTemp(temp: Double) -> String {
        return String(format: "%.01f °C", temp);
    }
}

extension WeatherViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ForecastCell", for: indexPath) as! ForecastCell;
        let forecast = self.weather.forecast[indexPath.row]
        cell.tempLabel.text = formateTemp(temp: forecast.tempDay);
        
        let dayTimePeriodFormatter = DateFormatter();
        dayTimePeriodFormatter.dateFormat = "dd MMM";
        let dateString = dayTimePeriodFormatter.string(from: forecast.date as Date);
        cell.dateLabel.text = dateString;
        cell.windInfo.text = "\(forecast.windSpeed) м/с";
        let tempMin = self.formateTemp(temp: forecast.tempMin);
        let tempMax = self.formateTemp(temp: forecast.tempMax);
        cell.minMaxTempLabel.text = "\(tempMin)..\(tempMax)";
        cell.pressureLabel.text = String(forecast.pressure);
        cell.pressureLabel.text = "\(forecast.pressure)";
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.weather.forecast.count;
    }
}
