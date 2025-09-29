import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CountdownTimerWidget extends StatefulWidget { // Tienes estado
 
  final int totalSeconds; // pre constante 
  final VoidCallback? onComplete;
  final int tickSoundStartAt; // Segundos desde cuando empezar el sonido
  final TextStyle? textStyle;
  final Color? backgroundColor;
  final double size;
  final bool isPlaying; // Control externo para play/pause
  final bool shouldReset; // Control externo para reset

  const CountdownTimerWidget({
    Key? key,
    required this.totalSeconds,
    this.onComplete,
    this.tickSoundStartAt = 10, // Por defecto últimos 10 segundos
    this.textStyle,
    this.backgroundColor,
    this.size = 200,
    this.isPlaying = false,
    this.shouldReset = false,
  }) : super(key: key);

  @override
  State<CountdownTimerWidget> createState() => _CountdownTimerWidgetState();
}

class _CountdownTimerWidgetState extends State<CountdownTimerWidget>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  
  int _currentSeconds = 0;
  bool _isActive = false;
  bool _wasPlaying = false;
  Color _previousColor = Colors.blue.shade600;

  @override
  void initState() {
    super.initState();
    _currentSeconds = widget.totalSeconds;
    
    _controller = AnimationController(
      duration: Duration(seconds: widget.totalSeconds),
      vsync: this,
    );

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.3,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.elasticOut,
    ));
  }

  @override
  void didUpdateWidget(CountdownTimerWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    // Reset si cambió shouldReset
    if (widget.shouldReset && !oldWidget.shouldReset) {
      resetTimer();
    }
    
    // Control de play/pause
    if (widget.isPlaying != _wasPlaying) {
      if (widget.isPlaying) {
        startTimer();
      } else {
        pauseTimer();
      }
      _wasPlaying = widget.isPlaying;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  void startTimer() {
    if (_isActive) return;
    
    setState(() {
      _isActive = true;
    });

    _controller.forward();
    
    // Timer que se actualiza cada segundo
    _startCountdown();
  }

  void _startCountdown() async {
    for (int i = _currentSeconds; i >= 0; i--) {
      if (!_isActive) break;
      
      setState(() {
        _currentSeconds = i;
      });

      // Verificar cambio de color y reproducir sonido correspondiente
      Color currentColor = _getTimerColor();
      if (currentColor != _previousColor) {
        if (i <= 3) {
          _playCriticalSound(); // Rojo
        } else if (i <= widget.tickSoundStartAt) {
          _playWarningSound(); // Naranja
        }
        _previousColor = currentColor;
      }

      // Reproducir sonido en los últimos segundos
      if (i <= widget.tickSoundStartAt && i > 0) {
        _playTickSound();
        _playPulseSound(); // Sonido adicional para la animación
        _pulseController.forward().then((_) => _pulseController.reverse());
      }

      // Sonido final cuando llega a 0
      if (i == 0) {
        _playFinalSound();
        widget.onComplete?.call();
        break;
      }

      await Future.delayed(const Duration(seconds: 1));
    }

    setState(() {
      _isActive = false;
    });
  }

  void _playTickSound() {
    // Sonido de tick usando vibración del sistema
    HapticFeedback.heavyImpact();
    SystemSound.play(SystemSoundType.click);
  }

  void _playPulseSound() {
    // Sonido específico para la animación de pulso
    HapticFeedback.lightImpact();
    SystemSound.play(SystemSoundType.click);
  }

  void _playWarningSound() {
    // Sonido de advertencia cuando cambia a naranja
    HapticFeedback.mediumImpact();
    SystemSound.play(SystemSoundType.click);
  }

  void _playCriticalSound() {
    // Sonido crítico cuando cambia a rojo
    HapticFeedback.heavyImpact();
    SystemSound.play(SystemSoundType.alert);
  }

  void _playFinalSound() {
    // Sonido final más intenso
    HapticFeedback.vibrate();
    for (int i = 0; i < 3; i++) {
      Future.delayed(Duration(milliseconds: i * 200), () {
        SystemSound.play(SystemSoundType.alert);
      });
    }
  }

  void pauseTimer() {
    setState(() {
      _isActive = false;
    });
    _controller.stop();
  }

  void resetTimer() {
    setState(() {
      _isActive = false;
      _currentSeconds = widget.totalSeconds;
    });
    _controller.reset();
    _pulseController.reset();
    _previousColor = Colors.blue.shade600; // Resetear color anterior
  }

  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  Color _getTimerColor() {
    if (_currentSeconds <= 3) {
      return Colors.red.shade700;
    } else if (_currentSeconds <= widget.tickSoundStartAt) {
      return Colors.orange.shade600;
    }
    return Colors.blue.shade600;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.size,
      height: widget.size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Círculo de fondo
          Container(
            width: widget.size,
            height: widget.size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: widget.backgroundColor ?? Colors.grey.shade200,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ],
            ),
          ),

          // Círculo de progreso
          SizedBox(
            width: widget.size - 20,
            height: widget.size - 20,
            child: CircularProgressIndicator(
              value: _currentSeconds / widget.totalSeconds,
              strokeWidth: 8,
              valueColor: AlwaysStoppedAnimation<Color>(_getTimerColor()),
              backgroundColor: Colors.grey.shade300,
            ),
          ),

          // Texto del tiempo con animación de pulso
          AnimatedBuilder(
            animation: _pulseAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _currentSeconds <= widget.tickSoundStartAt ? _pulseAnimation.value : 1.0,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _formatTime(_currentSeconds),
                      style: widget.textStyle ?? TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: _getTimerColor(),
                        fontFamily: 'monospace',
                      ),
                    ),
                    if (_currentSeconds <= 5 && _currentSeconds > 0)
                      Container(
                        margin: const EdgeInsets.only(top: 8),
                        child: Icon(
                          Icons.warning,
                          color: Colors.red,
                          size: 24,
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

// Ejemplo de uso con controles externos:
class CountdownExample extends StatefulWidget {
  @override
  _CountdownExampleState createState() => _CountdownExampleState();
}

class _CountdownExampleState extends State<CountdownExample> {
  bool _isPlaying = false;
  bool _shouldReset = false;

  void _togglePlayPause() {
    setState(() {
      _isPlaying = !_isPlaying;
    });
  }

  void _resetTimer() {
    setState(() {
      _isPlaying = false;
      _shouldReset = true;
    });
    
    // Resetear el flag después de un frame
    Future.delayed(Duration.zero, () {
      setState(() {
        _shouldReset = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cronómetro Regresivo'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CountdownTimerWidget(
              totalSeconds: 60, // 1 minuto
              tickSoundStartAt: 10, // Sonido en los últimos 10 segundos
              size: 250,
              isPlaying: _isPlaying,
              shouldReset: _shouldReset,
              onComplete: () {
                // Acción cuando termine el cronómetro
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  setState(() {
                    _isPlaying = false;
                  });
                  print('¡Tiempo terminado!');
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('¡Tiempo terminado! 💥'),
                      backgroundColor: Colors.red,
                    ),
                  );
                });
              },
            ),
            const SizedBox(height: 50),
            
            // Controles externos
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FloatingActionButton(
                  heroTag: "playPause",
                  onPressed: _togglePlayPause,
                  backgroundColor: _isPlaying ? Colors.red : Colors.green,
                  child: Icon(
                    _isPlaying ? Icons.pause : Icons.play_arrow,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 20),
                FloatingActionButton(
                  heroTag: "reset",
                  onPressed: _resetTimer,
                  backgroundColor: Colors.blue,
                  child: const Icon(Icons.refresh, color: Colors.white),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}