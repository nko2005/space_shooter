class Blob {
    float posX, posY;
    float angle;
    float health = 500;
    float maxHealth = 500;
    float size = 10;
    float speed;
    float spacing_distance = 20;
    float attackRange = 10; // Range within which the blob can attack
    float attackDamage = 25; // Damage per attack
    int attackCooldown = 60; // Frames between attacks
    int attackTimer = 0;
    boolean isDead = false;
    float points = 1000;
    int divideAmount;
    int maxDivide=4;

    Blob(float posX, float posY, float size,float health,float speed) {
        this.posX = posX;
        this.posY = posY;
        this.size = size;
        this.health = health;
        this.speed = speed;
    }

    boolean isDead() {
        return isDead;
    }

    void takeDamage(float damage, ArrayList<Blob> blobs) {
        health -= damage;
        if (health <= 0) {
            isDead = true;
        } else if (health <= (maxHealth * 3 / 4) && divideAmount == 0) {
            divide(blobs);
        } else if (health <= (maxHealth * 2 / 4) && divideAmount == 1) {
            divide(blobs);
        } else if (health <= (maxHealth * 1 / 4) && divideAmount == 2) {
            divide(blobs);
        }
    }

    void divide(ArrayList<Blob> blobs) {
        divideAmount++;
        // Create two new smaller blobs
        float newSize = size / 2;
        float newHealth = health/2;
        float newSpeed = speed +speed*0.2;
        if(divideAmount<=maxDivide){
        blobs.add(new Blob(posX + newSize, posY + newSize, newSize,newHealth,newSpeed));
        blobs.add(new Blob(posX - newSize, posY - newSize, newSize,newHealth,newSpeed));
        }
       
        blobs.remove(this);
    }

    void updateBlob(Player player, ArrayList<Blob> blobs) {
        if (!isDead) {
            float deltaX = player.posX - posX;
            float deltaY = player.posY - posY;

            angle = atan2(deltaY, deltaX);  // Get angle towards player

            // Move the blob towards player
            posX += cos(angle) * speed;
            posY += sin(angle) * speed;

            // Apply separation behavior
            for (Blob b : blobs) {
                if (b != this) {
                    float distance = dist(posX, posY, b.posX, b.posY);
                    if (distance < spacing_distance) {
                        float repulsionX = posX - b.posX;
                        float repulsionY = posY - b.posY;
                        float repulsionAngle = atan2(repulsionY, repulsionX);
                        float repulsionStrength = (spacing_distance - distance) / spacing_distance;
                        posX += cos(repulsionAngle) * repulsionStrength;
                        posY += sin(repulsionAngle) * repulsionStrength;
                    }
                }
            }

            // Check if within attack range and apply damage
            if (dist(posX, posY, player.posX, player.posY) < attackRange) {
                attackPlayer(player);
            }

            // Update attack timer
            if (attackTimer > 0) {
                attackTimer--;
            }
        }
    }

    void attackPlayer(Player player) {
        if (attackTimer == 0) {
            player.takeDamage(attackDamage);
            attackTimer = attackCooldown; // Reset cooldown timer
        }
    }

    void drawBlob() {
        push();
        translate(posX, posY);
        rotate(angle);
        fill(0, 255, 0);
        stroke(0);
        ellipse(0, 0, size, size); // Draw the main blob
        pop();
    }
}
