import 'package:flutter/material.dart';
import 'package:flx_core_flutter/src/app/util/number_format.dart';
import 'package:gap/gap.dart';

class FinancialSummaryCard extends StatelessWidget {
  const FinancialSummaryCard({
    required this.subtotal,
    required this.discountPercent,
    required this.discountValue,
    required this.subAfterDiscount,
    required this.pphType,
    required this.pphPercent,
    required this.pphValue,
    required this.ppnPercent,
    required this.ppnValue,
    required this.taxBase,
    required this.shippingCost,
    required this.otherCost,
    required this.total,
    this.otherCostDescription = '',
    this.title,
    this.width = 420,
    super.key,
  });

  final double subtotal;
  final double discountPercent;
  final double discountValue;
  final double subAfterDiscount;
  final String pphType;
  final double pphPercent;
  final double pphValue;
  final double ppnPercent;
  final double ppnValue;
  final double taxBase;
  final double shippingCost;
  final double otherCost;
  final String otherCostDescription;
  final double total;
  final String? title;
  final double width;

  String _formatPercent(double val) {
    return val.toStringAsFixed(
      val.truncateToDouble() == val ? 0 : 2,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: width,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: theme.dividerColor.withValues(alpha: 0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (title != null) ...[
            Text(
              title!,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const Divider(height: 24),
          ],
          _buildRow('Sub Total', subtotal.idr),
          const Gap(8),
          _buildRow(
            'Discount (${_formatPercent(discountPercent)}%)',
            '- ${discountValue.idr}',
            isNegative: true,
          ),
          const Gap(8),
          _buildRow(
            'Sub Total After Discount',
            subAfterDiscount.idr,
            isMuted: true,
          ),
          const Gap(8),
          _buildRow(
            'Tax Base (DPP)',
            taxBase.idr,
            isMuted: true,
          ),
          const Gap(8),
          _buildRow(
            'PPh $pphType (${_formatPercent(pphPercent)}%)',
            '- ${pphValue.idr}',
            isNegative: true,
          ),
          const Gap(8),
          _buildRow(
            'PPN (${_formatPercent(ppnPercent)}%)',
            '+ ${ppnValue.idr}',
            isPositive: true,
          ),
          if (shippingCost > 0) ...[
            const Gap(8),
            _buildRow('Shipping Charges', shippingCost.idr),
          ],
          if (otherCost > 0 || otherCostDescription.isNotEmpty) ...[
            const Gap(8),
            _buildRow(
              otherCostDescription.isNotEmpty
                  ? 'Other Cost ($otherCostDescription)'
                  : 'Other Cost',
              otherCost.idr,
            ),
          ],
          const Divider(height: 24),
          _buildRow(
            'Total (Rp.)',
            total.idr,
            isTotal: true,
            theme: theme,
          ),
        ],
      ),
    );
  }

  Widget _buildRow(
    String label,
    String value, {
    bool isTotal = false,
    bool isNegative = false,
    bool isPositive = false,
    bool isMuted = false,
    ThemeData? theme,
  }) {
    Color? valueColor;
    if (isNegative) valueColor = Colors.red.shade600;
    if (isPositive) valueColor = Colors.green.shade600;
    if (isMuted) valueColor = Colors.grey.shade600;
    if (isTotal) valueColor = theme?.colorScheme.primary;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              fontSize: isTotal ? 16 : 13,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
              color: isMuted ? Colors.grey.shade600 : null,
            ),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isTotal ? 17 : 13,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.w600,
            color: valueColor,
          ),
        ),
      ],
    );
  }
}
