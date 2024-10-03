import 'package:flutter/material.dart';

void main() => runApp(const DecoratedBoxTransitionExampleApp());

class DecoratedBoxTransitionExampleApp extends StatelessWidget {
  const DecoratedBoxTransitionExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DecoratedBoxTransitionExample(),
    );
  }
}

class DecoratedBoxTransitionExample extends StatefulWidget {
  const DecoratedBoxTransitionExample({super.key});

  @override
  State<DecoratedBoxTransitionExample> createState() =>
      _DecoratedBoxTransitionExampleState();
}

class _DecoratedBoxTransitionExampleState
    extends State<DecoratedBoxTransitionExample> with TickerProviderStateMixin {
  final DecorationTween decorationTween = DecorationTween(
    begin: BoxDecoration(
      color: const Color(0xFF1E1E1E),
      border: Border.all(style: BorderStyle.none),
      borderRadius: BorderRadius.circular(60.0),
      boxShadow: const <BoxShadow>[
        BoxShadow(
          color: Color.fromARGB(255, 99, 1, 61),
          blurRadius: 10.0,
          spreadRadius: 3.0,
          offset: Offset(0, 6.0),
        ),
      ],
    ),
    end: BoxDecoration(
      color: const Color(0xFF1E1E1E),
      border: Border.all(style: BorderStyle.none),
      borderRadius: BorderRadius.zero,
    ),
  );

  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 3),
  )..repeat(reverse: true);

  int? _hoveredIndex;
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  List<String> _capybaraImages = [];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _addCapybara() {
    _capybaraImages.add('images/capibara.png');
    _listKey.currentState?.insertItem(_capybaraImages.length - 1); 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 220, 
              child: AnimatedList(
                key: _listKey,
                scrollDirection: Axis.horizontal,
                initialItemCount: _capybaraImages.length,
                itemBuilder: (context, index, animation) {
                  return _buildCapybaraItem(index, _capybaraImages[index], animation);
                },
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _addCapybara,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
                padding: const EdgeInsets.all(16),
              ),
              child: const Icon(Icons.add, color: Colors.white), 
            ),
            const SizedBox(height: 20),
            const Text(
              'Exemplo de animações em Flutter',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCapybaraItem(int index, String imagePath, Animation<double> animation) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0), // Espaçamento horizontal
      child: DecoratedBoxTransition(
        decoration: decorationTween.animate(_controller),
        child: MouseRegion(
          onEnter: (_) {
            setState(() {
              _hoveredIndex = index; // Atualiza o índice da capivara "hovered"
            });
          },
          onExit: (_) {
            setState(() {
              _hoveredIndex = null; // Reseta o índice quando o mouse sai
            });
          },
          child: SizeTransition(
            sizeFactor: animation,
            child: Container(
              width: 200,
              height: 200,
              padding: const EdgeInsets.all(10),
              child: AnimatedOpacity(
                opacity: _hoveredIndex == index ? 1.0 : 0.0, // Exibe a capivara apenas se estiver "hovered"
                duration: const Duration(milliseconds: 300),
                child: Image.asset(imagePath),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
