import processing.net.*;

Server sMe;

String leftIP = "70.113.97.242";
String rightIP = "";
Client left, right;

int port = 2342;

float radius = 25; // radius
float diam = radius * 2;

boolean failLeft = true;
boolean failRight = false;

int j;

bag b1 = new bag();

void setup() {
    size(500, 500);
    fill(0);
    sMe = new Server(this, port); // start server
    while (failLeft || failRight) { // set up neighbors, while both are failing 
        if (leftIP != "" && failLeft) {
            left = new Client(this, leftIP, port);
            if (left.active()) {
                failLeft = false;
            }
        } else {
            failLeft = false;
        }
        if (rightIP != "" && failRight) {
            right = new Client(this, rightIP, port);
            if (right.active()) {
                failRight = false;
            }
        } else {
            failRight = true;
        }
    }
    background(255);
    b1.addBall(25, 25, 1, 2);
}

void mouseClicked() {
    // mouseX and mouseY are handy
    // random(lower, upper) is cool too
}

void draw() {
    background(255);
    b1.update();
    b1.draw();
    Client fClient = sMe.available();
    if (fClient != null) {
        println("Got message");
        String bString = fClient.readString();
        String[] bList = bString.split(",");
        float[] fList = new float[4];
        for (j = 0; j < 4; j++) {
            fList[j] = float(bList[j]);
        }
        if (fList[0] < radius) {
            b1.addBall(width - radius, fList[1], fList[2], fList[3]);
        } else {
            b1.addBall(radius, fList[1], fList[2], fList[3]);
        }
    }
}



class bag {
    ArrayList < ball > balls;
    int i;
    ball b;
    bag() {
        balls = new ArrayList < ball > ();
    }
    void update() {
        if (balls == null) {
            return;
        }
        for (i = balls.size() - 1; i >= 0; i--) {
            b = balls.get(i);
            if (b.ret(0) < radius) {
                if (leftIP != "") {
                    println("sending left");
                    left.write(b.toStr());
                    balls.remove(i);
                } else {
                    b.flop(2);
                    b.update();
                }
            } else if (b.ret(0) > width - radius) {
                if (rightIP != "") {
                    println("sending right");
                    right.write(b.toStr());
                    balls.remove(i);
                } else {
                    b.flop(2);
                    b.update();
                }
            } else if (b.ret(1) > height - radius || b.ret(1) < radius) {
                b.flop(3);
                b.update();
            } else {
                b.update();
            }
        }
        // Think about adding a new else if to check whether balls have collided
    }
    void draw() {
        for (i = 0; i < balls.size(); i++) {
            ball b = balls.get(i);
            b.draw();
        }
    }
    void addBall(float x, float y, float xv, float yv) {
        balls.add(new ball(x, y, xv, yv));
    }
}


class ball {
    //float[] ballAr = {25,25,2,3};
    float[] ballAr = new float[4];
    ball(float x, float y, float xv, float yv) {
            ballAr[0] = x;
            ballAr[1] = y;
            ballAr[2] = xv;
            ballAr[3] = yv;
        }
        // It would be cool if the balls sped up when they were
        // over a certain area.
    void update() {
        // Maybe have balls slow down
        ballAr[0] += ballAr[2];
        ballAr[1] += ballAr[3];
    }
    String toStr() {
        String[] sList = nf(ballAr, 0, 0);
        return join(sList, ",");
    }
    void draw() {
        ellipse(ballAr[0], ballAr[1], diam, diam);
    }
    float ret(int i) {
        return ballAr[i];
    }
    void flop(int i) {
        ballAr[i] *= -1.0;
    }
}
