import 'package:flutter/material.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';

import 'package:faculty_list/src/bl/models/faculty.dart';

class FacultyIcon extends StatelessWidget {
  final Faculty faculty;

  const FacultyIcon({required this.faculty});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, "/group", arguments: faculty.id),
      child: Column(
        children: [
          CachedNetworkImage(
            width: 150,
            imageUrl: faculty.imageUrl,
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
            child: Text(faculty.name, textScaleFactor: 1.2,),
          ),
        ],
      ),
    );
  }
}
