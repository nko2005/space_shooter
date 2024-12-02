class Player {
  // ... existing player variables ...
  
  boolean canUseAbility = true;
  int abilityCooldown = 5000; // 5 seconds cooldown
  int lastAbilityUseTime = 0;
  
  // ... rest of the Player class ...
}

// method to use the ability 
class Player {
  // ... existing methods ...
  
  void useAbility() {
    if (canUseAbility && millis() - lastAbilityUseTime > abilityCooldown) {
      // Perform ability action
      killNearbyZombies();
      
      // Set cooldown
      canUseAbility = false;
      lastAbilityUseTime = millis();
    }
  }
  
  void killNearbyZombies() {
    float killRadius = 150;
    for (int i = zombies.size() - 1; i >= 0; i--) {
      Zombie z = zombies.get(i);
      if (dist(x, y, z.x, z.y) < killRadius) {
        z.health = 0;
        createParticles(z.x, z.y, color(255, 0, 0));
      }
    }
  }
  
  void updateAbilityCooldown() {
    if (!canUseAbility && millis() - lastAbilityUseTime > abilityCooldown) {
      canUseAbility = true;
    }
  }
  
  // ... rest of the Player class ...
}

//mehtod to show the ability cooldown
class Player {
  // ... existing methods ...
  
  void displayPlayer() {
    // ... existing display code ...
    
    // Display ability cooldown
    fill(0);
    textAlign(CENTER, CENTER);
    textSize(12);
    if (canUseAbility) {
      text("Ability Ready", x, y - 30);
    } else {
      int remainingCooldown = (abilityCooldown - (millis() - lastAbilityUseTime)) / 1000;
      text("Cooldown: " + remainingCooldown + "s", x, y - 30);
    }
  }
  
  // ... rest of the Player class ...
}

// modify *key pressed funcion to trigger ability
void keyPressed() {
  // ... existing key handling ...
  
  if (gameState == 1) {
    // ... existing game controls ...
    
    // Use ability when 'E' is pressed
    if (key == 'e' || key == 'E') {
      player_1.useAbility();
    }
  }
  
  // ... rest of the function ...
}


// modify the draw function 
void draw() {
  if (gameState == 1) {
    // ... existing game logic ...
    
    player_1.updateAbilityCooldown();
    player_1.displayPlayer();
    
    // ... rest of the game logic ...
  }
  
  // ... rest of the function ...
}
