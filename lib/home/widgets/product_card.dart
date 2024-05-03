// ignore_for_file: must_be_immutable

import 'package:find_bill/utils/app_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ProductCard extends StatefulWidget {
  ProductCard(
      {super.key,
      required this.isLast,
      required this.productController,
      required this.idController,
      required this.qtController,
      required this.qntAdd,
      required this.onDelete,
      required this.priceController,
      required this.index,
      required this.onScan,
      required this.onAdd});
  bool isLast;
  TextEditingController productController;
  TextEditingController idController;
  TextEditingController priceController;
  TextEditingController qtController;
  VoidCallback onAdd;
  VoidCallback onScan;
  VoidCallback qntAdd;
  VoidCallback onDelete;
  int index;

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            border: Border.all(
              color: Colors.grey.shade400,
            ),
          ),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "${widget.index + 1}.",
                    style: AppTheme.titleText(
                        size: AppTheme.getMobileWidth(context) / 18,
                        color: AppTheme.nearlyBlue,
                        weight: FontWeight.bold),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: TextFormField(
                      controller: widget.productController,
                      style: AppTheme.subtitleText(
                          size: AppTheme.getMobileWidth(context) / 26,
                          color: AppTheme.nearlyGrey,
                          weight: FontWeight.bold),
                      cursorColor: AppTheme.darkishGrey,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 16),
                        counter: const Offstage(),
                        labelText: "Product",
                        labelStyle: AppTheme.subtitleText(
                            size: AppTheme.getMobileWidth(context) / 24,
                            weight: FontWeight.bold,
                            color: Colors.grey.shade800),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: const BorderSide(
                                color: AppTheme.nearlyBlue, width: 2)),
                        errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide:
                                const BorderSide(color: Colors.redAccent)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: const BorderSide(
                                color: AppTheme.nearlyBlue, width: 2)),
                        enabledBorder: OutlineInputBorder(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(5)),
                          borderSide: BorderSide(
                              color: Colors.grey.shade400, width: 1.2),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                keyboardType: TextInputType.none,
                readOnly: true,
                controller: widget.idController,
                cursorColor: AppTheme.darkishGrey,
                style: AppTheme.subtitleText(
                    size: AppTheme.getMobileWidth(context) / 26,
                    color: AppTheme.nearlyGrey,
                    weight: FontWeight.bold),
                decoration: InputDecoration(
                  suffixIcon: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: SizedBox(
                      height: AppTheme.getMobileWidth(context) / 16,
                      width: AppTheme.getMobileWidth(context) / 6,
                      child: ElevatedButton(
                          onPressed: () {
                            widget.onScan();
                          },
                          style: AppTheme.buttonStyle(
                              borderColor: AppTheme.darkishGrey,
                              backColor: AppTheme.darkishGrey),
                          child: Text(
                            "Scan",
                            style: AppTheme.subtitleText(
                                size: AppTheme.getMobileWidth(context) / 30,
                                color: AppTheme.backGroundColor,
                                weight: FontWeight.bold),
                          )),
                    ),
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  counter: const Offstage(),
                  labelText: "Barcode",
                  labelStyle: AppTheme.subtitleText(
                      size: AppTheme.getMobileWidth(context) / 24,
                      weight: FontWeight.bold,
                      color: Colors.grey.shade800),
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: const BorderSide(
                          color: AppTheme.nearlyBlue, width: 2)),
                  errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: const BorderSide(color: Colors.redAccent)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: const BorderSide(
                          color: AppTheme.nearlyBlue, width: 2)),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: const BorderRadius.all(Radius.circular(5)),
                    borderSide:
                        BorderSide(color: Colors.grey.shade400, width: 1.2),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: widget.qtController,
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      cursorColor: AppTheme.darkishGrey,
                      style: AppTheme.subtitleText(
                          size: AppTheme.getMobileWidth(context) / 24,
                          color: AppTheme.nearlyGrey,
                          weight: FontWeight.bold),
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                            onPressed: () {
                              widget.qntAdd();
                            },
                            icon: Icon(
                              Icons.add,
                              size: AppTheme.getMobileWidth(context) / 16,
                              color: AppTheme.nearlyBlue,
                            )),
                        contentPadding: const EdgeInsets.only(left: 7),
                        counter: const Offstage(),
                        isDense: true,
                        prefix: Text("Qt. ",
                            style: AppTheme.subtitleText(
                                size: AppTheme.getMobileWidth(context) / 24,
                                weight: FontWeight.bold,
                                color: Colors.grey.shade400)),
                        prefixIconConstraints:
                            const BoxConstraints(minWidth: 0, minHeight: 0),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: const BorderSide(
                                color: AppTheme.nearlyBlue, width: 2)),
                        errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide:
                                const BorderSide(color: Colors.redAccent)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: const BorderSide(
                                color: AppTheme.nearlyBlue, width: 2)),
                        enabledBorder: OutlineInputBorder(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(5)),
                          borderSide: BorderSide(
                              color: Colors.grey.shade400, width: 1.2),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      controller: widget.priceController,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      cursorColor: AppTheme.darkishGrey,
                      style: AppTheme.subtitleText(
                          size: AppTheme.getMobileWidth(context) / 24,
                          color: AppTheme.nearlyGrey,
                          weight: FontWeight.bold),
                      decoration: InputDecoration(
                        labelText: "Price",
                        labelStyle: AppTheme.subtitleText(
                            size: AppTheme.getMobileWidth(context) / 24,
                            weight: FontWeight.bold,
                            color: Colors.grey.shade800),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 12.5, horizontal: 16),
                        counter: const Offstage(),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: const BorderSide(
                                color: AppTheme.nearlyBlue, width: 2)),
                        errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide:
                                const BorderSide(color: Colors.redAccent)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: const BorderSide(
                                color: AppTheme.nearlyBlue, width: 2)),
                        enabledBorder: OutlineInputBorder(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(5)),
                          borderSide: BorderSide(
                              color: Colors.grey.shade400, width: 1.2),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  widget.index == 0
                      ? const SizedBox()
                      : SizedBox(
                          height: AppTheme.getMobileWidth(context) / 9.1,
                          child: IconButton(
                              onPressed: () {
                                widget.onDelete();
                              },
                              icon: Icon(
                                CupertinoIcons.delete,
                                size: AppTheme.getMobileWidth(context) / 13,
                                color: Colors.redAccent,
                              )),
                        )
                ],
              )
            ],
          ),
        ),
        Container(
            height: AppTheme.getMobileWidth(context) * 0.06,
            width: 1,
            decoration: BoxDecoration(color: Colors.grey.shade400)),
        widget.isLast
            ? GestureDetector(
                onTap: () {
                  widget.onAdd();
                },
                child: Icon(Icons.add_circle_outline_sharp,
                    color: AppTheme.darkishGrey.withOpacity(0.5)))
            : const SizedBox()
      ],
    );
  }
}
