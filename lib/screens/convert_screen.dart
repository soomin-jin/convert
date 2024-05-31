import 'package:flutter/material.dart';
import '../models/stock.dart';

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
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
              color: Colors.white,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 16),
                  Container(
                    width: 60,
                    height: 6,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: TextField(
                      decoration: InputDecoration(
                        labelText: '검색 후 교환할 종목을 선택해 주세요.',
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: ListView.builder(
                      itemCount: widget.stocks.length,
                      itemBuilder: (context, index) {
                        final stock = widget.stocks[index];
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.blue,
                            child: Text(
                              stock.name[0],
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                          title: Text(stock.name),
                          trailing: const Text('보유'),
                          onTap: () {
                            setState(() {
                              if (isFrom) {
                                _fromStock = stock;
                              } else {
                                _toStock = stock;
                              }
                            });
                            Navigator.pop(context);
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
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
                    _buildStockCard("From", _fromController, _fromStock, true),
                    const SizedBox(height: 20),
                    const Icon(Icons.swap_vert, size: 40, color: Colors.black),
                    const SizedBox(height: 20),
                    _buildStockCard("To", _toController, _toStock, false),
                    const SizedBox(height: 20),
                    const Text(
                      '❗ 시장가로 교환합니다.',
                      style: TextStyle(color: Colors.grey),
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
                  backgroundColor: Colors.teal,
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: _handleConvert,
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

  Widget _buildStockCard(String label, TextEditingController controller,
      Stock selectedStock, bool isFrom) {
    return GestureDetector(
      onTap: () => _showStockPicker(isFrom),
      child: Container(
        height: 170, // 고정 높이 약간 더 늘림
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        decoration: BoxDecoration(
          color: const Color(0xFFFAFAFA), // 배경색 변경
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.transparent), // 테두리 제거
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(label,
                    style: const TextStyle(fontSize: 14, color: Colors.grey)),
                const Spacer(),
                Padding(
                  padding:
                      const EdgeInsets.only(right: 20.0), // 오른쪽 패딩 절반 정도만 추가
                  child: Text(
                    '${selectedStock.count.toStringAsFixed(4)} 주',
                    style: const TextStyle(
                        color: Color(0xFF949494),
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 8), // 이미지를 2px 더 올림
                  child: CircleAvatar(
                    backgroundColor: Colors.blue,
                    child: Text(
                      selectedStock.name[0],
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  margin: const EdgeInsets.only(top: 17), // 텍스트를 2px 내림
                  child: Text(selectedStock.name,
                      style:
                          const TextStyle(color: Colors.black, fontSize: 16)),
                ),
                const SizedBox(width: 5),
                Container(
                  margin: const EdgeInsets.only(top: 17), // 텍스트를 2px 내림
                  child: const Icon(Icons.arrow_drop_down, color: Colors.black),
                ),
                const Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    SizedBox(
                      width: 160, // 너비를 줄임
                      height: 40, // 높이 조정
                      child: TextField(
                        focusNode: isFrom ? _fromFocusNode : _toFocusNode,
                        textAlign: TextAlign.right,
                        controller: controller,
                        keyboardType: TextInputType.number,
                        style: const TextStyle(fontSize: 20), // 폰트 크기 키움
                        decoration: const InputDecoration(
                          hintText: '0',
                          border: InputBorder.none,
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                        ),
                        onTap: () {
                          if (controller.text == '0') {
                            controller.clear();
                          }
                        },
                        onChanged: (value) {
                          if (isFrom) {
                            _calculateToStockCount(value);
                          }
                        },
                      ),
                    ),
                    const SizedBox(height: 15), // 높이 더 늘림
                    if (isFrom)
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _fromController.text =
                                selectedStock.count.toStringAsFixed(4);
                            _calculateToStockCount(_fromController.text);
                          });
                        },
                        child: const Padding(
                          padding: EdgeInsets.only(
                              right: 20.0, top: 3), // 오른쪽 패딩 추가, 아래로 3px 이동
                          child: Text('최대',
                              style: TextStyle(
                                  color: Colors.teal,
                                  fontSize: 18,
                                  fontWeight:
                                      FontWeight.bold)), // 글씨 크기와 두께를 키움
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
