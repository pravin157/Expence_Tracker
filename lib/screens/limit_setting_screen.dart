import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/expense_provider.dart';

class LimitSettingScreen extends StatefulWidget {
  const LimitSettingScreen({super.key});

  @override
  State<LimitSettingScreen> createState() => _LimitSettingScreenState();
}

class _LimitSettingScreenState extends State<LimitSettingScreen> {
  late TextEditingController _monthlyController;
  late TextEditingController _yearlyController;

  @override
  void initState() {
    super.initState();
    final provider = context.read<ExpenseProvider>();
    _monthlyController = TextEditingController(
      text: provider.monthlyLimit?.limitAmount.toString() ?? '',
    );
    _yearlyController = TextEditingController(
      text: provider.yearlyLimit?.limitAmount.toString() ?? '',
    );
  }

  @override
  void dispose() {
    _monthlyController.dispose();
    _yearlyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Set Expense Limits'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Consumer<ExpenseProvider>(
        builder: (context, expenseProvider, child) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Monthly Limit Section
                _buildLimitCard(
                  context,
                  'Monthly Limit',
                  Icons.calendar_month,
                  _monthlyController,
                  expenseProvider.monthlyExpenses,
                  expenseProvider.monthlyLimit?.limitAmount,
                  () async {
                    if (_monthlyController.text.isNotEmpty) {
                      final success = await expenseProvider.setMonthlyLimit(
                        double.parse(_monthlyController.text),
                      );
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              success
                                  ? 'Monthly limit updated successfully'
                                  : 'Failed to update monthly limit',
                            ),
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      }
                    }
                  },
                  'Set a budget limit for your monthly expenses',
                ),
                const SizedBox(height: 24),

                // Yearly Limit Section
                _buildLimitCard(
                  context,
                  'Yearly Limit',
                  Icons.calendar_today,
                  _yearlyController,
                  expenseProvider.yearlyExpenses,
                  expenseProvider.yearlyLimit?.limitAmount,
                  () async {
                    if (_yearlyController.text.isNotEmpty) {
                      final success = await expenseProvider.setYearlyLimit(
                        double.parse(_yearlyController.text),
                      );
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              success
                                  ? 'Yearly limit updated successfully'
                                  : 'Failed to update yearly limit',
                            ),
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      }
                    }
                  },
                  'Set a budget limit for your yearly expenses',
                ),
                const SizedBox(height: 24),

                // Recommendations Section
                _buildRecommendationsSection(context),
                const SizedBox(height: 24),

                // Alerts Section
                if (expenseProvider.isMonthlyLimitExceeded() ||
                    expenseProvider.isYearlyLimitExceeded())
                  _buildAlertsSection(context, expenseProvider),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildLimitCard(
    BuildContext context,
    String title,
    IconData icon,
    TextEditingController controller,
    double currentSpent,
    double? limit,
    Future<void> Function() onSave,
    String description,
  ) {
    final hasLimit = limit != null;
    final remaining = hasLimit
        ? (limit - currentSpent).clamp(0, double.infinity)
        : 0.0;
    final percentage = hasLimit
        ? (currentSpent / limit * 100).clamp(0, 100)
        : 0.0;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: Colors.blue, size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      description,
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall?.copyWith(color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Input Field
          TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Limit Amount',
              prefixText: '\$ ',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              suffixIcon: controller.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        controller.clear();
                        setState(() {});
                      },
                    )
                  : null,
            ),
            onChanged: (value) {
              setState(() {});
            },
          ),
          const SizedBox(height: 16),

          // Status Information
          if (hasLimit) ...[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Spent',
                        style: Theme.of(
                          context,
                        ).textTheme.bodySmall?.copyWith(color: Colors.grey),
                      ),
                      Text(
                        '\$${currentSpent.toStringAsFixed(2)} / \$${limit.toStringAsFixed(2)}',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: (percentage / 100).clamp(0, 1),
                      minHeight: 8,
                      backgroundColor: Colors.grey.shade300,
                      valueColor: AlwaysStoppedAnimation(
                        percentage > 100 ? Colors.red : Colors.green,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    percentage > 100
                        ? 'Over limit by \$${(currentSpent - limit).toStringAsFixed(2)}'
                        : 'Remaining: \$${remaining.toStringAsFixed(2)}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: percentage > 100 ? Colors.red : Colors.green,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],

          // Save Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onSave,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: const Text('Save Limit'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendationsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Budget Recommendations',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        _buildRecommendationCard(
          context,
          '50/30/20 Rule',
          'Allocate 50% for needs, 30% for wants, 20% for savings',
          Icons.pie_chart,
        ),
        const SizedBox(height: 8),
        _buildRecommendationCard(
          context,
          'Set Conservative Limits',
          'Start with lower limits and adjust as needed',
          Icons.trending_down,
        ),
        const SizedBox(height: 8),
        _buildRecommendationCard(
          context,
          'Review Monthly',
          'Check your spending regularly and adjust limits',
          Icons.assessment,
        ),
      ],
    );
  }

  Widget _buildRecommendationCard(
    BuildContext context,
    String title,
    String description,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.amber.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.amber.shade200),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.amber, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
                Text(
                  description,
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAlertsSection(BuildContext context, ExpenseProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Budget Alerts',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.red,
          ),
        ),
        const SizedBox(height: 12),
        if (provider.isMonthlyLimitExceeded())
          _buildAlertCard(
            context,
            'Monthly Limit Exceeded',
            'You have exceeded your monthly budget by \$${(provider.monthlyExpenses - provider.monthlyLimit!.limitAmount).toStringAsFixed(2)}',
            Icons.warning,
          ),
        if (provider.isYearlyLimitExceeded())
          _buildAlertCard(
            context,
            'Yearly Limit Exceeded',
            'You have exceeded your yearly budget by \$${(provider.yearlyExpenses - provider.yearlyLimit!.limitAmount).toStringAsFixed(2)}',
            Icons.error,
          ),
      ],
    );
  }

  Widget _buildAlertCard(
    BuildContext context,
    String title,
    String message,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.red.shade200),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.red, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
                Text(
                  message,
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: Colors.red.shade700),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
