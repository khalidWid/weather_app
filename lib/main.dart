import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final String _apiId = "7ffacafe5af9daf806375e9ac959dc64";
  var _pays = '';
  var _temp;
  String _description = 'No data yet';
  var _weatherIcon;
  final countries = {
    'MA': 'Morocco',
    'QA': 'Qatar',
    'FR': 'France',
    'ES': 'Spain',
    'GB': 'United Kingdom',
    'US': 'United States',
    'SA': 'Saudi Arabia',
  };

  dynamic _weatherValue;
  var _controller = TextEditingController();

  void _getWeatherData(String city) {
    String url =
        'https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$_apiId&units=metric';
    print(url);
    http
        .get(Uri.parse(url))
        .then((response) => {
              print(response.body),
              setState(() {
                _weatherValue = json.decode(response.body);
                _pays = _weatherValue['sys']['country'];
                _temp = _weatherValue['main']['temp'];
                _description = _weatherValue['weather'][0]['description'];
                _weatherIcon = _weatherValue['weather'][0]['icon'];
              })
            })
        .catchError((onError) {
      print(onError);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("METEO"),
      ),
      body: Center(
        child: Container(
          padding: EdgeInsets.all(35),
          child: Column(
            children: [
              TextField(
                controller: _controller,
                decoration: InputDecoration(
                    suffixIcon: IconButton(
                        onPressed: () {
                          _getWeatherData(_controller.text);
                        },
                        icon: Icon(Icons.search)),
                    hintText: 'Search for a city...',
                    border: OutlineInputBorder()),
              ),
              SizedBox(height: 40),
              Center(
                child: Text(
                  _description,
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 30),
              Row(
                children: [
                  _pays == ''
                      ? Image(
                          image: AssetImage('assets/countries/undefined.png'),
                          width: 50,
                        )
                      : Image(
                          image: NetworkImage(
                              'https://flagcdn.com/w320/$_pays.png'
                                  .toLowerCase()),
                          width: 60,
                        ),
                  SizedBox(width: 15),
                  Text(
                    countries.containsKey(_pays)
                        ? countries[_pays].toString()
                        : _pays,
                    style: TextStyle(fontSize: 25),
                  )
                ],
              ),
              SizedBox(height: 15),
              Row(
                children: [
                  _pays == ''
                      ? Image(
                          image: AssetImage('assets/countries/undefined.png'),
                          width: 50,
                        )
                      : Image(
                          image: NetworkImage(
                              'http://openweathermap.org/img/wn/$_weatherIcon@2x.png'),
                          width: 60,
                        ),
                  SizedBox(width: 15),
                  Text(
                    '$_temp °C',
                    style: TextStyle(fontSize: 25),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
