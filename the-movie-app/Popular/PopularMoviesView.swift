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
    
    var body: some View {
            VStack {
                if viewModel.popularMoviesData.isEmpty {
                    Text("empty state")
                } else {
                    List(viewModel.popularMoviesData) { movie in
                        VStack(alignment: .leading) {
                            Text(movie.name)
                                .font(.title)
                            if let imageURL = URL(string: "https://image.tmdb.org/t/p/w500\(movie.image)") {
                                URLImage(imageURL) { image in
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 100, height: 150)
                                }
                            } else {
                                Image(systemName: "photo")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 100, height: 150)
                            }
                        }
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

enum PopularMoviesViewFactory {
    static func build() -> PopularMoviesView {
        var view = PopularMoviesView()
    
        return view
    }
}
