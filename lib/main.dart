import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Exemplo de Velocímetro'),
        ),
        body: Center(
          child: VelocimetroWidget(
            valorAtual: 25, // Valor atual
            valorMaximo: 100, // Valor máximo
            tamanho: 250, // Tamanho do widget
          ),
        ),
      ),
    );
  }
}

class VelocimetroWidget extends StatelessWidget {
  final double valorAtual; // Valor atual para exibir no velocímetro
  final double valorMaximo; // Valor máximo no velocímetro
  final double tamanho; // Tamanho do velocímetro

  VelocimetroWidget({
    required this.valorAtual,
    required this.valorMaximo,
    required this.tamanho,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(tamanho, tamanho),
      painter: VelocimetroPainter(
        valorAtual: valorAtual,
        valorMaximo: valorMaximo,
      ),
    );
  }
}

class VelocimetroPainter extends CustomPainter {
  final double valorAtual;
  final double valorMaximo;

  VelocimetroPainter({
    required this.valorAtual,
    required this.valorMaximo,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final centerX = size.width / 2;
    final centerY = size.height / 2;
    final radius = size.width / 2;

    // Desenha o fundo do velocímetro
    final fundoPaint = Paint()..color = Colors.grey;
    canvas.drawCircle(Offset(centerX, centerY), radius, fundoPaint);

    // Desenha a bola no centro do círculo
    final bolaPaint = Paint()..color = Colors.red;
    canvas.drawCircle(Offset(centerX, centerY), 10, bolaPaint);

    // Desenha a escala do velocímetro
    final escalaPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    for (double angulo = -45; angulo <= 225; angulo += 10) {
      final radianos = (angulo - 180) * (pi / 180);
      final x1 = centerX + radius * 0.9 * cos(radianos);
      final y1 = centerY + radius * 0.9 * sin(radianos);

      final x2 = centerX + radius * cos(radianos);
      final y2 = centerY + radius * sin(radianos);

      canvas.drawLine(Offset(x1, y1), Offset(x2, y2), escalaPaint);
    }

    // Desenha o ponteiro do velocímetro
    final ponteiroPaint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.fill
      ..strokeWidth = 4;

    final ponteiroAngulo = (270 * (valorAtual / valorMaximo)) - 225;
    final ponteiroRadianos = ponteiroAngulo * (pi / 180);
    final ponteiroX = centerX + radius * 0.7 * cos(ponteiroRadianos);
    final ponteiroY = centerY + radius * 0.7 * sin(ponteiroRadianos);

    /* canvas.drawLine(
      Offset(centerX, centerY),
      Offset(ponteiroX, ponteiroY),
      ponteiroPaint,
    ); */

    // Desenhe a seta
    final path = Path();
    path.moveTo(centerX - 10, centerY);
    path.lineTo(centerX + 10, centerY);
    path.lineTo(ponteiroX, ponteiroY);
    path.close();

    canvas.drawPath(path, ponteiroPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
