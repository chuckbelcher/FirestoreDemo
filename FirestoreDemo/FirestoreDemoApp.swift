//
//  FirestoreDemoApp.swift
//  FirestoreDemo
//
//  Created by Chuck Belcher on 8/4/23.
//

import SwiftUI
import Firebase
//import FirebaseFirestore

@main
struct FirestoreDemoApp: App {
    
    init() {
        FirebaseApp.configure()
        //deleteReservation()
        //makeReservation()
        //updateReservation()
        //errorHandling()
        //readData()
        //readAllDocs()
        //watchForChangesOnCollection()
        //getTodaysReservations()
        useCompositeQuery()
    }
    
    func useCompositeQuery() {
        let db = Firestore.firestore()
        let reservations = db.collection("reservations")
        
        let query = reservations
            .whereField("name", in: ["Chuck", "Steve", "Susan"])
            .whereField("people", isLessThan: 17)
        
        query.getDocuments { querySnapshot, error in
            if let error = error {
                print(error)
            } else if let querySnapshot = querySnapshot {
                //cool code goes here
                for doc in querySnapshot.documents {
                    print(doc.data())
                }
            } else {
                print("No data found")
            }
        }
    }
    
    
    func getTodaysReservations() {
        let db = Firestore.firestore()
        let reservations = db.collection("reservations")
        
        let q1 = reservations.whereField("name", in: ["Chuck", "Steve"])
        let q2 =  reservations.whereField("name", notIn: ["Chuck", "Susan"])
        q1.getDocuments { querySnapshot, error in
            if let error = error {
                print(error)
            } else if let querySnapshot = querySnapshot {
                //cool code goes here
                for doc in querySnapshot.documentChanges {
                    print(doc.document.data())
                }
            } else {
                print("No data found")
            }
        }
        
    }
    
    
    func watchForChangesOnCollection() {
        let db = Firestore.firestore()
        let reservations = db.collection("reservations")
        
        //add snapshot listener
        let collectionListener = reservations.addSnapshotListener { querySnapshot, error in
            if let error = error {
                print(error)
            } else if let querySnapshot = querySnapshot {
                //cool code goes here
                for doc in querySnapshot.documentChanges {
                    print(doc.document.data())
                }
            } else {
                print("No data found")
            }
        }
        
        //App cleanup
        //remove listeners
        //collectionListener.remove()
    }
    
    func watchForChanges() {
        let db = Firestore.firestore()
        let reservation = db.collection("reservations").document("test123")
        
        //add snapshot listener
        reservation.addSnapshotListener { docSnapshot, error in
            if let error = error {
                print(error)
            } else if let docSnapshot = docSnapshot {
                //cool code goes here
                print(docSnapshot.data()!)
            } else {
                print("No data found")
            }
        }
    }
    
    func readAllDocs() {
        let db = Firestore.firestore()
        let reservations = db.collection("reservations")
        
        reservations.getDocuments { querySnapshot, error in
            if let error = error {
                print(error)
            } else if let querySnapshot = querySnapshot {
                //code here
                for doc in querySnapshot.documents {
                    print("#########################")
                    print(doc.documentID)
                    print(doc.data())
                }
            } else {
                print("No data returned")
            }
        }
    }
    func readData() {
        let db = Firestore.firestore()
        let reservation = db.collection("reservations").document("test123")
        
        reservation.getDocument { docSnapshot, error in
            //Check for error
            if let error = error {
                print(error.localizedDescription)
            } else if let docSnapshot = docSnapshot {
                print(docSnapshot.data()!)
                print(docSnapshot.documentID)
            } else {
                print("No data returned")
            }
        }
    }
    
    func errorHandling() {
        let db = Firestore.firestore()
        let reservations = db.collection("reservations")
        let r1 = reservations.addDocument(data: ["name": "Purduple1", "people": 4]) { (error) in
            //was there an error
            if let error = error {
                print(error.localizedDescription)
            } else {
                return
            }
        }
    }
    
    func deleteReservation() {
        let db = Firestore.firestore()
        let reservations = db.collection("reservations")
        
        //Create sample data to remove
        let r1 = reservations.addDocument(data: ["name": "Steve", "people": 4])
        let r2 = reservations.addDocument(data: ["name": "Katey", "people": 9])
        
        //Delete a single field in the document
        r1.updateData(["people": FieldValue.delete()])
        
        //Delete an entire document
        r2.delete()
    }
    
    func updateReservation() {
        let db = Firestore.firestore()
        let reservation = db.collection("reservations").document("test123")
        
        //reservation.setData(["people" : 24], merge: true)
        reservation.updateData(["people" : 24])
    }
    
    func makeReservation() {
        let db = Firestore.firestore()
        let reservations = db.collection("reservations")
        
        //Create a document with a given identifier
        reservations.document("test123").setData(["name" : "Carol", "people": 22])
        
        //Create a documenet with a uniq identifier
        reservations.document().setData(["name" : "Amy"])
        
        
        //Create a documetn with given data
        let document = reservations.addDocument(data: ["name" : "Susan", "people": 2])
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
