import SwiftUI

struct NavigationMovies: View {
    @State private var selectedMovie: MovieInfo?
    private var movies: [MovieInfo]
    
    init(movies: [MovieInfo]) {
        self.movies = movies
    }
    
    var body: some View {
        NavigationView {
            List(movies) { movie in
                Button(action: {
                    selectedMovie = movie
                }) {
                    Text(movie.name)
                }
            }
            .navigationTitle("Movies")
            .sheet(item: $selectedMovie) { movie in
                MovieDetail(type: movie.type)
            }
        }
    }
}

struct NavigationMoviesPreview: PreviewProvider {
    static var previews: some View {
        NavigationMovies(movies: [.init(name: "Popular", image: Image(systemName: "film"), type: .popularMovies), .init(name: "Favorites", image: Image(systemName: "film"), type: .favoriteMovies)])
    }
}
