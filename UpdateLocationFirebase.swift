// Firestore database'ine bağlanma işlemi
let db = Firestore.firestore()

// Eşleşen kaydı bulma ve güncelleme işlemi
db.collection("collection_name").whereField("email", isEqualTo: email)
    .getDocuments { (querySnapshot, error) in
        if let error = error {
            // Hata mesajı gösterin
            return
        } else {
            for document in querySnapshot!.documents {
                // Eşleşen kaydı güncelleyin
                document.reference.updateData(["location": updatedLocation])
            }
        }
    }
//denendi başarısız
