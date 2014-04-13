import processing.serial.*;
import cc.arduino.*;

import ddf.minim.analysis.*;
import ddf.minim.*;

Arduino arduino;

Minim minim;  
AudioPlayer song;
FFT fftLog;

int[] layers = {40,41,22,23};
int[] columns = {24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39};

boolean on[][] = new boolean[layers.length][columns.length];

void setup() {
    arduino = new Arduino(this, "/dev/tty.usbmodem1421", 57600);
    minim = new Minim(this);
    song = minim.loadFile("bounceit.mp3",1024);
    song.loop();
    
    fftLog = new FFT( song.bufferSize(), song.sampleRate() );
    fftLog.logAverages( 22, 2);
    
    for(int i = 0; i < layers.length; i ++){
        arduino.pinMode(layers[i], Arduino.OUTPUT); 
    }
    for(int i = 0; i < columns.length; i ++){
        arduino.pinMode(columns[i], Arduino.OUTPUT); 
    }
    //frameRate(120);
    setOff();
}

void setOff(){
    for(int layer = 0; layer < on.length; layer++){
        boolean [] layerArray = on[layer];
        for(int column = 0; column < layerArray.length; column++){
            on[layer][column] = false;
        }
    }
    for(int i = 0; i < layers.length; i++){
        setLayer(i, false);
    }
    for(int i = 0; i < columns.length; i++){
        setColumn(i, false);
    }
}
int cycleTimeout = 50;
int counter = cycleTimeout;
int currentOn = 0;
void setColumn(int index, boolean on){
    int pin = columns[index];
    
    if(on){
        arduino.digitalWrite(pin, Arduino.HIGH);
    }else{
        arduino.digitalWrite(pin, Arduino.LOW);
    }

}
void setLayer(int index, boolean on){
    int pin = layers[index];
    
    if(on){
        arduino.digitalWrite(pin, Arduino.LOW);
    }else{
        arduino.digitalWrite(pin, Arduino.HIGH);
    }
}
void turnOffColumns(){
   for(int i = 0; i < columns.length; i++){
        setColumn(i, false);
    }
}
int index = 0;
float maxAve = 0;
void draw() {
    setLayer(1,true);
    setColumn(1,true);
    println("something");
    /*fftLog.forward( song.mix );
    //println("num Averages: " + fftLog.avgSize());
    for(int i = 0; i < 16; i++){
        float ave = fftLog.getAvg(i);
        if(ave > maxAve){
          maxAve = ave;
          println(maxAve);
        }
        int power = (int)ave / 50;
        if(power > 3) power = 3;
        println(power);
        for(int j = 0; j < power; j++){
          on[j][i] = true;
        }
    }
    
    for(int layer = 0; layer < on.length; layer++){
        boolean [] layerArray = on[layer];
        setLayer(layer, true);
        for(int column = 0; column < layerArray.length; column++){
            boolean isOn = layerArray[column];
            setColumn(column, isOn);
            if(isOn){
                setColumn(column, false);
            }
        }
        delay(50);
        turnOffColumns();
        setLayer(layer, false);
    }*/
    /*
    if(counter == 0){
        counter = cycleTimeout;
        currentOn = (currentOn + 1) % 4;
        setOff();
        int currentOnLayer = currentOn / layers.length;
        int currentOnColumn = currentOn % 2;
        on[currentOnLayer][currentOnColumn] = true;
    }*/
}
    
