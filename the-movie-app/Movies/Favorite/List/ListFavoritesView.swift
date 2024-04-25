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
                            FavoriteMovieView(movie: movie)
                        }
                    }
                    .padding(.horizontal) // Ajuste opcional se desejar algum espaço adicional nos lados
                }
            }
        }
        .padding(.top, 20)
        .onAppear {
            viewModel.fetchFavorites()
        }
        .background(Color.black.opacity(0.9).edgesIgnoringSafeArea(.all))
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

class PopularMoviesData: ObservableObject, Identifiable {
    @Published var id: Int
    @Published var image: String
    @Published var name: String
    
    init(id: Int, image: String, name: String) {
        self.id = id
        self.image = image
        self.name = name
    }
}
