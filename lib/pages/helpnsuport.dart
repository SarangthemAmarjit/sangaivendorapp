
// Help & Support Page
import 'package:flutter/material.dart';
import 'package:sangaivendorapp/widget/guidestep.dart';

class HelpPage extends StatelessWidget {
  const HelpPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Help & Support'),
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
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.book, color: Colors.orange, size: 32),
                      SizedBox(width: 12),
                      Text(
                        'Quick Guide',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2D3748),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'How to scan and mark tickets as sold:',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2D3748),
                    ),
                  ),
                  const SizedBox(height: 12),
                  GuideStep(
                    number: '1',
                    text:
                        'Navigate to the Scan page from dashboard or bottom menu',
                  ),
                  GuideStep(
                    number: '2',
                    text: 'Position the ticket QR code within the camera frame',
                  ),
                  GuideStep(
                    number: '3',
                    text: 'Or enter the ticket number manually',
                  ),
                  GuideStep(
                    number: '4',
                    text: 'Verify the ticket is within your assigned range',
                  ),
                  GuideStep(
                    number: '5',
                    text: 'Ticket will be marked as sold automatically',
                  ),
                  GuideStep(
                    number: '6',
                    text: 'Sync data regularly to update central server',
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.phone, color: Colors.orange),
                  title: const Text('Support Contact'),
                  subtitle: const Text('+91-XXXXXXXXXX'),
                  trailing: IconButton(
                    icon: const Icon(Icons.call, color: Colors.orange),
                    onPressed: () {},
                  ),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.access_time, color: Colors.orange),
                  title: const Text('Festival Hours'),
                  subtitle: const Text('8:00 AM – 9:00 PM'),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.location_on, color: Colors.orange),
                  title: const Text('Venue'),
                  subtitle: const Text('Hapta Kangjeibung, Imphal'),
                  trailing: IconButton(
                    icon: const Icon(Icons.map, color: Colors.orange),
                    onPressed: () {},
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
