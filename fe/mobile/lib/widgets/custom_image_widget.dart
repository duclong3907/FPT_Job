import 'dart:convert';

import 'package:flutter/material.dart';
class CustomImageWidget extends StatelessWidget {
  final String imagePath;

  CustomImageWidget({required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 200,
      child: imagePath.startsWith('data:image')
          ? Image.memory(
        base64Decode(imagePath.split(',').last),
        fit: BoxFit.cover,
      )
          : Image.network(
        imagePath,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, progress) {
          if (progress == null) return child;
          return Center(child: const CircularProgressIndicator());
        },
      ),
    );
  }
}