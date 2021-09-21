float playerX, playerY, playerWidth, playerHeight, playerGravity, playerFacingFlag;
int machineGunX, machineGunY, machineGunSX, machineGunSY, machineGunPowerFlag;
int groundX, groundY, groundHeight, groundWidth;
int round, zombieGeneratorFlag, counter;
int gameScreen;
int startButtonX, startButtonY, buttonWidth, buttonHeight;
float playerLives;
PFont title;
PImage inGame, gameOver, mainMenu, platform, zombiesLeft, zombiesRight, playerLeft, playerRight, machineGun, winScreen;

String[] menu;
int menuX, menuY;

int menuSpacing = 25;

ArrayList<Float> bulletX = new ArrayList<Float>();
ArrayList<Float> bulletY = new ArrayList<Float>();
ArrayList<Float> bulletSX = new ArrayList<Float>();
ArrayList<Float> bulletSY = new ArrayList<Float>();

ArrayList<Float> zombieX = new ArrayList<Float>();
ArrayList<Float> zombieY = new ArrayList<Float>();
ArrayList<Float> zombieGravity = new ArrayList<Float>();

ArrayList<Float> homingX = new ArrayList<Float>();
ArrayList<Float> homingY = new ArrayList<Float>();
ArrayList<Float> homingSpeed = new ArrayList<Float>();
ArrayList<Float> Phoming = new ArrayList<Float>();


void setup() {
  noStroke();
  frameRate(60);
  size(1200, 680);

  gameScreen = 0;

  //player variables
  playerX = 100;
  playerY = 550;
  playerHeight = 100;
  playerWidth = 50;
  playerGravity = 0;
  playerLives = 500;
  playerFacingFlag = 0;

  //ground variables
  groundHeight = 30;
  groundWidth = 1200;
  groundX = 0;
  groundY = 680 - groundHeight;

  //start button variables
  startButtonX = 38;
  startButtonY = 276;


  //bullets variables
  bulletX.add(100.0);
  bulletY.add(100.0);
  bulletSX.add(5.0);
  bulletSY.add(3.0);

  //machine gun power-up variables
  machineGunSX = 3;
  machineGunSY = 3;
  machineGunPowerFlag = 0;

  //rounds variables
  round = 1;
  zombieGeneratorFlag = 0;
  counter = 500;

  //fonts loading
  title = loadFont("VinerHandITC-48.vlw");

  //image loading 
  inGame = loadImage("inGame.jpeg");
  platform = loadImage("platform.png");
  zombiesLeft = loadImage("zombieLeft.png");
  zombiesRight = loadImage("zombieRight.png");
  machineGun = loadImage("machineGun.png");
  playerLeft = loadImage("playerLeft.png");
  playerRight = loadImage("playerRight.png");
  mainMenu = loadImage("mainMenu.jpeg");
  gameOver = loadImage("gameOver.jpeg");
  winScreen = loadImage("win.jpeg");
}

void draw() {

  if (gameScreen == 0) {
    background(mainMenu);
    fill(#a62705);
    textFont(title);
    textSize(68);
    textAlign(CENTER);
    text("Zombie Hunter", 269, 93);

    buttonMaker(startButtonX, startButtonY, 150, 50, "Start Game", 20); // makes a button to start the game
  }


  if (gameScreen == 1) {
    background(inGame);

    //draws the ground
    fill(#64210A);
    image(platform, groundX, groundY, groundWidth, groundHeight);

    //building platforms using platformBuilder function
    platformBuilder(0, 446, 340);
    platformBuilder(868, 446, 340);
    platformBuilder(347, 276, 520);
    platformBuilder(0, 130, 224);
    platformBuilder(976, 130, 224);

    //machine gun power up bounce 
    if (machineGunPowerFlag == 0) {
      image(machineGun, machineGunX, machineGunY, 100, 50);
      machineGunX = machineGunX + machineGunSX; //horizontal movement
      machineGunY = machineGunY + machineGunSY; //vertical movement

      if (machineGunX > 1200 - 50) machineGunSX = -3; //limits the machine gun bounce to the screens width
      if (machineGunX < 0) machineGunSX = 3;

      if (machineGunY > 680 - 50) machineGunSY = -3; //limits the machine gun bounce to the screen height
      if (machineGunY < 0) machineGunSY = 3;
    }

    //machine gun vs player colision
    if (playerX + playerWidth > machineGunX && playerX < machineGunX + 50 && playerY + playerHeight > machineGunY && playerY < machineGunY + 50) {
      machineGunPowerFlag = 1;
    }

    //player facing direction based on status of flag variable 
    if (playerFacingFlag == 0) {
      image(playerLeft, playerX, playerY, 80, playerHeight);
    }
    if (playerFacingFlag == 1) {
      image(playerRight, playerX, playerY, 80, playerHeight);
    }
    
    //limiting player to the screen
    if (playerX + 80 < 0){
     playerX = width; 
    } 
    if (playerX > width){
     playerX = -50; 
    }
    if (playerY < 0){
      playerY = 0;
    }

    //player gravity
    playerY = playerY + playerGravity;
    playerGravity = playerGravity + 0.1;

    //player vs platform collision
    if (playerY >= 680 - playerHeight - groundHeight) {
      playerY =  680 - playerHeight - groundHeight;
    }


    //bullet movement
    for (int i=0; i < bulletX.size(); i=i+1) { 
      fill(#E52A2A);
      ellipse(bulletX.get(i), bulletY.get(i), 7, 7); 

      bulletX.set(i, bulletX.get(i) + bulletSX.get(i)); //bullet horizontal movement
      bulletY.set(i, bulletY.get(i) + bulletSY.get(i)); //bullet vertical movement
    }


    //Bullet Garbage Collection
    for (int i=0; i < bulletX.size(); i=i+1) {
      if (bulletX.get(i) < 0 || bulletX.get(i) > width || bulletY.get(i) < 0 || bulletY.get(i) > height) { //if there are random bullets that are not on the screen then remove them
        bulletX.remove(i);
        bulletY.remove(i);
        bulletSX.remove(i);
        bulletSY.remove(i);
      }
    }

    //Zombie Garbage Collection 
    for (int i=0; i < zombieX.size(); i=i+1) {
      if (zombieX.get(i) < 0 || zombieX.get(i) > width || zombieY.get(i) < 0 || zombieY.get(i) > height) { //if there are random zombies that are not on the screen then remove them
        zombieX.remove(i);
        zombieY.remove(i);
      }
    }



    //rounds of zombies 
    if (zombieX.size() == 0 ) {
      zombieGeneratorFlag = 0;
    } 
    if (round == 1  && zombieGeneratorFlag == 0) {
      zombieRounds(3);
      zombieGeneratorFlag = 1;
      round++;
    }
    if (round == 2 && zombieGeneratorFlag == 0) {
      zombieRounds(6);
      zombieGeneratorFlag = 1;
      round++;
    } 
    if (round == 3 && zombieGeneratorFlag == 0) {
      zombieRounds(10);
      zombieGeneratorFlag = 1;
      round++;
    }  
    if (round == 4 && zombieGeneratorFlag == 0) {
      zombieRounds(15);
      zombieGeneratorFlag = 1;
      round++;
    }  
    if (round == 5 && zombieGeneratorFlag == 0) {
      zombieRounds(20);
      zombieGeneratorFlag = 1;
      round++;
    }  
    if (round == 6 && zombieGeneratorFlag == 0) {
      zombieRounds(50);
      zombieGeneratorFlag = 1;
      round++;
    }  
    if (round == 7 && zombieGeneratorFlag == 0) {
      zombieRounds(200);
      zombieGeneratorFlag = 1;
      round++;
    }
    if (round == 8){
     gameScreen = 3; 
    }


    for (int i=0; i < zombieX.size(); i++) {
      if (zombieX.get(i) > playerX) { //if the zombie's x cord is greater than the players x cord, the zombie should face left
        image(zombiesLeft, zombieX.get(i), zombieY.get(i), playerWidth, playerHeight);
      }

      if (zombieX.get(i) < playerX) { //if the zombie's x cord is less than the players x cord, the zombie should face right
        image(zombiesRight, zombieX.get(i), zombieY.get(i), playerWidth, playerHeight);
      }


      //zombie gravity
      zombieGravity.set(i, zombieGravity.get(i) + 0.1);
      zombieY.set(i, zombieY.get(i) + zombieGravity.get(i));

      //Zombie vs ground collision
      if (zombieY.get(i) >= 680 - playerHeight - groundHeight) {
        zombieY.set(i, 680 - playerHeight - groundHeight);
      }

      //Zombie chasing player algorithm
      if (zombieX.get(i) < playerX) { 
        zombieX.set(i, zombieX.get(i) + homingSpeed.get(i));
      } else if (zombieX.get(i) > playerX) {
        zombieX.set(i, zombieX.get(i) - homingSpeed.get(i));
      }
    }

    // bullet vs zombie collision, zombies are index i, bullets are index j
    for (int i=0; i < zombieX.size(); i++) { //For all zombies
      for (int j = 0; j < bulletX.size(); j++) { //Look at all bullets
        if (dist(zombieX.get(i), zombieY.get(i), bulletX.get(j), bulletY.get(j)) < playerWidth) { //calculates the distance between the zombie and bullet
          //if contact is made between bullet and zombie then move them both off the screen, garbage removal will take care of the rest
          zombieX.set(i, -100.0);
          zombieY.set(i, -100.0);
          bulletY.set(j, -100.0);
          bulletX.set(j, -100.0);
        }
      }
    }


    //player Health Bar
    fill(#566258);
    rect(360, 23, 500, 15); 
    fill(#143a00);
    rect(360, 23, playerLives, 15);



    //zombie vs player collision
    for (int i=0; i < zombieX.size(); i++) {
      if (zombieX.get(i) + playerWidth > playerX && zombieX.get(i) < playerX + playerWidth && zombieY.get(i) + playerHeight > playerY && zombieY.get(i) < playerY + playerHeight) { //check if the zombie and player are touchin
        playerLives = playerLives - 1; // decrements the players life
        if (playerLives == 0) { //player is dead
          gameScreen = 2;
        }
      }
    }
  }

  //Gameover screen
  if (gameScreen == 2) {
    background(gameOver);
    fill(#289000);
    textSize(61);
    text("Game Over", 596, 389);
  }
  
  //Win Screen
  if (gameScreen == 3){
   background(winScreen);
       textSize(144);
    text("You win", 607, 330);
  }
}


void keyPressed() {
  if (key == CODED) {
    if (keyCode == RIGHT) {
      playerX = playerX + 5;
      playerFacingFlag = 1;
    } else if (keyCode == LEFT) {
      playerX = playerX - 5;
      playerFacingFlag = 0;
    } else if (keyCode == UP) {
      playerY = playerY - 5;
      playerGravity = -5;
    }
  }
}

void mousePressed() {

  //bullet shooting
  if (machineGunPowerFlag == 0) {
    if (bulletX.size() < 2) { //To control how many you are allowed to fire at once
      float speedx;
      float speedy;

      speedx = 10 * (mouseX - playerX) / dist(mouseX, mouseY, playerX, playerY);
      speedy = 10 * (mouseY - playerY) / dist(mouseX, mouseY, playerX, playerY);

      bulletX.add(playerX);
      bulletY.add(playerY);

      bulletSX.add(speedx);
      bulletSY.add(speedy);
    }
  }

  //if machine gun power up is caught
  if (machineGunPowerFlag == 1) {
    if (bulletX.size() < 10) { 
      float speedx;
      float speedy;

      speedx = 10 * (mouseX - playerX) / dist(mouseX, mouseY, playerX, playerY);
      speedy = 10 * (mouseY - playerY) / dist(mouseX, mouseY, playerX, playerY);

      bulletX.add(playerX);
      bulletY.add(playerY);

      bulletSX.add(speedx);
      bulletSY.add(speedy);
    }
  }

  if (mouseX > startButtonX && mouseX < startButtonX + 150 && mouseY > startButtonY && mouseY < startButtonY + 50) { //button to start the game
    gameScreen = 1;
  }
}

void platformBuilder(int platformX, int platformY, int platformWidth) {
  fill(#64210A);
  image(platform, platformX, platformY, platformWidth, 30);

  //player vs platform collision
  if (playerX > platformX && playerX < platformX + platformWidth && playerY + playerHeight > platformY && playerY < platformY + 30) {
    playerY = platformY - playerHeight;
  }

  //zombie vs platform collision
  for (int i=0; i < zombieX.size(); i++) {
    if (zombieX.get(i) > platformX && zombieX.get(i) < platformX + platformWidth && zombieY.get(i) + playerHeight > platformY && zombieY.get(i) < platformY + 30) {
      zombieY.set(i, platformY - playerHeight);
    }
  }
}

void zombieRounds(int zombies) {
  for (int i=0; i < zombies; i++) {
    zombieX.add(random(0, 1000 - playerWidth));
    zombieY.add(random(0, 500));
    zombieGravity.add(0.1);
    homingSpeed.add(0.5);
  }
}

void buttonMaker(int x, int y, int buttonWidth, int buttonHeight, String text, int textSize) {
  rect(x, y, buttonWidth, buttonHeight);

  fill(#ffffff);
  textSize(textSize);
  text(text, x + buttonWidth - textWidth(text) + 35, y + buttonHeight/2 + 10);
}
