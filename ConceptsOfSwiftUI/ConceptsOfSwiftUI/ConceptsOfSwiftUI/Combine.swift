//
//  Combine.swift
//  ConceptsOfSwiftUI
//
//  Created by Murali on 16/01/26.
//

import Foundation


//TODO: cold publisher, hotpublishrer and backpressure.




//More about the combine framework.
//Combine lets your app react automatically when data changes...



//Before Combine:

fetchUser { user in
    fetchPosts(user) { posts in
        DispatchQueue.main.async {
            self.updateUI(posts)
        }
    }
}
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



Publisher
   |
|  sends VALUES (data like int, float, user,posts)
   v
Subscriber

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
