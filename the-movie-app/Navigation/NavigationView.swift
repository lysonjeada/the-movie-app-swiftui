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
                    NavigationLink(destination: MovieDetail(type: movie.type)) {
                        Text(movie.name)
                    }
                }
                .navigationTitle("Movies")
            }
        }
}

struct NavigationMoviesPreview: PreviewProvider {
    static var previews: some View {
        NavigationMovies(movies: [.init(name: "Popular", image: Image(systemName: "film"), type: .popularMovies), .init(name: "Favorites", image: Image(systemName: "film"), type: .favoriteMovies)])
    }
}
