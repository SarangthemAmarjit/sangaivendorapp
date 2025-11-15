// Dashboard Page
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sangaivendorapp/controller/authcontroller.dart';
import 'package:sangaivendorapp/widget/statcard.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Authcontroller auth = Get.find<Authcontroller>();
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
