import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:foodio/services/store_service.dart';
import 'package:geolocator/geolocator.dart';

class TopPickStore extends StatefulWidget {
  @override
  _TopPickStoreState createState() => _TopPickStoreState();
}

class _TopPickStoreState extends State<TopPickStore> {
  StoreServices _storeServices = StoreServices();
  @override
  Widget build(BuildContext context) {
    return Container(
      child: StreamBuilder<QuerySnapshot>(
        stream: _storeServices.getTopPickedStore(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) return CircularProgressIndicator();
          
          return Column(
            children: [
              Flexible(
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: snapshot.data.docs.map((document) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        // color: Colors.red,
                        width: 80,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 80.0,
                              width: 80.0,
                              child: Card(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(4.0),
                                  child: Image.network(document['imageUrl'],
                                      fit: BoxFit.cover),
                                ),
                              ),
                            ),
                            Container(
                              height: 35,
                              child: Text(
                                document['shopName'],
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Text(
                              '20km',
                              style: TextStyle(
                                color: Colors.grey, //fontSize: 10
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
