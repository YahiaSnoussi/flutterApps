import 'package:flutter/material.dart';

class AddDhikrDialog extends StatefulWidget {
  final Function(Map<String, dynamic>) onAddDhikr;

  const AddDhikrDialog({super.key, required this.onAddDhikr});

  @override
  _AddDhikrDialogState createState() => _AddDhikrDialogState();
}

class _AddDhikrDialogState extends State<AddDhikrDialog> {
  String dhikrText = '';
  int repeatCount = 1;
  String dhikrDescription = '';

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('أضف الذكر'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            decoration: const InputDecoration(labelText: 'الوصف'),
            onChanged: (value) {
              dhikrDescription = value;
            },
          ),
          TextField(
            decoration: const InputDecoration(labelText: 'نص الذكر'),
            onChanged: (value) {
              dhikrText = value;
            },
          ),
          TextField(
            decoration: const InputDecoration(labelText: 'عدد التكرار'),
            keyboardType: TextInputType.number,
            onChanged: (value) {
              repeatCount = int.tryParse(value) ?? 1;
            },
          ),
        ],
      ),
      actions: [
        
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('الغاء'),
        ),
        TextButton(
          onPressed: () {
            if (dhikrText.isNotEmpty && dhikrDescription.isNotEmpty) {
              widget.onAddDhikr({
                'text': dhikrText,
                'count': repeatCount,
                'description': dhikrDescription,
              });
              Navigator.of(context).pop();
            }
          },
          child: const Text('اضافة'),
        ),
      ],
    );
  }
}
