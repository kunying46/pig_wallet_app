import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart'; // นำเข้า flutter_colorpicker
import 'home_page.dart'; // นำเข้า home_page.dart
import 'graph_page.dart'; // นำเข้า graph_page.dart
import 'summarize_page.dart'; // นำเข้า summarize_page.dart

class BudgetPage extends StatefulWidget {
  const BudgetPage({super.key});

  @override
  _BudgetPageState createState() => _BudgetPageState();
}

class _BudgetPageState extends State<BudgetPage> {
  // รายการ budget ที่ผู้ใช้เพิ่ม
  List<Map<String, dynamic>> budgets = [];

  // ฟังก์ชันแสดง dialog สำหรับเพิ่มหรือแก้ไข budget
  void _showAddBudgetDialog({Map<String, dynamic>? budget, int? index}) {
    String name = budget?['name'] ?? '';
    double amount = budget?['amount'] ?? 0;
    Color selectedColor = budget?['color'] ?? Colors.blue;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(budget == null ? 'Add new budget' : 'Edit Budget'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  decoration: const InputDecoration(labelText: 'Budget Name'),
                  onChanged: (value) {
                    name = value;
                  },
                  controller: TextEditingController(text: name),
                ),
                TextField(
                  decoration: const InputDecoration(labelText: 'Amount'),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    amount = double.tryParse(value) ?? 0;
                  },
                  controller: TextEditingController(text: amount.toString()),
                ),
                const SizedBox(height: 16),
                const Text('Choose color:'),
                const SizedBox(height: 8),
                // ใช้ BlockPicker สำหรับเลือกสี
                BlockPicker(
                  pickerColor: selectedColor,
                  onColorChanged: (color) {
                    selectedColor = color;
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (name.isNotEmpty && amount > 0) {
                  setState(() {
                    if (index != null) {
                      // แก้ไข budget ที่มีอยู่
                      budgets[index] = {
                        'name': name,
                        'amount': amount,
                        'color': selectedColor,
                      };
                    } else {
                      // เพิ่ม budget ใหม่
                      budgets.add({
                        'name': name,
                        'amount': amount,
                        'color': selectedColor,
                      });
                    }
                  });
                  Navigator.pop(context);
                }
              },
              child: const Text('Confirm'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent, // ทำให้ Scaffold โปร่งใส
      appBar: AppBar(
        title: const Text('Manage Budget'),
        backgroundColor: Color(0xFFB3E5FC),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFB3E5FC), // สีฟ้าอ่อน
              Color.fromARGB(255, 255, 197, 227), // สีชมพูอ่อน
              Color.fromARGB(255, 249, 249, 249), // สีขาว
            ],
          ),
        ),
        child: Column(
          children: [
            // ไอคอนและปุ่มเพิ่ม budget
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Image.asset(
                    'assets/mopuk.png', // เปลี่ยน path ตามที่คุณต้องการ
                    height: 100,
                    width: 100,
                  ),
                  const SizedBox(height: 16),
                  GestureDetector(
                    onTap: () {
                      _showAddBudgetDialog();
                    },
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add, color: Colors.black),
                          SizedBox(width: 8),
                          Text(
                            'Add new budget',
                            style: TextStyle(fontSize: 16, color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // รายการ budget ที่เพิ่ม (ใช้ GridView)
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // จำนวนคอลัมน์ (2 คอลัมน์)
                  crossAxisSpacing: 16, // ระยะห่างระหว่างคอลัมน์
                  mainAxisSpacing: 16, // ระยะห่างระหว่างแถว
                  childAspectRatio: 1.2, // อัตราส่วนความกว้างต่อความสูงของแต่ละกล่อง
                ),
                itemCount: budgets.length,
                itemBuilder: (context, index) {
                  var budget = budgets[index];
                  return GestureDetector(
                    onTap: () {
                      _showAddBudgetDialog(budget: budget, index: index);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: budget['color'],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            budget['name'],
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${budget['amount']} ฿',
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      // เมนูบาร์ด้านล่าง
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'MainMenu',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Graph',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment),
            label: 'Summarize',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet),
            label: 'Budget',
          ),
        ],
        currentIndex: 3, // ตั้งค่าให้เลือก Budget เป็นค่าเริ่มต้น
        selectedItemColor: Colors.grey[800], // สีเทาดำเมื่อถูกเลือก
        unselectedItemColor: Colors.grey[500], // สีเทาอ่อนเมื่อไม่ถูกเลือก
        onTap: (index) {
          if (index == 0) {
            // กลับไปหน้า home_page.dart
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const HomePage()),
            );
          } else if (index == 1) {
            // ไปยังหน้า graph_page.dart
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => GraphPage(
                  selectedDate: DateTime.now(),
                  transactions: {}, // ส่ง transactions ที่มีข้อมูลจริง
                ),
              ),
            );
          } else if (index == 2) {
            // ไปยังหน้า summarize_page.dart
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SummarizePage(transactions: {}), // ส่ง transactions ที่มีข้อมูลจริง
              ),
            );
          }
        },
      ),
    );
  }
}