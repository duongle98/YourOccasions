import 'package:flutter/material.dart';
import 'dart:async';

import 'package:youroccasions/screens/user/diagonally_cut_colored_image.dart';
import 'package:youroccasions/screens/home/home.dart';
import 'package:youroccasions/utilities/config.dart';
import 'package:youroccasions/models/user.dart';
import 'package:youroccasions/models/event.dart';
import 'package:youroccasions/controllers/user_controller.dart';
import 'package:youroccasions/controllers/event_controller.dart';
import 'package:youroccasions/screens/home/event_card.dart';
import 'package:youroccasions/models/data.dart';

final UserController _userController = UserController();
final EventController _eventController = EventController();

class UserProfileScreen extends StatefulWidget {
  final User user;

  UserProfileScreen(User user) :  this.user = user;

  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
  
}

class _UserProfileScreenState extends State<UserProfileScreen>{

  User user;
  int id;
  List<Event> _eventList;


  @override
  initState() {
    super.initState();
    user = widget.user;
    _eventController.getEvent(hostId: user.id).then((value){
      setState(() {
        _eventList = value;
      });
    });
    // getUserId().then((value){
    //   setState(() {
    //     id = value;
    //   });
    // });
  }
  
  Widget _buildAvatar() {
    return new Hero(
      tag: "User Profile",
      child: new CircleAvatar(
        radius: 50.0,
      ),
    );
  }

  Widget _buildDiagonalImageBackground(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;

    return new DiagonallyCutColoredImage(
      new Image.network(
        "https://i.imgur.com/dBy4rtg.png",
        width: screenWidth,
        height: 280.0,
        fit: BoxFit.cover,
      ),
      color: const Color(0xBB8338f4),
    );
  }

  List<Widget> _buildUserEventsCardList() {
    List<Widget> cards = List<Widget>();

    Widget e = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
      child: Text("User's Events", style: TextStyle(color: Colors.white, fontSize: 30.0, fontFamily: "Niramit")),
    );

    cards.add(e);

    if (_eventList == null){
      return cards;
    }

    _eventList.sort((b,a) => a.startTime.compareTo(b.startTime));
    _eventList.forEach((Event currentEvent) {
      if(currentEvent.startTime.compareTo(DateTime.now()) > 0) {
        cards.insert(1, Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: SmallEventCard(
            // color: Colors.blue[100],
            event: currentEvent,
            imageURL: currentEvent.picture ?? "https://img.cutenesscdn.com/640/cme/cuteness_data/s3fs-public/diy_blog/Information-on-the-Corgi-Dog-Breed.jpg",
            place: currentEvent.locationName ?? "Unname location",
            time: currentEvent.startTime ?? DateTime.now(),
            title: currentEvent.name ?? "Untitled event" ,
          ),
        ));
      }
    });
    return cards;
  }

  Widget _buildLocationInfo(TextTheme textTheme) {
    return new Row(
      children: <Widget>[
        new Icon(
          Icons.place,
          color: Colors.white,
          size: 16.0,
        ),
        new Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: new Text(
            'Plattsburgh',
            style: textTheme.subhead.copyWith(color: Colors.white),
          ),
        ),
      ],
    );
  }

  Widget _buildFollowerInfo(TextTheme textTheme) {
    int follower = user.followers;
    var followerStyle =
        textTheme.subhead.copyWith(color: Colors.yellow[100]);

    return new Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new Text('90 Following', style: followerStyle),
          new Text(
            ' | ',
            style: followerStyle.copyWith(
                fontSize: 24.0, fontWeight: FontWeight.normal),
          ),
          new Text('$follower Followers', style: followerStyle),
        ],
      ),
    );
  }

  Widget _createPillButton(
    String text, {
    Color backgroundColor = Colors.transparent,
    Color textColor = Colors.white70,
  }) {
    return new ClipRRect(
      borderRadius: new BorderRadius.circular(30.0),
      child: new MaterialButton(
        minWidth: 140.0,
        color: backgroundColor,
        textColor: textColor,
        onPressed: () {},
        child: new Text(text),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var theme = Theme.of(context);
    var textTheme = theme.textTheme;
    var linearGradient = const BoxDecoration(
      gradient: const LinearGradient(
        begin: FractionalOffset.centerRight,
        end: FractionalOffset.bottomLeft,
        colors: <Color>[
          Colors.blue,
          Colors.white,
        ],
      ),
    );

    return new Scaffold(
      body: new SingleChildScrollView(
        child: new Container(
          height: screenHeight,
          decoration: linearGradient,
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              new Stack(
                children: <Widget>[
                  new Align(
                    alignment: FractionalOffset.bottomCenter,
                    heightFactor: 1.4,
                    child: new Column(
                      children: <Widget>[
                        _buildAvatar(),
                        _buildFollowerInfo(textTheme),
                        // _buildActionButtons(theme),
                      ],
                    ),
                  ),
                  new Positioned(
                    top: 26.0,
                    left: 4.0,
                    child: new BackButton(color: Colors.white),
                  ),
                ],
              ),
              new Padding(
                padding: const EdgeInsets.all(24.0),
                child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    new Text(
                      user.name,
                      style: textTheme.headline.copyWith(color: Colors.white),
                    ),
                    new Text(
                      user.email,
                      style: TextStyle(color: Colors.white, fontSize: 14.0)
                    ),
                    new Padding(
                      padding: const EdgeInsets.only(top: 6.0),
                      child: _buildLocationInfo(textTheme),
                    ),
                  ],
                )
              ),
              new Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: _buildUserEventsCardList(),
                )
              )
            ],
          ),
        ),
      ),
    );
  }
}
