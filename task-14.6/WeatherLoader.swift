import Foundation
import Alamofire

class WeatherLoader {
    
    private let API_KEY = "3f376ce733bd1e03068ffb8f4a207e00";
    private let longitude: Double = 37.62;
    private let latitude: Double = 55.75;
    
    func loadWeatherAlamofire(competion: @escaping (Weather) -> Void) {
        let url = URL(string: "https://api.openweathermap.org/data/2.5/onecall?lat=\(self.latitude)&lon=\(self.longitude)&exclude=hourly,minutely&appid=\(self.API_KEY)")!;
        AF.request(url).responseJSON { response in
            if let data = response.data,
               let jsonString = String(data: data, encoding: .utf8) {
                let jsonData = jsonString.data(using: .utf8)!;
                let defaults = UserDefaults.standard;
                defaults.set(jsonData, forKey: "Weather");
                
                DispatchQueue.main.async {
                    do {
                        let decoder = JSONDecoder();
                        let weather = try decoder.decode(Weather.self, from: jsonData);
                        competion(weather);
                    } catch {
                        
                    }
                }
                }
            }
        }
}

