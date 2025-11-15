// Scan Page
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sangaivendorapp/config/cons.dart';
import 'package:sangaivendorapp/controller/managementcon.dart';
import 'package:sangaivendorapp/controller/pagecontroller.dart';

class ScanPage extends StatefulWidget {
  const ScanPage({super.key});

  @override
  State<ScanPage> createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  final _formKey = GlobalKey<FormState>();

  // void _scanTicket() {
  //   if (_ticketController.text.isEmpty) {
  //     return;
  //   }

  //   int ticketNo = int.parse(_ticketController.text);
  //   bool isInRange =
  //       ticketNo >= widget.vendorData.rangeStart &&
  //       ticketNo <= widget.vendorData.rangeEnd;

  //   // Simulate checking if already sold (you'd check against actual sold tickets)
  //   bool alreadySold = ticketNo <= 1005 && ticketNo >= 1001;

  //   setState(() {
  //     if (!isInRange) {
  //       mngcon.scanResult = 'Invalid Ticket';
  //       _scanMessage =
  //           'Ticket #$ticketNo is not in your assigned range\n(${widget.vendorData.rangeStart} - ${widget.vendorData.rangeEnd})';
  //       mngcon. = Colors.red;
  //       _resultIcon = Icons.cancel;
  //       _showValidationButtons = false;
  //     } else if (alreadySold) {
  //       mngcon.scanResult = 'Already Sold';
  //       _scanMessage = 'Ticket #$ticketNo was already sold';
  //       mngcon. = Colors.orange;
  //       _resultIcon = Icons.warning;
  //       _showValidationButtons = false;
  //     } else {
  //       mngcon.scanResult = 'Ticket Validated';
  //       _scanMessage = 'Ticket #$ticketNo is valid and ready to activate';
  //       mngcon. = Colors.blue;
  //       _resultIcon = Icons.verified;
  //       _showValidationButtons = true;
  //       _pendingTicketNo = ticketNo;
  //     }
  //   });
  // }

  // void _activateTicket() {
  //   if (_pendingTicketNo != null) {
  //     setState(() {
  //       mngcon.scanResult = 'Success!';
  //       _scanMessage = 'Ticket #$_pendingTicketNo marked as sold successfully';
  //       _resultColor = Colors.green;
  //       _resultIcon = Icons.check_circle;
  //       _showValidationButtons = false;
  //     });
  //     widget.onTicketScanned(_pendingTicketNo!, true, false);
  //   }
  // }

  // void _cancelTicket() {
  //   setState(() {
  //     mngcon.scanResult = 'Cancelled';
  //     _scanMessage = 'Ticket #$_pendingTicketNo activation was cancelled';
  //     _resultColor = Colors.grey;
  //     _resultIcon = Icons.close;
  //     _showValidationButtons = false;
  //     _pendingTicketNo = null;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    Managementcontroller mngcon = Get.put(Managementcontroller());
    PageManagementcontroller pngcon = Get.put(PageManagementcontroller());
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan Ticket'),
        backgroundColor: Colors.orange,
      ),
      body: GetBuilder<Managementcontroller>(
        builder: (_) {
          return Container(
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
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Card(
                  color: Colors.white,
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: mngcon.scanResult == null
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
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(
                                        Icons.qr_code_scanner,
                                        size: 100,
                                        color: Colors.orange,
                                      ),
                                      SizedBox(height: 10),
                                      Text(
                                        'Scan Ticket',
                                        style: TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
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
                              Form(
                                key: _formKey,
                                child: TextFormField(
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter ticket number';
                                    }

                                    if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                                      return 'Ticket number should contain only digits';
                                    }

                                    if (value.length < 11) {
                                      return 'Ticket number is too short';
                                    }

                                    return null; // valid
                                  },

                                  controller: mngcon.ticketController,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    hintText: 'Or enter ticket number manually',
                                    prefixIcon: const Icon(
                                      Icons.confirmation_number,
                                    ),
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
                              ),

                              const SizedBox(height: 16),
                              SizedBox(
                                width: double.infinity,
                                height: 50,
                                child: ElevatedButton(
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      // Form is valid
                                      mngcon.getdatabybarcode(
                                        barcodenum:
                                            mngcon.ticketController.text,
                                        context: context,
                                      );
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: buttonbgcolor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: const Text(
                                    'Verify Ticket',
                                    style: TextStyle(
                                      color: Colors.white,
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
                              Icon(
                                mngcon.resultIcon,
                                size: 100,
                                color: mngcon.resultColor,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                mngcon.scanResult!,
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: mngcon.resultColor,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                mngcon.scanMessage!,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Color(0xFF4A5568),
                                ),
                              ),
                              const SizedBox(height: 24),
                              // Show Activate/Cancel buttons if ticket is validated
                              if (mngcon.showValidationButtons!)
                                Column(
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: ElevatedButton.icon(
                                            onPressed: () {
                                              mngcon.activateTicket(context);
                                            },
                                            icon: mngcon.isloadingforactivate
                                                ? SizedBox()
                                                : Icon(Icons.check),
                                            label: mngcon.isloadingforactivate
                                                ? SizedBox(
                                                    height: 30,
                                                    width: 30,
                                                    child:
                                                        CircularProgressIndicator(),
                                                  )
                                                : Text('Activate'),
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.green,
                                              foregroundColor: Colors.white,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    vertical: 16,
                                                  ),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: ElevatedButton.icon(
                                            onPressed: () {
                                              mngcon.reset();
                                            },
                                            icon: const Icon(Icons.close),
                                            label: const Text('Cancel'),
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.red,
                                              foregroundColor: Colors.white,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    vertical: 16,
                                                  ),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                  ],
                                ),
                              // Show Scan Next/Dashboard buttons for other states
                              if (!mngcon.showValidationButtons!)
                                Row(
                                  children: [
                                    Expanded(
                                      child: ElevatedButton(
                                        onPressed: () {
                                          mngcon.reset();
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: buttonbgcolor,
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 16,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                        ),
                                        child: const Text(
                                          'Scan Next',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: OutlinedButton(
                                        onPressed: () {
                                          pngcon.setnavindex(ind: 0);
                                          mngcon.reset();
                                        },
                                        style: OutlinedButton.styleFrom(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 16,
                                          ),
                                          side: const BorderSide(
                                            color: Colors.orange,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
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
            ),
          );
        },
      ),
    );
  }
}
