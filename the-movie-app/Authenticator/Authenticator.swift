import Foundation

enum AuthenticationState {
    case loading
    case success
    case failure
}

class Authenticator {
    
    func authenticate(completion: @escaping (Bool) -> ()) {
        URLSession.shared.dataTask(with: returnRequest()) { data, response, error in
            if let error = error {
                print("Error fetching data:", error)
                // Handle the error here, maybe call completion with an error?
                // For example:
                // completion(.failure(error))
                return
            }
            
            guard let data = data else {
                print("No data received")
                // Handle the case where there is no data
                // For example:
                // completion(.failure(NetworkError.noData))
                return
            }
            
            do {
                let authenticatorResponse = try JSONDecoder().decode(AuthenticatorResponse.self, from: data)
                completion(authenticatorResponse.success)
            } catch {
                print("Error decoding data:", error)
                // Handle the decoding error
                // For example:
                // completion(.failure(NetworkError.decodingError))
            }
        }.resume()
    }
    
    func returnRequest() -> URLRequest {
        let url = URL(string: "https://api.themoviedb.org/3/authentication")!
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = [
            "accept": "application/json",
            "Authorization": "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJlMmNlM2Q3ZDIwODNjMjA4NTBhNDNjYzRmY2ZmZTNiMiIsInN1YiI6IjYxMjk3MWRmNDJmMTlmMDA5NTc2ZmFiMSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.h3D0kylycVezUE9fQi3k4UQp5_NrY7ExrjsVGyNgLH4"
        ]
        
        return request
    }
}
