// Firestore database'ine bağlanma işlemi
        func updateFirestore(aracnumarasi: Int, longitude: Double, latitude: Double, completion: @escaping (Error?) -> Void) {
          let firestoreDatabase = Firestore.firestore()
          let location = [GeoPoint(latitude: latitude, longitude: longitude)]
          let geoPoint = location[0]
          firestoreDatabase.collection("information").whereField("location", isEqualTo: geoPoint).getDocuments { [self] (snapshot, error) in
            if let error = error {
              completion(error)
              return
            } else {
              for document in snapshot!.documents {
                document.reference.updateData(["arac": aracnumarasi])
              }
            }
            completion(nil)
          }
        }

        var aracnumarasi = 1
        let queue = DispatchQueue(label: "updateQueue")

        for i in unscaleData {
            queue.sync {
                aracnumarasi += 1
                for a in i {
                    let longitude = a[1]
                    let latitude = a[0]

                    let semaphore = DispatchSemaphore(value: 0)
                    updateFirestore(aracnumarasi: aracnumarasi, longitude: longitude, latitude: latitude) { error in
                        if let error = error {
                            // Handle the error here
                            print(error.localizedDescription)
                        }
                        
                        semaphore.signal()
                        print("getsignal")
                    }
                    semaphore.wait()
                }
            }
        }
