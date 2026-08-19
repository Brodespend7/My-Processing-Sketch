// Pac-Man Sketch with 10 Levels, Targeted Ghost AI, Power Pellets & Ghost Eating (Java Mode)

int cols = 28;
int rows = 31;
int cellSize = 20;
int[][] map = new int[rows][cols]; // 0: Dot, 1: Wall, 2: Empty, 3: Power Pellet

float pacX, pacY;
int dirX = 0, dirY = 0;
int nextDirX = 0, nextDirY = 0;
int score = 0;
int currentLevel = 1;
int maxLevels = 10;
int dotsRemaining = 0;

// Ghost variables
float[] ghostX = new float[4];
float[] ghostY = new float[4];
int[] ghostDirX = {0, 0, 0, 0};
int[] ghostDirY = {-1, 1, -1, 1};
color[] ghostColors = {#FF0000, #FFB8FF, #00FFFF, #FFB852};

int frightenedTimer = 0;
boolean useMouse = false;

// Classic layout with 3 Power Pellets ('P') and 241 Pac-Dots (Total 244 collectibles)
String[] mazeLayout = {
  "1111111111111111111111111111",
  "1............11............1",
  "1.1111.11111.11.11111.1111.1",
  "1P1111.11111.11.11111.1111P1",
  "1.1111.11111.11.11111.1111.1",
  "1..........................1",
  "1.1111.11.11111111.11.1111.1",
  "1.1111.11.11111111.11.1111.1",
  "1......11....11....11......1",
  "111111.11111 11 11111.111111",
  "111111.11111 11 11111.111111",
  "111111.11          11.111111",
  "111111.11 111--111 11.111111",
  "111111.11 1      1 11.111111",
  "      .   1      1   .      ",
  "111111.11 1      1 11.111111",
  "111111.11 11111111 11.111111",
  "111111.11          11.111111",
  "111111.11 11111111 11.111111",
  "111111.11 11111111 11.111111",
  "1............11............1",
  "1.1111.11111.11.11111.1111.1",
  "1.1111.11111.11.11111.1111.1",
  "1P.11........  ........11..1",
  "111.11.11.11111111.11.11.111",
  "111.11.11.11111111.11.11.111",
  "1......11....11....11......1",
  "1.1111111111.11.1111111111.1",
  "1.1111111111.11.1111111111.1",
  "1..........................1",
  "1111111111111111111111111111"
};

void setup() {
  size(560, 620);
  initGame();
}

void initGame() {
  score = 0;
  currentLevel = 1;
  loadLevel();
}

void loadLevel() {
  dotsRemaining = 0;
  frightenedTimer = 0;

  for (int r = 0; r < rows; r++) {
    for (int c = 0; c < cols; c++) {
      char tile = mazeLayout[r].charAt(c);
      if (tile == '1') {
        map[r][c] = 1;
      } else if (tile == '.') {
        map[r][c] = 0;
        dotsRemaining++;
      } else if (tile == 'P') {
        map[r][c] = 3; // Power Pellet
        dotsRemaining++;
      } else {
        map[r][c] = 2;
      }
    }
  }

  resetPositions();
}

void resetPositions() {
  pacX = 13 * cellSize;
  pacY = 23 * cellSize;
  dirX = 0; dirY = 0;
  nextDirX = 0; nextDirY = 0;

  for (int i = 0; i < 4; i++) {
    ghostX[i] = (12 + i) * cellSize;
    ghostY[i] = 14 * cellSize;
    ghostDirX[i] = 0;
    ghostDirY[i] = -1;
  }
}

void draw() {
  background(0);
  
  if (frightenedTimer > 0) {
    frightenedTimer--;
  }

  drawMaze();
  updatePacman();
  drawPacman();
  updateGhosts();
  drawGhosts();
  drawUI();
}

void drawMaze() {
  for (int r = 0; r < rows; r++) {
    for (int c = 0; c < cols; c++) {
      float x = c * cellSize;
      float y = r * cellSize;
      if (map[r][c] == 1) {
        fill(33, 33, 222);
        stroke(0);
        rect(x, y, cellSize, cellSize, 3);
      } else if (map[r][c] == 0) {
        fill(255, 183, 174);
        noStroke();
        ellipse(x + cellSize/2, y + cellSize/2, 4, 4);
      } else if (map[r][c] == 3) {
        if (frameCount % 20 < 10) { // Flashing effect
          fill(255, 183, 174);
          noStroke();
          ellipse(x + cellSize/2, y + cellSize/2, 12, 12);
        }
      }
    }
  }
}

void updatePacman() {
  if (useMouse) {
    float dx = mouseX - (pacX + cellSize/2);
    float dy = mouseY - (pacY + cellSize/2);
    if (abs(dx) > abs(dy)) {
      nextDirX = dx > 0 ? 1 : -1;
      nextDirY = 0;
    } else {
      nextDirX = 0;
      nextDirY = dy > 0 ? 1 : -1;
    }
  }

  float speed = 2.0;

  // Tunnel wrap-around
  if (pacX < -cellSize/2) pacX = width - cellSize/2;
  if (pacX > width - cellSize/2) pacX = -cellSize/2;

  // Grid alignment check for dot consumption and turning
  if ((int)pacX % cellSize == 0 && (int)pacY % cellSize == 0) {
    int curC = int(pacX / cellSize);
    int curR = int(pacY / cellSize);

    if (curR >= 0 && curR < rows && curC >= 0 && curC < cols) {
      if (map[curR][curC] == 0) {
        map[curR][curC] = 2;
        score += 10;
        dotsRemaining--;
      } else if (map[curR][curC] == 3) {
        map[curR][curC] = 2;
        score += 50;
        dotsRemaining--;
        frightenedTimer = max(600 - (currentLevel * 45), 180); // Frightened duration scales down per level
      }
    }

    // Check for level progression
    if (dotsRemaining <= 0) {
      if (currentLevel < maxLevels) {
        currentLevel++;
        loadLevel();
      }
      return;
    }

    int nextC = curC + nextDirX;
    int nextR = curR + nextDirY;
    if (nextR >= 0 && nextR < rows && nextC >= 0 && nextC < cols) {
      if (map[nextR][nextC] != 1) {
        dirX = nextDirX;
        dirY = nextDirY;
      }
    }

    int checkC = curC + dirX;
    int checkR = curR + dirY;
    if (checkR >= 0 && checkR < rows && checkC >= 0 && checkC < cols) {
      if (map[checkR][checkC] == 1) {
        dirX = 0;
        dirY = 0;
      }
    }
  }

  pacX += dirX * speed;
  pacY += dirY * speed;
}

void drawPacman() {
  fill(255, 255, 0);
  noStroke();
  float angle = (frameCount % 16 < 8) ? 0.25 : 0.05;
  float baseAngle = 0;

  if (dirX == 1) baseAngle = 0;
  else if (dirX == -1) baseAngle = PI;
  else if (dirY == 1) baseAngle = HALF_PI;
  else if (dirY == -1) baseAngle = 3 * HALF_PI;

  arc(pacX + cellSize/2, pacY + cellSize/2, cellSize - 2, cellSize - 2, baseAngle + angle, baseAngle + TWO_PI - angle, PIE);
}

void updateGhosts() {
  // Ghost speed increases slightly per level
  float speed = 1.0 + (currentLevel * 0.1);
  if (frightenedTimer > 0) speed *= 0.6; // Ghosts slow down when frightened

  for (int i = 0; i < 4; i++) {
    if (ghostX[i] < -cellSize/2) ghostX[i] = width - cellSize/2;
    if (ghostX[i] > width - cellSize/2) ghostX[i] = -cellSize/2;

    if ((int)ghostX[i] % cellSize == 0 && (int)ghostY[i] % cellSize == 0) {
      int gC = int(ghostX[i] / cellSize);
      int gR = int(ghostY[i] / cellSize);

      int targetC = int(pacX / cellSize);
      int targetR = int(pacY / cellSize);

      // Arcade Ghost AI targeting behaviors
      if (frightenedTimer > 0) {
        targetC = int(random(cols));
        targetR = int(random(rows));
      } else {
        if (i == 1) { // Pinky targets 4 tiles ahead
          targetC += dirX * 4;
          targetR += dirY * 4;
        } else if (i == 2) { // Inky flank target
          targetC -= dirX * 2;
          targetR -= dirY * 2;
        } else if (i == 3) { // Clyde retreats if too close
          if (dist(ghostX[i], ghostY[i], pacX, pacY) < cellSize * 6) {
            targetC = 0;
            targetR = rows - 1;
          }
        }
      }

      int[] dirsX = {1, -1, 0, 0};
      int[] dirsY = {0, 0, 1, -1};
      
      float bestDist = 999999;
      int bestDirX = ghostDirX[i];
      int bestDirY = ghostDirY[i];

      for (int d = 0; d < 4; d++) {
        // Prevent 180-degree immediate turns
        if (dirsX[d] == -ghostDirX[i] && dirsY[d] == -ghostDirY[i]) continue;

        int nC = gC + dirsX[d];
        int nR = gR + dirsY[d];

        if (nR >= 0 && nR < rows && nC >= 0 && nC < cols && map[nR][nC] != 1) {
          float dSq = dist(nC, nR, targetC, targetR);
          if (dSq < bestDist) {
            bestDist = dSq;
            bestDirX = dirsX[d];
            bestDirY = dirsY[d];
          }
        }
      }

      ghostDirX[i] = bestDirX;
      ghostDirY[i] = bestDirY;
    }

    ghostX[i] += ghostDirX[i] * speed;
    ghostY[i] += ghostDirY[i] * speed;

    // Ghost collision logic
    if (dist(pacX, pacY, ghostX[i], ghostY[i]) < cellSize * 0.7) {
      if (frightenedTimer > 0) {
        // Eat Ghost: Respawn ghost at center house and award points
        score += 200;
        ghostX[i] = (12 + (i % 2)) * cellSize;
        ghostY[i] = 14 * cellSize;
      } else {
        // Death: Reset level positions
        resetPositions();
      }
    }
  }
}

void drawGhosts() {
  for (int i = 0; i < 4; i++) {
    pushMatrix();
    translate(ghostX[i], ghostY[i]);

    // Blue/White flashing when frightened
    if (frightenedTimer > 0) {
      if (frightenedTimer < 120 && (frameCount % 10 < 5)) fill(255);
      else fill(33, 33, 255);
    } else {
      fill(ghostColors[i]);
    }
    
    noStroke();

    // Round head & body
    arc(cellSize / 2.0, cellSize / 2.0, cellSize - 2, cellSize - 2, PI, TWO_PI);
    rect(1, cellSize / 2.0, cellSize - 2, (cellSize - 2) / 2.0);

    // Tentacles
    for (int t = 0; t < 3; t++) {
      float tw = (cellSize - 2) / 3.0;
      arc(1 + tw / 2.0 + t * tw, cellSize - 1, tw, 4, 0, PI);
    }

    if (frightenedTimer > 0) {
      // Frightened face expression
      fill(255, 183, 174);
      ellipse(cellSize * 0.35, cellSize * 0.45, 3, 3);
      ellipse(cellSize * 0.65, cellSize * 0.45, 3, 3);
    } else {
      // Normal eyes with directional pupils
      fill(255);
      ellipse(cellSize * 0.35, cellSize * 0.4, 6, 8);
      ellipse(cellSize * 0.65, cellSize * 0.4, 6, 8);

      fill(0, 0, 222);
      float pX = ghostDirX[i] * 1.5;
      float pY = ghostDirY[i] * 1.5;
      ellipse(cellSize * 0.35 + pX, cellSize * 0.4 + pY, 3, 3);
      ellipse(cellSize * 0.65 + pX, cellSize * 0.4 + pY, 3, 3);
    }

    popMatrix();
  }
}

void drawUI() {
  fill(255);
  textSize(12);
  textAlign(LEFT, TOP);
  text("SCORE: " + score, 10, 5);
  text("LEVEL: " + currentLevel + "/" + maxLevels, 130, 5);
  text("LEFT: " + dotsRemaining, 230, 5);
  text("MODE: " + (useMouse ? "MOUSE" : "WASD") + " ('M')", 370, 5);

  if (dotsRemaining == 0 && currentLevel == maxLevels) {
    textSize(32);
    fill(0, 255, 0);
    textAlign(CENTER, CENTER);
    text("YOU BEAT ALL 10 LEVELS!", width / 2, height / 2);
  }
}

void keyPressed() {
  if (key == 'w' || key == 'W') { nextDirX = 0; nextDirY = -1; useMouse = false; }
  if (key == 's' || key == 'S') { nextDirX = 0; nextDirY = 1; useMouse = false; }
  if (key == 'a' || key == 'A') { nextDirX = -1; nextDirY = 0; useMouse = false; }
  if (key == 'd' || key == 'D') { nextDirX = 1; nextDirY = 0; useMouse = false; }
  if (key == 'm' || key == 'M') { useMouse = !useMouse; }
}
