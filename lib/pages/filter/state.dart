class GetFilterState {
  GetFilterState() {
    ///Initialize variables
  }

  int currentIndex = 1;

  FliterItem? type01;
  FliterItem? type02;
  FliterItem? type03;
  FliterItem? type04;

  var comCenter = [];
  var category = [];
}

class FliterItem {
  String text;
  String key;
  List<FliterSubItem>? list;
  FliterItem(this.text, this.key);
}

class FliterSubItem {
  String value;
  String text;

  FliterSubItem(this.text, this.value);
}
