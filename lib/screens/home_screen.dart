import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wechat/models/chat_user.dart';
import 'package:wechat/screens/profile_screen.dart';
import 'package:wechat/widgets/char_user_card.dart';
import '../controllers/auth_controller.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<ChatUser> _list = [];

  // ignore: prefer_final_fields
  List<ChatUser> _searchlist = [];
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    AuthController.usergetSelfExists();
    userActiveInfo();
  }

  void userActiveDetachedInfo() {
    SystemChannels.lifecycle.setMessageHandler((message) {
      if (message.toString().contains('inactive')) {
        AuthController.updateActiveStatus(false);
      }
      if (message.toString().contains('detached')) {
        AuthController.updateActiveStatus(false);
      }
      return Future.value(message);
    });
  }

  void userActiveInfo() {
    SystemChannels.lifecycle.setMessageHandler((message) {
      if (message.toString().contains('resume')) {
        AuthController.updateActiveStatus(true);
      }
      if (message.toString().contains('pause')) {
        AuthController.updateActiveStatus(false);
      }

      return Future.value(message);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus;
        _isSearching = false;
        setState(() {});
      },
      child: WillPopScope(
        onWillPop: () async {
          AuthController.updateActiveStatus(true);
          userActiveDetachedInfo();
          return true;
        },
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.black,
            leading: const Icon(CupertinoIcons.home),
            title: _isSearching
                ? TextField(
                    autofocus: true,
                    style: const TextStyle(color: Colors.white, fontSize: 18),
                    onChanged: (val) {
                      _searchlist.clear();

                      for (var i in _list) {
                        if (i.name.toLowerCase().contains(val.toLowerCase()) ||
                            i.email.toLowerCase().contains(val.toLowerCase())) {
                          _searchlist.add(i);
                        }
                        setState(() {
                          _searchlist;
                        });
                      }
                    },
                    decoration: const InputDecoration(
                      hintStyle: TextStyle(color: Colors.white),
                      hintText: 'Name, Email...',
                      border: InputBorder.none,
                    ),
                  )
                : const Text('WeChat'),
            actions: [
              IconButton(
                  onPressed: () {
                    setState(() {
                      _isSearching = !_isSearching;
                    });
                  },
                  icon: _isSearching
                      ? const Icon(CupertinoIcons.clear_circled_solid)
                      : const Icon(Icons.search)),
              IconButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => ProfileScreen(
                                  user: AuthController.me,
                                )));
                  },
                  icon: const Icon(Icons.more_vert)),
            ],
          ),
          floatingActionButton: Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: FloatingActionButton(
              onPressed: () async {
                // await AuthController.auth.signOut();
                // await GoogleSignIn().signOut();
              },
              child: const Icon(
                Icons.add_comment_rounded,
                color: Colors.white,
              ),
            ),
          ),
          body: StreamBuilder(
            stream: AuthController.getAllUsers(),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                case ConnectionState.none:
                  return const Center(child: CircularProgressIndicator());
                case ConnectionState.active:
                case ConnectionState.done:
                  final data = snapshot.data?.docs;
                  _list =
                      data?.map((e) => ChatUser.fromJson(e.data())).toList() ??
                          [];

                  if (_list.isNotEmpty) {
                    return ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        itemCount:
                            _isSearching ? _searchlist.length : _list.length,
                        itemBuilder: (context, index) {
                          return ChatUserCard(
                              user: _isSearching
                                  ? _searchlist[index]
                                  : _list[index]);
                        });
                  } else {
                    return const Center(
                        child: Text(
                      'No Connection Found!',
                      style: TextStyle(fontSize: 20),
                    ));
                  }
              }
            },
          ),
        ),
      ),
    );
  }
}
