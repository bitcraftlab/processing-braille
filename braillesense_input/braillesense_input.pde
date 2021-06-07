import processing.serial.*;

Serial com;

void setup() {
  
  printArray(Serial.list());
  
  // pick the first port
  String portName = Serial.list()[0];
  
  // transmitting at 115200 baud
  com = new Serial(this, portName, 115200);
  
  // package size is 10 bytes
  com.buffer(10);
}

void draw() {
  background(0);
}

void printByte(String label, byte b) {
    int unsignedByte = b & 0xFF;
    println(label, unsignedByte);
}

void serialEvent(Serial com) {
  
  // read bytes into a buffer
  byte[] buf = new byte[10];
  com.readBytes(buf);
  
  // get the payload
  byte typ = buf[1];
  byte dat1 = buf[3];
  byte dat2 = buf[4];
  byte dat3 = buf[5];
  
  // print the payload
  printByte("typ", typ);
  printByte("dat1", dat1);
  printByte("dat2", dat2);
  printByte("dat3", dat3);
  
  // print perkins keys
  if( typ == 1 && dat2 > 0) {
    println("braille", dat2); 
  }

}
