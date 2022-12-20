var aracnumarasi = 1
        var yenibirdizi = [[Double]: Int]()
        for i in unscaleData{
            for a in i {
               
                yenibirdizi[a] = aracnumarasi
            }
            aracnumarasi = aracnumarasi + 1
        }
        print(yenibirdizi)
        
        //let firestoreDatabase = Firestore.firestore()
        let semaphore = DispatchSemaphore(value: 0)

        for (key, value) in yenibirdizi {
            
            
            let longitude = key[1]
            let latitude = key[0]
            let point = [GeoPoint(latitude: latitude, longitude: longitude)]
            let geoPoint = point[0]
            let docRef = Firestore.firestore().collection("information").whereField("location", isEqualTo: geoPoint)
            
            docRef.getDocuments { (querySnapshot, error) in
                  if let error = error {
                     print(error.localizedDescription)
                     return
                  }
                  guard let documents = querySnapshot?.documents else { return }
                  for document in documents {
                     document.reference.updateData(["arac": value])
                      print(value)
                  }
               }
            }
