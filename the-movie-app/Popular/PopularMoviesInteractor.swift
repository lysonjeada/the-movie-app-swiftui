import Foundation

enum NetworkError: Error {
    case invalidResponse
    case noData
    case decodingError
}

class PopularMoviesInteractor {
    
    private var presenter: PopularMoviesPresenterProtocol?
    
    init(presenter: PopularMoviesPresenterProtocol?) {
        self.presenter = presenter
    }

    func getListOfPopularMovies() {
        URLSession.shared.dataTask(with: returnRequest()) { data, response, error in
            if let error = error {
                print("Error fetching data:", error)
                // Handle the error here, maybe show an alert?
                // For example:
                // self.showErrorAlert(message: "Error fetching data: \(error)")
                return
            }

            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                print("Invalid response")
                // Handle invalid response, maybe show an alert?
                // For example:
                // self.showErrorAlert(message: "Invalid response")
                return
            }

            guard let data = data else {
                print("No data received")
                // Handle no data, maybe show an alert?
                // For example:
                // self.showErrorAlert(message: "No data received")
                return
            }

            do {
                let decoder = JSONDecoder()
                let movieResponse = try decoder.decode(PopularMovie.self, from: data)
                self.presenter?.setListOfMovies(with: movieResponse.results)
            } catch {
                print("Error decoding data:", error)
                // Handle decoding error, maybe show an alert?
                // For example:
                // self.showErrorAlert(message: "Error decoding data: \(error)")
            }
        }.resume()
    }
    
    func returnRequest() -> URLRequest {
        let url = URL(string: "https://api.themoviedb.org/3/movie/popular")!
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
        let queryItems: [URLQueryItem] = [
          URLQueryItem(name: "language", value: "en-US"),
          URLQueryItem(name: "page", value: "1"),
        ]
        components.queryItems = components.queryItems.map { $0 + queryItems } ?? queryItems
        var request = URLRequest(url: components.url!)
        request.httpMethod = "GET"
        request.timeoutInterval = 10
        request.allHTTPHeaderFields = [
          "accept": "application/json",
          "Authorization": "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJlMmNlM2Q3ZDIwODNjMjA4NTBhNDNjYzRmY2ZmZTNiMiIsInN1YiI6IjYxMjk3MWRmNDJmMTlmMDA5NTc2ZmFiMSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.h3D0kylycVezUE9fQi3k4UQp5_NrY7ExrjsVGyNgLH4"
        ]
        
        return request
    }
}
