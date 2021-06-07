import processing.serial.*;

Serial com;

void setupSerial() {

  // get all serial inputs and pick the first one
  printArray(Serial.list());
  String portName = Serial.list()[0];
  println(portName);

  com = new Serial(this, portName, 115200);
  // receiving messages in chunks of 10 chars
  com.buffer(10);
}


// incoming data on the serial port
void serialEvent(Serial myPort) {

  // read 10 bytes from the buffer
  byte[] buf = new byte[10];
  com.readBytes(buf);
  
  byte type = buf[1];
  byte dat1 = buf[3];
  byte dat2 = buf[4];
  byte dat3 = buf[5];

  /*
  printByte("type", type);
  printByte("dat1", dat1);
  printByte("dat2", dat2);
  printByte("dat3", dat3);
  */

  // perkins keys
  if (type == 1) {
    if (dat2 != 0) {
      // convert to unsinged byte
      int udat2 = dat2 & 0xff; 
      txt += brailleChar(udat2);
      renderBraille();
    }
    // space key
    else if (dat3 == 1) {
      txt += brailleChar(0);
      renderBraille();
    }
  }
}

// send chars to the braille line
void outputBraille(String txt) {
  int n = txt.length();
  
  // we need to fill the braille line with chars (!)
  byte[] braille = new byte[braillechars]; 
  
  // text to chars
  for (int i = 0; i < n; i++) {
    char ch = txt.charAt(i);
    braille[i] = (byte) charBraille(ch);
  }
  himsBraille(braille);
}

// send code to the braille device
void himsBraille(byte[] code) {
  
  if(code.length == 0) return;
  
  // packet size = code length + 18 bytes of protocol overhead
  int n = code.length + 18; 
  byte[] bytes = new byte[n];

  // set protocol bytes
  bytes[0] = (byte) 0xFC; // start code
  bytes[1] = (byte) 0xFC; // start code
  bytes[2] = (byte) 0x01; // mode
  bytes[3] = (byte) 0xF0; // start data section 1
  bytes[4] = (byte) (code.length & 0xff); // byte count lo
  bytes[5] = (byte) (code.length>>8 & 0xff);    // byte count hi 
  bytes[n - 12] = (byte) 0xF1; // start (empty) data section 2
  bytes[n - 11] = (byte) 0xF2; // end (empty) data section 2
  bytes[n - 8] = (byte) 0xF3; // end data section 2
  bytes[n - 2] = (byte) 0xFD; // end code
  bytes[n - 1] = (byte) 0xFD; // end code
  
  // add payload
  arrayCopy(code, 0, bytes, 6, code.length);
  
  // compute checksum over the packet
  int check = 0;
  for(int i = 0; i < bytes.length; i++) {
    check = 0xff & (check + (0xff & bytes[i]));
  }
  
  // set checksum byte
  bytes[n - 3] = (byte) check;
  
  /*
  println("code:");
  for(int i = 0; i < bytes.length; i++) {
    print(hex(bytes[i]));
    print(" ");
  }
  */
  
  com.write(bytes);
  
}
