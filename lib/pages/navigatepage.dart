// Main Screen with Navigation
import 'package:flutter/material.dart';
import 'package:sangaivendorapp/model/soldticket.dart';
import 'package:sangaivendorapp/model/ticketdata.dart';
import 'package:sangaivendorapp/model/vendordata.dart';
import 'package:sangaivendorapp/pages/dashboard.dart';
import 'package:sangaivendorapp/pages/profilepage.dart';
import 'package:sangaivendorapp/pages/reportpage.dart';
import 'package:sangaivendorapp/pages/scanpage.dart';
import 'package:sangaivendorapp/pages/ticketrangepage.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

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
        onNavigate: (index) => setState(() => _selectedIndex = index),
        onSync: _syncData,
      ),
      ScanPage(vendorData: vendorData, onTicketScanned: _handleTicketScanned),
      ReportPage(ticketData: ticketData, soldTickets: soldTickets),
      TicketRangePage(vendorData: vendorData, ticketData: ticketData),
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
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.orange,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Dashboard'),
          BottomNavigationBarItem(
            icon: Icon(Icons.qr_code_scanner),
            label: 'Scan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assessment),
            label: 'Report',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.confirmation_number),
            label: 'Range',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
