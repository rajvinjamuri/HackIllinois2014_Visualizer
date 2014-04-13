import processing.serial.*;
import cc.arduino.*;

Arduino arduino;

int[] planes = {40,41,22,23};
int[] columns = {24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39};

void setup() {
  boolean groovin = false;
  
  /* Initialize the arduino */
  arduino = new Arduino(this, "/dev/tty.usbmodem1421");
    
  /* Init sequence:
   * Do quick incremental sequence
   * then set all the LEDs off 
   */
   
  for(int i = 0; i < planes.length; i ++){
      arduino.pinMode(planes[i], Arduino.OUTPUT); 
  }
  for(int i = 0; i < columns.length; i ++){
        arduino.pinMode(columns[i], Arduino.OUTPUT); 
  }
  
  clearLed(); // end init
  
  if(!groovin){
    loop_sequence(0); //fast
  }

  
  groovin = dropBeats();
    
}

void clearLed(){
  _clearPlanes();
  _clearColumns();
}

void _clearPlanes(){
  for (int curPlane = 0; curPlane < planes.length; curPlane++){
    arduino.digitalWrite(planes[curPlane], Arduino.HIGH);
  }
}

void _clearColumns(){
  for (int curColumn = 0; curColumn < columns.length; curColumn++){
    arduino.digitalWrite(columns[curColumn], Arduino.LOW);
  }
}

void loop_sequence(int speed_mode){
  int delayT = 50;
  if (speed_mode == 1) delayT = 500;
  
  for (int curPlane = 0; curPlane < planes.length; curPlane++){
    for (int curColumn = 0; curColumn < columns.length; curColumn++){
      
      _clearPlanes();
      arduino.digitalWrite(columns[curColumn], Arduino.HIGH);
      arduino.digitalWrite(planes[curPlane], Arduino.LOW);
      delay(delayT);
      arduino.digitalWrite(columns[curColumn], Arduino.LOW);
      arduino.digitalWrite(planes[curPlane], Arduino.HIGH);
      
    }
  }
  
}

boolean dropBeats(){

  //code here


  return false;
}

