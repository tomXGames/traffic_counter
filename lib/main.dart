import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:confirm_dialog/confirm_dialog.dart';
import 'package:flutter_grid_button/flutter_grid_button.dart';


void main() {
  runApp(TabBarDemo());
}

class TabBarDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            bottom: TabBar(
              tabs: [
                Tab(icon: Icon(Icons.directions_car)),
                Tab(icon: Icon(Icons.motorcycle)),
                Tab(icon: Icon(Icons.directions_bike)),
              ],
            ),
            title: Text('Traffic Counter'),
          ),
          body: TabBarView(
            children: [
              TrafficCounter(title: 'Cars', icon: Icons.directions_car),
              TrafficCounter(title: 'Motorcycle', icon: Icons.motorcycle),
              TrafficCounter(title: 'Bikes', icon: Icons.directions_bike),
            ],
          ),
        ),
      ),
    );
  }
}
class TrafficCounter extends StatefulWidget {
  TrafficCounter({Key key, this.title, this.icon}) : super(key: key);
  final String title;
  final IconData icon;
  @override
  _TrafficCounter createState() => new _TrafficCounter();
}
class _TrafficCounter extends State<TrafficCounter> {
  int _counter;
  @override
  void initState() {
    super.initState();
    _loadCounter(widget.title);
  }

  void _incrementCounter(String type)  async{
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _counter = (prefs.getInt(type) ?? 0) + 1;
      prefs.setInt(type, _counter);
    });
  }
    void _decreaseCounter(String type)  async{
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _counter = (prefs.getInt(type) ?? 0) - 1;
      if((_counter >= 1)){
        prefs.setInt(type, _counter);
      }
    });
  }
  void _loadCounter(String type) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _counter = (prefs.getInt(type) ?? 0);
    });
  }
  void _resetCounter(String type) async {
    final prefs = await SharedPreferences.getInstance();
    if (await confirm(context,
        title: Text('Confirm'),
        content: Text('Do you really want to reset the counter?'),
        textOK: Text('Yes'),
        textCancel: Text('No'),
    )) {
      setState(() {
        _counter = 0;
        prefs.setInt(type, 0);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
              Container( child: Icon(
              widget.icon,
              ), height: 50, ),
              Container(child: Text(
                '$_counter',
                style: Theme.of(context).textTheme.headline4,
              ), height: 50, ),  
              Container( child:GridButton(
              borderWidth: 2,
              borderColor: Colors.white10,
              enabled: true,
              onPressed: (dynamic val) {
                switch(val) { 
                    case "+": {  _incrementCounter(widget.title); } 
                    break; 
                  
                    case "-": {  _decreaseCounter(widget.title); } 
                    break; 
                  
                    case "r": {  _resetCounter(widget.title); } 
                    break; 
                  
                    default: { _incrementCounter(widget.title); } 
                    break; 
                } 
              },
              items: [
                [
                  GridButtonItem(title: '+', borderRadius: 7, color: Colors.blue, value: "+", textStyle: TextStyle(fontSize: 20)),
                ],
                [
                  GridButtonItem(title: "-", borderRadius: 7, color: Colors.red, value: "-", textStyle: TextStyle(fontSize: 20)),
                  GridButtonItem(title: "Reset", borderRadius: 7, color: Colors.black, value: "r", textStyle: TextStyle(fontSize: 20, color: Colors.white)),
                ]
              ],
            ), height: 200,)]
          )
        );
  }
}