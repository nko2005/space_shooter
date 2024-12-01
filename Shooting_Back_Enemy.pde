class ShootingEnemy extends Zombie {
  float shootCooldown = 2.0; // Time between shots in seconds
  float shootTimer = 0;

  ShootingEnemy(float x, float y, float size, float speed) {
    super(x, y, size, speed);
  }

  void update(Player player) {
    super.updateZombie(player, zombies);
    shootTimer += 1.0 / frameRate;
    if (shootTimer >= shootCooldown) {
      shoot(player);
      shootTimer = 0;
    }
  }

  void shoot(Player player) {
    PVector direction = PVector.sub(player.position, position).normalize();
    // Add a new bullet to a list of enemy bullets
    enemyBullets.add(new Bullet(position.x, position.y, direction));
  }

  void display() {
    fill(255, 0, 0); // Red color to distinguish from regular zombies
    ellipse(position.x, position.y, size, size);
  }
}