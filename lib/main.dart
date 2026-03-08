import 'package:flutter/material.dart';
import 'package:camera/camera.dart'; 
import 'dart:async';

late List<CameraDescription> cameras;

Future<void> main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    cameras = await availableCameras();
  } catch (e) {
    print("Gagal mendeteksi kamera: $e");
    cameras = [];
  }
  runApp(const TelkomGateApp());
}

class TelkomGateApp extends StatelessWidget {
  const TelkomGateApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFFC32031),
      ),
      home: const GateDashboard(),
    );
  }
}

class GateDashboard extends StatefulWidget {
  const GateDashboard({super.key});

  @override
  State<GateDashboard> createState() => _GateDashboardState();
}

// PERBAIKAN: Menyambungkan kembali State ke Class GateDashboard
class _GateDashboardState extends State<GateDashboard> {
  CameraController? controller;
  bool isCameraInitialized = false;

  String statusVerifikasi = "Mendeteksi Wajah";
  String animatedDots = "";
  Timer? _dotsTimer;
  String namaUser = "-";
  String nimUser = "-";
  bool isDetected = false; // false = Standby, true = Ada Motor

  // Animasi instruksi
  final PageController _instructionController = PageController();
  int _currentInstruction = 0;
  Timer? _instructionTimer;
  final List<Map<String, dynamic>> _instructions = [
    {"text": "BUKA KACA HELM", "icon": Icons.sports_motorsports},
    {"text": "BUKA MASKER DAN KACAMATA", "icon": Icons.masks},
    {"text": "ATUR JARAK ANDA DENGAN KAMERA", "icon": Icons.straighten},
    {"text": "POSISIKAN WAJAH KE KAMERA", "icon": Icons.face_retouching_natural},
  ];

  @override
  void initState() {
    super.initState();
    _initializeCamera();
    _startDotsAnimation();
    _instructionTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (_instructionController.hasClients) {
        _currentInstruction = (_currentInstruction + 1) % _instructions.length;
        _instructionController.animateToPage(
          _currentInstruction,
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  void _startDotsAnimation() {
    _dotsTimer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      if (mounted) {
        setState(() {
          int dotsCount = (animatedDots.length + 1) % 4;
          animatedDots = "." * dotsCount;
        });
      }
    });
  }

  Future<void> _initializeCamera() async {
    if (cameras.isEmpty) return;

    controller = CameraController(
      cameras[0],
      ResolutionPreset.medium,
      enableAudio: false,
    );

    try {
      await controller!.initialize();
      if (!mounted) return;
      setState(() {
        isCameraInitialized = true;
      });
    } catch (e) {
      print("Kamera Windows Error: $e");
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    _dotsTimer?.cancel();
    _instructionTimer?.cancel();
    _instructionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              child: !isDetected
                  ? _buildStandbyUI()
                  : Row(
                      key: const ValueKey("ActiveUI"),
                      children: [
                        _buildCameraPanel(),
                        _buildDataPanel(),
                      ],
                    ),
            ),
          ),
          _buildFooter(),
        ],
      ),
    );
  }

  Widget _buildStandbyUI() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 30),
          SizedBox(
            height: 300,
            width: 1200,
            child: PageView.builder(
              controller: _instructionController,
              itemCount: _instructions.length,
              itemBuilder: (context, index) {
                final iconData = _instructions[index]['icon'];
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (iconData is List)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(iconData[0], size: 120, color: const Color(0xFFC32031)),
                          const SizedBox(width: 30),
                          Icon(iconData[1], size: 120, color: const Color(0xFFC32031)),
                        ],
                      )
                    else
                      Icon(iconData, size: 150, color: const Color(0xFFC32031)),
                    const SizedBox(height: 10),
                    Text(
                      _instructions[index]['text'],
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 60,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          ElevatedButton(
            onPressed: () => setState(() => isDetected = true),
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFC32031)),
            child: const Text("VERIFIKASI WAJAH ANDA", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 40),
      decoration: BoxDecoration(
        color: const Color(0xFFC32031),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          const FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              "SELAMAT DATANG DI TELKOM UNIVERSITY",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 52,
                fontWeight: FontWeight.bold,
                letterSpacing: 2.0,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Container(height: 3, width: 300, color: const Color(0xFFB4975A)),
        ],
      ),
    );
  }

  Widget _buildCameraPanel() {
    return Expanded(
      flex: 2,
      child: Container(
        margin: const EdgeInsets.all(25),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFB4975A), width: 5),
          boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 15)],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: (isCameraInitialized && controller != null)
              ? AspectRatio(
                  aspectRatio: controller!.value.aspectRatio,
                  child: CameraPreview(controller!),
                )
              : const Center(
                  child: CircularProgressIndicator(color: Color(0xFFB4975A)),
                ),
        ),
      ),
    );
  }

  Widget _buildDataPanel() {
    return Expanded(
      flex: 1,
      child: Container(
        margin: const EdgeInsets.only(right: 25, top: 25, bottom: 25),
        padding: const EdgeInsets.all(35),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey[300]!),
          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10)],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const FittedBox(
              child: Text(
                "IDENTITAS PENGGUNA",
                style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFC32031), fontSize: 28),
              ),
            ),
            const Divider(thickness: 2, height: 40),
            _infoTile("NAMA LENGKAP", namaUser),
            const SizedBox(height: 15),
            _infoTile("NIM / NIP", nimUser),
            const Spacer(),
            _statusBox(statusVerifikasi),
          ],
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        border: Border(top: BorderSide(color: Colors.grey[300]!)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/logo_telkom.png', // Ganti path sesuai lokasi logo
            height: 40,
          ),
        ],
      ),
    );
  }

  Widget _infoTile(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 14, color: Colors.grey, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Text(
          value, 
          style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.black87),
          overflow: TextOverflow.ellipsis, // Agar tidak berantakan jika nama terlalu panjang
        ),
      ],
    );
  }

  Widget _statusBox(String status) {
    bool isAuthorized = status.contains("Berhasil");
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isAuthorized ? Colors.green[600] : Colors.orange[700],
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: (isAuthorized ? Colors.green : Colors.orange).withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            isAuthorized ? status.toUpperCase() : status + animatedDots,
            key: ValueKey(isAuthorized ? status : status + animatedDots),
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 32),
          ),
        ),
      ),
    );
  }
}