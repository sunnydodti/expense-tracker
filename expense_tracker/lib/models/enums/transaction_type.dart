enum TransactionType {
  expense,
  income,
  reimbursement,
  // transfer,
  // loan,
  // borrow,
  // payback,
  // receive,
  // refund,
  // unknown
}

List<String> getTransactionTypes() {
  List<String> transactionTypes = [];
  for (TransactionType transactionType in TransactionType.values) {
    transactionTypes.add(transactionType.name);
  }
  return transactionTypes;
}
