import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:number_display/number_display.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class ToPDF {
  Future<void> savePdfFile(String fileName, Uint8List byteList) async {
    final output = await getTemporaryDirectory();
    var filePath = "${output.path}/$fileName.pdf";
    final file = File(filePath);
    await file.writeAsBytes(byteList);
    await OpenFile.open(file.path);

    // await OpenDocument.openDocument(filePath: filePath);
  }

  Future<Uint8List> acctStatement(
    startDate,
    endDate,
    List acctList,
    openBal,
    Map compInfo,
    //     instantInvoiceDate, totalInvoicedAmt
  ) async {
    final pdf = pw.Document();

    final logo =
        (await rootBundle.load("images/shopper_logo.png")).buffer.asUint8List();
    pdf.addPage(
      pw.MultiPage(
          margin: const pw.EdgeInsets.all(20),
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
            return <pw.Widget>[
              pw.Column(
                children: [
                  // getOrderNo(detailCustomerInfo),
                  pw.Header(
                    child: getCompanyInfo(logo, compInfo),
                  ),
                  pw.Header(
                    child: acctPeriodOpeningBal(startDate, endDate, openBal),
                    level: 0,
                  ),
                  getRowHeader(),

                  // ================= ROW DETAILS ===================
                  for (int x = 0; x < acctList.length; x++)
                    pw.Table(columnWidths: const {
                      0: pw.FixedColumnWidth(80),
                      1: pw.FixedColumnWidth(20),
                      2: pw.FixedColumnWidth(50),
                      3: pw.FixedColumnWidth(50),
                    }, children: [
                      pw.TableRow(
                          decoration: getDecoration(x % 2 == 0),
                          children: [
                            pw.Container(
                              // color: PdfColors.yellow,
                              alignment: pw.Alignment.centerLeft,
                              height: 30,
                              child: pw.Text(
                                acctList[x]['transactionDate'].toString(),
                                // style: pw.TextStyle(

                                // ),
                              ),
                              // ),
                            ),
                            pw.Container(
                              // color: PdfColors.red,
                              height: 30,
                              alignment: pw.Alignment.centerRight,
                              child: pw.Text(
                                formattedNumber(acctList[x]['credit'])
                                    .toString(),
                                style: const pw.TextStyle(
                                  fontSize: 13,
                                ),
                              ),
                            ),
                            pw.Container(
                              // color: PdfColors.green,
                              alignment: pw.Alignment.centerRight,
                              height: 30,
                              child: pw.Text(
                                formattedNumber(acctList[x]['debit'])
                                    .toString(),
                                style: const pw.TextStyle(
                                  fontSize: 13,
                                ),
                              ),
                            ),
                            pw.Container(
                              alignment: pw.Alignment.centerRight,
                              height: 30,
                              // color: PdfColors.purple,
                              // child: pw.Center(
                              child: pw.Text(
                                formattedNumber(acctList[x]['closingBal'])
                                    .toString(),
                                style: const pw.TextStyle(
                                  fontSize: 13,
                                ),
                              ),
                              // ),
                            ),
                          ])
                    ]),
                  pw.Divider(thickness: 1),

                  pw.SizedBox(height: 10),
                  // getSubTotalUnit(
                  //   '95000',
                  //   // totalInvoicedAmt
                  // ),
                ],
              ),
            ];
          },
          header: (context) {
            return pw.Container(
              child: pw.Column(children: [
                if (context.pageNumber > 1) getRowHeader(),
              ]),
            );
          },
          footer: (context) {
            final text = 'Page ${context.pageNumber} of ${context.pagesCount}';

            return pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text(''),
                  pw.Text(
                    'Powered by Oski Enterprises',
                    style: const pw.TextStyle(
                      color: PdfColors.grey300,
                      fontSize: 9,
                    ),
                  ),
                  pw.Container(
                    alignment: pw.Alignment.centerRight,
                    // margin: const pw.EdgeInsets.only(top: 1 * PdfPageFormat.cm),
                    child: pw.Text(
                      text,
                      style: const pw.TextStyle(
                        color: PdfColors.black,
                      ),
                    ),
                  ),
                ]);
          }),
    );

    return pdf.save();
  }

  getCompanyInfo(companyLogo, compInfo) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Container(),
        pw.Container(
          width: 180,
          // color: PdfColors.amber,
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // (compInfo['companyLogo']
              // // .bodyBytes.toList()
              // ),
              // pw.Image(compInfo['companyLogo']
              // pw.MemoryImage(
              //   // compInfo['companyLogo'].buffer.asUint8List() == null
              //   //     ? companyLogo
              //   //     :
              //   (compInfo['companyLogo']),
              //   // width: 30,
              //   // height: 30,
              //   // fit: pw.BoxFit.cover
              // ),
              // ),
              pw.Image(pw.MemoryImage(companyLogo),
                  width: 70, height: 70, fit: pw.BoxFit.cover),
              pw.Text(
                "Oski Enterprises",
                style: pw.TextStyle(
                  color: PdfColors.grey400,
                  fontWeight: pw.FontWeight.bold,
                  fontSize: 8,
                ),
              ),
            ],
          ),
        ),
        pw.Column(
          children: [
            pw.SizedBox(height: 15),
            pw.SizedBox(
              width: 200,
              child: pw.Container(
                child: pw.Text(
                  compInfo['businessName'],
                  style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
            pw.SizedBox(
              width: 200,
              child: pw.Container(
                child: pw.Text(
                  compInfo['streetAddress1'],
                  style: const pw.TextStyle(
                    fontSize: 12,
                  ),
                ),
              ),
            ),
            pw.SizedBox(
              width: 200,
              child: pw.Container(
                child: pw.Text(
                  compInfo['city'],
                  style: const pw.TextStyle(
                    fontSize: 12,
                  ),
                ),
              ),
            ),
            pw.SizedBox(
              width: 200,
              child: pw.Container(
                child: pw.Text(
                  compInfo['state'],
                  style: const pw.TextStyle(
                    fontSize: 12,
                  ),
                ),
              ),
            ),
            pw.SizedBox(
              width: 200,
              child: pw.Container(
                child: pw.Text(
                  compInfo['postal'],
                  style: const pw.TextStyle(
                    fontSize: 12,
                  ),
                ),
              ),
            ),
            pw.SizedBox(
              width: 200,
              child: pw.Container(
                child: pw.Text(
                  compInfo['country'],
                  style: const pw.TextStyle(
                    fontSize: 12,
                  ),
                ),
              ),
            ),
            pw.SizedBox(
              width: 200,
              child: pw.Container(
                child: pw.Text(
                  compInfo['phone'],
                  style: const pw.TextStyle(
                    fontSize: 12,
                  ),
                ),
              ),
            ),
            if (compInfo['phone2'] != null && compInfo['phone2'] != '')
              pw.SizedBox(
                width: 200,
                child: pw.Container(
                  child: pw.Text(
                    compInfo['phone2'],
                    style: const pw.TextStyle(
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            pw.SizedBox(
              width: 200,
              child: pw.Container(
                child: pw.Text(
                  compInfo['email'],
                  style: const pw.TextStyle(
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  acctPeriodOpeningBal(startDate, endDate, openBal) {
    return pw.Column(children: [
      pw.Text(
        'Statement of Account',
        style: pw.TextStyle(
          fontSize: 17,
          fontWeight: pw.FontWeight.bold,
          color: PdfColors.grey,
        ),
      ),
      pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
        pw.Text(
          'Period: ',
          style: pw.TextStyle(
            fontSize: 15,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
        pw.Text(
          DateFormat('yyyy-MM-dd').format(startDate),
          style: pw.TextStyle(
            color: PdfColors.cyanAccent700,
            fontSize: 13,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
        pw.Text(' To '),
        pw.Text(
          DateFormat('yyyy-MM-dd').format(endDate),
          style: pw.TextStyle(
            color: PdfColors.cyanAccent700,
            fontSize: 13,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
        pw.Expanded(child: pw.Container())
      ]),

      pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(
            'Opening Bal: ',
            style: pw.TextStyle(
              fontSize: 15,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.Text(
            formattedNumber(openBal).toString(),
            style: pw.TextStyle(
              color: PdfColors.cyanAccent700,
              fontSize: 13,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.Expanded(child: pw.Container())
          // pw.Column(
          //   crossAxisAlignment: pw.CrossAxisAlignment.start,
          //   children: [
          //     pw.SizedBox(
          //       width: 200,
          //       child: pw.Container(
          //         child: pw.Text(
          //           'B11, Akin Metiola Street',
          //           // "${detailCustomerInfo['address']}",
          //           style: const pw.TextStyle(
          //             fontSize: 12,
          //           ),
          //         ),
          //       ),
          //     ),
          //     pw.SizedBox(
          //       width: 200,
          //       child: pw.Container(
          //         child: pw.Text(
          //           'Amuwo-Odofin',
          //           // "${detailCustomerInfo['city']}",
          //           style: const pw.TextStyle(
          //             fontSize: 12,
          //           ),
          //         ),
          //       ),
          //     ),
          //     pw.SizedBox(
          //       width: 200,
          //       child: pw.Container(
          //         child: pw.Text(
          //           'Lagos State',
          //           // "${detailCustomerInfo['state']}",
          //           style: const pw.TextStyle(
          //             fontSize: 12,
          //           ),
          //         ),
          //       ),
          //     ),
          //     pw.SizedBox(
          //       width: 200,
          //       child: pw.Container(
          //         child: pw.Row(children: [
          //           pw.Text(
          //             "Phone: ",
          //             style: pw.TextStyle(
          //               fontSize: 13,
          //               color: PdfColors.blue800,
          //               fontWeight: pw.FontWeight.bold,
          //             ),
          //           ),
          //           pw.SizedBox(
          //               width: 180,
          //               child: pw.Text(
          //                 '080595898854',
          //                 // "${detailCustomerInfo['mobile']}",
          //                 style: const pw.TextStyle(
          //                   fontSize: 12,
          //                 ),
          //               ))
          //         ]),
          //       ),
          //     ),
          //     pw.SizedBox(
          //       width: 200,
          //       child: pw.Container(
          //         child: pw.Row(children: [
          //           pw.Text(
          //             "Alt Phone: ",
          //             style: pw.TextStyle(
          //               fontSize: 13,
          //               color: PdfColors.blue800,
          //               fontWeight: pw.FontWeight.bold,
          //             ),
          //           ),
          //           pw.SizedBox(
          //               width: 160,
          //               child: pw.Text(
          //                 '09058438854',
          //                 // "${detailCustomerInfo['altMobile']}",
          //                 style: const pw.TextStyle(
          //                   fontSize: 12,
          //                 ),
          //               ))
          //         ]),
          //       ),
          //     ),
          //     pw.SizedBox(
          //       width: 200,
          //       child: pw.Container(
          //         child: pw.Row(children: [
          //           pw.Text(
          //             "Email: ",
          //             style: pw.TextStyle(
          //               fontSize: 13,
          //               color: PdfColors.blue800,
          //               fontWeight: pw.FontWeight.bold,
          //             ),
          //           ),
          //           pw.SizedBox(
          //               width: 180,
          //               child: pw.Text(
          //                 'oskienterprises@gmail.com',
          //                 // "${detailCustomerInfo['user_email']}",
          //                 style: const pw.TextStyle(
          //                   fontSize: 12,
          //                 ),
          //               ))
          //         ]),
          //       ),
          //     ),
        ],
      ),
      // pw.Container(
      //   width: 215,
      //   child: pw.Column(
      //       crossAxisAlignment: pw.CrossAxisAlignment.start,
      //       children: [
      //         pw.SizedBox(
      //           // width: 100,
      //           // child: pw.Container(
      //           child: pw.Row(children: [
      //             pw.Text(
      //               "Invoice Date: ",
      //               style: pw.TextStyle(
      //                 fontSize: 13,
      //                 color: PdfColors.blue800,
      //                 fontWeight: pw.FontWeight.bold,
      //               ),
      //             ),
      //             pw.SizedBox(
      //                 width: 130,
      //                 child: pw.Text(
      //                   '2023/08/03',
      //                   // instantInvoiceDate.toString(),
      //                   style: const pw.TextStyle(
      //                     fontSize: 12,
      //                   ),
      //                 ))
      //           ]),
      //           // ),
      //         ),
      //         pw.SizedBox(
      //           // width: 100,
      //           // child: pw.Container(
      //           //   width: 190,
      //           //   color: PdfColors.green200,
      //           child: pw.Row(children: [
      //             pw.Text(
      //               "Payment Method: ",
      //               style: pw.TextStyle(
      //                 fontSize: 13,
      //                 color: PdfColors.blue800,
      //                 fontWeight: pw.FontWeight.bold,
      //               ),
      //             ),
      //             pw.SizedBox(
      //               width: 100,
      //               child: pw.Text(
      //                 'Credit Card',
      //                 // "${detailCustomerInfo['payment_option']}",
      //                 style: const pw.TextStyle(
      //                   fontSize: 12,
      //                 ),
      //               ),
      //             )
      //           ]),
      //           // ),
      //         ),
      //         pw.SizedBox(
      //           // width: 100,
      //           // child: pw.Container(
      //           child: pw.Row(children: [
      //             pw.Text(
      //               "Invoice Total: ",
      //               style: pw.TextStyle(
      //                 fontSize: 13,
      //                 color: PdfColors.blue800,
      //                 fontWeight: pw.FontWeight.bold,
      //               ),
      //             ),
      //             pw.SizedBox(
      //                 width: 130,
      //                 child: pw.Text(
      //                   '90,900.03',
      //                   // 'N $totalInvoicedAmt',
      //                   style: pw.TextStyle(
      //                     color: PdfColors.cyanAccent700,
      //                     fontSize: 20,
      //                     fontWeight: pw.FontWeight.bold,
      //                   ),
      //                 ))
      //           ]),
      //           // ),
      //         ),
      //       ]),
      // ),
      // ]),
    ]);
  }

  static pw.Widget getRowHeader() {
    return pw.Container(
      margin: const pw.EdgeInsets.only(bottom: 10),
      child: pw.Column(children: [
        pw.Table(columnWidths: const {
          0: pw.FixedColumnWidth(80),
          1: pw.FixedColumnWidth(20),
          2: pw.FixedColumnWidth(50),
          3: pw.FixedColumnWidth(50),
        }, children: [
          pw.TableRow(children: [
            pw.Container(
              // color: PdfColors.yellow200,
              alignment: pw.Alignment.centerLeft,
              child: pw.Text(
                'Date',
                style: pw.TextStyle(
                  fontSize: 18,
                  color: PdfColors.cyanAccent700,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ),
            pw.Container(
              // color: PdfColors.red200,
              alignment: pw.Alignment.centerRight,
              child: pw.Text(
                'Credit',
                style: pw.TextStyle(
                  fontSize: 18,
                  color: PdfColors.cyanAccent700,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ),
            pw.Container(
              // color: PdfColors.green200,
              alignment: pw.Alignment.centerRight,
              child: pw.Text(
                'Debit (N)',
                style: pw.TextStyle(
                  fontSize: 18,
                  color: PdfColors.cyanAccent700,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ),
            pw.Container(
              // color: PdfColors.purple200,
              alignment: pw.Alignment.centerRight,
              child: pw.Text(
                'Balance (N)',
                style: pw.TextStyle(
                  fontSize: 18,
                  color: PdfColors.cyanAccent700,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ),
          ])
        ]),
      ]),
    );
  }

  getDecoration([bool even = true]) {
    return pw.BoxDecoration(
      color: even ? PdfColors.grey100 : PdfColors.white,
      shape: pw.BoxShape.rectangle,
      // border: const pw.Border(
      //     bottom : pw.BorderSide( color: Colors.black87,
      //         width: 1, style: pw.BorderStyle.solid
      //     )
      // )
    );
  }

  // getSubTotalUnit(totalInvoicedAmt) {
  //   return pw.Container(
  //     // width: 500,
  //     child: pw.Row(
  //         mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
  //         children: [
  //           pw.Text(''),
  //           pw.Container(
  //             // color: PdfColors.amber300,
  //             child: pw.Table(
  //               columnWidths: const {
  //                 0: pw.FixedColumnWidth(100),
  //                 1: pw.FixedColumnWidth(140),
  //               },
  //               children: [
  //                 pw.TableRow(
  //                   children: [
  //                     pw.Container(
  //                       alignment: pw.Alignment.centerRight,
  //                       child: pw.Text(
  //                         'SUBTOTAL',
  //                         style: pw.TextStyle(
  //                           fontWeight: pw.FontWeight.bold,
  //                           fontSize: 17,
  //                         ),
  //                       ),
  //                     ),
  //                     pw.Container(
  //                       alignment: pw.Alignment.centerRight,
  //                       child: pw.Text(
  //                         'N $totalInvoicedAmt',
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //                 pw.TableRow(
  //                   children: [
  //                     pw.Container(
  //                       alignment: pw.Alignment.centerRight,
  //                       child: pw.Text(
  //                         'TAX',
  //                         style: pw.TextStyle(
  //                           fontWeight: pw.FontWeight.bold,
  //                           fontSize: 17,
  //                         ),
  //                       ),
  //                     ),
  //                     pw.Container(
  //                       alignment: pw.Alignment.centerRight,
  //                       child: pw.Text('N 0.00'),
  //                     ),
  //                   ],
  //                 ),
  //                 pw.TableRow(
  //                   children: [
  //                     pw.Container(
  //                       alignment: pw.Alignment.centerRight,
  //                       child: pw.Text(
  //                         'TOTAL',
  //                         style: pw.TextStyle(
  //                           fontWeight: pw.FontWeight.bold,
  //                           fontSize: 17,
  //                         ),
  //                       ),
  //                     ),
  //                     pw.Container(
  //                       alignment: pw.Alignment.centerRight,
  //                       child: pw.Text(
  //                         'N $totalInvoicedAmt',
  //                         style: pw.TextStyle(
  //                           fontSize: 20,
  //                           fontWeight: pw.FontWeight.bold,
  //                           color: PdfColors.cyanAccent700,
  //                         ),
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //               ],
  //             ),
  //           ),
  //         ]),
  //   );
  // }

  // ============ FIGURE FORMATTER TO TWO DECIMAL PLACES ===========
  final formattedNumber = createDisplay(
    length: 12,
    separator: ',',
    decimal: 2,
    decimalPoint: '.',
  );
}
