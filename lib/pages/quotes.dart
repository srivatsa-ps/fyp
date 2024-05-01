import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MotivationalQuotesApp());
}

class MotivationalQuotesApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Daily Motivational Quotes',
      theme: ThemeData(
        primaryColor: Colors.black45,
        hintColor: Colors.black45,
        fontFamily: 'Georgia',
        textTheme: TextTheme(
          headline1: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
          headline6: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
          bodyText2: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
        ),
      ),
      home: QuotePage(),
    );
  }
}

class QuotePage extends StatefulWidget {
  @override
  _QuotePageState createState() => _QuotePageState();
}

class _QuotePageState extends State<QuotePage> {
  String quote = 'Loading...';
  String author = '';
  String backgroundImage = 'https://picsum.photos/800/600';

  @override
  void initState() {
    super.initState();
    fetchQuote();
  }

  Future<void> fetchQuote() async {
    const quoteUrl = 'https://api.quotable.io/random';
    try {
      final quoteResponse = await http.get(Uri.parse(quoteUrl));
      if (quoteResponse.statusCode == 200) {
        var quoteData = jsonDecode(quoteResponse.body);
        setState(() {
          quote = quoteData['content'];
          author = quoteData['author'] ?? 'Unknown';
        });
      } else {
        throw Exception('Failed to load quote');
      }

      setState(() {
        backgroundImage =
            'https://picsum.photos/800/600?random=${DateTime.now().millisecondsSinceEpoch}';
      });
    } catch (e) {
      setState(() {
        quote = 'Failed to load quote.';
        author = '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daily Motivational Quote'),
        backgroundColor: Colors.blueAccent[400],
        elevation: 10.0,
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(backgroundImage),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.5), BlendMode.dstATop),
          ),
        ),
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              quote,
              style: TextStyle(
                fontSize: 24,
                fontStyle: FontStyle.italic,
                color: Colors.yellowAccent, // Bright and visible text color
                shadows: [
                  Shadow(
                    blurRadius: 5.0,
                    color: Colors.black,
                    offset: Offset(2, 2),
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            Text(
              '- $author',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.yellowAccent, // Matching the quote color
              ),
              textAlign: TextAlign.right,
            ),
            SizedBox(height: 40),
            ElevatedButton(
              onPressed: fetchQuote,
              child: Text(
                'New Quote',
                style: TextStyle(
                    color: Colors.black), // Button text color to black
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent[700],
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                textStyle: TextStyle(fontSize: 18),
                shadowColor: Colors.black,
                elevation: 15.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
