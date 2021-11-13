import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Unhandled Ex Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Unhandled Exception Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int? _statusCode;

  Future<void> _incrementCounter() async {
    setState(() {
      _statusCode = null;
    });

    try {
      var httpClient = Dio()..options.contentType = "application/json";

      var response = await httpClient.get(
        "https://gorest.co.in/public/v1/posts/nonExistingId",
      );

      setState(() {
        _statusCode = response.statusCode;
      });
    } on DioError catch (dioError) {
      setState(() {
        _statusCode = dioError.response?.statusCode;
      });

      print("DioError catch: ${dioError.message}");
    } catch (e) {
      print("Other exception catch: ${e.toString()}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'API response status code:',
            ),
            Text(
              '${_statusCode ?? "-"}',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.api),
      ),
    );
  }
}
