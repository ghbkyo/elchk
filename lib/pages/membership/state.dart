class GetMembershipState {
  GetMembershipState() {
    ///Initialize variables
  }

  int currentIndex = 1;
  int shipStep = 0;
  int dialogType = 0;
  int payTypeId = 0;
  int payModeId = 0;

  String expiryDate = '';
  String centerName = '';
  String payTypeName = '';
  String payModeName = '';
  double fee = 0;
  var memberRenewInfoQuery = {};
  var paymentMethods = [];

  bool payStatus = false;
  String dialogText = '';
  bool dialogStatus = false;
}
