// ignore_for_file: unused_field, prefer_final_fields, prefer_is_not_empty
import 'package:find_bill/common/App_store.dart';
import 'package:find_bill/excel/models/item_models.dart';
import 'package:find_bill/home/layout/pdf_generator_page.dart';
import 'package:find_bill/home/widgets/product_card.dart';
import 'package:find_bill/utils/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

class BillGeneratorPage extends StatefulWidget {
  const BillGeneratorPage({super.key});

  @override
  State<BillGeneratorPage> createState() => _BillGeneratorPageState();
}

class _BillGeneratorPageState extends State<BillGeneratorPage> {
  List<TextEditingController> productControllers = [TextEditingController()];
  List<TextEditingController> idControllers = [TextEditingController()];
  List<TextEditingController> qtControllers = [TextEditingController()];
  List<TextEditingController> priceControllers = [TextEditingController()];
  AppStore store = AppStore();
  Map<String, ItemModel> models = {};
  bool _loading = false;
  String _scanBarcode = 'Unknown';
  num totalCost = 0;
  int quantity = 1;

  Future<void> scanBarcodeNormal() async {
    String barcodeScanRes;
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#7C3AED', 'Cancel', true, ScanMode.BARCODE);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }
    if (!mounted) return;

    setState(() {
      _scanBarcode = barcodeScanRes;
    });
  }

  @override
  void dispose() {
    for (int i = 0; i < productControllers.length; i++) {
      idControllers[i].dispose();
      productControllers[i].dispose();
      qtControllers[i].dispose();
      priceControllers[i].dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ItemModel>>(
        future: store.getItemModels(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data!.isEmpty) {
              return Scaffold(
                backgroundColor: AppTheme.backGroundColor,
                body: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(40.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Ops!",
                          style: AppTheme.titleText(
                              color: AppTheme.nearlyBlue,
                              size: AppTheme.getMobileWidth(context) / 8,
                              weight: FontWeight.bold),
                        ),
                        Text(
                          "Seems like you haven't added your inventory.\nUpload the excel sheet containing the details of your products from the inventory section.",
                          textAlign: TextAlign.center,
                          style: AppTheme.subtitleText(
                              color: AppTheme.darkishGrey.withOpacity(0.8),
                              size: AppTheme.getMobileWidth(context) / 30,
                              weight: FontWeight.w600),
                        )
                      ],
                    ),
                  ),
                ),
              );
            } else {
              for (var element in snapshot.data!) {
                models.putIfAbsent(element.barCode, () => element);
              }
              return Scaffold(
                backgroundColor: AppTheme.backGroundColor,
                bottomNavigationBar: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: SizedBox(
                    height: AppTheme.getMobileWidth(context) / 8,
                    child: ElevatedButton(
                        onPressed: productControllers.first.text.isNotEmpty &&
                                priceControllers.first.text.isNotEmpty &&
                                idControllers.first.text.isNotEmpty &&
                                qtControllers.first.text.isNotEmpty
                            ? () {
                                List<ItemModel> itemModels = [];
                                for (int i = 0;
                                    i < productControllers.length;
                                    i++) {
                                  if (productControllers[i].text.isNotEmpty &&
                                      priceControllers[i].text.isNotEmpty &&
                                      idControllers[i].text.isNotEmpty &&
                                      qtControllers[i].text.isNotEmpty) {
                                    itemModels.add(ItemModel(
                                        qt: qtControllers[i].text,
                                        barCode: idControllers[i].text,
                                        name: productControllers[i].text,
                                        price: priceControllers[i].text));
                                  }
                                }
                                PersistentNavBarNavigator.pushNewScreen(context,
                                    screen: PDFGeneratorPage(
                                      models: itemModels,
                                    ),
                                    pageTransitionAnimation:
                                        PageTransitionAnimation.scale,
                                    withNavBar: false);
                              }
                            : null,
                        style:
                            AppTheme.buttonStyle(backColor: AppTheme.nearlyBlue),
                        child: Text(
                          "Generate PDF",
                          style: AppTheme.titleText(
                              color: AppTheme.backGroundColor,
                              size: AppTheme.getMobileWidth(context) / 20,
                              weight: FontWeight.bold),
                        )),
                  ),
                ),
                appBar: AppBar(
                  backgroundColor: Colors.transparent,
                  foregroundColor: AppTheme.darkishGrey,
                  elevation: 0.0,
                  automaticallyImplyLeading: true,
                  title: Text(
                    "Generate Bill",
                    style: AppTheme.titleText(
                        color: AppTheme.darkishGrey,
                        size: AppTheme.getMobileWidth(context) / 20,
                        weight: FontWeight.bold),
                  ),
                ),
                body: Padding(
                  padding: const EdgeInsets.only(top: 10, left: 20, right: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        children: [
                          Container(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Add Items",
                              style: AppTheme.titleText(
                                  color: AppTheme.nearlyBlue,
                                  size: AppTheme.getMobileWidth(context) / 14,
                                  weight: FontWeight.bold),
                            ),
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            child: Text("Include products to generate Qr-Bill.",
                                style: AppTheme.subtitleText(
                                    size: AppTheme.getMobileWidth(context) / 27,
                                    color: AppTheme.nearlyGrey,
                                    weight: FontWeight.w500)),
                          ),
                        ],
                      ),
                      Container(
                        height: 0.4,
                        margin: const EdgeInsets.only(top: 20, bottom: 40),
                        width: AppTheme.getMobileWidth(context),
                        color: AppTheme.nearlyGrey.withOpacity(0.6),
                      ),
                      Expanded(
                        child: ListView.builder(
                            padding: const EdgeInsets.only(bottom: 20),
                            physics: const BouncingScrollPhysics(),
                            itemCount: productControllers.length,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return ProductCard(
                                priceController: priceControllers[index],
                                productController: productControllers[index],
                                idController: idControllers[index],
                                qtController: qtControllers[index],
                                onDelete: () {
                                  setState(() {
                                    priceControllers
                                        .remove(priceControllers[index]);
                                    productControllers
                                        .remove(productControllers[index]);
                                    qtControllers.remove(qtControllers[index]);
                                    idControllers.remove(idControllers[index]);
                                  });
                                },
                                qntAdd: () {
                                  int qt = int.parse(qtControllers[index].text);
                                  qt = qt + 1;
                                  setState(() {
                                    qtControllers[index].text = qt.toString();
                                  });
                                },
                                onScan: () {
                                  scanBarcodeNormal().then((value) {
                                    setState(() {
                                      idControllers[index].text = _scanBarcode;
                                      productControllers[index].text =
                                          models[_scanBarcode]!.name;
                                      priceControllers[index].text =
                                          models[_scanBarcode]!.price;
                                      qtControllers[index].text = "1";
                                    });
                                  });
                                },
                                index: index,
                                onAdd: () {
                                  priceControllers.add(TextEditingController());
                                  productControllers
                                      .add(TextEditingController());
                                  idControllers.add(TextEditingController());
                                  qtControllers.add(TextEditingController());
                                  setState(() {});
                                },
                                isLast: index + 1 == productControllers.length,
                              );
                            }),
                      ),
                    ],
                  ),
                ),
              );
            }
          } else {
            return Scaffold(
              backgroundColor: AppTheme.backGroundColor,
              body: Center(
                child: SizedBox(
                  height: AppTheme.getMobileWidth(context) / 15,
                  width: AppTheme.getMobileWidth(context) / 15,
                  child: const CircularProgressIndicator(
                      strokeWidth: 3, color: AppTheme.nearlyBlue),
                ),
              ),
            );
          }
        });
  }
}
