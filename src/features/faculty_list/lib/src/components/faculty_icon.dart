import 'package:faculty_list/src/models/faculty.dart';
import 'package:flutter/material.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';


class FacultyIcon extends StatelessWidget {
  final Faculty? faculty;

  const FacultyIcon({this.faculty});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Column(
        children: [
          CachedNetworkImage(
            width: 150,
            imageUrl: faculty!.imageUrl,
            placeholder: (context, url) => Shimmer.fromColors(
              baseColor: Colors.black,
              highlightColor: Colors.grey.shade800,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black12,
                  shape: BoxShape.circle,
                ),
                height: 150,
                width: 147.2,
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
