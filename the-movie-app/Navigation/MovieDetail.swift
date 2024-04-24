import Foundation
import SwiftUI

enum MovieType {
    case popularMovies
    case favoriteMovies
}

struct MovieInfo: Identifiable, Hashable {
    var id = UUID()
    let name: String
    let image: Image
    let type: MovieType
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
    }
}

struct MovieDetail: View {
    @Environment(\.presentationMode) var presentationMode
    let type: MovieType
    
    init(type: MovieType = .popularMovies){
        UITabBar.appearance().backgroundColor = .white
        self.type = type
    }
    
    var body: some View {
        NavigationView {
            switch type {
            case .popularMovies:
                NavigationStack {
                    TabView {
                        PopularMoviesView()
                            .tabItem {
                                Image(systemName: "film")
                                Text("Popular Movies")
                            }
                        TopRatedMovieView()
                            .tabItem {
                                Image(systemName: "film")
                                Text("Top Rated Movies")
                            }
                        UpcomingMovieView()
                            .tabItem {
                                Image(systemName: "film")
                                Text("Upcoming Movies")
                            }
                            .toolbarBackground(.automatic, for: .tabBar)
                    }
                    
                }
            case .favoriteMovies:
                ListMovieFavoritesView()
            }
            
            
        }
        .padding()
        .navigationTitle("Movies")
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .edgesIgnoringSafeArea(.all)
    }
    
    var closeButton: some View {
        Button(action: {
            presentationMode.wrappedValue.dismiss()
        }) {
            Image(systemName: "chevron.left")
                .imageScale(.large)
        }
    }
}
