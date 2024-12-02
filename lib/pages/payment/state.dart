class GetPaymentState {
  GetPaymentState() {
    ///Initialize variables
  }

  bool isLoading = false;
  var txList = [];
  var paymentMethods = [];

  double fee = 0;
  int payModeId = 0;
  String payModeName = '';

  int currentIndex = 1;
  int shipStep = 0;
  int dialogType = 0;
  List<int> payType = [];
  List<int> txIds = [];
  String payMode = 'payme';

  var post = {};
  String dialogText = '';
  bool dialogStatus = false;

  var joinRes = {};
}
