//
//  ContentView.swift
//  ConceptsOfSwiftUI
//
//  Created by Murali on 14/01/26.
//

import SwiftUI



struct ContentView: View {
    var body: some View {
       
        ContentView2()
        
    }
}

struct ContentView2: View {
    var body: some View {
       // LightView()
        VStack{
            Text("one")
            Text("two88")
        }
    }
}

#Preview {
    LightView()
}



//Stateobject and observed object. :: 1 

//@StateObject → This view CREATES and OWNS the object
//@ObservedObject → This view RECEIVES the object from somewhere else



class LightViewModel: ObservableObject {
    @Published var isOn: Bool = false
}

//parent
struct LightView: View {
    @StateObject private var viewModel = LightViewModel()

    var body: some View {
        VStack {
            Text(viewModel.isOn ? "💡 ON" : "💡 OFF")

            Toggle("Switch", isOn: $viewModel.isOn)

            LightStatusView(viewModel: viewModel)
        }
        .padding()
    }
}
//child
struct LightStatusView: View {
    @ObservedObject var viewModel: LightViewModel

    var body: some View {
        Text("The light is currently \(viewModel.isOn ? "ON" : "OFF")")
            .foregroundColor(.gray)
    }
}


//One unified example (everything together)

class ProfileViewModel: ObservableObject {
    @Published var username = "Alex"
}

struct ParentView: View {
    @State private var isEditing = false
    @StateObject private var vm = ProfileViewModel()

    var body: some View {
        ChildView(
            isEditing: $isEditing,
            vm: vm
        )
    }
}

struct ChildView: View {
    @Binding var isEditing: Bool
    @ObservedObject var vm: ProfileViewModel

    var body: some View {
        VStack {
            Text(vm.username)

            Toggle("Editing", isOn: $isEditing)
        }
    }
}

//What to notice
//Parent owns everything
//Child modifies & observes
//One source of truth
//Zero sync bugs

/*
Side-by-side comparison (smooth mapping)
@State                       @StateObject
Owns a value                 Owns a reference
Recreated automatically      Created once
Lightweight UI state         Heavy logic / models

Both mean:

“This view is the source of truth”

@Binding                  @ObservedObject
Borrows a value           Borrows a reference
No ownership              No ownership
Reads + writes            Observes + reacts

*/



//Simple example for the diff mechanisum: 3

struct CounterView: View {
    @State private var count = 0

    var body: some View {
        VStack {
            Text("Count: \(count)")
            Button("Increment") {
                count += 1
            }
        }
    }
}

/*What happens when you tap the button
count changes
body is recalculated
SwiftUI compares:
old Text("Count: 0")
new Text("Count: 1")
Only the text node updates
VStack and Button stay untouched. */


//SwiftUI decides a view is the same as before using:

//NOTE: Type + position in the hierarchy + identity (id)


//Note: viewbuilder concept.
struct ContentView1: View {
    @State private var isLoggedIn = false

    var body: some View {
        VStack(spacing: 20) {
            // Use the ViewBuilder function within the VStack
            userStatusView(isLoggedIn: isLoggedIn)

            Button(isLoggedIn ? "Log Out" : "Log In") {
                isLoggedIn.toggle()
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
        .padding()
    }

    // A function marked with @ViewBuilder can return different views conditionally
    @ViewBuilder
    func userStatusView(isLoggedIn: Bool) -> some View {
        if isLoggedIn {
            Text("Welcome back, user!")
                .font(.headline)
                .foregroundColor(.green)
            Image(systemName: "person.circle.fill") // Multiple views allowed
                .imageScale(.large)
        } else {
            Text("Please log in to continue.")
                .font(.subheadline)
                .foregroundColor(.red)
        }
    }
}



//geometry
struct ContentView3: View {
    var body: some View {
        GeometryReader { geometry in
            Rectangle()
                .fill(Color.blue)
                .frame(width: geometry.size.width / 2,
                       height: geometry.size.height / 2)
                .position(x: geometry.size.width / 2,
                          y: geometry.size.height / 2)
        }
        .background(Color.gray.opacity(0.2))
    }
}

struct ContentView4: View {
    
    var body: some View {
        GeometryReader { geo in
            VStack {
                Text("Top half")
                    .frame(height: geo.size.height / 2)
                    .background(Color.green)
                
                Text("Bottom half")
                    .frame(height: geo.size.height / 2)
                    .background(Color.orange)
            }
        }
    }
}

//DI

/*Dependency Injection is a technique where a class or struct doesn’t create its own dependencies but receives them from outside.
Why? Makes code modular, testable, and reusable.
In SwiftUI, DI is commonly done using:
@EnvironmentObject
@StateObject
@ObservedObject*/

class UserService {
    func getUserName() -> String {
        return "Alice"
    }
}


class UserViewModel: ObservableObject {
    @Published var name: String = ""
    
    private let service: UserService
    
    // Inject the service through initializer
    init(service: UserService) {
        self.service = service
        fetchName()
    }
    
    func fetchName() {
        name = service.getUserName()
    }
}


struct ContentVie: View {
    @StateObject var viewModel: UserViewModel
    
    var body: some View {
        Text("Hello, \(viewModel.name)!")
            .padding()
    }
}


struct MyApp: App {
    var body: some Scene {
        WindowGroup {
            // Injecting UserService into UserViewModel
            ContentVie(viewModel: UserViewModel(service: UserService()))
        }
    }
}

//Viewmodifier:

struct MyModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
    }
}



/*
Text("Hello, SwiftUI!")
    .modifier(MyModifier()) */


/*Benefits:
No repeated styling code
Customizable (color parameter)
Clean & readable*/



//Environment object::



struct MyApp: App {
    @StateObject var counter = Counter() // single source of truth
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(counter) // inject into environment
        }
    }
}

class Counter: ObservableObject {
    @Published var value = 0
}



/////////***
///
///
/////
//  Combine.swift
//  ConceptsOfSwiftUI
//
//  Created by Murali on 16/01/26.
//

import Foundation


//More about the combine framework.
//Combine lets your app react automatically when data changes...







//Before Combine:
/*
fetchUser { user in
    fetchPosts(user) { posts in
        DispatchQueue.main.async {
            self.updateUI(posts)
        }
    }
}
 
 */
//Issues: Multiple callback leads difficulty in testig, hard to cancel.

//Combine:
/*
Core Combine Concepts

Publisher    Something that produes values over time
Subscriber    Something that listens
Operator    Transforms values (map, filter, etc.)
Subscription    The connection between them
Cancellable    A handle to stop listening
 */


//Finally: Publisher → Operators → Subscriber

/*1::Publisher

Examples:
A text field sending text as user types
A network request sending data when it finishes
A timer sending a value every second
*/

//2::Subscriber
/*Examples:
Update a label
Enable a button
Save data
*/


//3::Value
/*The actual data flowing
Examples:
String
Int
User
[Post] */

//NOTE: Publisher does NOT push values until someone subscribes



/*Publisher
   |
|  sends VALUES (data like int, float, user,posts)
   v
Subscriber
 */

/*if The subscriber subscribes to the publisher
    The publisher sends values to the subscriber */



//Why We Store AnyCancellable

/*var cancellables = Set<AnyCancellable>()
Subscription lives as long as it’s stored
Remove it → stream stops */


//
let emailPublisher = NotificationCenter.default
    .publisher(for: UITextField.textDidChangeNotification, object: emailTextField)
    .compactMap { ($0.object as? UITextField)?.text }

let passwordPublisher = NotificationCenter.default
    .publisher(for: UITextField.textDidChangeNotification, object: passwordTextField)
    .compactMap { ($0.object as? UITextField)?.text }



let emailValidPublisher = emailPublisher
    .map { text in
        text.contains("@") && text.contains(".")
    }

let passwordValidPublisher = passwordPublisher
    .map { $0.count >= 8 }



Publishers.CombineLatest(emailValidPublisher, passwordValidPublisher)
    .map { isEmailValid, isPasswordValid in
        isEmailValid && isPasswordValid
    }
    .receive(on: RunLoop.main)
    .sink { isFormValid in
        loginButton.isEnabled = isFormValid
    }
    .store(in: &cancellables)

/* User types →
 TextField publishes text →
 Validation publishers emit Bool →
 CombineLatest merges →
 sink updates button

 */


