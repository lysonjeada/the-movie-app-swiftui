import Foundation

enum NetworkError: Error {
    case invalidUrl
}

class AddFavoriteMovieUseCase {

    func addToFavorites(accountId: Int32, movieId: Int, completion: @escaping (Result<String, Error>) -> Void) {
        // Create URLSession
        let session = URLSession.shared
        
        guard let request = returnRequest(accountId: accountId, movieId: movieId) else {
            completion(.failure(NetworkError.invalidUrl))
            return
        }
        
        // Perform the request
        let task = session.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            // Check response
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid response"])))
                return
            }
            
            // Check status code
            if !(200...299).contains(httpResponse.statusCode) {
                completion(.failure(NSError(domain: "", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "HTTP Error"])))
                return
            }
            
            // Check for data
            guard let data = data else {
                completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                return
            }
            
            // Parse response data
            if let responseString = String(data: data, encoding: .utf8) {
                completion(.success(responseString))
            } else {
                completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Unable to parse response"])))
            }
        }
        
        // Start the task
        task.resume()
    }
    
    func returnRequest(accountId: Int32, movieId: Int) -> URLRequest? {
        // URL Components
        let baseURL = "https://api.themoviedb.org/3/account/\(accountId)/favorite"
        var urlComponents = URLComponents(string: baseURL)
        // Query Parameters
        let apiKeyQueryItem = URLQueryItem(name: "api_key", value: "e2ce3d7d2083c20850a43cc4fcffe3b2")
        urlComponents?.queryItems = [apiKeyQueryItem]
        
        if let url = urlComponents?.url {
            // Request Body
            let requestBody = [
                "media_type": "movie",
                "media_id": movieId,
                "favorite": true
            ] as [String : Any]
            
            // Create the POST request
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.httpBody = try? JSONSerialization.data(withJSONObject: requestBody, options: [])
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpMethod = "POST"
            request.allHTTPHeaderFields = [
                "accept": "application/json",
                "Authorization": "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJlMmNlM2Q3ZDIwODNjMjA4NTBhNDNjYzRmY2ZmZTNiMiIsInN1YiI6IjYxMjk3MWRmNDJmMTlmMDA5NTc2ZmFiMSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.h3D0kylycVezUE9fQi3k4UQp5_NrY7ExrjsVGyNgLH4"
            ]
            
            return request
        }
        
        return nil
    }
}
