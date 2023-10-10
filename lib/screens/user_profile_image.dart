import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../models/chat_user.dart';

class UserProfileImage extends StatefulWidget {
  final ChatUser user;
  const UserProfileImage({Key? key, required this.user}) : super(key: key);

  @override
  State<UserProfileImage> createState() => _UserProfileImageState();
}

class _UserProfileImageState extends State<UserProfileImage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        child: Center(
          child: Hero(
            tag: 'imageHero',
            child: CachedNetworkImage(
              fit: BoxFit.fill,
              imageUrl: widget.user.image,
              errorWidget: (context, url, error) =>
              const CircleAvatar(
                child: Icon(CupertinoIcons.person),
              ),
            ),
          ),
        ),
        onTap: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}
