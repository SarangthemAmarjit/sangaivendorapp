// Scan Page
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sangaivendorapp/controller/managementcon.dart';
import 'package:sangaivendorapp/model/vendordata.dart';

class ScanPage extends StatefulWidget {
  final VendorData vendorData;
  final Function(int, bool, bool) onTicketScanned;

  const ScanPage({
    super.key,
    required this.vendorData,
    required this.onTicketScanned,
  });

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
    Managementcontroller mngcon = Get.put(Managementcontroller());
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
                      InkWell(
                        onTap: () {
                          mngcon.scanticket(context);
                        },
                        child: Container(
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
