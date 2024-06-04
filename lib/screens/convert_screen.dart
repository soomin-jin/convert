import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../models/stock.dart';
import '../widgets/stock_card.dart';
import '../widgets/stock_picker.dart';
import '../widgets/popup_dialog.dart';

class ConvertScreen extends StatefulWidget {
  final Stock fromStock;
  final List<Stock> stocks;

  const ConvertScreen({
    super.key,
    required this.fromStock,
    required this.stocks,
  });

  @override
  _ConvertScreenState createState() => _ConvertScreenState();
}

class _ConvertScreenState extends State<ConvertScreen> {
  final TextEditingController _fromController = TextEditingController();
  final TextEditingController _toController = TextEditingController();

  late Stock _fromStock;
  late Stock _toStock;

  final FocusNode _fromFocusNode = FocusNode();
  final FocusNode _toFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _fromStock = widget.fromStock;
    _toStock = widget.stocks.firstWhere((stock) => stock.name == '애플');

    // From TextField에 포커스를 맞추어 키보드가 자동으로 뜨도록 설정
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(_fromFocusNode);
    });
  }

  void _calculateToStockCount(String value) {
    setState(() {
      double fromStockCount = double.tryParse(value) ?? 0;
      double toStockCount = _toStock.price != 0
          ? (fromStockCount * _fromStock.price) / _toStock.price
          : 0;
      _toController.text = toStockCount.toStringAsFixed(4);
    });
  }

  void _handleConvert() {
    double fromStockCount = double.tryParse(_fromController.text) ?? 0;
    double toStockCount = double.tryParse(_toController.text) ?? 0;

    if (fromStockCount <= 0 ||
        toStockCount <= 0 ||
        fromStockCount > _fromStock.count) {
      // 유효하지 않은 값 처리
      return;
    }

    setState(() {
      _fromStock.count -= fromStockCount;
      _toStock.count += toStockCount;
    });

    Navigator.of(context).pop({
      'fromStockName': _fromStock.name,
      'fromStockCount': _fromStock.count,
      'toStockName': _toStock.name,
      'toStockCount': _toStock.count,
    });
  }

  void _swapStocks() {
    setState(() {
      final tempStock = _fromStock;
      _fromStock = _toStock;
      _toStock = tempStock;

      _fromController.clear();
      _toController.clear();
    });
  }

  @override
  void dispose() {
    _fromController.dispose();
    _toController.dispose();
    _fromFocusNode.dispose();
    _toFocusNode.dispose();
    super.dispose();
  }

  void _showStockPicker(bool isFrom) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return StockPicker(
          stocks: widget.stocks,
          isFrom: isFrom,
          onStockSelected: (selectedStock) {
            setState(() {
              if (isFrom) {
                _fromStock = selectedStock;
              } else {
                _toStock = selectedStock;
              }
            });
          },
        );
      },
    );
  }

  void _showPopupDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return PopupDialog(
          onConfirm: () {
            Navigator.of(context).pop();
            _handleConvert();
          },
          onCancel: () {
            Navigator.of(context).pop();
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text(
          '교환하기',
          style: TextStyle(color: Colors.black),
        ),
        elevation: 0,
      ),
      backgroundColor: Colors.white, // 전체 배경색을 white로 설정
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    _buildDropdown(),
                    const SizedBox(height: 20),
                    StockCard(
                      label: "From",
                      controller: _fromController,
                      selectedStock: _fromStock,
                      isFrom: true,
                      showStockPicker: () => _showStockPicker(true),
                      focusNode: _fromFocusNode,
                      onChanged: _calculateToStockCount,
                    ),
                    const SizedBox(height: 20),
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        CircleAvatar(
                          radius: 30, // 반지름 크기 조정
                          backgroundColor: Colors.white, // 배경색을 white로 설정
                          child: IconButton(
                            icon: SvgPicture.asset(
                              'assets/icons/swap_btn_icon.svg',
                              width: 50,
                              height: 50,
                            ),
                            onPressed: _swapStocks,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    StockCard(
                      label: "To",
                      controller: _toController,
                      selectedStock: _toStock,
                      isFrom: false,
                      showStockPicker: () => _showStockPicker(false),
                      focusNode: _toFocusNode,
                      onChanged: (value) {},
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          'assets/icons/info_icon.svg',
                          width: 16,
                          height: 16,
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          '시장가로 교환합니다.',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: SizedBox(
              width: double.infinity, // 너비를 화면에 맞게 조정
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff00b0ad),
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: _showPopupDialog,
                child: const Text(
                  "교환하기",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown() {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          '[매매] 20712565-11',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        Icon(Icons.arrow_drop_down, color: Colors.black),
      ],
    );
  }
}
