
int[] bitorder = {0, 1, 2, 6, 3, 4, 5, 7};

void consoleBraille(String txt) {
  consoleBraille(txt, 'O');
}

void consoleBraille(String txt, char dot) {
  int cols = txt.length();
  printSeparator('-', cols * 3 - 1);
  for(int row = 0; row < 4; row++) {
    for(int col = 0; col < cols; col++) {
      char ch = txt.charAt(col);
      int code = charBraille(ch);
      for(int bcol = 0; bcol < 2; bcol++) {
        int pos = row + bcol * 4;
        int pos2 = bitorder[pos];
        boolean bit = (code & (1<<pos2)) != 0;
        print( bit ? dot : " ");
      }
      print(" ");
    }
    println();
  }
  //printSeparator('-', cols * 3 - 1);
  //println();
}

void printSeparator(char ch, int n) {
   for(int i = 0; i < n; i++) {
     print(ch);
   }
   println();
}
