 let firestoreDatabase = Firestore.firestore()

        var aracnumarasi = 1

        for i in unscaleData {
            
            for a in i {
                let queue = DispatchQueue(label: "updateQueue")

                queue.sync(flags: .barrier){
                    let longitude = a[1]
                    let latitude = a[0]
                    let point = [GeoPoint(latitude: latitude, longitude: longitude)]
                    let geoPoint = point[0]
                    
                    
                    //let semaphore = DispatchSemaphore(value: 0)
                    firestoreDatabase.collection("information").whereField("location", isEqualTo: geoPoint).getDocuments { [self] (snapshot, error) in
                        if let error = error {
                            return
                        } else {
                            for document in snapshot!.documents {
                                print("burayagirdi")
                                document.reference.updateData(["arac": aracnumarasi])
                            }
                        }
                        
                        //semaphore.signal()
                        print("getsignal")
                    }
                    //semaphore.wait()
                }
                aracnumarasi += 1
            }}
