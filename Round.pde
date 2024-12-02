//class Round {

//  int numEnemies;
//  int current_round = 1;
//  int numSpecialEnemies;

//  boolean roundOver = false;
//  int roundCount = 1;
//  float roundHealth = 100;
//  float roundSpeed = 2;
//  boolean enemiesCreated = false;

//  // Variables for zombie spawning
//  int spawnInterval = 1000; // Spawn a zombie every 1 second
//  int lastSpawnTime = 0;
//  int zombiesSpawned = 0;

//  Player player;

//  Round(int numEnemies, int numSpecialEnemies, Player player) {
//    this.numEnemies = numEnemies;
//    this.numSpecialEnemies = numSpecialEnemies;
//    this.player = player;
//  }

//  void checkRound(PImage zombieSpriteSheet) {
//    if (zombies.isEmpty() && zombiesSpawned >= numEnemies) {
//      roundCount++;
//      numEnemies += 10;
//      roundSpeed += 0.01;
//      roundHealth += 20;
//      roundOver = true;
//      enemiesCreated = false;
//    }
    
//    if (!enemiesCreated) {
//      createZombies(zombieSpriteSheet);
//    }
//  }

//  void createZombies(PImage zombieSpriteSheet) {
//    if (zombiesSpawned < numEnemies) {
//      if (millis() - lastSpawnTime > spawnInterval) {
//        float spawn_location = random(1, 5);
//        //spawn zombies top of the screen 
//        if (spawn_location==1) {
          
//          zombies.add(new Zombie(random(width), -10, roundSpeed, zombieSpriteSheet, roundHealth));
//        }
//        //spawn zombies to the left of the screen 
//        else if(spawn_location==2) {
//          zombies.add(new Zombie(-10, random(height), roundSpeed, zombieSpriteSheet, roundHealth));
//        }
//        //spawn zombies to the right of the screen 
//        else if(spawn_location ==3){
//                    zombies.add(new Zombie(width+10, random(height), roundSpeed, zombieSpriteSheet, roundHealth));

//        }
//        //spawn at the bottom 
//        else{
//           zombies.add(new Zombie(random(width), height+10, roundSpeed, zombieSpriteSheet, roundHealth));

          
//        }
//        zombiesSpawned++;
//        lastSpawnTime = millis();
//      }
//    } else {
//      enemiesCreated = true;
//    }
//  }

//  void updateZombies() {
//    if (!zombies.isEmpty()) {
//      for (int j = zombies.size() - 1; j >= 0; j--) {
//        Zombie z = zombies.get(j);
//        if (!z.isDead()) {
//          z.updateZombie(player, zombies);
//          z.drawZombie();
      
//      }
//    }
//  }
//  }
      
//  boolean isRoundOver() {
//    return roundOver;
//  }
//}

class Round {

  int numEnemies;
  int current_round = 1;
  int numSpecialEnemies;

  boolean roundOver = false;
  int roundCount = 1;
  float roundHealth = 100.0;
  float roundSpeed = 2.0;
  boolean enemiesCreated = false;

  // Variables for zombie spawning
  int spawnInterval = 500; // Spawn a zombie every 1 second
  int lastSpawnTime = 0;
  int zombiesSpawned = 0;
  int lastRoundEnd = 1000;
  
  // Variables for round delay
  int delayDuration = 5000; // 1 second delay
  int roundEndTime = 0;
  boolean delayStarted = false;

  Player player;
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
      }
   if (millis() - roundEndTime >= delayDuration) {
      roundCount++;
      numEnemies += 5;
      //roundSpeed += 0.2;
      roundHealth += 10;
      roundOver = true;
      enemiesCreated = false;
      zombiesSpawned =0;
      if(spawnInterval>200){
      spawnInterval-=100;
      }
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
     // ArrayList<Zombie> zombiesToRemove = new ArrayList<Zombie>();
      
      // Update zombies, but don't remove them yet
      for (int j = zombies.size() - 1; j >= 0; j--) {
        
        Zombie z = zombies.get(j);
        print(z.health);
        if (!z.isDead()) {
          z.updateZombie(player, zombies);
          z.drawZombie();
       
         // zombiesToRemove.add(z); // Mark zombies to be removed
        }
        else{
          
              createParticles(z.posX, z.posY, color(255, 0, 0));
              zombies.remove(j);
              break;
            }
      }

      //// Remove dead zombies after the iteration
      //for (int j = zombiesToRemove.size() - 1; j >= 0; j--) {
      //    Zombie z = zombiesToRemove.get(j);
      //     createParticles(z.posX, z.posY, color(255, 0, 0));
      //     zombies.remove(j);
        
      //}
     
    }
  }

  boolean isRoundOver() {
    return roundOver;
  }
  void resetRoundSystem(){
    
    roundCount =1;
    numEnemies = 10;
    spawnInterval = 500;
    zombies.clear();
    
    
    
  }
}
