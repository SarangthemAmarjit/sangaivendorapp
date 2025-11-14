// Profile Page
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sangaivendorapp/controller/authcontroller.dart';
import 'package:sangaivendorapp/model/vendordata.dart';
import 'package:sangaivendorapp/pages/setting.dart';
import 'package:sangaivendorapp/widget/profile.dart';

class ProfilePage extends StatelessWidget {
  final VendorData vendorData;

  const ProfilePage({super.key, required this.vendorData});

  @override
  Widget build(BuildContext context) {
    Authcontroller authcon = Get.put(Authcontroller());
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.orange,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsPage()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Colors.orange, Colors.red],
                        ),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: const Icon(
                        Icons.store,
                        size: 50,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      vendorData.shopName,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2D3748),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      vendorData.boothId,
                      style: const TextStyle(
                        color: Color(0xFF718096),
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 24),
                    ProfileItem(
                      icon: Icons.person,
                      label: 'Owner Name',
                      value: vendorData.ownerName,
                    ),
                    const SizedBox(height: 16),
                    ProfileItem(
                      icon: Icons.phone,
                      label: 'Mobile Number',
                      value: vendorData.mobile,
                    ),
                    const SizedBox(height: 16),
                    ProfileItem(
                      icon: Icons.store,
                      label: 'Booth ID',
                      value: vendorData.boothId,
                    ),
                    const SizedBox(height: 16),
                    ProfileItem(
                      icon: Icons.confirmation_number,
                      label: 'Assigned Range',
                      value:
                          '${vendorData.rangeStart} - ${vendorData.rangeEnd}',
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: OutlinedButton.icon(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Logout'),
                              content: const Text(
                                'Are you sure you want to logout?',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('Cancel'),
                                ),
                                OutlinedButton(
                                  onPressed: () {
                                    authcon.logout();
                                  },
                                  style: OutlinedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      side: BorderSide(color: Colors.red),
                                      borderRadius:
                                          BorderRadiusGeometry.circular(10),
                                    ),
                                  ),
                                  child: const Text('Logout'),
                                ),
                              ],
                            ),
                          );
                        },
                        icon: const Icon(Icons.logout, color: Colors.red),
                        label: const Text(
                          'Logout',
                          style: TextStyle(color: Colors.red),
                        ),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.red),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Version 1.0.0 • © Sangai Festival Committee 2025',
              style: TextStyle(color: Color(0xFF718096), fontSize: 12),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
