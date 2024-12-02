class GetFreeState {
  GetFreeState() {
    ///Initialize variables
  }
  bool isLoading = false;
  var txList = [];

  int currentIndex = 1;
  int shipStep = 0;
  int dialogType = 0;
  List<int> payType = [];
  List<int> txIds = [];
  String payMode = 'payme';

  String dialogText = '';
  bool dialogStatus = false;

  var joinRes = {};

  Map<String, dynamic> post = {'id': 0};
}
