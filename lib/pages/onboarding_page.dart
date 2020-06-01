import 'package:foodspace/pages/authenticate_page.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';

class OnboardingPage extends StatelessWidget {

  List<PageViewModel> _getPages() {
    return [
      PageViewModel(
        image: Image.asset('assets/explore_.png', height: 100.0, width: 200.0),
        title: 'Explore',
        body: 'Explore Restaurants present in your city.',
        decoration: PageDecoration(
          titleTextStyle: PageDecoration().titleTextStyle.copyWith(color: Colors.black87, fontSize: 35.0),
          bodyTextStyle: PageDecoration().titleTextStyle.copyWith(color: Colors.white),
          boxDecoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              //colors: [Color(0xFF7AACFE), Color(0xFF004ECE)]
              colors: [Color(0xFF7AACFE), Color(0xFF0041AD)]
            )
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 50.0)
        ),
      ),

      PageViewModel(
        image: Image.asset('assets/categories_.png'),
        title: 'Categories',
        body: 'Find out different categories of food restaurants.',
        decoration: PageDecoration(
          titleTextStyle: PageDecoration().titleTextStyle.copyWith(color: Colors.black87, fontSize: 35.0),
          bodyTextStyle: PageDecoration().titleTextStyle.copyWith(color: Colors.white),
          boxDecoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              //colors: [Colors.lightBlueAccent, Colors.blue]
              colors: [Color(0xFF7AACFE), Color(0xFF0041AD)]
            )
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 50.0)
        ),
      ),

      PageViewModel(
        image: Image.asset('assets/reviews_.png'),
        title: 'Reviews',
        body: 'See user reviews and feedback for any restauant.',
        decoration: PageDecoration(
          titleTextStyle: PageDecoration().titleTextStyle.copyWith(color: Colors.black87, fontSize: 35.0),
          bodyTextStyle: PageDecoration().titleTextStyle.copyWith(color: Colors.white),
          boxDecoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              //colors: [Colors.lightBlueAccent, Colors.blue]
              colors: [Color(0xFF7AACFE), Color(0xFF0041AD)]
            )
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 50.0)
        ),
      ),

      PageViewModel(
        image: Image.asset('assets/hearts_.png'),
        title: 'Like it?',
        body: 'Add restaurants to your Favorites section.',
        decoration: PageDecoration(
          titleTextStyle: PageDecoration().titleTextStyle.copyWith(color: Colors.black87, fontSize: 35.0),
          bodyTextStyle: PageDecoration().titleTextStyle.copyWith(color: Colors.white),
          boxDecoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              //colors: [Colors.lightBlueAccent, Colors.blue]
              colors: [Color(0xFF7AACFE), Color(0xFF0041AD)]
            )
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 50.0)
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IntroductionScreen(
        globalBackgroundColor: Colors.transparent,
        dotsDecorator: DotsDecorator(
          color: Colors.black26,
          activeColor: Colors.white,
        ),
        pages: _getPages(),
        skip: Text('SKIP', style: TextStyle(color: Colors.white, fontSize: 20.0)),
        onSkip: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => AuthenticatePage()));
        },
        showSkipButton: true,
        done: Text('DONE', style: TextStyle(color: Colors.white, fontSize: 20.0)),
        onDone: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => AuthenticatePage()));
        },
        next: Text('NEXT', style: TextStyle(color: Colors.white, fontSize: 20.0)),
      ),
    );
  }
}