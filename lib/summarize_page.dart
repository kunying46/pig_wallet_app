import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'home_page.dart'; // นำเข้า home_page.dart
import 'graph_page.dart'; // นำเข้า graph_page.dart
import 'budget_page.dart'; // นำเข้า budget_page.dart

class SummarizePage extends StatefulWidget {
  final Map<DateTime, List<Map<String, dynamic>>> transactions;

  const SummarizePage({super.key, required this.transactions});

  @override
  _SummarizePageState createState() => _SummarizePageState();
}

class _SummarizePageState extends State<SummarizePage> {
  DateTime _selectedMonth = DateTime.now();

  @override
  Widget build(BuildContext context) {
    // คำนวณรายรับและรายจ่ายของเดือนที่เลือก
    double income = 0;
    double expense = 0;
    List<Map<String, dynamic>> monthlyTransactions = [];

    widget.transactions.forEach((date, transactions) {
      if (date.year == _selectedMonth.year && date.month == _selectedMonth.month) {
        monthlyTransactions.addAll(transactions);
        for (var transaction in transactions) {
          if (transaction['type'] == 'income') {
            income += transaction['amount'];
          } else {
            expense += transaction['amount'];
          }
        }
      }
    });

    // ยอดเงินคงเหลือ
    double balance = income - expense;

    return Scaffold(
      backgroundColor: Colors.transparent, // ทำให้ Scaffold โปร่งใส
      appBar: AppBar(
        title: const Text('Summarize'),
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
            // ส่วนเลือกเดือน
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () {
                      setState(() {
                        _selectedMonth = DateTime(_selectedMonth.year, _selectedMonth.month - 1);
                      });
                    },
                  ),
                  Text(
                    DateFormat('MMMM yyyy').format(_selectedMonth),
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(Icons.arrow_forward),
                    onPressed: () {
                      setState(() {
                        _selectedMonth = DateTime(_selectedMonth.year, _selectedMonth.month + 1);
                      });
                    },
                  ),
                ],
              ),
            ),
            // ตารางสรุปรายการ
            Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white, // พื้นหลังสีขาว
                  borderRadius: BorderRadius.circular(10), // มุมโค้งมน
                ),
                child: Column(
                  children: [
                    const Text(
                      'Summarize list',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                      child: ListView.builder(
                        itemCount: monthlyTransactions.length,
                        itemBuilder: (context, index) {
                          var transaction = monthlyTransactions[index];
                          return ListTile(
                            title: Text(transaction['description']),
                            subtitle: Text(transaction['type'] == 'income' ? 'INCOME' : 'EXPENSE'),
                            trailing: Text(
                              '${transaction['amount']} ฿',
                              style: TextStyle(
                                color: transaction['type'] == 'income' ? Colors.green : Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const Divider(),
                    Text(
                      'Balance: $balance ฿',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
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
        currentIndex: 2, // ตั้งค่าให้เลือกสรุปเป็นค่าเริ่มต้น
        selectedItemColor: Colors.grey[800], // สีเทาดำเมื่อถูกเลือก
        unselectedItemColor: Colors.grey[500], // สีเทาอ่อนเมื่อไม่ถูกเลือก
        onTap: (index) {
          if (index == 0) {
            // กลับไปหน้า home_page.dart
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomePage()),
            );
          } else if (index == 1) {
            // ไปยังหน้า graph_page.dart
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => GraphPage(
                  selectedDate: DateTime.now(),
                  transactions: widget.transactions,
                ),
              ),
            );
          } else if (index == 3) {
            // ไปยังหน้า budget_page.dart
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const BudgetPage()),
            );
          }
        },
      ),
    );
  }
}