// Settings Page
import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _autoSync = true;
  bool _soundEnabled = true;
  bool _vibrationEnabled = true;
  String _theme = 'Light';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Colors.orange,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.palette, color: Colors.orange),
                  title: const Text('Theme'),
                  trailing: DropdownButton<String>(
                    value: _theme,
                    items: ['Light', 'Dark'].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _theme = newValue!;
                      });
                    },
                  ),
                ),
                const Divider(height: 1),
                SwitchListTile(
                  secondary: const Icon(Icons.sync, color: Colors.orange),
                  title: const Text('Auto Sync'),
                  subtitle: const Text('Automatically sync data when online'),
                  value: _autoSync,
                  activeColor: Colors.orange,
                  onChanged: (bool value) {
                    setState(() {
                      _autoSync = value;
                    });
                  },
                ),
                const Divider(height: 1),
                SwitchListTile(
                  secondary: const Icon(Icons.volume_up, color: Colors.orange),
                  title: const Text('Sound on Scan'),
                  subtitle: const Text('Play sound when scanning tickets'),
                  value: _soundEnabled,
                  activeColor: Colors.orange,
                  onChanged: (bool value) {
                    setState(() {
                      _soundEnabled = value;
                    });
                  },
                ),
                const Divider(height: 1),
                SwitchListTile(
                  secondary: const Icon(Icons.vibration, color: Colors.orange),
                  title: const Text('Vibration on Scan'),
                  subtitle: const Text('Vibrate when scanning tickets'),
                  value: _vibrationEnabled,
                  activeColor: Colors.orange,
                  onChanged: (bool value) {
                    setState(() {
                      _vibrationEnabled = value;
                    });
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}