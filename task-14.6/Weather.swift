import Foundation

struct Wind {
    let speed: Int;
    let deg: Int;
}

struct Forecast: Decodable {
    var date: Date;
    var tempDay: Double;
    var tempNight: Double;
    var tempMin: Double;
    var tempMax: Double;
    var feelsLike: Double;
    var pressure: Int;
    var humidity: Int;
    var windSpeed: Double;
    
    enum CodingKeys: String, CodingKey {
        case date = "dt"
        case pressure
        case humidity
        case temp
        case feelsLike = "feels_like"
        case windSpeed = "wind_speed"
    }
    
    enum TempKeys: String, CodingKey {
        case day
        case night
        case min
        case max
    }
    
    enum FeelsLikeKeys: String, CodingKey {
        case day
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self);
        self.date = try container.decode(Date.self, forKey: .date);
        self.pressure = try container.decode(Int.self, forKey: .pressure);
        self.humidity = try container.decode(Int.self, forKey: .humidity);
        self.windSpeed = try container.decode(Double.self, forKey: .windSpeed);
        
        let tempContainer = try container.nestedContainer(keyedBy: TempKeys.self, forKey: .temp);
        self.tempDay = convertTemp(temp: try tempContainer.decode(Double.self, forKey: .day));
        self.tempNight = convertTemp(temp: try tempContainer.decode(Double.self, forKey: .night));
        self.tempMax = convertTemp(temp: try tempContainer.decode(Double.self, forKey: .max));
        self.tempMin = convertTemp(temp: try tempContainer.decode(Double.self, forKey: .min));
        
        let feelsContainer = try container.nestedContainer(keyedBy: FeelsLikeKeys.self, forKey: .feelsLike);
        self.feelsLike = convertTemp(temp: try feelsContainer.decode(Double.self, forKey: .day));
    }
}

class Weather: Decodable {
    var temp: Double = 0.0;
    var feelsLike: Double = 0.0;
    var pressure: Int = 0;
    var wind: Wind = Wind(speed: 0, deg: 0);
    var forecast: [Forecast] = [];
    
    enum RootKeys: String, CodingKey {
        case current
        case daily
    }
    
    enum CurrentCodingKeys: String, CodingKey {
            case temp
            case feelsLike = "feels_like"
            case pressure
            case wind
    }

    required init(from decoder: Decoder ) throws {
        let container = try decoder.container(keyedBy: RootKeys.self);
        let currentContainer = try container.nestedContainer(keyedBy: CurrentCodingKeys.self, forKey: .current);
        
        self.temp = convertTemp(temp: try currentContainer.decode(Double.self, forKey: .temp));
        self.feelsLike = convertTemp(temp: try currentContainer.decode(Double.self, forKey: .feelsLike));
        self.pressure = try currentContainer.decode(Int.self, forKey: .pressure);
        self.forecast = try container.decode([Forecast].self, forKey: .daily);
    }
    
    init() {
     
    }
}

func convertTemp(temp: Double) -> Double {
    return temp - 273;
}
