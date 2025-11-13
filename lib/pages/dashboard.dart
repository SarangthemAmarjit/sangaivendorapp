
// Dashboard Page
import 'package:flutter/material.dart';
import 'package:sangaivendorapp/model/soldticket.dart';
import 'package:sangaivendorapp/model/ticketdata.dart';
import 'package:sangaivendorapp/model/vendordata.dart';
import 'package:sangaivendorapp/pages/helpnsuport.dart';
import 'package:sangaivendorapp/widget/statcard.dart';

class DashboardPage extends StatelessWidget {
  final VendorData vendorData;
  final TicketData ticketData;
  final List<SoldTicket> soldTickets;
  final Function(int) onNavigate;
  final VoidCallback onSync;

  const DashboardPage({
    Key? key,
    required this.vendorData,
    required this.ticketData,
    required this.soldTickets,
    required this.onNavigate,
    required this.onSync,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int unsyncedCount = soldTickets.where((t) => !t.synced).length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        backgroundColor: Colors.orange,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HelpPage()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome, ${vendorData.shopName}! 👋',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2D3748),
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Track and manage your ticket sales',
              style: TextStyle(color: Color(0xFF718096)),
            ),
            const SizedBox(height: 24),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.3,
              children: [
                StatCard(
                  title: 'Total Tickets',
                  value: vendorData.totalTickets.toString(),
                  icon: Icons.confirmation_number,
                  color: Colors.blue,
                ),
                StatCard(
                  title: 'Tickets Sold',
                  value: ticketData.sold.toString(),
                  icon: Icons.check_circle,
                  color: Colors.green,
                ),
                StatCard(
                  title: 'Remaining',
                  value: ticketData.remaining.toString(),
                  icon: Icons.pending,
                  color: Colors.orange,
                ),
                StatCard(
                  title: 'Unsynced',
                  value: unsyncedCount.toString(),
                  icon: Icons.sync_problem,
                  color: Colors.red,
                  subtitle: ticketData.lastSynced,
                ),
              ],
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Colors.orange, Colors.red],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  const Text(
                    'Scan a ticket QR/Barcode to record it as sold instantly',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    alignment: WrapAlignment.center,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () => onNavigate(1),
                        icon: const Icon(Icons.qr_code_scanner),
                        label: const Text('Scan Ticket'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.orange,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: () => onNavigate(2),
                        icon: const Icon(Icons.assessment),
                        label: const Text('View Report'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.orange,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: onSync,
                        icon: const Icon(Icons.sync),
                        label: const Text('Sync Data'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.orange,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}