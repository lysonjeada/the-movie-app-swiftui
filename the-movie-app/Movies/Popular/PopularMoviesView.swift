import SwiftUI
import URLImage

protocol PopularMoviesViewProtocol {
    mutating func setMoviesData(with moviesData: [PopularMoviesData])
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

struct PopularMoviesView: View, PopularMoviesViewProtocol {
    
    @ObservedObject var viewModel = PopularMoviesViewModel()
    
    @State private var moviesData: [PopularMoviesData] = []
    
    let columns = [
        GridItem(.fixed(50)),
        GridItem(.fixed(50))
    ]
    
    var body: some View {
        VStack {
            if viewModel.popularMoviesData.isEmpty {
                Text("empty state")
            } else {
                ScrollView {
                    LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 2), spacing: 16) {
                        ForEach(viewModel.popularMoviesData, id: \.id) { movie in
                            MoviesView(movie: movie)
                        }
                    }
                    
                    .padding(.horizontal)
                }
                
            }
                
        }
        .onAppear {
            viewModel.loadData()
        }
    }
    
    mutating func setMoviesData(with moviesData: [PopularMoviesData]) {
        self.moviesData = moviesData
    }
}

#Preview {
    PopularMoviesView_Previews.previews
}

struct PopularMoviesView_Previews: PreviewProvider {
    static var previews: some View {
        return PopularMoviesView()
    }
}

struct MoviesView: View {
    @State private var isFavorited = false
    let movie: PopularMoviesData
    let viewModel = FavoritesViewModel()
    
    var body: some View {
        VStack(alignment: .leading) {
            ZStack(alignment: .bottomTrailing) {
                if let imageURL = URL(string: "https://image.tmdb.org/t/p/w500\(movie.image)") {
                    URLImage(imageURL) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 160, height: 300)
                            .clipped()
                            .cornerRadius(8)
                            .padding(.top, 20)
                    }
                } else {
                    Image(systemName: "photo")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 100, height: 150)
                        .clipped()
                        .cornerRadius(8)
                }
                
                Button(action: {
                    // Toggle favorite state
                    addFavorite(movieId: movie.id)
                    isFavorited.toggle()
                }) {
                    Image(systemName: isFavorited ? "heart.fill" : "heart")
                        .foregroundColor(isFavorited ? .red : .white)
                        .padding(8)
                        .background(Color.black.opacity(0.6))
                        .clipShape(Circle())
                        .padding(10)
                }
                .padding(.bottom, 10)
                .padding(.trailing, 10)
            }
            
            Text(movie.name)
                .font(.caption)
                .foregroundColor(.primary)
                .lineLimit(2)
                .padding(.top, 4)
        }
        .padding(.horizontal, 8)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    func addFavorite(movieId: Int) {
        viewModel.addToFavorites(movieId: movieId)
    }
}


struct SideMenuView: View {
    @Binding var isShowingMenu: Bool
    
    var body: some View {
        // Conteúdo do menu lateral
        Text("Side Menu")
            .onTapGesture {
                isShowingMenu.toggle()
            }
    }
}
