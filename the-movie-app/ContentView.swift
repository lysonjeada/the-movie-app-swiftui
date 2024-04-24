import SwiftUI
import CoreData

class AppState: ObservableObject {
    @Published var hasAuthenticated: Bool

    init(hasAuthenticated: Bool) {
        self.hasAuthenticated = hasAuthenticated
    }
}

@main
struct DemoApp: App {
    @StateObject var appState = AppState(hasAuthenticated: false)
    let movies = [MovieInfo(name: "Popular", image: Image(systemName: "film"), type: .popularMovies), .init(name: "Favorites", image: Image(systemName: "film"), type: .favoriteMovies)]
    
    var body: some Scene {
        WindowGroup {
            if appState.hasAuthenticated {
                NavigationMovies(movies: movies)
                    .environmentObject(appState)
            } else {
                ContentView()
                    .environmentObject(appState)
            }
        }
    }
}

struct ContentView: View {
    @State private var authenticationState: AuthenticationState = .loading
    @EnvironmentObject var appState: AppState
    private var authenticator: Authenticator
    
    init(authenticator: Authenticator = Authenticator()) {
        self.authenticator = authenticator
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                switch authenticationState {
                case .loading:
                    ProgressView("Loading...")
                case .success:
                    Text("Authentication successful!")
                        .foregroundColor(.green)
                    Button {
                        appState.hasAuthenticated = true
                    } label: {
                        Text("go to root view")
                    }
                case .failure:
                    Text("Authentication failed!")
                        .foregroundColor(.red)
                }
            }
        }
        
        .onAppear {
            authenticator.authenticate { success in
                if success {
                    authenticationState = .success
                } else {
                    authenticationState = .failure
                }
            }
        }
    }
}

#Preview {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
