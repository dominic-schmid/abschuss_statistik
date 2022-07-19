import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:jagdverband_scraper/kills_screen.dart';
import 'package:jagdverband_scraper/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'request_methods.dart';

class CredentialsScreen extends StatefulWidget {
  const CredentialsScreen({Key? key}) : super(key: key);

  @override
  State<CredentialsScreen> createState() => _CredentialsScreenState();
}

class _CredentialsScreenState extends State<CredentialsScreen> {
  final TextEditingController _revierController = TextEditingController();
  final TextEditingController _passwortController = TextEditingController();

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFF66BB6A),
                    Color(0xFF4CAF50),
                    Color(0xFF43A047),
                    Color(0xFF388E3C),
                  ],
                  stops: [
                    0.1,
                    0.4,
                    0.7,
                    0.9
                  ]),
            ),
          ),
          Container(
            height: double.infinity,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(
                horizontal: 40.0,
                vertical: 120.0,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  const Text(
                    'Anmelden',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'OpenSans',
                      fontSize: 30.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 30.0),
                  _buildRevierTF(),
                  const SizedBox(height: 30.0),
                  _buildPasswordTF(),
                  const SizedBox(height: 15.0),
                  _buildLoginBtn(),
                  const SizedBox(height: 50.0),
                  const Text(
                    'Deine Anmeldedaten werden nur lokal gespeichert und verwendet, um die Abschüsse von der Seite des Jagdverbands herunterzuladen.',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'OpenSans',
                      fontSize: 10,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRevierTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Revier',
          style: kLabelStyle,
        ),
        const SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          child: TextField(
            controller: _revierController,
            keyboardType: TextInputType.text,
            style: const TextStyle(
              color: Colors.white,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              //contentPadding: const EdgeInsets.only(top: 14.0),
              prefixIcon: const Icon(
                Icons.co_present_rounded,
                color: Colors.white,
              ),
              hintText: 'z.B. Bruneck13L',
              hintStyle: kHintTextStyle,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Passwort',
          style: kLabelStyle,
        ),
        const SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          child: TextField(
            textInputAction: TextInputAction.go,
            onSubmitted: (_) => login(),
            controller: _passwortController,
            obscureText: true,
            style: const TextStyle(
              color: Colors.white,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
//              contentPadding: const EdgeInsets.only(top: 14.0),
              prefixIcon: const Icon(
                Icons.lock,
                color: Colors.white,
              ),
              hintText: 'Passwort',
              hintStyle: kHintTextStyle,
            ),
          ),
        ),
      ],
    );
  }

  void login() async {
    String revier = _revierController.text;
    String pass = _passwortController.text;
    if (revier.isEmpty || pass.isEmpty) {
      showSnackBar('Du musst beide Felder Angeben!', context, duration: 2500);
      return;
    }

    if (await Connectivity()
            .checkConnectivity()
            .timeout(const Duration(seconds: 15)) ==
        ConnectivityResult.none) {
      showSnackBar('Fehler: Kein Internet!', context);
      return;
    }

    if (mounted) setState(() => _isLoading = true);
    bool login = await RequestMethods.tryLogin(revier, pass);
    if (!login) {
      print('Trying to log in one more time');
      login = await RequestMethods.tryLogin(revier, pass);
    }

    if (login) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('revierLogin', _revierController.text);
      await prefs.setString('revierPasswort', _passwortController.text);

      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const KillsScreen(),
        ),
      );
    } else {
      if (!mounted) return;
      showSnackBar('Fehler: Zu diesen Daten gibt es kein Revier!', context);
    }

    if (mounted) setState(() => _isLoading = false);
  }

  Widget _buildLoginBtn() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 25.0),
      width: double.infinity,
      child: MaterialButton(
        elevation: 5.0,
        onPressed: () async {
          login();
        },
        padding: const EdgeInsets.all(15.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        color: Colors.white,
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : const Text(
                'ANMELDEN',
                style: TextStyle(
                  color: Colors.green,
                  letterSpacing: 1.5,
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'OpenSans',
                ),
              ),
      ),
    );
  }
}

const kHintTextStyle = TextStyle(
  color: Colors.white54,
  fontFamily: 'OpenSans',
);

const kLabelStyle = TextStyle(
  color: Colors.white,
  fontWeight: FontWeight.bold,
  fontFamily: 'OpenSans',
);

final kBoxDecorationStyle = BoxDecoration(
  color: const Color(0xFF2E7D32),
  borderRadius: BorderRadius.circular(10.0),
  boxShadow: const [
    BoxShadow(
      color: Colors.black12,
      blurRadius: 6.0,
      offset: Offset(0, 2),
    ),
  ],
);
