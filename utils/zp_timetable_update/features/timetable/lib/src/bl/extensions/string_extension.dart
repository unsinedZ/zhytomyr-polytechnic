extension StringExtensions on String {
  int compareAsTimeTo(String another) {
    List<int> time = this.split(':')
        .map((element) => int.parse(element))
        .toList();
    List<int> anotherTime = another.split(':')
        .map((element) => int.parse(element))
        .toList();

    int result = 0;
    int index = 0;

    while(index + 1 < 2 && result == 0){
      result = time[index].compareTo(anotherTime[index]);
      index++;
    }

    return result;
  }
}