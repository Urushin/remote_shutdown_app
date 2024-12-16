import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_animate/flutter_animate.dart';

void main() {
  runApp(const RemoteShutdownApp());
}

/// Configuration centralisée des paramètres de connexion.
class AppConfig {
  static String ipAddress = "192.168.0.92"; // Adresse IP de ton PC
  static String password = "ton_mot_de_passe"; // Mot de passe sécurisé
}

class RemoteShutdownApp extends StatelessWidget {
  const RemoteShutdownApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Arrêt à Distance',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blueAccent,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),
      home: const ShutdownPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class ShutdownPage extends StatefulWidget {
  const ShutdownPage({super.key});

  @override
  State<ShutdownPage> createState() => _ShutdownPageState();
}

class _ShutdownPageState extends State<ShutdownPage> {
  String _statusMessage = "";
  bool _isLoading = false;

  /// Envoie une requête HTTP GET au serveur Flask.
  Future<void> sendShutdownRequest(String endpoint, {int? delayMinutes}) async {
    setState(() {
      _isLoading = true;
      _statusMessage = "";
    });

    final String delayParam = delayMinutes != null ? "&minutes=$delayMinutes" : "";
    final url = Uri.parse(
      "http://${AppConfig.ipAddress}:5000/$endpoint?password=${AppConfig.password}$delayParam",
    );

    try {
      final response = await http.get(url);
      setState(() {
        _isLoading = false;
        if (response.statusCode == 200) {
          _statusMessage = "✅ Commande envoyée avec succès.";
        } else {
          _statusMessage = "❌ Erreur : ${response.statusCode} - ${response.body}";
        }
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _statusMessage = "❌ Erreur de connexion : $e";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Arrêt à Distance",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.blueAccent.shade200,
                Colors.blueAccent.shade700
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        elevation: 10,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => _showSettingsDialog(),
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            elevation: 12,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Contrôle d'Arrêt PC",
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                          color: Colors.blueAccent,
                          fontWeight: FontWeight.bold,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  Image.asset(
                    'assets/shutdown_icon.png',
                    height: 150,
                  ).animate()
                    .fadeIn(duration: const Duration(milliseconds: 500))
                    .slideY(begin: 0.1, end: 0),
                  const SizedBox(height: 30),
                  _buildShutdownButton(
                    label: "Éteindre Maintenant",
                    icon: Icons.power_settings_new,
                    color: Colors.redAccent,
                    onPressed: () => sendShutdownRequest("shutdown-now"),
                  ),
                  const SizedBox(height: 20),
                  _buildShutdownButton(
                    label: "Éteindre dans 10 Minutes",
                    icon: Icons.timer,
                    color: Colors.orangeAccent,
                    onPressed: () => sendShutdownRequest(
                      "shutdown-delay",
                      delayMinutes: 10,
                    ),
                  ),
                  const SizedBox(height: 30),
                  Divider(color: Colors.grey[300], thickness: 1),
                  const SizedBox(height: 20),
                  if (_isLoading)
                    const CircularProgressIndicator()
                  else
                    Text(
                      _statusMessage,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.black87,
                      ),
                    ),
                ],
              ),
            ),
          ).animate()
            .fadeIn(duration: const Duration(milliseconds: 500))
            .scale(begin: Offset(0.9, 0.9), end: Offset(1.0, 1.0)),
        ),
      ),
    );
  }

  Widget _buildShutdownButton({
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton.icon(
      onPressed: _isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        disabledBackgroundColor: color.withAlpha(100), // Correction du warning withOpacity
      ),
      icon: Icon(icon, color: Colors.white),
      label: Text(
        label,
        style: const TextStyle(fontSize: 18, color: Colors.white),
      ),
    ).animate()
      .fadeIn(duration: const Duration(milliseconds: 500))
      .slideX(begin: 0.1, end: 0);
  }

  void _showSettingsDialog() {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Paramètres de Connexion'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Adresse IP',
                  hintText: 'Ex: 192.168.0.92',
                ),
                onChanged: (value) {
                  AppConfig.ipAddress = value;
                },
                controller: TextEditingController(text: AppConfig.ipAddress),
              ),
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Mot de passe',
                  hintText: 'Mot de passe de connexion',
                ),
                obscureText: true,
                onChanged: (value) {
                  AppConfig.password = value;
                },
                controller: TextEditingController(text: AppConfig.password),
              ),
            ],
          ),
          actions: [
            TextButton(
              child: const Text('Annuler'),
              onPressed: () => Navigator.of(dialogContext).pop(),
            ),
            ElevatedButton(
              child: const Text('Enregistrer'),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
          ],
        );
      },
    );
  }
}