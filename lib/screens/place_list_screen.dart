import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './add_place_screen.dart';
import '../providers/great_places.dart';
import '../screens/place_detail_screen.dart';

class PlacesListScreen extends StatelessWidget {
  const PlacesListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Your Places'),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(AddPlaceScreen.routeName);
                },
                icon: Icon(Icons.add))
          ],
        ),
        body: FutureBuilder(
          future: Provider.of<GreatPlaces>(context, listen: false)
              .fetchAndSetPlaces(),
          builder: (ctx, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return Consumer<GreatPlaces>(
                builder: (context, gp, child) {
                  if (gp.items.length <= 0) {
                    return child!;
                  } else {
                    return ListView.builder(
                      itemCount: gp.items.length,
                      itemBuilder: (ctx, idx) {
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundImage: FileImage(gp.items[idx].image),
                          ),
                          title: Text(gp.items[idx].title),
                          subtitle: Text(gp.items[idx].location.address),
                          onTap: () {
                            Navigator.of(context).pushNamed(
                                PlaceDetailScreen.routeName,
                                arguments: gp.items[idx].id);
                          },
                        );
                      },
                    );
                  }
                },
                child: const Center(
                    child: Text("Got no places yet, start adding some!")),
              );
            }
          },
        ));
  }
}
