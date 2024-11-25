//Serial Communication
import processing.serial.*;
import processing.sound.*;

SoundFile shootSound;
Serial serialPort;
String serialBuffer = "";
int NUM_OF_VALUES_FROM_ARDUINO = 5;  /* CHANGE THIS ACCORDING TO YOUR PROJECT */

/* This array stores values from Arduino */
int arduino_values[] = new int[NUM_OF_VALUES_FROM_ARDUINO];

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

int gameState = 0;
//ArrayList<Bullet> bullets = new ArrayList<Bullet>();
Player player_1 = new Player(width/2, height/2, 100.0);
ArrayList<Powerup> powerups = new ArrayList<Powerup>();

void createPowerups(){
  //speed powerup
   powerups.add(new Powerup(random(0, width), random(0, height), 0.5, color(0, 255, 0)));
  //damage powerup
  powerups.add(new Powerup(random(0, width), random(0, height), 0.5, color(255, 0, 0)));
  
}

//void updateAndDrawPowerups(){
  
//   for (int i = powerups.size() - 1; i >= 0; i--) {
     
//     Powerup p = powerups.get(i);
//     if(p.isConsumed()){
       
       
       
//     }
     
       
    
     
     
     
//   }
  
//}



ArrayList<Zombie> zombies = new ArrayList<Zombie>();


void updateZombies( ArrayList<Zombie> zombies, Player player) {

  for (int j = zombies.size() - 1; j >= 0; j--) {
    Zombie z = zombies.get(j);
    z.updateZombie(player, zombies);
    z.drawZombie();
  }
}

ArrayList<Particle> particles = new ArrayList<Particle>();

void createParticles(float x, float y) {
  int numParticles = 20; // Number of particles per explosion
  for (int i = 0; i < numParticles; i++) {

    particles.add(new Particle(x, y));
  }
}

void updateAndDrawParticles() {
  for (int i = particles.size() - 1; i >= 0; i--) {
    Particle p = particles.get(i);
    p.updateParticle();
    p.displayParticle();
    if (p.isDead()) {
      particles.remove(i);
    }
  }
}

ArrayList<Asteroid> asteroids = new ArrayList<Asteroid>();

void createAsteroids(ArrayList<Asteroid> asteroids) {
  int numAsteriods = 20;
  for (int i = 0; i < numAsteriods; i++) {
    float random_pull = random(1, 2);
    if (random_pull==1) {
      asteroids.add(new Asteroid(random(0, width), 0.0, 10.0, color(random(255), random(255), random(255)), random(-3, 3), random(-3, 3), 50.0));
    } else {

      asteroids.add(new Asteroid(0.0, random(0, height), 10.0, color(random(255), random(255), random(255)), random(-3, 3), random(-3, 3), 50.0));
    }
  }
}

void updateAndDrawAsteriods() {
  for (int i = asteroids.size() - 1; i >= 0; i--) {
    Asteroid a = asteroids.get(i);
    a.updateAsteroid();
    a.displayAsteroid();
    if (a.isOffScreen()) {
      asteroids.remove(i);
    }
  }
}



void setup() {
  size(800, 800);  // Adjust size as necessary
  background(255);
  frameRate(120);


  //printArray(Serial.list());
  // put the name of the serial port your Arduino is connected
  // to in the line below - this should be the same as you're
  // using in the "Port" menu in the Arduino IDE
  serialPort = new Serial(this, "COM3", 9600);
  shootSound = new SoundFile(this, "pew.mp3"); 




  x = width / 2;
  y = height / 2;
  //player_1.photo = loadImage("spaceshipplaceholder.png"); // Load image only once

  zombies.add(new Zombie(200, 200, 20));
  zombies.add(new Zombie(400, 300, 20));
  zombies.add(new Zombie(200, 200, 20));
  zombies.add(new Zombie(400, 300, 20));
  zombies.add(new Zombie(200, 200, 20));
  zombies.add(new Zombie(400, 300, 20));
  zombies.add(new Zombie(200, 200, 20));
  zombies.add(new Zombie(400, 300, 20));
  zombies.add(new Zombie(200, 200, 20));
  zombies.add(new Zombie(400, 300, 20));

 


  createAsteroids(asteroids);
}

void draw() {
  if (gameState == 0) {
    startScreen();
  } else if (gameState == 1) {
    background(255);
    //get Analogsticksdata
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


    // remove bullets off screen
    player_1.cleanPlayerBullets();






    //draw and make the zombies follow the player
    updateZombies(zombies, player_1);
    //create particle effect whenever zombie is kileld
    push();
    updateAndDrawParticles();
    pop();
    //create asteriods
    push();
    updateAndDrawAsteriods();
    pop();
    //display the player HUD
    push();
    player_1.displayPlayerHUD();
    pop();
  } else if (gameState == 2) {
    gameOverScreen();
  }
}







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
  resetZombies();
  
  
}


void resetZombies(){
  
   for (int i = zombies.size() - 1; i >= 0; i--) {
        zombies.remove(i);
   }
  zombies.add(new Zombie(200, 200, 20));
  zombies.add(new Zombie(400, 300, 20));
  zombies.add(new Zombie(200, 200, 20));
  zombies.add(new Zombie(400, 300, 20));
  zombies.add(new Zombie(200, 200, 20));
  zombies.add(new Zombie(400, 300, 20));
  zombies.add(new Zombie(200, 200, 20));
  zombies.add(new Zombie(400, 300, 20));
  zombies.add(new Zombie(200, 200, 20));
  zombies.add(new Zombie(400, 300, 20));
   
}
