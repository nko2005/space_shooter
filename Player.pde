

class Player {
  //health stuff
   float health;
  float maxHealth=100;  // Maximum health
  float healthRegenRate=5;  // Amount of health to regenerate per interval
  int regenCooldown=1000;  // Cooldown time between regenerations (in milliseconds)
  int lastRegenTime;  // Timestamp of the last regeneration
  float posX, posY;
  float angle;
  boolean moveUp, moveDown, moveLeft, moveRight;
  float speed;
  ArrayList<Bullet> bullets = new ArrayList<Bullet>();  // Store bullets
  float player_score = 0.0;
  float moveX, moveY;
  float lookX, lookY;
  float deadzone = 0.1;
  float size = 30;
  float maxhealth = 100;
  boolean isHit = false;
  long lastHitTime;
  long damageIndicatorDuration = 500;  // duration in milliseconds

  // Perks
  ArrayList<String> activePerks = new ArrayList<String>();
  boolean hasSpeedPowerup = false;
  boolean hasDamagePowerup = false;
  boolean hasDoublePowerup = false;
  boolean hasHealthPowerup = false;

  // Colors for each perk
  color damageColor = color(255, 0, 0);  // Red for Damage Boost
  color speedColor = color(0, 255, 0);  // Green for Speed Boost
  color doubleColor = color(160, 32, 240);  // Purple for Double Points

  Player(float x, float y, float hp) {
    posX = x;
    posY = y;
    health = hp;
    angle = 0;
    speed = 5;
  }

  boolean isDead() {

    return health<=0;
  }

  void updatePerks() {



    activePerks.clear();
    if (hasDamagePowerup) {
      activePerks.add("Damage Boost");
    }
    if (hasSpeedPowerup) {
      activePerks.add("Speed Boost");
    }
    if (hasDoublePowerup) {
      activePerks.add("Double Points");
    }
  }

  void updateHealth() {
    if (!isDead()) {

      if (health < maxHealth) {
        if (millis() - lastHitTime >= 3000) {
            if (millis() - lastRegenTime >= regenCooldown) {
            
          // Regenerate health based on the percentage of health the player has left
          float healthPercentage = health / maxHealth;

          // Regeneration is faster when health is low and slower when health is high
          float dynamicRegenRate = healthRegenRate * (1.0f - healthPercentage);


          // Apply the regeneration
          health += dynamicRegenRate;

          // Prevent health from exceeding max health
          if (health > maxHealth) {
            health = maxHealth;
            regenCooldown =1000;
          }
            regenCooldown-= regenCooldown*healthPercentage;
            lastRegenTime = millis();
        }
      }
    }
  }
  }

void updatePlayerAnalog() {
  if (isHit && millis() - lastHitTime > damageIndicatorDuration) {
    isHit = false;
  }
  updatePerks();
  updateHealth();

  float moveX = map(arduino_values[1] - 512, -512, 512, -1, 1);
  float moveY = map(arduino_values[2] - 512, -512, 512, 1, -1);
  float lookX = map(arduino_values[3] - 512, -512, 512, -1, 1);
  float lookY = map(arduino_values[4] - 512, -512, 512, 1, -1);

  if (abs(moveX) < deadzone) moveX = 0;
  if (abs(moveY) < deadzone) moveY = 0;

  posX += moveX * speed;
  posY += moveY * speed;

  if (abs(lookX) >= deadzone || abs(lookY) >= deadzone) {
    angle = atan2(lookY, lookX);
  }

  if (arduino_values[0] == 1) {
    shoot();
  }

  if (posY <= 0) posY = 0;
  else if (posY >= height) posY = height;

  if (posX <= 0) posX = 0;
  else if (posX >= width) posX = width;
}

void updatePlayerMouse() {
  angle = atan2(mouseY - posY, mouseX - posX);

  if (moveUp) posY -= (posY <= 0) ? 0 : speed;
  if (moveDown) posY += (posY >= height) ? 0 : speed;
  if (moveLeft) posX -= (posX <= 0) ? 0 : speed;
  if (moveRight) posX += (posX >= width) ? 0 : speed;
}

void takeDamage(float damage) {
  health -= damage;
  isHit = true;
  lastHitTime = millis();
}

void shoot() {
  Bullet b = new Bullet(posX, posY, angle);
  bullets.add(b);
  shootSound.play();
}

void drawPlayerBullets() {
  ArrayList<Bullet> bulletsToRemove = new ArrayList<Bullet>(); // List to track bullets to remove

  for (int i = bullets.size() - 1; i >= 0; i--) {
    Bullet b = bullets.get(i);

    b.updateBullet();
    if (b.isOffScreen()) {
      bulletsToRemove.add(b); // Mark bullet for removal
    } else {
      b.displayBullet();
    }
    if (!zombies.isEmpty()) {
      // Check for bullet collision with zombies
      for (int j = zombies.size() - 1; j >= 0; j--) {
        Zombie z = zombies.get(j);
        if (dist(b.posX, b.posY, z.posX, z.posY) < z.size / 2) {
          z.takeDamage(b.damage);
          bulletsToRemove.add(b); // Mark bullet for removal
          if (z.isDead()) {
            player_score += hasDoublePowerup ? 200 : 100;
            //zombies.remove(j); // Optional: Handle zombie removal elsewhere
            break;
          }
        }
      }
    }

    if (!blobs.isEmpty()) {
      // Check for bullet collision with blobs
      for (int j = blobs.size() - 1; j >= 0; j--) {
        Blob bl = blobs.get(j);
        if (dist(b.posX, b.posY, bl.posX, bl.posY) < bl.size / 2) {
          bl.takeDamage(b.damage, blobs);
          bulletsToRemove.add(b); // Mark bullet for removal
          if (bl.isDead()) {
            player_score += hasDoublePowerup ? 2000 : 1000;
            createParticles(bl.posX, bl.posY, color(0, 255, 0));
            blobs.remove(j);
            break;
          }
        }
      }
    }
  }

  // Remove bullets that are marked for removal
  for (Bullet b : bulletsToRemove) {
    bullets.remove(b);
  }
}

void displayPlayer() {
  if (health <= 0) {
    gameState = 2;
    return;
  }

  push();
  translate(posX, posY);
  rotate(angle);

  if (isHit) {
    strokeWeight(3);
    stroke(255, 0, 0);
    fill(0, 255, 0);
    float h = sqrt(3) / 2 * (size + 10);
    beginShape();
    rotate(100);
    vertex(-(size + 10) / 2, h / 2);
    vertex((size + 10) / 2, h / 2);
    vertex(0, -h / 2);
    endShape(CLOSE);
  } else {
    strokeWeight(1);
    stroke(0);
    fill(0, 255, 0);
    float h = sqrt(3) / 2 * size;
    beginShape();
    rotate(100);
    vertex(-size / 2, h / 2);
    vertex(size / 2, h / 2);
    vertex(0, -h / 2);
    endShape(CLOSE);
  }

  pop();
}

void resetPlayer() {
  moveUp = moveDown = moveLeft = moveRight = false;
  speed = 4;
  bullets.clear();
  player_score = 0;
  health = 100;
  posX = width / 2;
  posY = height / 2;
}

void displayPlayerHUD(Round round) {
  fill(0);
  textSize(24);
  textAlign(LEFT, TOP);
  text("Health: " + int(health), 10, 10);
  text("Score: " + player_score, 10, 40);
  text("Perks:", 10, 60);
  push();
  for (int i = 0; i < activePerks.size(); i++) {
    if (activePerks.get(i).equals("Damage Boost")) {
      fill(damageColor);
    } else if (activePerks.get(i).equals("Speed Boost")) {
      fill(speedColor);
    } else if (activePerks.get(i).equals("Double Points")) {
      fill(doubleColor);
    }
    text(activePerks.get(i), 70 + i * 150, 60);
  }
  pop();
  
  text("Round: "+ round.roundCount,10,80);
}
}
