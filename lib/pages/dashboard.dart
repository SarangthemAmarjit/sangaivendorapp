// Dashboard Page
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sangaivendorapp/controller/authcontroller.dart';
import 'package:sangaivendorapp/model/soldticket.dart';
import 'package:sangaivendorapp/model/ticketdata.dart';
import 'package:sangaivendorapp/model/vendordata.dart';
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

  // Calculate today's statistics
  Map<String, dynamic> _getTodayStats() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    final todayTickets = soldTickets.where((ticket) {
      final ticketDate = DateTime.now();
      final ticketDay = DateTime(
        ticketDate.year,
        ticketDate.month,
        ticketDate.day,
      );
      return ticketDay.isAtSameMomentAs(today);
    }).toList();
    double totalBudget = soldTickets.fold(0.0, (sum, ticket) => sum + (50));

    // int generalCount = todayTickets.where((t) => t.ticketType.toLowerCase() == 'general').length;
    // int studentCount = todayTickets.where((t) => t.ticketType.toLowerCase() == 'student').length;

    return {'total': 99, 'budget': totalBudget, 'general': 43, 'student': 56};
  }

  // Calculate overall statistics
  Map<String, dynamic> _getOverallStats() {
    int generalCount = 43;
    int studentCount = 56;
    int totalActivations = soldTickets.length;

    // Calculate total budget (assuming each ticket has an amount field)
    double totalBudget = soldTickets.fold(0.0, (sum, ticket) => sum + (50));

    return {
      'activations': totalActivations,
      'budget': totalBudget,
      'general': generalCount,
      'student': studentCount,
    };
  }

  @override
  Widget build(BuildContext context) {
    int unsyncedCount = soldTickets.where((t) => !t.synced).length;
    final todayStats = _getTodayStats();
    final overallStats = _getOverallStats();
    Authcontroller auth = Get.put(Authcontroller());
    return GetBuilder<Authcontroller>(
      builder: (_) {
        return auth.isfetchingdata
            ? Center(
                child: SizedBox(
                  height: 30,
                  width: 30,
                  child: CircularProgressIndicator(),
                ),
              )
            : Scaffold(
                appBar: AppBar(
                  title: const Text('Dashboard'),
                  backgroundColor: Colors.orange,
                  elevation: 0,
                ),
                body: Container(
                  height: MediaQuery.of(context).size.height,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color.fromARGB(255, 251, 239, 233),
                        Color.fromARGB(255, 229, 248, 225),
                        Color.fromARGB(255, 223, 241, 247),
                      ],
                    ),
                  ),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Welcome, ${Get.find<Authcontroller>().fullname}! 👋',
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

                        // Overall Statistics Section
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Overall Statistics',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF2D3748),
                                ),
                              ),
                              const SizedBox(height: 16),
                              GridView.count(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                crossAxisCount: 2,
                                crossAxisSpacing: 12,
                                mainAxisSpacing: 12,
                                childAspectRatio: 1.4,
                                children: [
                                  StatCard(
                                    title: 'Total Activations',
                                    value: auth
                                        .ticketSummaryModel!
                                        .activatedBySummary
                                        .totalTickets
                                        .toString(),
                                    icon: Icons.verified,
                                    color: Colors.purple,
                                  ),
                                  StatCard(
                                    title: 'Total Budget',
                                    value:
                                        '₹${auth.ticketSummaryModel!.activatedBySummary.totalAmount}',
                                    icon: Icons.account_balance_wallet,
                                    color: Colors.teal,
                                  ),
                                  StatCard(
                                    title: 'General Tickets',
                                    value: auth
                                        .ticketSummaryModel!
                                        .activatedBySummary
                                        .ticketTypeBreakdown
                                        .firstWhere(
                                          (da) => da.ticketTypeId == 1,
                                        )
                                        .count
                                        .toString(),
                                    icon: Icons.person,
                                    color: Colors.blue,
                                  ),
                                  StatCard(
                                    title: 'Student Tickets',
                                    value: auth
                                        .ticketSummaryModel!
                                        .activatedBySummary
                                        .ticketTypeBreakdown
                                        .firstWhere(
                                          (da) => da.ticketTypeId == 2,
                                        )
                                        .count
                                        .toString(),
                                    icon: Icons.school,
                                    color: Colors.indigo,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Today's Statistics Section
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Text(
                                    'Today\'s Statistics',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF2D3748),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Icon(
                                    Icons.today,
                                    size: 20,
                                    color: Colors.orange.shade700,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              GridView.count(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                crossAxisCount: 2,
                                crossAxisSpacing: 12,
                                mainAxisSpacing: 12,
                                childAspectRatio: 1.4,
                                children: [
                                  StatCard(
                                    title: 'Today\'s Activation',
                                    value: auth
                                        .ticketSummaryModel!
                                        .todaySummary
                                        .totalTickets
                                        .toString(),
                                    icon: Icons.today,
                                    color: Colors.green,
                                  ),
                                  StatCard(
                                    title: 'Today Budget',
                                    value:
                                        '₹${auth.ticketSummaryModel!.todaySummary.totalAmount}',
                                    icon: Icons.account_balance_wallet,
                                    color: Colors.teal,
                                  ),
                                  StatCard(
                                    title: 'General Today',
                                    value: auth
                                        .ticketSummaryModel!
                                        .todaySummary
                                        .ticketTypeBreakdown
                                        .firstWhere(
                                          (da) => da.ticketTypeId == 1,
                                        )
                                        .count
                                        .toString()
                                        .toString(),
                                    icon: Icons.person_outline,
                                    color: Colors.lightBlue,
                                  ),
                                  StatCard(
                                    title: 'Student Today',
                                    value: auth
                                        .ticketSummaryModel!
                                        .todaySummary
                                        .ticketTypeBreakdown
                                        .firstWhere(
                                          (da) => da.ticketTypeId == 1,
                                        )
                                        .count
                                        .toString()
                                        .toString(),
                                    icon: Icons.school_outlined,
                                    color: Colors.deepPurple,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Inventory Status Section
                      ],
                    ),
                  ),
                ),
              );
      },
    );
  }
}
