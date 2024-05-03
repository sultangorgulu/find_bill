// ignore_for_file: unused_field, non_constant_identifier_names, prefer_final_fields, unnecessary_null_comparison, avoid_print, unused_local_variable

import 'dart:io';

import 'package:find_bill/common/App_store.dart';
import 'package:find_bill/excel/models/item_models.dart';
import 'package:find_bill/utils/app_theme.dart';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class UploadExcel extends StatefulWidget {
  const UploadExcel({super.key});

  @override
  State<UploadExcel> createState() => _UploadExcelState();
}

class _UploadExcelState extends State<UploadExcel> {
  String _filePath = "";
  Map<String, dynamic> dict_detail = {};
  AppStore store = AppStore();
  bool _fileLoader = false;
  bool _loader = false;
  bool _show = false;
  Map<String, ItemModel> models = {};

  getItemModels() {
    setState(() {
      _loader = true;
    });
    store.getItemModels().then((value) {
      for (var element in value) {
        models.putIfAbsent(element.barCode, () => element);
      }
      setState(() {
        _loader = false;
        if (value.isNotEmpty) {
          _show = true;
        }
      });
    });
  }

  @override
  void initState() {
    getItemModels();
    super.initState();
  }

  void getFilePath({required bool isUpdate}) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles();
      String filePath = result!.files.single.path.toString();
      if (result != null) {
        setState(() {
          _fileLoader = true;
        });
        File file = File(filePath);
        var bytes = file.readAsBytesSync();
        var excel = Excel.decodeBytes(bytes);
        Map<String, dynamic> dict_det = {};
        for (var table in excel.tables.keys) {
          for (var row in excel.tables[table]!.rows) {
            if (row[0]!.value.toString() != "barcode") {
              dict_det[row[0]!.value.toString()] = [
                row[1]!.value.toString(),
                row[2]!.value.toString()
              ];
            }
          }
        }
        dict_detail = dict_det;
        store.uploadJson(json: dict_detail, isUpdate: isUpdate).then((value) {
          setState(() {
            _fileLoader = false;
            _show = true;
            dict_detail.forEach((key, value) {
              models.putIfAbsent(
                  key,
                  () =>
                      ItemModel(barCode: key, name: value[0], price: value[1]));
            });
          });
        });
      }
      if (filePath == null || filePath == '') {
        return;
      }
      setState(() {
        _filePath = filePath;
      });
    } on PlatformException catch (e) {
      print(e.toString());
    }
  }

  Widget bodyData() => Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 20),
            width: AppTheme.getMobileWidth(context),
            height: 50,
            child: ElevatedButton(
                style: AppTheme.buttonStyle(backColor: AppTheme.nearlyBlue),
                onPressed: () {
                  getFilePath(isUpdate: true);
                },
                child: _fileLoader
                    ? Container(
                        alignment: Alignment.center,
                        width: AppTheme.getMobileWidth(context) / 8,
                        height: AppTheme.getMobileWidth(context) / 8,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                                AppTheme.getMobileWidth(context) / 16),
                            color: AppTheme.nearlyBlue),
                        child: SizedBox(
                          height: AppTheme.getMobileWidth(context) / 20,
                          width: AppTheme.getMobileWidth(context) / 20,
                          child: const CircularProgressIndicator(
                              strokeWidth: 2, color: AppTheme.backGroundColor),
                        ),
                      )
                    : Text(
                        "Update Excel",
                        style: AppTheme.subtitleText(
                            size: AppTheme.getMobileWidth(context) / 24,
                            color: AppTheme.backGroundColor,
                            weight: FontWeight.bold),
                      )),
          ),
          Container(
            margin: const EdgeInsets.only(top: 20),
            width: AppTheme.getMobileWidth(context),
            child: DataTable(
                onSelectAll: (b) {},
                sortColumnIndex: 1,
                sortAscending: true,
                columns: <DataColumn>[
                  DataColumn(
                    label: Text(
                      "Name",
                      style: AppTheme.titleText(
                          size: AppTheme.getMobileWidth(context) / 30,
                          color: AppTheme.nearlyBlue,
                          weight: FontWeight.bold),
                    ),
                    numeric: false,
                    tooltip: "To display name of product name",
                  ),
                  DataColumn(
                    label: Text(
                      "Barcode",
                      style: AppTheme.titleText(
                          size: AppTheme.getMobileWidth(context) / 30,
                          color: AppTheme.nearlyBlue,
                          weight: FontWeight.bold),
                    ),
                    numeric: false,
                    tooltip: "To display barcode id of product",
                  ),
                  DataColumn(
                    label: Text(
                      "Price",
                      style: AppTheme.titleText(
                          size: AppTheme.getMobileWidth(context) / 30,
                          color: AppTheme.nearlyBlue,
                          weight: FontWeight.bold),
                    ),
                    numeric: true,
                    tooltip: "To display price of product",
                  ),
                ],
                rows: models.values
                    .map(
                      (x) => DataRow(
                        cells: [
                          DataCell(
                            Text(
                              x.name,
                              style: AppTheme.subtitleText(
                                  size: AppTheme.getMobileWidth(context) / 30,
                                  color: AppTheme.nearlyGrey.withOpacity(0.8),
                                  weight: FontWeight.w600),
                            ),
                            showEditIcon: false,
                            placeholder: false,
                          ),
                          DataCell(
                            Text(
                              x.barCode,
                              style: AppTheme.subtitleText(
                                  size: AppTheme.getMobileWidth(context) / 30,
                                  color: AppTheme.nearlyGrey,
                                  weight: FontWeight.w600),
                            ),
                            showEditIcon: false,
                            placeholder: false,
                          ),
                          DataCell(
                            Text(
                              x.price,
                              style: AppTheme.subtitleText(
                                  size: AppTheme.getMobileWidth(context) / 30,
                                  color: AppTheme.nearlyGrey,
                                  weight: FontWeight.w600),
                            ),
                            showEditIcon: false,
                            placeholder: false,
                          )
                        ],
                      ),
                    )
                    .toList()),
          ),
        ],
      );

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      if (_loader) {
        return Scaffold(
          backgroundColor: AppTheme.backGroundColor,
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: AppTheme.getMobileWidth(context) / 15,
                  width: AppTheme.getMobileWidth(context) / 15,
                  child: const CircularProgressIndicator(
                      strokeWidth: 3, color: AppTheme.nearlyBlue),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 20),
                  child: Text("Gathering your Data!",
                      style: AppTheme.titleText(
                          size: AppTheme.getMobileWidth(context) / 18,
                          color: AppTheme.nearlyGrey,
                          weight: FontWeight.bold)),
                ),
                Container(
                  alignment: Alignment.center,
                  child: Text("Fetching your inventory.",
                      style: AppTheme.titleText(
                          size: AppTheme.getMobileWidth(context) / 28,
                          color: AppTheme.nearlyGrey.withOpacity(0.8),
                          weight: FontWeight.w500)),
                ),
              ],
            ),
          ),
        );
      } else {
        return buildWidget(context);
      }
    });
  }

  @override
  Widget buildWidget(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backGroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    margin: const EdgeInsets.only(top: 0),
                    child: Text("Simplest way to save \nand upload.",
                        style: AppTheme.titleText(
                            size: AppTheme.getMobileWidth(context) / 14,
                            color: AppTheme.nearlyBlue,
                            weight: FontWeight.bold)),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 10),
                    alignment: Alignment.centerLeft,
                    child: Text("Upload all your products in excel format",
                        style: AppTheme.subtitleText(
                            size: AppTheme.getMobileWidth(context) / 27,
                            color: AppTheme.nearlyGrey,
                            weight: FontWeight.w500)),
                  ),
                ],
              ),
              _show
                  ? bodyData()
                  : Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset(
                            "assets/images/business.png",
                            height: AppTheme.getMobileWidth(context) / 1.5,
                            width: AppTheme.getMobileWidth(context) / 1.2,
                          ),
                          Container(
                            alignment: Alignment.center,
                            margin: const EdgeInsets.only(top: 0),
                            child: Text("Upload File",
                                style: AppTheme.titleText(
                                    size: AppTheme.getMobileWidth(context) / 18,
                                    color: AppTheme.nearlyBlue,
                                    weight: FontWeight.bold)),
                          ),
                          Container(
                            margin: const EdgeInsets.only(bottom: 30),
                            alignment: Alignment.center,
                            child: Text(
                                "Browse and select your files\nyou want to upload",
                                textAlign: TextAlign.center,
                                style: AppTheme.subtitleText(
                                    size: AppTheme.getMobileWidth(context) / 30,
                                    color: AppTheme.nearlyGrey,
                                    weight: FontWeight.w500)),
                          ),
                          GestureDetector(
                            onTap: () {
                              getFilePath(isUpdate: false);
                            },
                            child: _fileLoader
                                ? Container(
                                    alignment: Alignment.center,
                                    width: AppTheme.getMobileWidth(context) / 8,
                                    height: AppTheme.getMobileWidth(context) / 8,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                            AppTheme.getMobileWidth(context) /
                                                16),
                                        color: AppTheme.nearlyBlue),
                                    child: SizedBox(
                                      height:
                                          AppTheme.getMobileWidth(context) / 20,
                                      width:
                                          AppTheme.getMobileWidth(context) / 20,
                                      child: const CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: AppTheme.backGroundColor),
                                    ),
                                  )
                                : Container(
                                    alignment: Alignment.center,
                                    width: AppTheme.getMobileWidth(context) / 8,
                                    height: AppTheme.getMobileWidth(context) / 8,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                            AppTheme.getMobileWidth(context) /
                                                16),
                                        color: AppTheme.nearlyBlue),
                                    child: const Icon(
                                      Icons.add,
                                      color: AppTheme.backGroundColor,
                                    ),
                                  ),
                          )
                        ],
                      ),
                    )
            ],
          ),
        ),
      ),
    );
  }
}
