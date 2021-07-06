import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';

import 'package:faculty_list/src/bl/models/faculty.dart';

class FacultyIcon extends StatelessWidget {
  final Faculty faculty;

  const FacultyIcon({required this.faculty});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: () => Navigator.pushNamed(context, "/group", arguments: {
            'facultyId': faculty.id,
            'facultyName': faculty.name
          }),
          borderRadius: BorderRadius.all(Radius.circular(5000)),
          highlightColor: Color(0xff35b9ca).withOpacity(0.3),
          child: Ink(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: CachedNetworkImageProvider(faculty.imageUrl))),
            width: 150,
            height: 150,
          ),
        ),
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            faculty.name,
            textScaleFactor: 1.2,
          ),
        ),
      ],
    );
  }
}
