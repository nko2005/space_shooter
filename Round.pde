

class Round {

  int numEnemies;
  //int current_round = 1;
  int numSpecialEnemies;

  boolean roundOver = false;
  int roundCount = 1;
  float roundHealth = 100.0;
  float roundSpeed = 3.0;
  float maxRoundSpeed = 4.2;
  boolean enemiesCreated = false;

  // Variables for zombie spawning
  int spawnInterval = 500; // Spawn a zombie every 1 second
  int lastSpawnTime = 0;
  int zombiesSpawned = 0;
  int lastRoundEnd = 1000;
  int specialSpawned =0;
  boolean isSpecialSpawned =false;
  // Variables for round delay
  int delayDuration = 5000; // 1 second delay
  int roundEndTime = 0;
  boolean delayStarted = false;
  int lastPowerUpTime;
  Player player;
  int scoreThreshold=2000;
  // ArrayList<Zombie> zombies = new ArrayList<>(); // Initialize the zombies list

  Round(int numEnemies, int numSpecialEnemies, Player player) {
    this.numEnemies = numEnemies;
    this.numSpecialEnemies = numSpecialEnemies;
    this.player = player;
  }

  void checkRound(PImage zombieSpriteSheet) {
    // Round over if all zombies are spawned and dead
    if (zombies.isEmpty() && zombiesSpawned >= numEnemies) {
      if (!delayStarted) {
        roundEndTime = millis();
        delayStarted = true;
        roundOver = true;
        //print("Round Over");
      }
      if(roundCount%3==0){
        //isSpecialSpawned =true;
        createBlobs();
        
        
      }
      
      
      

      if (roundOver&& millis() - roundEndTime >= delayDuration) {
        roundCount++;
        //print("Starting round " + roundCount);

        numEnemies += 5;
        if(roundCount%3==0){
        numSpecialEnemies+=1;
        }
        roundSpeed += 0.2;
        if(roundSpeed>maxRoundSpeed){
          roundSpeed = maxRoundSpeed;
        }
        roundHealth += 50;
        roundOver = false;
        enemiesCreated = false;
        zombiesSpawned =0;
        specialSpawned =0;
        if (spawnInterval>200) {
          spawnInterval-=100;
        }
        delayStarted=false;
      }
    }

    // Only create zombies if they haven't been created already
    if (!enemiesCreated) {
      createZombies(zombieSpriteSheet);
    }
  }

  void createZombies(PImage zombieSpriteSheet) {
    if (zombiesSpawned < numEnemies) {
      if (millis() - lastSpawnTime > spawnInterval) {
        int spawnLocation = int(random(1, 5));  // Ensure spawnLocation is an integer
        if (spawnLocation == 1) {
          zombies.add(new Zombie(random(width), -10, roundSpeed, zombieSpriteSheet, roundHealth));
        } else if (spawnLocation == 2) {
          zombies.add(new Zombie(-10, random(height), roundSpeed, zombieSpriteSheet, roundHealth));
        } else if (spawnLocation == 3) {
          zombies.add(new Zombie(width + 10, random(height), roundSpeed, zombieSpriteSheet, roundHealth));
        } else {
          zombies.add(new Zombie(random(width), height + 10, roundSpeed, zombieSpriteSheet, roundHealth));
        }
        zombiesSpawned++;
        lastSpawnTime = millis();
      }
    } else {
      enemiesCreated = true;
    }
  }

  void updateZombies() {
    if (!zombies.isEmpty()) {
      ArrayList<Zombie> zombiesToRemove = new ArrayList<Zombie>();

      // Update zombies, but don't remove them yet
      for (int j = zombies.size() - 1; j >= 0; j--) {

        Zombie z = zombies.get(j);
        //print(z.health);
        if (!z.isDead()) {
          z.updateZombie(player, zombies);
          z.drawZombie();

          // zombiesToRemove.add(z); // Mark zombies to be removed
        } else {
          zombiesToRemove.add(z);
          createParticles(z.posX, z.posY, color(255, 0, 0));
          zombies.remove(j);
          break;
        }
      }

      // Remove dead zombies after the iteration
      //for (int j = zombiesToRemove.size() - 1; j >= 0; j--) {
      //    Zombie z = zombiesToRemove.get(j);
      //     createParticles(z.posX, z.posY, color(255, 0, 0));
      //     zombiesToRemove.remove(j);
      //     break;

      //}
    }
  }

  void createBlobs() {

    
      if (specialSpawned<numSpecialEnemies) {
        if (millis() - lastSpawnTime > spawnInterval) {
          int spawnLocation = int(random(1, 5));  // Ensure spawnLocation is an integer
          if (spawnLocation == 1) {
            blobs.add(new Blob(random(width), -10, 40, 500, 4.1,25));
          } else if (spawnLocation == 2) {
            blobs.add(new Blob(-10, random(height), 40, 500, 4.1,25));
          } else if (spawnLocation == 3) {
            blobs.add(new Blob(width + 10, random(height), 40, 500, 4.1,25));
          } else {
            blobs.add(new Blob(random(width), height + 10, 40, 500, 4.1,25));
          }
          specialSpawned++;
          lastSpawnTime = millis();
        }
      }
    
  }
  
  void updateBlobs() {
    for (Blob b : blobs) {
        b.updateBlob(player, blobs);
        b.drawBlob();
    }
}

  void checkPlayerStatus() {

    if (player.player_score>=scoreThreshold) {
      //print("powerup spawned");
      spawnPowerUp();
      scoreThreshold += 1000; // Increase threshold for the next power-up
    }
    if (player.health < 50 && millis() - lastPowerUpTime > 10000) { // Spawn health power-up if health is low
      spawnPowerUp();
      lastPowerUpTime = millis();
    }
  }

  void spawnPowerUp() {
    float randomPull = random(1, 5);
    float x = random(width);  // Random x position within the screen width
    float y = random(height); // Random y position within the screen height

    if (randomPull < 2) {
      // Speed powerup (green)
      powerups.add(new Powerup(x, y, 3, color(0, 255, 0), 1));
    } else if (randomPull < 3) {
      // Damage powerup (red)
      powerups.add(new Powerup(x, y, 2, color(255, 0, 0), 2));
    } else if (randomPull < 4) {
      // Nuke powerup (orange)
      powerups.add(new Powerup(x, y, 0, color(255, 165, 0), 4));
    } else {
      // Double points powerup (purple)
      powerups.add(new Powerup(x, y, 0, color(160, 32, 240), 3));
    }
  }

  void updatePowerups() {
    if (!powerups.isEmpty()) {
      for (int i = powerups.size() - 1; i >= 0; i--) {
        Powerup p = powerups.get(i);
        p.update();
        //print("actual spawned");
        if (p.isConsumed()||!p.isActive()) {
          powerups.remove(i);
        } else {
          p.drawPowerup();
          p.update();
          p.checkCollision(player);
        }
      }
    }
  }

  boolean isRoundOver() {
    return roundOver;
  }
  void resetRoundSystem() {

    roundCount =1;
    numEnemies = 10;
    spawnInterval = 500;
    zombies.clear();
  }
}
