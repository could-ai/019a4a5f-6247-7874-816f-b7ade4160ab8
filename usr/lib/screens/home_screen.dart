import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cash_provider.dart';
import '../screens/unpaid_students_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CashProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Class Cash Manager'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Summary Cards
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      'Total Balance',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    Text(
                      'RM ${provider.balance.toStringAsFixed(2)}',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: provider.balance >= 0 ? Colors.green : Colors.red,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Text(
                            'Total Students',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          Text(
                            '${provider.totalStudents}',
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: InkWell(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const UnpaidStudentsScreen()),
                        ),
                        child: Column(
                          children: [
                            Text(
                              'Unpaid Students',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            Text(
                              '${provider.unpaidStudents.length}',
                              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                color: provider.unpaidStudents.isNotEmpty ? Colors.red : null,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Text(
                            'Income',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          Text(
                            'RM ${provider.totalCollected.toStringAsFixed(2)}',
                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              color: Colors.green,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Text(
                            'Expenses',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          Text(
                            'RM ${provider.totalExpenses.toStringAsFixed(2)}',
                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            // Quick Actions
            Text(
              'Quick Actions',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () => Navigator.pushNamed(context, '/students'),
                  icon: const Icon(Icons.people),
                  label: const Text('Students'),
                ),
                ElevatedButton.icon(
                  onPressed: () => Navigator.pushNamed(context, '/payments'),
                  icon: const Icon(Icons.payment),
                  label: const Text('Payments'),
                ),
                ElevatedButton.icon(
                  onPressed: () => Navigator.pushNamed(context, '/purchases'),
                  icon: const Icon(Icons.shopping_cart),
                  label: const Text('Purchases'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
