import 'dart:io';

import 'package:flutter/material.dart';

import '../models/place.dart';
import '../helpers/db_helpers.dart';

class GreatPlaces with ChangeNotifier {
  List<Place> _items = [];

  List<Place> get items {
    return [..._items];
  }

  Future<void> addPlace(String title, File image) async {
    final newPlace = Place(
        id: DateTime.now().toIso8601String(),
        title: title,
        location: null,
        image: image);

    _items.add(newPlace);
    notifyListeners();
    await DBHelper.insert('places', {
      'id': newPlace.id,
      'title': newPlace.title,
      'image': newPlace.image.path
    });
  }

  Future<void> fetchAndSetPlaces() async {
    final dataList = await DBHelper.getData("places");
    _items = dataList
        .map((item) => Place(
            id: item['id'], title: item['title'], image: File(item['image'])))
        .toList();
    notifyListeners();
  
  }
}
