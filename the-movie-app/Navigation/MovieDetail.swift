import Foundation
import SwiftUI

enum MovieType {
    case popularMovies
    case favoriteMovies
}

struct MovieInfo: Identifiable, Hashable {
    var id = UUID()
    let name: String
    let image: String
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
                    HomeView()
                    
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
