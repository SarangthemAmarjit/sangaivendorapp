import 'package:flutter/material.dart';

void main() {
  runApp(const SangaiVendorApp());
}

class SangaiVendorApp extends StatelessWidget {
  const SangaiVendorApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sangai Vendor App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.orange,
        scaffoldBackgroundColor: const Color(0xFFFFF5F0),
        fontFamily: 'Roboto',
      ),
      home: const LoginPage(),
    );
  }
}

// Models
class VendorData {
  final String shopName;
  final String ownerName;
  final String mobile;
  final String boothId;
  final int rangeStart;
  final int rangeEnd;
  final int totalTickets;

  VendorData({
    required this.shopName,
    required this.ownerName,
    required this.mobile,
    required this.boothId,
    required this.rangeStart,
    required this.rangeEnd,
    required this.totalTickets,
  });
}

class TicketData {
  int sold;
  int remaining;
  String lastSynced;

  TicketData({
    required this.sold,
    required this.remaining,
    required this.lastSynced,
  });
}

class SoldTicket {
  final int ticketNo;
  final String time;
  final String date;
  bool synced;

  SoldTicket({
    required this.ticketNo,
    required this.time,
    required this.date,
    required this.synced,
  });
}

// Login Page
class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  bool _otpSent = false;

  void _sendOtp() {
    if (_mobileController.text.length == 10) {
      setState(() {
        _otpSent = true;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid 10-digit mobile number'),
        ),
      );
    }
  }

  void _verifyOtp() {
    if (_otpController.text == '123456') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MainScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid OTP. Try 123456 for demo')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFFFF5F0), Color(0xFFFFE8E0)],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Container(
                padding: const EdgeInsets.all(32.0),
                constraints: const BoxConstraints(maxWidth: 400),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Colors.orange, Colors.red],
                        ),
                        borderRadius: BorderRadius.circular(40),
                      ),
                      child: const Icon(
                        Icons.qr_code,
                        size: 40,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Sangai Festival',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2D3748),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Vendor Ticket Management',
                      style: TextStyle(fontSize: 16, color: Color(0xFF718096)),
                    ),
                    const SizedBox(height: 32),
                    if (!_otpSent) ...[
                      const Text(
                        'Enter your registered mobile number to access your Sangai Ticket Dashboard.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Color(0xFF4A5568)),
                      ),
                      const SizedBox(height: 24),
                      TextField(
                        controller: _mobileController,
                        keyboardType: TextInputType.phone,
                        maxLength: 10,
                        decoration: InputDecoration(
                          hintText: 'Enter Mobile Number',
                          prefixIcon: const Icon(Icons.phone),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: Colors.orange,
                              width: 2,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: _sendOtp,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Send OTP',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ] else ...[
                      Text(
                        'Enter the 6-digit OTP sent to ${_mobileController.text}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Color(0xFF4A5568)),
                      ),
                      const SizedBox(height: 24),
                      TextField(
                        controller: _otpController,
                        keyboardType: TextInputType.number,
                        maxLength: 6,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 24, letterSpacing: 8),
                        decoration: InputDecoration(
                          hintText: 'Enter OTP',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: Colors.orange,
                              width: 2,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: _verifyOtp,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Verify OTP',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _otpSent = false;
                            _otpController.clear();
                          });
                        },
                        child: const Text('Change Number'),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Main Screen with Navigation
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

// Dashboard Page
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
                _StatCard(
                  title: 'Total Tickets',
                  value: vendorData.totalTickets.toString(),
                  icon: Icons.confirmation_number,
                  color: Colors.blue,
                ),
                _StatCard(
                  title: 'Tickets Sold',
                  value: ticketData.sold.toString(),
                  icon: Icons.check_circle,
                  color: Colors.green,
                ),
                _StatCard(
                  title: 'Remaining',
                  value: ticketData.remaining.toString(),
                  icon: Icons.pending,
                  color: Colors.orange,
                ),
                _StatCard(
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

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final String? subtitle;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border(left: BorderSide(color: color, width: 4)),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          color: Color(0xFF718096),
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        value,
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2D3748),
                        ),
                      ),
                      if (subtitle != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          subtitle!,
                          style: const TextStyle(
                            fontSize: 10,
                            color: Color(0xFF718096),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                Icon(icon, size: 40, color: color.withOpacity(0.3)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Scan Page
class ScanPage extends StatefulWidget {
  final VendorData vendorData;
  final Function(int, bool, bool) onTicketScanned;

  const ScanPage({
    Key? key,
    required this.vendorData,
    required this.onTicketScanned,
  }) : super(key: key);

  @override
  State<ScanPage> createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  final TextEditingController _ticketController = TextEditingController();
  String? _scanResult;
  String? _scanMessage;
  Color? _resultColor;
  IconData? _resultIcon;

  void _scanTicket() {
    if (_ticketController.text.isEmpty) {
      return;
    }

    int ticketNo = int.parse(_ticketController.text);
    bool isInRange =
        ticketNo >= widget.vendorData.rangeStart &&
        ticketNo <= widget.vendorData.rangeEnd;

    // Simulate checking if already sold (you'd check against actual sold tickets)
    bool alreadySold = ticketNo <= 1005 && ticketNo >= 1001;

    setState(() {
      if (!isInRange) {
        _scanResult = 'Invalid Ticket';
        _scanMessage =
            'Ticket #$ticketNo is not in your assigned range\n(${widget.vendorData.rangeStart} - ${widget.vendorData.rangeEnd})';
        _resultColor = Colors.red;
        _resultIcon = Icons.cancel;
      } else if (alreadySold) {
        _scanResult = 'Already Sold';
        _scanMessage = 'Ticket #$ticketNo was already sold';
        _resultColor = Colors.orange;
        _resultIcon = Icons.warning;
      } else {
        _scanResult = 'Success!';
        _scanMessage = 'Ticket #$ticketNo marked as sold successfully';
        _resultColor = Colors.green;
        _resultIcon = Icons.check_circle;
        widget.onTicketScanned(ticketNo, isInRange, alreadySold);
      }
    });
  }

  void _reset() {
    setState(() {
      _scanResult = null;
      _scanMessage = null;
      _ticketController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan Ticket'),
        backgroundColor: Colors.orange,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: _scanResult == null
                ? Column(
                    children: [
                      Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.orange.shade100,
                              Colors.red.shade100,
                            ],
                          ),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: Colors.orange.shade300,
                            width: 3,
                            style: BorderStyle.solid,
                          ),
                        ),
                        child: const Icon(
                          Icons.qr_code_scanner,
                          size: 100,
                          color: Colors.orange,
                        ),
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'Position the QR code or barcode within the frame',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Color(0xFF718096)),
                      ),
                      const SizedBox(height: 24),
                      TextField(
                        controller: _ticketController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: 'Or enter ticket number manually',
                          prefixIcon: const Icon(Icons.confirmation_number),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: Colors.orange,
                              width: 2,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: _scanTicket,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Verify Ticket',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                : Column(
                    children: [
                      Icon(_resultIcon, size: 100, color: _resultColor),
                      const SizedBox(height: 16),
                      Text(
                        _scanResult!,
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: _resultColor,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _scanMessage!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Color(0xFF4A5568),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: _reset,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.orange,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Text('Scan Next'),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () => Navigator.pop(context),
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                side: const BorderSide(color: Colors.orange),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Text('Dashboard'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}

// Report Page
class ReportPage extends StatelessWidget {
  final TicketData ticketData;
  final List<SoldTicket> soldTickets;

  const ReportPage({
    Key? key,
    required this.ticketData,
    required this.soldTickets,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int totalRevenue = ticketData.sold * 100;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sales Report'),
        backgroundColor: Colors.orange,
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Export feature coming soon!')),
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
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _ReportStat(
                      title: 'Total Sold',
                      value: ticketData.sold.toString(),
                      color: Colors.green,
                    ),
                    _ReportStat(
                      title: 'Revenue',
                      value: '₹${totalRevenue.toString()}',
                      color: Colors.blue,
                    ),
                    _ReportStat(
                      title: 'Unsold',
                      value: ticketData.remaining.toString(),
                      color: Colors.orange,
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
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade50,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16),
                      ),
                    ),
                    child: Row(
                      children: const [
                        Expanded(
                          flex: 2,
                          child: Text(
                            'Ticket No',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                            'Time',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                            'Status',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: soldTickets.length,
                    separatorBuilder: (context, index) =>
                        const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final ticket = soldTickets[index];
                      return Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: Text(
                                ticket.ticketNo.toString(),
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            Expanded(flex: 2, child: Text(ticket.time)),
                            Expanded(
                              flex: 2,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: ticket.synced
                                      ? Colors.green.shade100
                                      : Colors.orange.shade100,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  ticket.synced ? 'Synced' : 'Pending',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: ticket.synced
                                        ? Colors.green.shade800
                                        : Colors.orange.shade800,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
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

class _ReportStat extends StatelessWidget {
  final String title;
  final String value;
  final Color color;

  const _ReportStat({
    required this.title,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          style: const TextStyle(color: Color(0xFF718096), fontSize: 12),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
}

// Ticket Range Page
class TicketRangePage extends StatelessWidget {
  final VendorData vendorData;
  final TicketData ticketData;

  const TicketRangePage({
    Key? key,
    required this.vendorData,
    required this.ticketData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Assigned Ticket Range'),
        backgroundColor: Colors.orange,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Colors.orange, Colors.red],
                    ),
                    borderRadius: BorderRadius.circular(60),
                  ),
                  child: const Icon(
                    Icons.qr_code,
                    size: 60,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  '${vendorData.rangeStart} – ${vendorData.rangeEnd}',
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2D3748),
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Your Assigned Range',
                  style: TextStyle(color: Color(0xFF718096), fontSize: 16),
                ),
                const SizedBox(height: 32),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          children: [
                            const Text(
                              'Total Tickets',
                              style: TextStyle(
                                color: Colors.blue,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              vendorData.totalTickets.toString(),
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.green.shade50,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          children: [
                            const Text(
                              'Sold Tickets',
                              style: TextStyle(
                                color: Colors.green,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              ticketData.sold.toString(),
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.orange.shade50,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          children: [
                            const Text(
                              'Remaining',
                              style: TextStyle(
                                color: Colors.orange,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              ticketData.remaining.toString(),
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.orange,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.yellow.shade50,
                    border: Border.all(color: Colors.yellow.shade200),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.warning, color: Colors.orange),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'You have been assigned ticket numbers from ${vendorData.rangeStart} to ${vendorData.rangeEnd}. Ensure you only scan tickets within this range.',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFF744210),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Profile Page
class ProfilePage extends StatelessWidget {
  final VendorData vendorData;

  const ProfilePage({Key? key, required this.vendorData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                    _ProfileItem(
                      icon: Icons.person,
                      label: 'Owner Name',
                      value: vendorData.ownerName,
                    ),
                    const SizedBox(height: 16),
                    _ProfileItem(
                      icon: Icons.phone,
                      label: 'Mobile Number',
                      value: vendorData.mobile,
                    ),
                    const SizedBox(height: 16),
                    _ProfileItem(
                      icon: Icons.store,
                      label: 'Booth ID',
                      value: vendorData.boothId,
                    ),
                    const SizedBox(height: 16),
                    _ProfileItem(
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
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.of(context).pushAndRemoveUntil(
                                      MaterialPageRoute(
                                        builder: (context) => const LoginPage(),
                                      ),
                                      (route) => false,
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
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

class _ProfileItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _ProfileItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.orange),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF718096),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF2D3748),
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

// Settings Page
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

// Help & Support Page
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
                  _GuideStep(
                    number: '1',
                    text:
                        'Navigate to the Scan page from dashboard or bottom menu',
                  ),
                  _GuideStep(
                    number: '2',
                    text: 'Position the ticket QR code within the camera frame',
                  ),
                  _GuideStep(
                    number: '3',
                    text: 'Or enter the ticket number manually',
                  ),
                  _GuideStep(
                    number: '4',
                    text: 'Verify the ticket is within your assigned range',
                  ),
                  _GuideStep(
                    number: '5',
                    text: 'Ticket will be marked as sold automatically',
                  ),
                  _GuideStep(
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

class _GuideStep extends StatelessWidget {
  final String number;
  final String text;

  const _GuideStep({required this.number, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Colors.orange, Colors.red],
              ),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Center(
              child: Text(
                number,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                text,
                style: const TextStyle(fontSize: 14, color: Color(0xFF4A5568)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
