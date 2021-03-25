import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:foodio/providers/app_provider.dart';
import 'package:foodio/services/db_functions.dart';
import 'package:provider/provider.dart';

import 'dot_indicator.dart';

class ImageSlider extends StatefulWidget {
  @override
  _ImageSliderState createState() => _ImageSliderState();
}

class _ImageSliderState extends State<ImageSlider> {
  DbFunctions _dbFunctions = DbFunctions();

  @override
  void initState() {
    _dbFunctions.getSliderImage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _appProvider = Provider.of<AppProvider>(context);
    return Column(
      children: [
        FutureBuilder(
          future: _dbFunctions.getSliderImage(),
          builder: (_, snapshot) {
            return snapshot.data == null
                ? Center(child: CircularProgressIndicator())
                : Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CarouselSlider.builder(
                          itemCount: snapshot.data.length,
                          itemBuilder: (context, index, h) {
                            DocumentSnapshot sliderImage = snapshot.data[index];
                            Map getImage = sliderImage.data();
                            return Image.network(
                              getImage["image"],
                              fit: BoxFit.cover,
                            );
                          },
                          options: CarouselOptions(
                            initialPage: 0,
                            autoPlay: false,
                            height: 180,
                            onPageChanged: (page, p) {
                              _appProvider.changePage(page);
                            },
                          ),
                        ),
                        DotIndicator(
                          count: snapshot.data.length,
                          currentPage: _appProvider.page,
                          size: Size.square(5.0),
                        ),
                      ],
                    ),
                  );
          },
        ),
      ],
    );
  }
}
