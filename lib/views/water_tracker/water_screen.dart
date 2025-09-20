import 'dart:ui' as ui;
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_images.dart';
import '../../models/water_model.dart';
import '../../view_models/water_vm.dart';
import '../../../widgets/custom_appbar.dart';

class WaterTrackerScreen extends StatefulWidget {
  const WaterTrackerScreen({super.key});

  @override
  State<WaterTrackerScreen> createState() => _WaterTrackerScreenState();
}

class _WaterTrackerScreenState extends State<WaterTrackerScreen>
    with SingleTickerProviderStateMixin {
  final WaterTrackerViewModel vm = Get.put(WaterTrackerViewModel(), permanent: true);
  ui.Image? maskImage;
  late AnimationController _waveController;

  @override
  void initState() {
    super.initState();
    _loadMaskImage();
    _waveController = AnimationController(
        vsync: this, duration: const Duration(seconds: 2))
      ..repeat();
    vm.checkNewDay(); // save yesterday's total if date changed
  }

  Future<void> _loadMaskImage() async {
    final data = await rootBundle.load(AppImages.people);
    final bytes = data.buffer.asUint8List();
    final codec = await ui.instantiateImageCodec(bytes);
    final frame = await codec.getNextFrame();
    setState(() => maskImage = frame.image);
  }

  @override
  void dispose() {
    _waveController.dispose();
    super.dispose();
  }

  void _updateWaterFromSlider(double localY, double height) {
    double progress = (height - localY) / height; // 0.0 to 1.0
    int newValue = (progress * vm.dailyGoal).round();
    newValue = ((newValue / 250).round() * 250).clamp(0, vm.dailyGoal);
    vm.setWater(newValue);
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width * 0.5;
    final height = MediaQuery.of(context).size.height * 0.5;

    return Scaffold(
      backgroundColor: AppColors.lightBlue.withOpacity(0.7),
      appBar: CustomAppBar(title: '💦 Water Tracker', centerTitle: true),
      body: maskImage == null
          ? const Center(child: CircularProgressIndicator())
          : Obx(() {
        final tipHeight = 30.0;
        final fillHeight = height * vm.progress.value;
        final tipPosition = height - fillHeight - tipHeight - 10;

        return SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 10),
              // Top intake box
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey.shade400,
                        blurRadius: 10,
                        offset: const Offset(0, 4))
                  ],
                ),
                child: Text(
                  "${vm.totalIntake.value} / ${vm.dailyGoal} ml",
                  style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87),
                ),
              ),
              const SizedBox(height: 8),
              // Water bottle + vertical slider
              Center(
                child: SizedBox(
                  height: height,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Vertical Slider
                      SizedBox(
                        width: 50,
                        height: height,
                        child: GestureDetector(
                          onVerticalDragUpdate: (details) {
                            RenderBox box = context.findRenderObject() as RenderBox;
                            Offset local = box.globalToLocal(details.globalPosition);
                            double localY = local.dy - 24;
                            localY = localY.clamp(0.0, height);
                            _updateWaterFromSlider(localY, height);
                          },
                          onTapDown: (details) {
                            RenderBox box = context.findRenderObject() as RenderBox;
                            Offset local = box.globalToLocal(details.globalPosition);
                            double localY = local.dy - 24;
                            localY = localY.clamp(0.0, height);
                            _updateWaterFromSlider(localY, height);
                          },
                          child: Stack(
                            alignment: Alignment.bottomCenter,
                            children: [
                              Container(
                                width: 8,
                                height: height,
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade300,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                child: Container(
                                  width: 8,
                                  height: height * vm.progress.value,
                                  decoration: BoxDecoration(
                                    color: AppColors.lightBlue,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: (height * vm.progress.value - 18)
                                    .clamp(0.0, height - 36),
                                child: Container(
                                  width: 36,
                                  height: 36,
                                  decoration: BoxDecoration(
                                    color: Colors.blue,
                                    shape: BoxShape.circle,
                                    border: Border.all(color: Colors.white, width: 2),
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    "${vm.totalIntake.value}",
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      // Water container
                      SizedBox(
                        width: width,
                        height: height,
                        child: Stack(
                          alignment: Alignment.center,
                          clipBehavior: Clip.none,
                          children: [
                            AnimatedBuilder(
                              animation: _waveController,
                              builder: (_, __) {
                                return CustomPaint(
                                  size: Size(width, height),
                                  painter: _WaterWavePainter(
                                    fillPercentage: vm.progress.value,
                                    maskImage: maskImage!,
                                    wavePhase: _waveController.value * 2 * pi,
                                  ),
                                );
                              },
                            ),
                            Positioned(
                              top: tipPosition.clamp(0.0, height - tipHeight),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade200,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  "${vm.totalIntake.value} ml",
                                  style: const TextStyle(
                                    color: Colors.black87,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
              // Gradient button section
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  gradient: LinearGradient(
                    colors: [Colors.blue.shade400, Colors.blue.shade800],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.shade200.withOpacity(0.4),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () => vm.addWater(200),
                          icon: const Icon(Icons.add),
                          label: const Text("A glass of water"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.blue.shade800,
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                          ),
                        ),
                        const SizedBox(width: 16),
                        ElevatedButton.icon(
                          onPressed: vm.undoLastEntry,
                          icon: const Icon(Icons.undo),
                          label: const Text("Undo"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.blue.shade800,
                            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                        ),
                      ],
                    ),
                    //const SizedBox(height: 6),

                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.lightbulb, color: Colors.yellow.shade800),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              '💦 Hydrate Now and Fill Me Up!\n1 glass = 200ml',
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              // Scrollable 24-hour history (only previous days)
              // Container(
              //   margin: const EdgeInsets.symmetric(horizontal: 20),
              //   padding: const EdgeInsets.all(12),
              //   decoration: BoxDecoration(
              //     color: Colors.white,
              //     borderRadius: BorderRadius.circular(20),
              //     boxShadow: [
              //       BoxShadow(color: Colors.grey.shade300, blurRadius: 6, offset: const Offset(0, 3)),
              //     ],
              //   ),
              //   child: Column(
              //     crossAxisAlignment: CrossAxisAlignment.start,
              //     children: [
              //       const Text("24-Hour History",
              //           style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              //       const SizedBox(height: 8),
              //       FutureBuilder<List<WaterEntry>>(
              //         future: vm.getLast24HourEntries(), // new method in VM
              //         builder: (context, snapshot) {
              //           if (!snapshot.hasData) {
              //             return const Center(child: CircularProgressIndicator());
              //           }
              //           final history = snapshot.data!;
              //           if (history.isEmpty) {
              //             return const Text("No entries yet", style: TextStyle(color: Colors.grey));
              //           }
              //           return SizedBox(
              //             height: 120,
              //             child: ListView.builder(
              //               itemCount: history.length,
              //               itemBuilder: (context, index) {
              //                 final entry = history[index];
              //                 return ListTile(
              //                   dense: true,
              //                   contentPadding: EdgeInsets.zero,
              //                   title: Text("${entry.amount} ml"),
              //                   subtitle: Text(
              //                     "${entry.timestamp.hour.toString().padLeft(2, '0')}:${entry.timestamp.minute.toString().padLeft(2, '0')}",
              //                     style: const TextStyle(fontSize: 12, color: Colors.grey),
              //                   ),
              //                 );
              //               },
              //             ),
              //           );
              //         },
              //       ),
              //     ],
              //   ),
              // ),
              //const SizedBox(height: 20),
            ],
          ),
        );
      }),
    );
  }
}

class _WaterWavePainter extends CustomPainter {
  final double fillPercentage;
  final ui.Image maskImage;
  final double wavePhase;

  _WaterWavePainter({
    required this.fillPercentage,
    required this.maskImage,
    required this.wavePhase,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    final baseHeight = size.height * (1 - fillPercentage);

    final path = Path();
    final waveHeight = 10.0;
    final waveLength = size.width / 1.5;

    path.moveTo(0, size.height);
    path.lineTo(0, baseHeight);

    for (double x = 0; x <= size.width; x++) {
      final y = sin((2 * pi / waveLength) * x + wavePhase) * waveHeight;
      path.lineTo(x, baseHeight + y);
    }

    path.lineTo(size.width, size.height);
    path.close();

    paint.shader = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Colors.blue.shade900, Colors.blue, AppColors.lightBlue],
    ).createShader(Rect.fromLTWH(0, baseHeight, size.width, size.height - baseHeight));

    canvas.saveLayer(Rect.fromLTWH(0, 0, size.width, size.height), Paint());
    canvas.drawPath(path, paint);

    paint.blendMode = BlendMode.dstIn;
    canvas.drawImageRect(
      maskImage,
      Rect.fromLTWH(0, 0, maskImage.width.toDouble(), maskImage.height.toDouble()),
      Rect.fromLTWH(0, 0, size.width, size.height),
      paint,
    );
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _WaterWavePainter oldDelegate) =>
      oldDelegate.fillPercentage != fillPercentage || oldDelegate.wavePhase != wavePhase;
}
