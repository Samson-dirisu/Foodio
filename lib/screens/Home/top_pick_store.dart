import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:foodio/providers/location_provider.dart';
import 'package:foodio/services/store_service.dart';
import 'package:provider/provider.dart';

class TopPickStore extends StatelessWidget {
  final StoreServices _storeServices = StoreServices();
  @override
  Widget build(BuildContext context) {
    var locationProvider = Provider.of<LocationProvider>(context);
    return Container(
      child:  StreamBuilder<QuerySnapshot>(
        stream: _storeServices.getTopPickedStore(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) return CircularProgressIndicator();
          locationProvider.getVendorsLatLng(snapshot);

          return  Column(
            children: [
              Container(
                child: Flexible(
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: snapshot.data.docs.map((document) {
                      // show stores within 10km
                      if (double.parse(locationProvider
                              .getDistance(document['location'])) <=
                          10.0) {
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
                                  "${locationProvider.getDistance(document['location'])}km",
                                  style: TextStyle(
                                    color: Colors.grey,
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      } else {
                        return Container();
                      }
                    }).toList(),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
