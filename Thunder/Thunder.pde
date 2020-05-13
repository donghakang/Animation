
/*
This Part of the method is only for sound of the Thunder.

Using Processing's MINIM to use mp3 files
*/

// Initializing thunder sound
void thunder_init() {
  minim    = new Minim(this);
  thunder[0] = minim.loadFile("./data/1.mp3");
  thunder[1] = minim.loadFile("./data/2.mp3");
  thunder[2] = minim.loadFile("./data/3.mp3");
}

// Play thunder sound
void thunder_play() {
  delay(10);
  int number = int(random(3));
  
  if(thunder[number].isPlaying()==false) {
      thunder[number].play(); // fort
  } else {
    thunder[number].rewind();
    thunder[number].play();
  }
  thunder[number].rewind();
  thunder[number].play();
}
