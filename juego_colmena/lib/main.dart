import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter COLMENA',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyTablero(),
    );
  }
}

class MyTablero extends StatefulWidget {
  @override
  _MyTableroState createState() => _MyTableroState();
}

class _MyTableroState extends State<MyTablero> {
  final List<IconData> _icons = [
    Icons.bug_report,
    Icons.emoji_nature,
    Icons.pest_control,
    Icons.favorite, // Ícono de un corazón
  ];
  List<bool> _flippedStates = List.generate(25, (index) => false);
  int _points = 7; // Inicializar el contador de puntos en 7
  bool _gameOver = false; // Bandera para indicar el estado de juego terminado

  @override
  void initState() {
    super.initState();
    _shuffleIcons(); // Barajar los íconos al cargar inicialmente
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('COLMENA'),
      ),
      body: Column(
        children: [
          SizedBox(height: 20),
          Text(
            'Puntos: $_points',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.all(10),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 5,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 1,
              ),
              itemCount: 25,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: _gameOver ? null : () {
                    _flipCell(index);
                    _updatePoints(_icons[index % _icons.length]);
                  },
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    decoration: BoxDecoration(
                      color: _flippedStates[index] ? Colors.grey[300] : Colors.blueAccent,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.black),
                    ),
                    child: Center(
                      child: _flippedStates[index]
                          ? Icon(_icons[index % _icons.length], size: 40, color: Colors.green)
                          : null,
                    ),
                  ),
                );
              },
            ),
          ),
          ElevatedButton(
            onPressed: _gameOver ? _restartGame : _shuffleIcons, // Desactivar el botón de revolver durante el juego terminado
            child: Text(_gameOver ? 'Reiniciar Juego' : 'Revolver Iconos', style: TextStyle(fontSize: 18)),
          ),
          SizedBox(height: 20),
          Visibility(
            visible: _gameOver,
            child: Text(
              '¡Juego Terminado!',
              style: TextStyle(fontSize: 24, color: Colors.red, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  void _flipCell(int index) {
    setState(() {
      _flippedStates[index] = !_flippedStates[index];
    });
  }

  void _shuffleIcons() {
    setState(() {
      _icons.shuffle();
    });
  }

  void _updatePoints(IconData icon) {
    if (icon == Icons.bug_report) {
      _points -= 2; // Restar 2 puntos si se toca la celda con el ícono "bug_report"
    } else if (icon == Icons.emoji_nature) {
      _points -= 1; // Restar 1 punto si se toca la celda con el ícono "emoji_nature"
    }
    if (_points <= 0) { // Comprobar si el juego termina con 0 o menos puntos
      _points = 0;
      _gameOver = true;
    }
  }

  void _restartGame() {
    setState(() {
      _flippedStates = List.generate(25, (index) => false);
      _points = 7;
      _gameOver = false;
      _shuffleIcons(); // Barajar iconos al reiniciar
    });
  }
}