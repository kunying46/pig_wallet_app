import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'home_page.dart'; // นำเข้า home_page.dart เพื่อใช้เมนูบาร์
import 'summarize_page.dart';
import 'budget_page.dart'; // นำเข้า budget_page.dart

class GraphPage extends StatelessWidget {
  final DateTime selectedDate;
  final Map<DateTime, List<Map<String, dynamic>>> transactions;

  const GraphPage({
    super.key,
    required this.selectedDate,
    required this.transactions,
  });

  @override
  Widget build(BuildContext context) {
    // คำนวณรายรับและรายจ่ายของวันที่เลือก
    double income = 0;
    double expense = 0;
    List<Map<String, dynamic>> dailyTransactions = transactions[selectedDate] ?? [];

    for (var transaction in dailyTransactions) {
      if (transaction['type'] == 'income') {
        income += transaction['amount'];
      } else {
        expense += transaction['amount'];
      }
    }

    // Balance
    double balance = income - expense;

    return Scaffold(
      backgroundColor: Colors.transparent, // ทำให้ Scaffold โปร่งใส
      appBar: AppBar(
        title: const Text('Graph'),
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
            // แผนภูมิแท่ง
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white, // พื้นหลังสีขาว
                borderRadius: BorderRadius.circular(10), // มุมโค้งมน
              ),
              child: SizedBox(
                height: 300,
                child: BarChart(
                  BarChartData(
                    barGroups: _buildBarGroups(dailyTransactions),
                    borderData: FlBorderData(show: false),
                    titlesData: FlTitlesData(
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            if (value.toInt() < dailyTransactions.length) {
                              return Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Text(
                                  dailyTransactions[value.toInt()]['description'],
                                  style: const TextStyle(fontSize: 12),
                                ),
                              );
                            }
                            return const SizedBox.shrink();
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            // ตารางรายละเอียด
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
                      'Details of item',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                      child: ListView.builder(
                        itemCount: dailyTransactions.length,
                        itemBuilder: (context, index) {
                          var transaction = dailyTransactions[index];
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
        currentIndex: 1, // ตั้งค่าให้เลือกGraphเป็นค่าเริ่มต้น
        selectedItemColor: Colors.grey[800], // สีเทาดำเมื่อถูกเลือก
        unselectedItemColor: Colors.grey[500], // สีเทาอ่อนเมื่อไม่ถูกเลือก
        onTap: (index) {
          if (index == 0) {
            // กลับไปหน้า home_page.dart
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const HomePage()),
            );
          } else if (index == 2) {
            // ไปยังหน้า summarize_page.dart
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SummarizePage(transactions: transactions),
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

  // สร้าง BarGroups สำหรับแผนภูมิ
  List<BarChartGroupData> _buildBarGroups(List<Map<String, dynamic>> transactions) {
    if (transactions.isEmpty) {
      return []; // หากไม่มีข้อมูล ให้คืนค่า empty list
    }

    return transactions.asMap().entries.map((entry) {
      int index = entry.key;
      var transaction = entry.value;
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: transaction['amount'],
            color: transaction['type'] == 'income' ? Colors.green : Colors.red,
            width: 16,
          ),
        ],
      );
    }).toList();
  }
}