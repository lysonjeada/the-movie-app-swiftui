import SwiftUI

struct the_movie_appApp: App {
    let persistenceController = PersistenceController.shared
    let authenticator = Authenticator()

    var body: some Scene {
        
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
    
    
}
