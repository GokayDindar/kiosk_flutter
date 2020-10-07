int d1 = 2;
int d2 = 3;
int d3 = 4;
int d4 = 3;
String readString;

void setup() {
  Serial.begin(115200);
  pinMode(d1, OUTPUT);
  pinMode(d2, OUTPUT);
  pinMode(d3, OUTPUT);
  pinMode(d4, OUTPUT); 
  pinMode(8, INPUT);
  pinMode(6, INPUT);
  digitalWrite(d1, LOW);
  digitalWrite(d2, LOW);
  digitalWrite(d3, LOW);
  digitalWrite(d4, HIGH);
  
  Serial.println("serial on/off test 0021"); // so I can keep track
  
}

void loop() {

  while (Serial.available()) {
    delay(3);  
    char c = Serial.read();
    readString += c; 
  }
  readString.trim();
  if(digitalRead(6) == HIGH){Serial.println("hıgh");}
  else{Serial.println("low");}
  if (readString.length() >0) {
    if (readString == "stop")
    {
      digitalWrite(d1, HIGH);
      digitalWrite(d2, HIGH);
      digitalWrite(d3, HIGH);
      digitalWrite(d4, HIGH);
    }
    else if (readString == "open")
    {
     
      digitalWrite(d1, LOW);
      digitalWrite(d2, LOW);
      digitalWrite(d3, LOW);
      digitalWrite(d4, HIGH);
      
    }
    else if (readString == "close")
    {
      digitalWrite(d1, LOW);
      digitalWrite(d2, LOW);
      digitalWrite(d3, LOW);
      digitalWrite(d4, LOW);
    }
    else if (readString == "halfopen")
    {
      digitalWrite(d1, LOW);
      digitalWrite(d2, LOW);
      digitalWrite(d3, HIGH);
      digitalWrite(d4, HIGH);
    }
   else if (readString == "halfclose")
    {
      digitalWrite(d1, LOW);
      digitalWrite(d2, LOW);
      digitalWrite(d3, HIGH);
      digitalWrite(d4, LOW);
    }
    readString="";
  } 
}
