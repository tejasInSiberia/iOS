
int mouseX,mouseY,scroll,keypress;
int interval = 40;




void setup() 
{
  
  // initialize serial:
  Serial.begin(9600);
  Serial1.begin(57600);

  Keyboard.begin();
  Mouse.begin();


}

void loop() 
{

  
  if (Serial1.available()) 
  {
    
    ///// Parsing Value From Left Controller
    
    mouseX = Serial1.parseInt();
    mouseY = Serial1.parseInt();
    scroll = Serial1.parseInt();
    keypress = Serial1.parseInt(); 
    
    
    ///// Value Mapping

    
    mouseX = map(mouseX,20,300,-10,10);
    mouseY = map(mouseY,20,300,-10,10);
    
    Serial.print("X:");
    Serial.print(mouseX);
    Serial.print("Y:");
    Serial.println(mouseY);
 
  //////////////Motion Controller ///////////////


  if(Serial1.read() == 'M')
{


 
  if(keypress == 256)  // Up Arrow Key
  {
     Keyboard.press(KEY_UP_ARROW);
     delay(interval);
     Keyboard.release(KEY_UP_ARROW);
  }
  
  else if(keypress == 257)  // Down Arrow Key
  {
     Keyboard.press(KEY_DOWN_ARROW);
     delay(interval);
     Keyboard.release(KEY_DOWN_ARROW);
  }
  
  else if(keypress == 258)  // Right Arrow Key
  {
     Keyboard.press(KEY_RIGHT_ARROW);
     delay(interval);
     Keyboard.release(KEY_RIGHT_ARROW);
  }
  
  else if(keypress == 259)  // Left Arrow Key
  {
     Keyboard.press(KEY_LEFT_ARROW);
     delay(interval);
     Keyboard.release(KEY_LEFT_ARROW);
  }
  
  
  else if(keypress == 260)  // Swipe Up
  {
     Keyboard.press(KEY_LEFT_CTRL);
     Keyboard.press(KEY_UP_ARROW);
     delay(interval);
     Keyboard.release(KEY_LEFT_CTRL);
     Keyboard.release(KEY_UP_ARROW);
  }
  
  else if(keypress == 261)  // Swipe Down
  {
     Keyboard.press(KEY_LEFT_CTRL);
     Keyboard.press(KEY_DOWN_ARROW);
     delay(interval);
     Keyboard.release(KEY_LEFT_CTRL);
     Keyboard.release(KEY_DOWN_ARROW);
  }
  
  else if(keypress == 262)  // Swipe Right 
  {
     Keyboard.press(KEY_LEFT_CTRL);
     Keyboard.press(KEY_RIGHT_ARROW);
     delay(interval);
     Keyboard.release(KEY_LEFT_CTRL);
     Keyboard.release(KEY_RIGHT_ARROW);
  }
  
  else if(keypress == 263)  // Swipe Left
  {
     Keyboard.press(KEY_LEFT_CTRL);
     Keyboard.press(KEY_LEFT_ARROW);
     delay(interval);
     Keyboard.release(KEY_LEFT_CTRL);
     Keyboard.release(KEY_LEFT_ARROW);
  }
  
  
  else
  {
   Mouse.move(mouseX, mouseY, 0);
   delay(5);
  }
 
  
  

    }

  }
  
}



