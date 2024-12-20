//Serial Communication
import processing.serial.*;
import processing.sound.*;
import java.util.ArrayList;

SoundFile shootSound;
Serial serialPort;
String serialBuffer = "";
// expected values are five: button,joystickA_X, joystickA_Y, joystickB_X,joystickB_Y
int NUM_OF_VALUES_FROM_ARDUINO = 5; 

/* This array stores values from Arduino */
int arduino_values[] = new int[NUM_OF_VALUES_FROM_ARDUINO];
//grabs data from arduino
void getSerialData() {
  while (serialPort.available() > 0) {
    String in = serialPort.readStringUntil( 10 );  // 10 = '\n'  Linefeed in ASCII
    if (in != null) {
      //print("From Arduino: " + in);
      String[] serialInArray = split(trim(in), ",");
      if (serialInArray.length == NUM_OF_VALUES_FROM_ARDUINO) {
        for (int i=0; i<serialInArray.length; i++) {
          arduino_values[i] = int(serialInArray[i]);
        }
      }
    }
  }
}


// Initial positions
float x, y;
//set the game state to 0 (the start screen)
//gameState = 0 (start screen)
//gameState = 1 (game screen)
//gameState = 2 (game over)
int gameState = 0;
//create player 
ArrayList<Zombie> zombies = new ArrayList<Zombie>();
Player player_1 = new Player(width/2, height/2, 100.0);
//create list to store powerups
ArrayList<Powerup> powerups = new ArrayList<Powerup>();
//function to create powerup
//void createPowerups(){
//  //speed powerup (green)
//   powerups.add(new Powerup(width/2, height/2, 3, color(0, 255, 0)));
//  //damage powerup (red)
//  powerups.add(new Powerup(width/2+100, height/2+100, 2, color(255, 0, 0)));
//  //nuke powerup  (orange)
//  powerups.add(new Powerup(width/2+200,height/2+200, 0,color(255, 165, 0)));
//  // double points powerup (purple)
//  powerups.add(new Powerup(width/2-200,height/2-200, 0,color(160, 32, 240)));
  
//}
//void updateAndDrawPowerups(Player player) {
//  if(!powerups.isEmpty()){
//  for (int i = powerups.size() - 1; i >= 0; i--) {
//    Powerup p = powerups.get(i);
//    p.update();
//    if (p.isConsumed()||!p.isActive()) {
//      powerups.remove(i);
//    } else {
//      p.drawPowerup();
//      p.update();
//      p.checkCollision(player);
        
//      }
//    }
//  }
//  }



//zombie sprite data 
 PImage zombieSpriteSheet;
//list to store zombies 

Round round_master = new Round(5,1,player_1);
//void createZombies(ArrayList<Zombie> zombies,int numEnemies,float waveSpeed,float waveHealth ){
//  zombieSpriteSheet = loadImage("Zombie_SpriteSheet.png");

//  for(int i=0; i<numEnemies;i++){
//      float cointoss = random(1,2);
//      if(cointoss==1){
//      zombies.add(new Zombie(random(width), 0, waveSpeed,zombieSpriteSheet,waveHealth));
//      }
//      else{
//        zombies.add(new Zombie(0, random(height), waveSpeed,zombieSpriteSheet,waveHealth));
        
//      }

    
    
//  }
  

//}
//update zombies to move to player

//list to store particles 
ArrayList<Particle> particles = new ArrayList<Particle>();
/// function that creates particles and add them to the list 
void createParticles(float x, float y,color clr) {
  int numParticles = 20; // Number of particles per explosion
  for (int i = 0; i < numParticles; i++) {

    particles.add(new Particle(x, y,clr));
  }
}
//function that draws and animates the list of particels 
void updateAndDrawParticles() {
  if(!particles.isEmpty()){
  for (int i = particles.size() - 1; i >= 0; i--) {
    Particle p = particles.get(i);
    p.updateParticle();
    p.displayParticle();
    if (p.isDead()) {
      particles.remove(i);
    }
  }
  }
}
//list to store asteroids 
//ArrayList<Asteroid> asteroids = new ArrayList<Asteroid>();
//function to create asteriods and add them to the list 
//void createAsteroids(ArrayList<Asteroid> asteroids) {
//  int numAsteriods = 20;
//  for (int i = 0; i < numAsteriods; i++) {
//    float random_pull = random(1, 2);
//    if (random_pull==1) {
//      asteroids.add(new Asteroid(random(0, width), 0.0, 10.0, color(random(255), random(255), random(255)), random(-3, 3), random(-3, 3), 50.0));
//    } else {

//      asteroids.add(new Asteroid(0.0, random(0, height), 10.0, color(random(255), random(255), random(255)), random(-3, 3), random(-3, 3), 50.0));
//    }
//  }
//}
////draw and move the asteriods on the screen 
//void updateAndDrawAsteroids() {
// if(!asteroids.isEmpty()){
//  for (int i = asteroids.size() - 1; i >= 0; i--) {
//    Asteroid a = asteroids.get(i);
//    a.updateAsteroid();
//    a.displayAsteroid();
//    if (a.isOffScreen()) {
//      asteroids.remove(i);
//    }
//   }
//  }
//}

ArrayList<Blob> blobs = new ArrayList<Blob>();

//void createBlobs(){
//Blob initialBlob = new Blob(100, 100, 40,500,1.0); 
//blobs.add(initialBlob);

  
  
//}

//void updateBlobs(Player player) {
//    for (Blob b : blobs) {
//        b.updateBlob(player, blobs);
//    }
//}

//void drawBlobs() {
//    for (Blob b : blobs) {
//        b.drawBlob();
//    }
//}
PImage background;
//void settings() {
 
//  //size(displayWidth, displayHeight);
//}


PFont customFont;
ArrayList<PImage> health_status = new ArrayList<PImage>();

void setup() {
  background = loadImage("final_game_background.png");
  size(1440, 810);  // Adjust size as necessary
   customFont = createFont("operius/operius-regular.ttf", 48); // Load the TTF font from the data folder
  textFont(customFont); // Set the font for text drawing
   if (background != null) {
   background.resize(width, height);
  }
 
  frameRate(120);
  
 

  //printArray(Serial.list());
  // put the name of the serial port your Arduino is connected
  // to in the line below - this should be the same as you're
  // using in the "Port" menu in the Arduino IDE
  serialPort = new Serial(this, "COM3", 9600);
  shootSound = new SoundFile(this, "pew.mp3"); 




  x = width / 2;
  y = height / 2;
  player_1.posX=x;
   player_1.posY=y;
  
  //player_1.photo = loadImage("spaceshipplaceholder.png"); // Load image only once

 
 
  zombieSpriteSheet = loadImage("Zombie_SpriteSheet.png");
  PImage icon;
  for(int i=0; i<7;i++){
    String text = "skull00" + (i + 1) + ".png";
   
    icon = loadImage(text);
    icon.resize(64,64);
    health_status.add(icon);
    
  }
  
  

  
  //createAsteroids(asteroids);
  //createZombies(zombies);
  //createPowerups();

}

void draw() {
  if (gameState == 0) {
    startScreen();
  } else if (gameState == 1) {
//background(255);

 background(background);
    //get Analog sticks data
    getSerialData();
    //print(arduino_values);

    //setup analogstick controls
    player_1.updatePlayerAnalog();

    // Move player based on key presses
    //player_1.updatePlayerMouse();
    
    // Draw player
    player_1.displayPlayer();
    
    // Update and draw bullets and check collisions
    player_1.drawPlayerBullets();
    
    //place powerups 
    //updateAndDrawPowerups(player_1);


    //draw and make the zombies follow the player
   
    round_master.checkRound(zombieSpriteSheet);
    round_master.updateZombies();
    push();
    round_master.updateBlobs();
    pop();
    //create particle effect whenever zombie is kileld
    push();
    updateAndDrawParticles();
    pop();
    //create asteriods
    round_master.checkPlayerStatus();
    round_master.updatePowerups();
    
    
    //push();
    ////updateAndDrawAsteroids();
    //pop();
    //display the player HUD
    
    //push();
    //updateBlobs(player_1);
    //drawBlobs();
    //pop();
    push();
    player_1.displayPlayerHUD(round_master);
    pop();
    
    
    
  } else if (gameState == 2) {
    gameOverScreen();
  }
}






//functions for mouse and keyboard controls 
void keyPressed() {
  if (gameState == 0) {
    // Start game only from start screen
    if (key == 'e' || key == 'E') gameState = 1;
  } else if (gameState == 1) {
    // Set movement flags when keys are pressed
    if (key == 'w' || key == 'W') player_1.moveUp = true;
    if (key == 's' || key == 'S') player_1.moveDown = true;
    if (key == 'a' || key == 'A') player_1.moveLeft = true;
    if (key == 'd' || key == 'D') player_1.moveRight = true;

    // Shoot bullet
    if (key == ' ') {
      player_1.shoot();
    }

    // End game (go to game over screen)
    if (key == 'q' || key == 'Q') gameState = 2;
  } else if (gameState == 2) {
    // Reset game (go back to start screen)
    if (key == 'r' || key == 'R') {
      resetGame();
      gameState = 0;
    }
  }
}

void keyReleased() {
  if (gameState == 1) {
    // Unset movement flags when keys are released
    if (key == 'w' || key == 'W') player_1.moveUp = false;
    if (key == 's' || key == 'S') player_1.moveDown = false;
    if (key == 'a' || key == 'A') player_1.moveLeft = false;
    if (key == 'd' || key == 'D') player_1.moveRight = false;
  }
}

void startScreen() {
  background(0);
  fill(255);
  textSize(64);
  textAlign(CENTER, CENTER);
  text("Press E to Start", width / 2, height / 2);
}

void gameOverScreen() {
  background(0);
  fill(255);
  textSize(64);
  textAlign(CENTER, CENTER);
  text("Game Over", width / 2, height / 2);
  textSize(32);
  text("Press R to Restart", width / 2, height / 2 + 50);
}

void resetGame() {
  x = width / 2;
  y = height / 2;
  //reset player information
  player_1.resetPlayer();
  //resetZombies();
  
  
}


//void resetZombies(){
  
//   for (int i = zombies.size() - 1; i >= 0; i--) {
//        zombies.remove(i);
//   }
//  zombies.add(new Zombie(200, 200, 20,zombieSpriteSheet,100));
//  zombies.add(new Zombie(400, 300, 20,zombieSpriteSheet,100));
//  zombies.add(new Zombie(200, 200, 20,zombieSpriteSheet,100));
//  zombies.add(new Zombie(400, 300, 20,zombieSpriteSheet,100));
//  zombies.add(new Zombie(200, 200, 20,zombieSpriteSheet,100));
//  zombies.add(new Zombie(400, 300, 20,zombieSpriteSheet,100));
//  zombies.add(new Zombie(200, 200, 20,zombieSpriteSheet,100));
//  zombies.add(new Zombie(400, 300, 20,zombieSpriteSheet,100));
//  zombies.add(new Zombie(200, 200, 20,zombieSpriteSheet,10));
//  zombies.add(new Zombie(400, 300, 20,zombieSpriteSheet));
   
//}
