import processing.sound.*;
import controlP5.*;
import java.util.ArrayList;
import java.text.SimpleDateFormat;
import java.util.Date;

Table solarTable;
Table RainTotal;
Table ChargeCurrentTable;
Table WindSpeedTable;

SoundFile file;
SoundFile music;
SoundFile song;
SoundFile bird;


PImage img; 
PFont f;
float num;
int number = 0;
int LightNumber = 7; 
//Cloud Variable
float CloudX = 0;
float CloudSize = 100;
int ballX=300, ballY=700;
int baxx = 1600;
float Sp =0;
Rain[] rains = new Rain[1000];
ControlP5 cp5;

//House
int time = 0;
Chart myChart;

final color Red = #D12020;
final color Blue = #515DD8;
final color White = #FFFFFF;
final color Black = #000000;
final color Gray = #808080;
final color Brown = #40735d;

color[] lerpColors = {#6a2c70, #b83b5e, #f08a5d, #f9ed69, #ffffd2, #fcbad3, #aa96da, #a8d8ea};
final color wallColor = #FCD4FC;
final color windowColor = #AA13AA;

String inFile = "CB11.PC09.28_ CB11.08.CR10 In.csv";
String outFile = "CB11.PC09.28_ CB11.08.CR10 Out.csv";

Table table;
ArrayList<DatePoint> data;
boolean hasInfo = false;

int oldWidth = 800;
int oldHeight = 700;
int houseXShift = 0;
int houseYShift = 0;
int doorHeight = 80;
int doorWeight = 50;


void setup()
{
  fullScreen();
  for(int i = 0; i < rains.length; i++)
  {
    rains[i] = new Rain();
  }
  solarTable = loadTable("data.csv");
  RainTotal = loadTable("RainTotal.csv"); 
  ChargeCurrentTable = loadTable("ChargeCurrent.csv");
  WindSpeedTable = loadTable("windSpeed.csv");
    
  bird = new SoundFile(this, "birds.mp3");
  bird.amp(0.1);
  bird.loop();
  
  song = new SoundFile(this, "Rainn.mp3");
  song.stop();
  
  file = new SoundFile(this, "shizukana umi.mp3");
  file.stop();
  
  music = new SoundFile(this, "Felicity-Isaac Shepard.mp3");
  music.stop();
  
  cp5 = new ControlP5(this);
   
  cp5.addButton("Rain")
  .setPosition(20, 20)
  .setSize(100, 40);

  cp5.addButton("RainPause")
  .setPosition(20, 70)
  .setSize(100, 40);
  
  f = createFont("Arial",16,true);
  
  //house
  try {
    loadData();
  }
  catch (Exception e)
  {
    exit();
  }
  houseXShift = (width-oldWidth) / 2;
  houseYShift = height - oldHeight;
  background(Gray);
  gui();
}      

void draw()
{
  drawBackGround();
  pushMatrix();
  translate(houseXShift, houseYShift);
  fill(255);
  textSize(30);
  DatePoint point = data.get(time);
  text(point.date, 350, 100);
  fill(lerpColors[frameCount / 10 % 8]);
  textSize(100);
  text("UST 11", 350, 260);

  if (point.in != 0) {
    drawPeopleIn(point.in);
  }
  if (point.out != 0) {
    drawPeopleOut(point.out);
  }
  popMatrix();
  if (hasInfo) {
    fill(0);
    textSize(25);
    text(point.people + " people in house", mouseX, mouseY);
  }
 
  
  //Cloud
  pushStyle();
  fill(255);
  noStroke();
  ellipse(CloudX+25,50,CloudSize,CloudSize);    
  ellipse(CloudX+30+25,50,CloudSize+30,CloudSize+30); 
  ellipse(CloudX+60+25,50,CloudSize,CloudSize);  
  ellipse(CloudX-30+25,50,CloudSize-25,CloudSize-25); 
  ellipse(CloudX+90+25,50,CloudSize-25,CloudSize-25); 

  ellipse(CloudX+120,200,CloudSize,CloudSize);
  ellipse(CloudX+30+120,200,CloudSize+30,CloudSize+30);  
  ellipse(CloudX+60+120,200,CloudSize,CloudSize);  
  ellipse(CloudX-30+120,200,CloudSize-25,CloudSize-25); 
  ellipse(CloudX+90+120,200,CloudSize-25,CloudSize-25); 
  CloudX += 3;
  if(CloudX > width + (CloudSize/2)+75)
  {
    CloudX = 0 - (CloudSize/2)-75;
  }
  popStyle();
  
  //Light
  pushStyle();
  strokeWeight(5);
  line(0, 200, 2500, 200);
  popStyle();
  
  
  //ChargeCurrent
  if (number <  ChargeCurrentTable.getRowCount()) 
  {
    int AirValue = ChargeCurrentTable.getInt(number, 1);
    textFont(f);
    fill(0);
    textSize(15);
    text("ChargeCurrent = " + AirValue, 225, 190);

    img = loadImage("ChargeCount.jpg");
    image(img,130,175, 20, 20);

    //0 Light
    fill(AirValue+236,AirValue+255,AirValue+36);
    pushStyle();
   stroke(50);
   ellipse(100, 270, 50, 50);
   popStyle();
   fill(#74D8D2);
   rect(95, 200, 10, 40);
   
    //First Light
    fill(AirValue+240,AirValue+230,AirValue+59);
    pushStyle();
   stroke(50);
   ellipse(185, 270, 50, 50);
   popStyle();
   fill(#74D8D2);
   rect(180, 200, 10, 40);
   
   //Second Light
    fill(AirValue+236,AirValue+255,AirValue+36);
   pushStyle();
   stroke(50);
   ellipse(265, 270, 50, 50);
   popStyle();
   fill(#74D8D2);
   rect(260, 200, 10, 40);
   
   
   //Third Light
   fill(AirValue+240,AirValue+230,AirValue+59);
   pushStyle();
   stroke(50);
   ellipse(350, 270, 50, 50);
   popStyle();
   fill(#74D8D2);
   rect(345, 200, 10, 40);
   
   //Four Light
    fill(AirValue+236,AirValue+255,AirValue+36);
   pushStyle();
   stroke(50);
   ellipse(435, 270, 50, 50);
   popStyle();
   fill(#74D8D2);
   rect(430, 200, 10, 40);
   
   //5 Light
   fill(AirValue+240,AirValue+230,AirValue+59);
   pushStyle();
   stroke(50);
   ellipse(520, 270, 50, 50);
   popStyle();
   fill(#74D8D2);
   rect(515, 200, 10, 40);
   
   //6 Light
    fill(AirValue+236,AirValue+255,AirValue+36);
   pushStyle();
   stroke(50);
   ellipse(605, 270, 50, 50);
   popStyle();
   fill(#74D8D2);
   rect(600, 200, 10, 40);
   
   //7 Light
   fill(AirValue+240,AirValue+230,AirValue+59);
   pushStyle();
   stroke(50);
   ellipse(690, 270, 50, 50);
   popStyle();
   fill(#74D8D2);
   rect(685, 200, 10, 40);
   
   //8 Light
    fill(AirValue+236,AirValue+255,AirValue+36);
   pushStyle();
   stroke(50);
   ellipse(775, 270, 50, 50);
   popStyle();
   fill(#74D8D2);
   rect(770, 200, 10, 40);
   
   //9 Light
   fill(AirValue+240,AirValue+230,AirValue+59);
   pushStyle();
   stroke(50);
   ellipse(860, 270, 50, 50);
   popStyle();
   fill(#74D8D2);
   rect(855, 200, 10, 40);
   
   //10 Light
    fill(AirValue+236,AirValue+255,AirValue+36);
   pushStyle();
   stroke(50);
   ellipse(945, 270, 50, 50);
   popStyle();
   fill(#74D8D2);
   rect(940, 200, 10, 40);
   
   //11 Light
   fill(AirValue+240,AirValue+230,AirValue+59);
   pushStyle();
   stroke(50);
   ellipse(1030, 270, 50, 50);
   popStyle();
   fill(#74D8D2);
   rect(1025, 200, 10, 40);
   
   //12 Light
    fill(AirValue+236,AirValue+255,AirValue+36);
   pushStyle();
   stroke(50);
   ellipse(1115, 270, 50, 50);
   popStyle();
   fill(#74D8D2);
   rect(1110, 200, 10, 40);
   
   //13 Light
   fill(AirValue+240,AirValue+230,AirValue+59);
   pushStyle();
   stroke(50);
   ellipse(1200, 270, 50, 50);
   popStyle();
   fill(#74D8D2);
   rect(1195, 200, 10, 40);
   
   //14 Light
    fill(AirValue+236,AirValue+255,AirValue+36);
   pushStyle();
   stroke(50);
   ellipse(1285, 270, 50, 50);
   popStyle();
   fill(#74D8D2);
   rect(1280, 200, 10, 40);
   
   //15 Light
   fill(AirValue+240,AirValue+230,AirValue+59);
   pushStyle();
   stroke(50);
   ellipse(1370, 270, 50, 50);
   popStyle();
   fill(#74D8D2);
   rect(1365, 200, 10, 40);
   
   //16 Light
    fill(AirValue+236,AirValue+255,AirValue+36);
   pushStyle();
   stroke(50);
   ellipse(1455, 270, 50, 50);
   popStyle();
   fill(#74D8D2);
   rect(1450, 200, 10, 40);
   
   //17 Light
   fill(AirValue+240,AirValue+230,AirValue+59);
   pushStyle();
   stroke(50);
   ellipse(1540, 270, 50, 50);
   popStyle();
   fill(#74D8D2);
   rect(1535, 200, 10, 40);
   
   //18 Light
    fill(AirValue+236,AirValue+255,AirValue+36);
   pushStyle();
   stroke(50);
   ellipse(1625, 270, 50, 50);
   popStyle();
   fill(#74D8D2);
   rect(1620, 200, 10, 40);
   
   //18 Light
   fill(AirValue+240,AirValue+230,AirValue+59);
   pushStyle();
   stroke(50);
   ellipse(1710, 270, 50, 50);
   popStyle();
   fill(#74D8D2);
   rect(1705, 200, 10, 40);
   
   //18 Light
    fill(AirValue+236,AirValue+255,AirValue+36);
   pushStyle();
   stroke(50);
   ellipse(1795, 270, 50, 50);
   popStyle();
   fill(#74D8D2);
   rect(1790, 200, 10, 40);
    number++;
  } 
  else 
  {
    number=0;
  }
  
  
  //Sun
  if (number <  solarTable.getRowCount()) 
  {
    int solarValue = solarTable.getInt(number, 1);
    textFont(f);
    fill(0);
    textSize(15);
    text("Sun Radiation = " + solarValue, 230, 100);
    
    img = loadImage("Sun.jpg");
    image(img,130,85, 20, 20);
  for (int i = -180; i < 180; i+=12) 
  {
    pushMatrix();
    translate(1780, 100);
    rotate(radians(-i));
    for(int z = 0; z < 200; z+=5){
      float solar = map(solarValue, 0,200, 40, 0);
      float sun = sin(-i+z+num) * 2;
      fill(#FFD271);
      ellipse(sun, z, solar-50, solar-20); 
 }
   popMatrix();
 }
  num += 0.2;
   number++;
  } else 
  {
    number=0;
  }

  
  //Rain
if (number <  RainTotal.getRowCount()) 
{
    int RainValue = RainTotal.getInt(number, 1);
    textFont(f);
    fill(0);
    textSize(15);
    text("TotalRainValue = " + RainValue, 230, 130);
    img = loadImage("Rain.jpg");
    image(img,130,115, 20, 20);
    if(song.isPlaying())
  {
        for(int i = 0; i < rains.length; i++)
       {
            rains[i].Down(RainValue);
       }
           pushStyle();
           img = loadImage("Clound.jpg");
           tint(100,127);
           image(img,800,10, 280, 180);
           popStyle();
   }
      number++;
  } 
else 
{
    number=0;
}




//WindSpeed
 Sp +=PI/-1200;
  if (number <  WindSpeedTable.getRowCount()) 
  {
    int windValue = WindSpeedTable.getInt(number, 1);
    textFont(f);
    fill(0);
    textSize(15);
    text("WindSpeedValue = " + windValue, 235, 160);
    img = loadImage("Wind.jpg");
    image(img,130,150, 20, 20);
    //One Windmills
  fill(#26EDC3);
  rect(275, 700, 50, 400);
  
  
   fill(#ED262D);
   pushMatrix();
   translate(ballX, ballY);
   rotate(Sp + windValue);
   rect(0, 0, 75, 200);
   fill(#ED262D);
   rect(0, 0, 60, 185);
   rotate(PI/2);
   fill(#EDB526);
   rect(0, 0, 75, 200);
   fill(#EDB526);
   rect(0, 0, 60, 185);
   rotate(PI/2);
   fill(#E9ED26);
   rect(0, 0, 75, 200);
   fill(#E9ED26);
   rect(0, 0, 60, 185);
   rotate(PI/2);
   fill(#26ED27);
   rect(0, 0, 75, 200);
   fill(#26ED27);
   rect(0, 0, 60, 185);
   popMatrix();
   fill(#FFFFFF);
   ellipse(ballX, ballY, 50, 50);
   
   
   
   //Second Windmills
  fill(#26EDC3);
  rect(1570, 700, 50, 400);
  
   fill(#26EDE8); 
   pushMatrix();
   translate(baxx, ballY);
   rotate(Sp+windValue);
   rect(0, 0, 75, 200);
   fill(#26EDE8);
   rect(0, 0, 60, 185);
   rotate(PI/2);
   fill(#ED26E4);
   rect(0, 0, 75, 200);
   fill(#ED26E4);
   rect(0, 0, 60, 185);
   rotate(PI/2);
   fill(#DADDF0);
   rect(0, 0, 75, 200);
   fill(#DADDF0);
   rect(0, 0, 60, 185);
   rotate(PI/2);
   fill(#2BFC45);
   rect(0, 0, 75, 200);
   fill(#2BFC45);
   rect(0, 0, 60, 185);
   popMatrix();
   fill(#FFFFFF);
   ellipse(baxx, ballY, 50, 50);
   number++;
  } 
  else 
  {
    number=0;
  }
 
//Word Label
String s = "Press A to play the music for shizukana umi";
String p = "Press a to pause the music for shizukana umi";
   
String h = "Press S to play the music for Felicity-Isaac Shepard";
String L = "Press s to pause the music for Felicity-Isaac Shepard";
   
textFont(f);
fill(0);
textAlign(CENTER);
textSize(15);
text(s, 300, 20);
   
textFont(f);
fill(0);
textAlign(CENTER);
textSize(15);
text(p, 305, 36);
   
textFont(f);
fill(0);
textAlign(CENTER);
textSize(15);
text(h, 325, 50);
   
textFont(f);
fill(0);
textAlign(CENTER);
textSize(15);
text(L, 330, 66);



 
}

public void Rain()
{
  if(song.isPlaying())
  {
  }
  else
  {
  song.amp(0.1);
  song.loop();
   
  bird.stop();
  }
}

public void RainPause()
{
  if(song.isPlaying())
  {
   song.pause();
   bird.play();
   }
}

public void keyPressed()
{
  if(key == 'A')
  {
    file.play();
    file.amp(0.08);
  }
  else if(key == 'S')
  {
    music.play();
    music.amp(0.08);
  }
  else if(key == 'a')
  {
    file.stop();
    file.amp(0.08);
  }
  else if(key == 's')
  {
    music.stop();
    music.amp(0.08);
  }
}

class Rain
{
  float LineX = random(width);
  float LineY = random(-300, -100);
  float Speed = random(4,10);
  
  void Down(float RainValue)
  {
    LineY = LineY + Speed;
    if(LineY > height)
    {
      LineY = random(-200, -100);
    }
    pushStyle();
    stroke(#1274FA);
    strokeWeight(10);
    line(LineX, LineY, LineX + RainValue, LineY + RainValue);
    popStyle();
  }
}







//house
void mouseMoved() {
  float[] x1 = {250, 540, 100+400/12, 100+400/12, 100+400/12+400/3, 100+400/12+400/3, 100+400/12+800/3, 100+400/12+800/3};
  float[] y1 = {520, 500, 300+90/4, 390+90/4, 300+90/4, 390+90/4, 300+90/4, 390+90/4};
  float[] x2 = {350, 620, 200, 200, 200+400/3, 200+400/3, 200+800/3, 200+800/3};
  float[] y2 = {600, 555, 390, 480, 390, 480, 390, 480};
  for (int i=0; i< x1.length; i++) {
    if (mouseX >= x1[i]+houseXShift && mouseX<= x2[i]+houseXShift && 
    mouseY>= y1[i]+houseYShift && mouseY<= y2[i]+houseYShift) {
      hasInfo = true;
      return;
    }
  }
  hasInfo = false;
}

void drawBackGround() {
  fill(#87b181);
  rect(0, 500*height/oldHeight, width, 200*height/oldHeight);
  fill(#a0d8ef);
  rect(0, 0, width, 500*height/oldHeight);

  pushMatrix();
  translate(houseXShift, houseYShift);
  strokeWeight(2);
  fill(wallColor);
  rect(100, 300, 400, 300);
  fill(#ffffd2);
  quad(100, 300, 180, 150, 580, 150, 500, 300);
  fill(#7FB69F);
  triangle(580, 150, 500, 300, 660, 240);
  fill(wallColor);
  quad(500, 300, 660, 240, 660, 540, 500, 600);
  pushMatrix();
  translate(100, 300);
  line(0, 180, 400, 180);
  int windowH = 90;
  fill(windowColor);
  for (int i=0; i<2; i++) {
    line(0, windowH*(i+1), 400, windowH*(i+1));
    for (int j=0; j<3; j++) {
      rect(400/12+400/3*j, windowH*i+windowH/4, 66, windowH*3/4);
    }
  }
  fill(#fce38a);
  rect(150, 300 - doorHeight, doorWeight, doorHeight);
  rect(200, 300 - doorHeight, doorWeight, doorHeight);
  popMatrix();
  pushMatrix();
  translate(500, 600);
  line(0, -120, 160, -120-60);
  line(0, -120-90, 160, -120-90-60);
  fill(#f38181);
  float y1 = 40*60/160;
  float y2 = 80*60/160;
  quad(40, -y1, 80, -y2, 80, -(y2+doorHeight), 40, -(y1+doorHeight));
  y1 = 80*60/160;
  y2 = 120*60/160;
  quad(80, -y1, 120, -y2, 120, -(y2+doorHeight), 80, -(y1+doorHeight));
  popMatrix();
  strokeWeight(1);
  popMatrix();
}

void gui () {
  cp5 = new ControlP5(this);

  cp5.addSlider("time")
    .setPosition(houseXShift + 200, houseYShift + 10)
    .setSize(400, 30)
    .setRange(data.get(0).timestamp, data.get(data.size()-1).timestamp)
    .setValue(data.get(0).timestamp);

  ControlP5.printPublicMethodsFor(Chart.class);
  myChart = cp5.addChart("chart")
    .setPosition(170, 350)
    .setSize(100, 100)
    .setRange(-20, 20)
    .setView(Chart.BAR) 
    ;
  myChart = cp5.addChart("chart");

  myChart.getColor().setBackground(color(255, 100));

  myChart.addDataSet("world");
  myChart.setColors("world", color(255, 0, 255), color(255, 0, 0));
  myChart.setData("world", new float[10]);

  myChart.addDataSet("earth");
  myChart.setColors("earth", color(255), color(0, 255, 0));
  myChart.updateData("earth", new float[10]);
}

void loadData() throws Exception {
  SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
  ArrayList<DatePoint> inData = new ArrayList<DatePoint>();
  table = loadTable(inFile);
  for (TableRow row : table.rows()) {
    String date = row.getString(0);
    int id = row.getInt(1);
    DatePoint point = new DatePoint(date);
    point.in = id;
    inData.add(point);
  }
  ArrayList<DatePoint> outData = new ArrayList<DatePoint>();
  table = loadTable(outFile);
  for (TableRow row : table.rows()) {
    String date = row.getString(0);
    int id = row.getInt(1);
    DatePoint point = new DatePoint(date);
    point.out = id;
    outData.add(point);
  }

  long first1 = df.parse(inData.get(0).date).getTime();
  long first2 = df.parse(outData.get(0).date).getTime();
  long first;
  if (first1 < first2) {
    first = first1;
  } else {
    first = first2;
  }
  long end1 = df.parse(inData.get(inData.size()-1).date).getTime();
  long end2 = df.parse(outData.get(outData.size()-1).date).getTime();
  long end;
  if (end1 < end2) {
    end = end2;
  } else {
    end = end1;
  }

  data = new ArrayList<DatePoint>();
  int index = 0;
  int people = 0;
  for (long i=first; i<=end; i+=1000*60*5) {
    Date d = new Date(i);
    String date = df.format(d);
    DatePoint point = new DatePoint(date);
    point.timestamp = index;
    index ++;
    for (int j=0; j<inData.size(); j++) {
      if (inData.get(j).date.equals(date)) {
        point.in +=  inData.get(j).in;
      }
    }
    for (int j=0; j<outData.size(); j++) {
      if (outData.get(j).date.equals(date)) {
        point.out +=  outData.get(j).out;
      }
    }
    people += point.in - point.out;
    point.people = people;
    data.add(point);
  }
}

void drawPeopleIn(int num) {
  pushMatrix();
  translate(300, 600);
  for (int i=0; i<num; i++) {
    fill(lerpColors[i%lerpColors.length]);
    circle(-i*30, 30, 30);
    strokeWeight(4);
    line(-i*30, 45, -i*30, 65);
    line(-i*30, 45, -i*30-15, 60);
    line(-i*30, 45, -i*30+15, 60);
    line(-i*30, 65, -i*30-15, 80);
    line(-i*30, 65, -i*30+15, 80);
    strokeWeight(1);
  }
  popMatrix();
}

void drawPeopleOut(int num) {
  pushMatrix();
  translate(580, 580);
  for (int i=0; i<num; i++) {
    fill(lerpColors[i%lerpColors.length]);
    circle(i*30, 30, 30);
    strokeWeight(4);
    line(i*30, 45, i*30, 65);
    line(i*30, 45, i*30-15, 60);
    line(i*30, 45, i*30+15, 60);
    line(i*30, 65, i*30-15, 80);
    line(i*30, 65, i*30+15, 80);
    strokeWeight(1);
  }
  popMatrix();
}

class DatePoint {
  int timestamp;
  String date;
  int in = 0;
  int out = 0;
  int people = 0;

  DatePoint(String date) {
    this.date = date;
  }
}
