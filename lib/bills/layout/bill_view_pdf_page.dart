// ignore_for_file: prefer_const_constructors, depend_on_referenced_packages, non_constant_identifier_names

import 'dart:async';

import 'package:find_bill/utils/app_theme.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf_viewer_plugin/pdf_viewer_plugin.dart';

class BillView extends StatefulWidget {
  const BillView(this.pdfLink, {Key? key}) : super(key: key);
  final String pdfLink;

  @override
  State<BillView> createState() => _BillViewState();
}

class _BillViewState extends State<BillView> {
  late File pdf_file;
  bool isLoading = false;
  int? pages = 0;
  bool isReady = false;

  Future<void> loadNetwork() async {
    setState(() {
      isLoading = true;
    });
    var url = widget.pdfLink;
    final response = await http.get(Uri.parse(url));
    final bytes = response.bodyBytes;
    final filename = basename(url);
    final dir = await getApplicationDocumentsDirectory();
    File file = File('${dir.path}/$filename');
    file.writeAsBytes(bytes, flush: true).then((value) {
      setState(() {
        pdf_file = file;
        isLoading = false;
      });
    });
  }

  @override
  void initState() {
    loadNetwork();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          foregroundColor: AppTheme.darkishGrey,
          elevation: 0.0,
          automaticallyImplyLeading: true,
          title: Text(
            "Bill",
            style: AppTheme.titleText(
                color: AppTheme.darkishGrey,
                size: AppTheme.getMobileWidth(context) / 20,
                weight: FontWeight.bold),
          ),
        ),
        body: Builder(builder: (context) {
          if (isLoading) {
            return Center(
              child: SizedBox(
                height: AppTheme.getMobileWidth(context) / 15,
                width: AppTheme.getMobileWidth(context) / 15,
                child: const CircularProgressIndicator(
                    strokeWidth: 3, color: AppTheme.nearlyBlue),
              ),
            );
          } else {
            return PdfView(path: pdf_file.path);
          }
        }));
  }
}
