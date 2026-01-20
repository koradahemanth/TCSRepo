//
//  ContentviewOne.swift
//  ConceptsOfSwiftUI
//
//  Created by Murali on 14/01/26.
//

import Foundation


struct ContentView: View {
    var body: some View {
       
        ContentViewWithVStack()
        
    }
}

/*
//VStack advantages and when required:
It arranges views vertically
It does NOT scroll
It shows everything at once
 
 Limitations:
 Use only limited items, donot use for the bigger lists.

*/

struct ContentViewWithVStack: View {
    var body: some View {
       // LightView()
        VStack{
            Text("one")
            Text("two88")
        }
    }
}

/*
Acts like VStack
BUT creates views only when visible
MUST be inside ScrollView
Use for many
*/

ScrollView {
    LazyVStack {
        ForEach(1...1000, id: \.self) { number in
            Text("Item \(number)")
        }
    }
}



/*List already includes:
Scrolling
Layout
Performance
Use when you want a normal iOS  types of list
 */


List {
    Text("Apple")
    Text("Banana")
}

//OR::
List(fruits, id: \.self) { fruit in
    Text(fruit)
}



/*Choose List if you want:
A normal vertical list
Row separators
Swipe to delete
Swipe actions
Reordering
Automatic performance handling */

/*
 Use ScrollView + LazyVStack (custom UI)
 Choose this when you need:
 Custom spacing
 Cards
 Big images
 Animations
 No separators
 A non-list look
 like:
 Real-life example
 Instagram feed
 Custom dashboard
 Cards UI
 */


//ALternative of the struture with identifible

struct Fruit: Identifiable {
    let id = UUID()
    let name: String
}

let fruits = [
    Fruit(name: "Apple"),
    Fruit(name: "Banana"),
    Fruit(name: "Orange")
]

List(fruits) { fruit in
    Text(fruit.name)
}


//suppose if id is no thre, the process is like below:

/*
problems UnitArea
Problem:

You must manually choose an id
Risky if name is not unique */
        
            
struct Fruit {
    let idd: UUID()
    let name: String
}

let fruits = [
    Fruit(name: "Apple"),
    Fruit(name: "Banana"),
    Fruit(name: "Orange")
]

List(fruits, id: \.idd) { fruit in
    Text(fruit.name)
}


//TASK{}

//HERE Button actions are not async But fetchData() is async
//Without Task You cannot call await  and also the Compiler error in picture.


Button("Load Data") {
    Task {
        let data = await fetchData()
        print(data)
    }
}

//About @Mainactor:

func loadData() async {
    let data = await fetchData()
    text = data
}

//safe: all properties and methods are thread safe.

@MainActor
class ViewModel: ObservableObject {
    @Published var text = ""
}


//Async let:

//without async let
let user = await fetchUser()
let posts = await fetchPosts()


//With async let

async let user = fetchUser()
async let posts = fetchPosts()

let userData = await user
let postsData = await posts


func loadScreen() async {
    async let profile = fetchProfile()
    async let messages = fetchMessages()

    let p = await profile
    let m = await messages

    print(p, m)
}


//All working together:

@MainActor
class ViewModel: ObservableObject {
    @Published var title = ""

    func load() {
        Task {
            async let user = fetchUser()
            async let score = fetchScore()

            let name = await user
            let points = await score

            title = "\(name) - \(points)"
        }
    }
}


