class Player {

  float health;
  float posX, posY;
  float angle;
  boolean moveUp, moveDown, moveLeft, moveRight;
  float speed;
  //PImage photo; // To store the player's image
  ArrayList<Bullet> bullets = new ArrayList<Bullet>(); // Store bullets
  float player_score=0.0;
  float moveX, moveY;
  float lookX, lookY;
  float deadzone = 0.1;
  float size =30;

  boolean isHit = false;
  long lastHitTime;
  long damageIndicatorDuration = 500; // duration in milliseconds
  boolean hasSpeedPowerup=false;
  boolean hasDamagePowerup = false;
  boolean hasDoublePowerup = false;
  // Constructor to initialize position and health
  Player(float x, float y, float hp) {
    posX = x;
    posY = y;
    health = hp;
    angle = 0;
    speed =5;
  }

  // Update player position and angle

  void updatePlayerAnalog() {
    // Map the analog stick values to a useful range with a dead zone
    if (isHit && millis() - lastHitTime > damageIndicatorDuration) {
      isHit = false;
    }

    float moveX = map(arduino_values[1] - 512, -512, 512, -1, 1);
    float moveY = map(arduino_values[2] - 512, -512, 512, 1, -1);
    float lookX = map(arduino_values[3] - 512, -512, 512, -1, 1);
    float lookY = map(arduino_values[4] - 512, -512, 512, 1, -1);

    // Apply dead zone to movement inputs
    if (abs(moveX) < deadzone) moveX = 0;
    if (abs(moveY) < deadzone) moveY = 0;

    // Update player position
    posX += moveX * speed;
    posY += moveY * speed;

    // Update player look direction only if there's significant joystick input
    if (abs(lookX) >= deadzone || abs(lookY) >= deadzone) {
      angle = atan2(lookY, lookX);
    }

    // Check if the fire button is pressed
    if (arduino_values[0] == 1) {
      shoot();
    }

    // Ensure the player stays within the screen boundaries
    if (posY <= 0) {
      posY = 0;
    } else if (posY >= height) {
      posY = height;
    }

    if (posX <= 0) {
      posX = 0;
    } else if (posX >= width) {
      posX = width;
    }
  }

  void updatePlayerMouse() {

    // Update the angle to look towards the mouse cursor
    angle = atan2(mouseY - posY, mouseX - posX);

    // Move the player based on the movement flags
    if (moveUp) {
      if (posY<=0) {
        posY -= 0;
      } else {
        posY -= speed;
      }
    }

    if (moveDown) {
      if (posY>=height) {

        posY += 0;
      } else {
        posY += speed;
      }
    }
    if (moveLeft) {
      if (posX<=0) {
        posX -= 0;
      } else {
        posX -=speed;
      }
    }

    if (moveRight) {
      if (posX>=width) {
        posX += 0;
      } else {
        posX +=speed;
      }
    }
  }

  void takeDamage(float damage) {

    health-=damage;
    isHit = true;
    lastHitTime = millis();
  }
  // Create a new bullet in the direction of the mouse
  void shoot() {

    Bullet b = new Bullet(posX, posY, angle);
    bullets.add(b); // Add to the list of bullets

    shootSound.play(); // Play the sound
  }
  // Update and draw bullets
  void drawPlayerBullets() {
    if(!bullets.isEmpty()){
    for (int i = bullets.size() - 1; i >= 0; i--) {
      Bullet b = bullets.get(i);
      b.updateBullet();
      if (b.isOffScreen()) {
        bullets.remove(i);
      }
      else{
      b.displayBullet();
      }
      // Check for bullet collision with zombies
      for (int j = zombies.size() - 1; j >= 0; j--) {
        Zombie z = zombies.get(j);
        if (dist(b.posX, b.posY, z.posX, z.posY) < z.size / 2) {
          z.takeDamage(b.damage);
          // Remove the bullet only if it exists
           if (i >= 0 && i < bullets.size()) {
                        bullets.remove(i);
                    }
          //createParticles(z.posX, z.posY);
          if (z.isDead()) {
            if (hasDoublePowerup) {
              player_score+=  200;
            } else {
              player_score+=100;
            }
            push();
            createParticles(z.posX, z.posY);
            pop();
            zombies.remove(j);
            


            break;
          }
        }
      }
    }
  }
  }

  
  void displayPlayer() {
    if (health <= 0) {
      gameState = 2;
      return; // Stop drawing the player if health is zero or less
    }

    push(); // Save the current transformation matrix

    translate(posX, posY); // Move the coordinate system to the player's position
    rotate(angle); // Rotate the coordinate system by the player's angle

    // Change the player's appearance based on whether it is hit
    if (isHit) {
      strokeWeight(3);
      stroke(255, 0, 0); // Red stroke color when hit
      fill(0, 255, 0); // Green fill color
      float h = sqrt(3) / 2 * (size + 10); // Height of an equilateral triangle
      beginShape();
      rotate(100);
      vertex(-(size + 10) / 2, h / 2);
      vertex((size + 10) / 2, h / 2);
      vertex(0, -h / 2);
      endShape(CLOSE);
    } else {
      strokeWeight(1);
      stroke(0); // Default stroke color
      fill(0, 255, 0); // Green fill color
      float h = sqrt(3) / 2 * size; // Height of an equilateral triangle
      beginShape();
      rotate(100);
      vertex(-size / 2, h / 2);
      vertex(size / 2, h / 2);
      vertex(0, -h / 2);
      endShape(CLOSE);
    }

    pop(); // Restore the original transformation matrix
  }


  void resetPlayer() {
    moveUp = player_1.moveDown = moveLeft = moveRight = false;
    speed =4;
    bullets.clear();
    player_score =0;
    health=100;
    posX = width/2;
    posY= height/2;
  }

  void displayPlayerHUD() {
    fill(0);
    textSize(24);
    textAlign(LEFT, TOP);
    text("Health: " + health, 10, 10);
    text("Score: " + player_score, 10, 40);
  }
}
