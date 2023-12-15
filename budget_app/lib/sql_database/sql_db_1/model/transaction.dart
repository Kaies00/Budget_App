final String tableTransactionXs = 'Transaction04';

class TransactionXFields {
  static final List<String> values = [
    /// Add all fieldsào,
    id, isImportant, amount, account, description, time, category, transfertto,
    type
  ];

  static const String id = '_id';
  static const String isImportant = 'isImportant';
  static const String amount = 'amount';
  static const String account = 'account';
  static const String description = 'description';
  static const String time = 'time';
  static const String category = 'category';
  static const String transfertto = 'transfertto';
  static const String type = 'type';
}

class TransactionX {
  final int? id;
  final bool isImportant;
  final String amount;
  final String account;
  final String description;
  final DateTime createdTime;
  final String category;
  final String transfertto;
  final String type;

  const TransactionX({
    this.id,
    required this.isImportant,
    required this.amount,
    required this.account,
    required this.description,
    required this.createdTime,
    required this.category,
    required this.transfertto,
    required this.type,
  });

  TransactionX copy({
    int? id,
    bool? isImportant,
    String? amount,
    String? account,
    String? description,
    DateTime? createdTime,
    String? category,
    String? transfertto,
    String? type,
  }) =>
      TransactionX(
        id: id ?? this.id,
        isImportant: isImportant ?? this.isImportant,
        amount: amount ?? this.amount,
        account: account ?? this.account,
        description: description ?? this.description,
        createdTime: createdTime ?? this.createdTime,
        category: category ?? this.category,
        transfertto: transfertto ?? this.transfertto,
        type: type ?? this.type,
      );

  static TransactionX fromJson(Map<String, Object?> json) => TransactionX(
        id: json[TransactionXFields.id] as int?,
        isImportant: json[TransactionXFields.isImportant] == 1,
        amount: json[TransactionXFields.amount] as String,
        account: json[TransactionXFields.account] as String,
        description: json[TransactionXFields.description] as String,
        createdTime: DateTime.parse(json[TransactionXFields.time] as String),
        category: json[TransactionXFields.category] as String,
        transfertto: json[TransactionXFields.transfertto] as String,
        type: json[TransactionXFields.type] as String,
      );

  Map<String, Object?> toJson() => {
        TransactionXFields.id: id,
        TransactionXFields.account: account,
        TransactionXFields.isImportant: isImportant ? 1 : 0,
        TransactionXFields.amount: amount,
        TransactionXFields.description: description,
        TransactionXFields.time: createdTime.toIso8601String(),
        TransactionXFields.category: category,
        TransactionXFields.transfertto: transfertto,
        TransactionXFields.type: type,
      };
}
