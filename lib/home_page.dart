import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart'; // สำหรับ isSameDay
import 'graph_page.dart'; // นำเข้า graph_page.dart
import 'summarize_page.dart';
import 'budget_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime? _selectedDate;
  Map<DateTime, List<Map<String, dynamic>>> _transactions = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent, // ทำให้ Scaffold โปร่งใส
      appBar: AppBar(
        title: const Text('Pig Wallet'),
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
            // ปฏิทิน
            _buildCalendar(),
            const SizedBox(height: 20),
            // กล่องแสดง INCOME และ EXPENSE
            _buildIncomeExpenseBox(),
            const SizedBox(height: 20),
            // รายการของวันที่เลือก
            _buildTransactionList(),
          ],
        ),
      ),
      // ปุ่มเพิ่มรายการ
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _addTransaction();
        },
        backgroundColor: Color.fromARGB(255, 235, 110, 174),
        child: const Icon(Icons.add, color: Colors.white),
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
        currentIndex: 0, // ตั้งค่าให้เลือกหน้าหลักเป็นค่าเริ่มต้น
        selectedItemColor: Colors.grey[800], // สีเทาดำเมื่อถูกเลือก
        unselectedItemColor: Colors.grey[500], // สีเทาอ่อนเมื่อไม่ถูกเลือก
        onTap: (index) {
          if (index == 1) {
            // ไปยังหน้า graph_page.dart
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => GraphPage(
                  selectedDate: _selectedDate ?? DateTime.now(),
                  transactions: _transactions,
                ),
              ),
            );
          } else if (index == 2) {
            // ไปยังหน้า summarize_page.dart
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SummarizePage(transactions: _transactions),
              ),
            );
          } else if (index == 3) {
            // ไปยังหน้า budget_page.dart
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const BudgetPage()),
            );
          }
        },
      ),
    );
  }

  Widget _buildCalendar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white, // พื้นหลังสีขาว
        borderRadius: BorderRadius.circular(10), // มุมโค้งมน
      ),
      margin: const EdgeInsets.all(16), // ระยะห่างจากขอบ
      padding: const EdgeInsets.all(16), // ระยะห่างภายใน
      child: TableCalendar(
        firstDay: DateTime.utc(2025, 1, 1),
        lastDay: DateTime.utc(2025, 12, 31),
        focusedDay: _selectedDate ?? DateTime.now(),
        selectedDayPredicate: (day) {
          return isSameDay(_selectedDate, day);
        },
        onDaySelected: (selectedDay, focusedDay) {
          setState(() {
            _selectedDate = selectedDay;
          });
        },
      ),
    );
  }

  Widget _buildIncomeExpenseBox() {
    double income = 0;
    double expense = 0;

    if (_selectedDate != null && _transactions.containsKey(_selectedDate)) {
      for (var transaction in _transactions[_selectedDate]!) {
        if (transaction['type'] == 'income') {
          income += transaction['amount'];
        } else {
          expense += transaction['amount'];
        }
      }
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.green.withOpacity(0.2),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              const Text(
                'INCOME',
                style: TextStyle(fontSize: 16, color: Colors.green),
              ),
              Text(
                '$income ฿',
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.red.withOpacity(0.2),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              const Text(
                'EXPENSE',
                style: TextStyle(fontSize: 16, color: Colors.red),
              ),
              Text(
                '$expense ฿',
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.red),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTransactionList() {
    if (_selectedDate == null || !_transactions.containsKey(_selectedDate)) {
      return const Center(
        child: Text('No Items Today', style: TextStyle(fontSize: 18)),
      );
    }

    final selectedDate = _selectedDate!;

    return Expanded(
      child: ListView.builder(
        itemCount: _transactions[selectedDate]!.length,
        itemBuilder: (context, index) {
          var transaction = _transactions[selectedDate]![index];
          return Container(
            height: 100, // เพิ่มความสูงของ ListTile
            margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 3,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: ListTile(
              leading: Icon(
                transaction['type'] == 'income' ? Icons.arrow_upward : Icons.arrow_downward,
                color: transaction['type'] == 'income' ? Colors.green : Colors.red,
                size: 30,
              ),
              title: Text(
                transaction['description'],
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    transaction['type'] == 'income' ? 'INCOME' : 'EXPENSE',
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                  Text(
                    'Date: ${DateFormat('dd/MM/yyyy').format(selectedDate)}',
                    style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                  ),
                ],
              ),
              trailing: Text(
                '${transaction['amount']} ฿',
                style: TextStyle(
                  fontSize: 18,
                  color: transaction['type'] == 'income' ? Colors.green : Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _addTransaction() {
    showDialog(
      context: context,
      builder: (context) {
        String description = '';
        double amount = 0;
        String type = 'income'; // ค่าเริ่มต้น

        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Add new item'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    decoration: const InputDecoration(labelText: 'Details'),
                    onChanged: (value) {
                      description = value;
                    },
                  ),
                  TextField(
                    decoration: const InputDecoration(labelText: 'Amount'),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      amount = double.tryParse(value) ?? 0;
                    },
                  ),
                  DropdownButton<String>(
                    value: type,
                    onChanged: (value) {
                      setDialogState(() {
                        type = value!; // อัปเดตค่า type และ UI
                      });
                    },
                    items: const [
                      DropdownMenuItem(value: 'income', child: Text('INCOME')),
                      DropdownMenuItem(value: 'expense', child: Text('EXPENSE')),
                    ],
                  ),
                ],
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
                    if (_selectedDate != null && description.isNotEmpty && amount > 0) {
                      setState(() {
                        _transactions[_selectedDate!] ??= [];
                        _transactions[_selectedDate!]!.add({
                          'description': description,
                          'amount': amount,
                          'type': type,
                        });
                      });
                    }
                    Navigator.pop(context);
                  },
                  child: const Text('Confirm'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}