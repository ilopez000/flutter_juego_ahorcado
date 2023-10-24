import 'package:flutter/material.dart';
import 'dart:math';

void main() => runApp(AhorcadoApp());

class AhorcadoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ahorcado Flutter',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: AhorcadoHomePage(),
    );
  }
}

class AhorcadoHomePage extends StatefulWidget {
  @override
  _AhorcadoHomePageState createState() => _AhorcadoHomePageState();
}

class _AhorcadoHomePageState extends State<AhorcadoHomePage> {
  final List<String> palabras = ["FLUTTER", "DART", "DOSMIL", "CERTIFICADO"];
  String palabraSeleccionada = '';
  String palabraActual = '';
  List<String> letrasAdivinadas = [];
  int fallos = 0;

  @override
  void initState() {
    super.initState();
    iniciarJuego();
  }

  void iniciarJuego() {
    setState(() {
      palabraSeleccionada = palabras[Random().nextInt(palabras.length)];
      palabraActual = '_' * palabraSeleccionada.length;
      letrasAdivinadas.clear();
      fallos = 0;
    });
  }

  void adivinarLetra(String letra) {
    if (!palabraSeleccionada.contains(letra) && !letrasAdivinadas.contains(letra)) {
      setState(() {
        fallos++;
      });
    }

    if (!letrasAdivinadas.contains(letra)) {
      setState(() {
        letrasAdivinadas.add(letra);
        palabraActual = actualizarPalabraActual(palabraSeleccionada, letrasAdivinadas);
      });
    }

    if (palabraActual == palabraSeleccionada) {
      mostrarDialogoGanador();
    } else if (fallos == 6) {
      mostrarDialogoGameOver();
    }
  }

  void mostrarDialogoGanador() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('¡Ganaste!'),
          content: Text('¡Felicidades! Adivinaste la palabra.'),
          actions: <Widget>[
            TextButton(
              child: Text('Nueva partida'),
              onPressed: () {
                iniciarJuego();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void mostrarDialogoGameOver() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Game Over'),
          content: Text('No adivinaste la palabra. La palabra era: $palabraSeleccionada.'),
          actions: <Widget>[
            TextButton(
              child: Text('Nueva partida'),
              onPressed: () {
                iniciarJuego();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  String actualizarPalabraActual(String palabra, List<String> adivinadas) {
    String nuevaPalabra = '';
    for (int i = 0; i < palabra.length; i++) {
      if (adivinadas.contains(palabra[i])) {
        nuevaPalabra += palabra[i];
      } else {
        nuevaPalabra += '_';
      }
    }
    return nuevaPalabra;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ahorcado en Flutter'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Fallos: $fallos / 6'),
            Text(palabraActual, style: TextStyle(fontSize: 24)),
            Wrap(
              children: 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'.split('').map((e) {
                return Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: ElevatedButton(
                    child: Text(e),
                    onPressed: letrasAdivinadas.contains(e) ? null : () => adivinarLetra(e),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

