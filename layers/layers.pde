import processing.serial.*;
import cc.arduino.*;

import ddf.minim.analysis.*;
import ddf.minim.*;

Arduino arduino;

Minim minim;  
AudioPlayer song;
FFT fftLog;

int[] layersL = {40,41,22,23};
int[] columnsL = {24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39};

//int[] layersR = {48,49,50,51};
//int[] columnsR = {0,1,2,3,4,5,6,7,8,9,10,11,12,13,46,47};

boolean on[][] = new boolean[layersL.length][columnsL.length];

void setup() {
    arduino = new Arduino(this, "/dev/tty.usbmodem1421");
    minim = new Minim(this);
    song = minim.loadFile("nightcall.mp3",1024);
    song.loop();
    
    fftLog = new FFT( song.bufferSize(), song.sampleRate() );
    fftLog.logAverages( 22, 2);
    
    for(int i = 0; i < layersL.length; i ++){
        arduino.pinMode(layersL[i], Arduino.OUTPUT); 
        //arduino.pinMode(layersR[i], Arduino.OUTPUT); 
    }
    for(int i = 0; i < columnsL.length; i ++){
        arduino.pinMode(columnsL[i], Arduino.OUTPUT); 
        //arduino.pinMode(columnsR[i], Arduino.OUTPUT); 
    }
    setOff();
}

void setOff(){
    /*for(int layer = 0; layer < on.length; layer++){
        boolean [] layerArray = on[layer];
        for(int column = 0; column < layerArray.length; column++){
            on[layer][column] = false;
        }
    }*/
    for(int i = 0; i < layersL.length; i++){
        setLayer(i, true);
    }
    for(int i = 0; i < columnsL.length; i++){
        setColumn(i, true);
    }
}
void setColumn(int index, boolean on){
    int pinL = columnsL[index];
    //int pinR = columnsR[index];
    if(on){
        arduino.digitalWrite(pinL, Arduino.HIGH);
        //arduino.digitalWrite(pinR, Arduino.HIGH);
    }else{
        arduino.digitalWrite(pinL, Arduino.LOW);
        //arduino.digitalWrite(pinR, Arduino.LOW);
    }

}
void setLayer(int index, boolean on){
    int pinL = columnsL[index];
    //int pinR = columnsR[index];
    if(on){
        arduino.digitalWrite(pinL, Arduino.LOW);
        //arduino.digitalWrite(pinR, Arduino.LOW);
    }else{
        arduino.digitalWrite(pinL, Arduino.HIGH);
        //arduino.digitalWrite(pinR, Arduino.HIGH);
    }
}
void turnOffcolumns(){
   for(int i = 0; i < columnsL.length; i++){
        setColumn(i, false);
    }
}
int index = 0;
float maxAve = 0;
int delay_t = 200; //(ms)
int previousLayer = -1;

void draw() {
    if(true)return;
    println("something");
    fftLog.forward( song.mix );
    //println("num Averages: " + fftLog.avgSize());
    for(int i = 0; i < 16; i++){
        float ave = fftLog.getAvg(i) * fftLog.getAverageBandWidth(i);
        //float averageWidth = fftLog.getAverageBandWidth(i);
        //float total = ave * aveWidth;
        if(ave > maxAve){
          maxAve = ave;
          println(maxAve);
        }
        int power = (int)ave / 800;
        if(power > 3) power = 3;
        //println(power + " - " + ave);
        for(int j = 0; j < power; j++){
          //println("setting on");
          on[j][i] = true;
        }
    }
    
    for(int layer = 0; layer < on.length; layer++){
        boolean [] layerArray = on[layer];
        if(previousLayer != -1) setLayer(previousLayer, false);
        setLayer(layer, true);
        for(int column = 0; column < layerArray.length; column++){
            boolean isOn = layerArray[column];
            if(isOn) println("turning on!");
            setColumn(column, isOn);
        }
        delay(delay_t);
        turnOffcolumns();
        previousLayer = layer;
    }
}
    
