import SwiftUI
import URLImage

struct ListMovieFavoritesView: View {
    
    @ObservedObject var viewModel = ListMoviesFavoritesViewModel()
    
    @State private var moviesData: [PopularMoviesData] = []
    
    let columns = [
        GridItem(.fixed(50)),
        GridItem(.fixed(50))
    ]
    
    var body: some View {
        VStack {
            if viewModel.favorites.isEmpty {
                Text("empty state")
            } else {
                ScrollView {
                    LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 2), spacing: 16) {
                        ForEach(viewModel.favorites, id: \.id) { movie in
                            MoviesView(movie: movie)
                        }
                    }
                    .padding(.horizontal)
                }
            }
        }
        .onAppear {
            viewModel.fetchFavorites()
        }
    }
}

#Preview {
    ListMovieFavoritesView_Previews.previews
}

struct ListMovieFavoritesView_Previews: PreviewProvider {
    static var previews: some View {
        return ListMovieFavoritesView()
    }
}

