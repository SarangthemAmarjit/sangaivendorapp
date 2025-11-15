// Main Screen with Navigation
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sangaivendorapp/controller/pagecontroller.dart';
import 'package:sangaivendorapp/model/soldticket.dart';
import 'package:sangaivendorapp/model/ticketdata.dart';
import 'package:sangaivendorapp/model/vendordata.dart';
import 'package:sangaivendorapp/pages/dashboard.dart';
import 'package:sangaivendorapp/pages/profilepage.dart';
import 'package:sangaivendorapp/pages/scanpage.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final VendorData vendorData = VendorData(
    shopName: 'Imphal Cultural Crafts',
    ownerName: 'Rajesh Kumar',
    mobile: '+91-9876543210',
    boothId: 'BOOTH-A12',
    rangeStart: 1001,
    rangeEnd: 1500,
    totalTickets: 500,
  );

  TicketData ticketData = TicketData(
    sold: 230,
    remaining: 270,
    lastSynced: '12 Nov, 10:15 AM',
  );

  List<SoldTicket> soldTickets = [
    SoldTicket(
      ticketNo: 1001,
      time: '10:32 AM',
      date: '12 Nov 2025',
      synced: true,
    ),
    SoldTicket(
      ticketNo: 1002,
      time: '10:35 AM',
      date: '12 Nov 2025',
      synced: true,
    ),
    SoldTicket(
      ticketNo: 1003,
      time: '10:38 AM',
      date: '12 Nov 2025',
      synced: false,
    ),
    SoldTicket(
      ticketNo: 1004,
      time: '10:42 AM',
      date: '12 Nov 2025',
      synced: true,
    ),
    SoldTicket(
      ticketNo: 1005,
      time: '10:45 AM',
      date: '12 Nov 2025',
      synced: false,
    ),
  ];

  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      DashboardPage(
        vendorData: vendorData,
        ticketData: ticketData,
        soldTickets: soldTickets,
        onNavigate: (index) =>
            Get.find<PageManagementcontroller>().setnavindex(ind: index),
        onSync: _syncData,
      ),
      ScanPage(),
      // ReportPage(ticketData: ticketData, soldTickets: soldTickets),
      // TicketRangePage(vendorData: vendorData, ticketData: ticketData),
      ProfilePage(vendorData: vendorData),
    ];
  }

  void _syncData() {
    setState(() {
      for (var ticket in soldTickets) {
        ticket.synced = true;
      }
      ticketData.lastSynced =
          '${DateTime.now().day} Nov, ${TimeOfDay.now().format(context)}';
    });
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Data synced successfully!')));
  }

  void _handleTicketScanned(int ticketNo, bool isValid, bool alreadySold) {
    if (isValid && !alreadySold) {
      setState(() {
        soldTickets.insert(
          0,
          SoldTicket(
            ticketNo: ticketNo,
            time: TimeOfDay.now().format(context),
            date: '${DateTime.now().day} Nov ${DateTime.now().year}',
            synced: false,
          ),
        );
        ticketData.sold++;
        ticketData.remaining--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    PageManagementcontroller pngcon = Get.put(PageManagementcontroller());
    return GetBuilder<PageManagementcontroller>(
      builder: (_) {
        return Scaffold(
          body: _pages[pngcon.selectedindex],
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: pngcon.selectedindex,
            onTap: (index) => pngcon.setnavindex(ind: index),
            type: BottomNavigationBarType.fixed,
            selectedItemColor: Colors.orange,
            unselectedItemColor: Colors.grey,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Dashboard',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.qr_code_scanner, size: 40),
                label: 'Scan',
              ),
              // BottomNavigationBarItem(
              //   icon: Icon(Icons.assessment),
              //   label: 'Report',
              // ),
              // BottomNavigationBarItem(
              //   icon: Icon(Icons.confirmation_number),
              //   label: 'Range',
              // ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Profile',
              ),
            ],
          ),
        );
      },
    );
  }
}
