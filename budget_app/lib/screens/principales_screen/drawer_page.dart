import 'package:flutter/material.dart';

import '../../values.dart';

class DrawerPage extends StatefulWidget {
  final bool drawerIsOpen;
  const DrawerPage({Key? key, required this.drawerIsOpen}) : super(key: key);

  @override
  State<DrawerPage> createState() => _DrawerPageState();
}

class _DrawerPageState extends State<DrawerPage> {
  // final AuthServices _auth = AuthServices();
  double _xOffset = -100.0;
  double _yOffset = -100.0;
  //bool _drawerIsOpen = false;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Container(
      height: double.infinity,
      width: double.infinity,
      decoration: const BoxDecoration(
        color: bColor,
      ),
      child: AnimatedContainer(
        duration: const Duration(
          milliseconds: 500,
        ),
        transform: Matrix4.translationValues(
            widget.drawerIsOpen ? 0.0 : -300.0, 0.0, 0.0)
        //..scale(widget.drawerIsOpen ? 1.0 : 0.3)
        ,
        child: Padding(
          padding: const EdgeInsets.only(left: 20.0, top: 40.0, bottom: 60.0),
          child: SizedBox(
            width: size.width * 0.1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Hello,\nKais Mabrouk',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
                Container(
                  height: size.height * 0.4,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      InkWell(
                        onTap: () {},
                        child: _listTitleElement(
                            context, Icons.home_rounded, "home"),
                      ),
                      InkWell(
                        onTap: () {},
                        child: _listTitleElement(
                            context, Icons.person_rounded, "Profile"),
                      ),
                      InkWell(
                        onTap: () {},
                        child: _listTitleElement(
                            context, Icons.local_atm, "Balance"),
                      ),
                      InkWell(
                        onTap: () {},
                        child: _listTitleElement(
                            context, Icons.shopping_basket_rounded, "Cart"),
                      ),
                      InkWell(
                        onTap: () {},
                        child: _listTitleElement(
                            context, Icons.favorite_rounded, "Favorites"),
                      ),
                      InkWell(
                        onTap: () {},
                        child: _listTitleElement(context, Icons.help, "Help"),
                      ),
                      InkWell(
                        onTap: () {},
                        child: _listTitleElement(
                            context, Icons.settings_rounded, "Settings"),
                      ),
                    ],
                  ),
                ),
                const Divider(color: Colors.white),
                InkWell(
                  onTap: () async {
                    // await _auth.signOut();
                    setState(() {});
                  },
                  child: _listTitleElement(context, Icons.logout, "Logout"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  SizedBox _listTitleElement(
      BuildContext context, IconData iconData, String txt) {
    return SizedBox(
      width: 200,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(iconData, color: Colors.yellow),
                  const SizedBox(width: 10),
                  Text(txt, style: const TextStyle(color: Colors.white)),
                ],
              ),
              const Icon(
                Icons.arrow_forward_ios,
                color: Colors.white,
              )
            ],
          ),
          const SizedBox(width: 10),
        ],
      ),
    );
  }
}
