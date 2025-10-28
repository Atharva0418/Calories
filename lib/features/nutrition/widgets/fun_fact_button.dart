import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:vibration/vibration.dart';

class FunFactButton extends StatefulWidget {
  const FunFactButton({super.key});

  @override
  State<FunFactButton> createState() => _FunFactButtonState();
}

class _FunFactButtonState extends State<FunFactButton>
    with TickerProviderStateMixin {
  bool _isCooldown = false;
  late AnimationController _colorController;
  late Animation<Color?> _colorAnimation;
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;
  final random = Random();

  final funFacts = [
    "🍫 Dark chocolate can improve brain function!",
    "🍯 Honey never spoils — even after thousands of years!",
    "🍎 Apples float because they’re 25% air!",
    "🍌 Bananas are berries, but strawberries aren’t!",
    "🌽 Corn always has an even number of rows!",
    "🍉 Watermelon is 92% water — drink it, don’t eat it!",
    "🍟 French fries aren’t actually French — they were invented in Belgium!",
    "🍕 Pizza was invented in Naples, Italy — and was once food for the poor!",
    "🍵 Masala chai isn’t a drink, it’s therapy served in a cup.",
    "🍪 Jalebi is proof that life can twist and still stay sweet.",
    "🍫 Chocolate releases the same chemical as falling in love — cheaper, less risky.",
    "🍎 An apple a day keeps anyone away — if thrown hard enough.",
    "🥗 Eating healthy is easy. It’s the ‘not ordering fries’ part that’s hard.",
    "🍌 Did you know bananas share about 60% of their DNA with humans? So technically, we’re part banana.",
    "🧀 There are more than 2,000 varieties of cheese in the world.",
    "☕ India is the world’s largest producer of milk, yet somehow every chai tapri still runs out of milk by evening.",
    "🥔 Potatoes were the first vegetable grown in space.",
  ];

  @override
  void initState() {
    super.initState();
    _colorController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _colorAnimation = TweenSequence<Color?>([
      TweenSequenceItem(
        tween: ColorTween(begin: Colors.black, end: Colors.amber),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: ColorTween(begin: Colors.amber, end: Colors.black),
        weight: 50,
      ),
    ]).animate(
      CurvedAnimation(parent: _colorController, curve: Curves.slowMiddle),
    );

    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
      lowerBound: 0.5, // shrink amount
      upperBound: 1,
    );

    _scaleAnimation = CurvedAnimation(
      parent: _scaleController,
      curve: Curves.bounceOut,
    );

    _scaleController.forward();
  }

  @override
  void dispose() {
    _colorController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  Future<void> _showFunFact() async {
    if (_isCooldown) return;

    setState(() {
      _isCooldown = true;
    });

    _scaleController.reverse();
    await Future.delayed(const Duration(milliseconds: 300));
    _scaleController.forward();
    _colorController.forward(from: 0);

    if (await Vibration.hasVibrator()) {
      Vibration.vibrate(duration: 40, amplitude: 60);
    }

    final fact = getRandomFact();
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          fact,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.amber,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
        duration: const Duration(seconds: 3),
      ),
    );

    await Future.delayed(const Duration(seconds: 3));
    if (mounted) setState(() => _isCooldown = false);
  }

  List<String> shuffledFacts = [];
  int currentIndex = 0;

  String getRandomFact() {
    if (shuffledFacts.isEmpty || currentIndex >= shuffledFacts.length) {
      shuffledFacts = List.from(funFacts)..shuffle();
      currentIndex = 0;
    }

    return shuffledFacts[currentIndex++];
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      // 💡 ensures it's not stretched by parents
      child: SizedBox(
        width: 30,
        height: 30,
        child: AnimatedBuilder(
          animation: _colorAnimation,
          builder:
              (context, child) => ScaleTransition(
                scale: _scaleAnimation,
                child: InkWell(
                  onTap: _isCooldown ? null : _showFunFact,
                  borderRadius: BorderRadius.circular(50),
                  child: Opacity(
                    opacity: _isCooldown ? 0.5 : 1,
                    child: Icon(
                      FontAwesomeIcons.bolt,
                      size: 23,
                      color: _colorAnimation.value,
                    ),
                  ),
                ),
              ),
        ),
      ),
    );
  }
}
