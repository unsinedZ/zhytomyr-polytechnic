import 'package:flutter/material.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';

import 'package:faculty_list_abstractions/faculty_list_abstractions.dart';

class FacultyIcon extends StatelessWidget {
  final Faculty? faculty;

  const FacultyIcon({Key? key, this.faculty}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Column(
        children: [
          CachedNetworkImage(
            width: 150,
            imageUrl: faculty!.imageUrl,
            placeholder: (context, url) => Shimmer.fromColors(
              baseColor: Colors.grey,
              highlightColor: Colors.grey.shade800,
              child: Container(
                height: 20,
                width: double.infinity,
              ),
            ),
            errorWidget: (context, url, error) => Icon(Icons.error),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(faculty!.name),
          ),
        ],
      ),
    );
  }
}
