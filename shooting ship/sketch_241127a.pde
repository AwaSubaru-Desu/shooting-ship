import ddf.minim.*;

Minim minim;
import processing.video.*;

Movie movie;
int stage = 1;
AudioPlayer music;
Back back;//背景类
Main main;//主机类
PFont Font1,Font2;//字体
Enemey[] enemey=new Enemey[10];//敌机类
boolean[] keys = new boolean[128];
Bullet bullet;//子弹一
Bullet bullet1;//子弹二
int LF=10;//接收换行符的acsii码
boolean shoot;
int correction=-20;
int alpha=255;
int score=0;
int bestScore;
int life;
int times = 1;
float voice = 0;
boolean gameOver;
boolean regameOver;
int endmillis;
void setup()
{
size(1024,824);//画布大小

minim=new Minim(this);
music=minim.loadFile("music1.mp3",1024);//导入音乐
back = new Back(0,0);//初始化背景
Font1 = createFont("fangsong",50);
Font2 = createFont("fangsong",30);
main = new Main(250,300);//初始化主机
for(int i=0;i<10;i++)
{
enemey[i] = new Enemey(random(0,600),random(-200,-100));
}//初始化敌人
bullet = new Bullet(main.x-20,main.y+20,correction,alpha);
bullet1= new Bullet(main.x+65,main.y+20,correction+85,alpha);
endmillis = millis();
movie = new Movie(this, "Movie1.mp4");
movie.loop();
}

void movieEvent(Movie m) {
m.read();
}
void draw()
{
if (stage==1)
{ 
if (millis()-endmillis > 73000)
{
stage=2;
} 
image(movie, 0, 0, width, height);
}
if (stage == 2)
{
if(gameOver==false)
{
showBegin();
}
if(keyPressed && key=='s' && !gameOver)
{
gameOver=true;
music.loop();
}
if(!gameOver)
{
return;
}
voice=music.mix.level();
regameOver=false;
if(life<=0)
{
showOver();
if(keyPressed && key=='r' && !regameOver)
{
reGame();
}
if(!regameOver)
{
return;
}
}
back.display();//画布流动
main.display();//主机模型和方向
interFace();//显示分数，生命
bullet.update();
bullet.display();
bullet1.update();
bullet1.display();
for(int i=0;i<10;i++)
{
enemey[i].display();
enemey[i].update();
if(enemey[i].bruise())
{
life-=1;
enemey[i].life=0;
enemey[i].die();
}//判断敌机是否撞到主机 如果是主机生命减一
if(enemey[i].check())
{
enemey[i].life-=1;
if(enemey[i].direction==1)
{
bullet.die();//左边击中
}
if(enemey[i].direction==2)
{
bullet1.die();//右边击中
}
enemey[i].die();//判断敌机是否死亡
}//判断敌机是否被击中 如果是敌机生命减一
if(enemey[i].reach())
{
enemey[i].x = random(0,700);
enemey[i].y = random(-50,-30);
enemey[i].life = enemey[i].type+1;
}//判断敌机是否安全到达 如果是初始化其位置
}
}
}
//-----------------------------------------------------------------------按键函数
void keyPressed()
{
keys[key] = true;
}
void keyReleased()
{
keys[key] = false;
}
//-----------------------------------------------------------------------界面
void interFace()
{
int difficulty=0;
for(int i=0; i<10; i++)
{
difficulty = difficulty+enemey[i].type;
}
PImage[] png;
fill(255);
textSize(20);
text("Score:",25,40);
text(score,90,40);
text("DY:",130,40);
text("V:",200,40);
text("Mainlife:",365,40);
png = new PImage[5];
for(int i=0;i<life;i++)
{
int j=i+1;
png[i] = loadImage("Mainlife.png");
png[i].resize(25,25);
image(png[i],425+j*30,22);
}
if(score>100*times)
{
life+=1;
times+=1;
if(life>5)
{
life=5;
}
}
fill(255);
rect(220,27.5,120,10,10);
noStroke();
fill(bullet.v*(255/15),150,0);
rect(220,27.5,bullet.v*(120/15),10,10);
if(difficulty>=13)
{
fill(255,0,0);
}
if(difficulty<13 && difficulty>8)
{
fill(255,255,0);
}
if(difficulty<=8)
{
fill(0,255,0);
}
ellipse(170,33,15,15);
}
//-----------------------------------------------------------------------开始
void showBegin()
{
fill(0);
rect(0,0,width,height);
fill(255);
textFont(Font1);
text("Stop illegal whaler",160,180);
textFont(Font2);
text("Press 's' to begin",230,240);
}
//-----------------------------------------------------------------------结束
void showOver()
{
music.pause();
fill(0);
rect(0,0,width,height);
fill(255);
textFont(Font1);
text("Stop illegal whaler",160,180);
textFont(Font2);
text("You have failed the emperor!",170,300);
text("Press 'R' to Reburn",210,240);
text("Score:",200,90);
text(score,350,90);
if(bestScore<score)
{
bestScore=score;
}
text("bestScore:",200,120);
text(bestScore,350,120);
}
void reGame()
{
main = new Main(250,300);
regameOver=true;
score=0;
life=3;
for(int i=0;i<10;i++)
{
enemey[i] = new Enemey(random(0,700),random(-50,-30));
}
minim=new Minim(this);
music=minim.loadFile("music.mp3",1024);//导入音乐

}
//-----------------------------------------------------------------------背景类
class Back
{
PImage[] background;
int x;
int y;
int y1;
int y2;
Back(int x,int y)
{
background = new PImage[2];
this.y1=y;
this.y2=y-400;
this.x=x;
for (int i=0;i<2;i++)
{ 
background[i] = loadImage("background.jpg");
}
}
void display()
{
y1++;
y2++;
if(y1==400)
{
y1=-400;
}
if(y2==400)
{
y2=-400;
}
tint(255,255);
image(background[0],x,y1);
image(background[1],x,y2); 
}
}
//-----------------------------------------------------------------------主机类
class Main
{
int r;
int x;
int y;
int state;
boolean[] direction;
PImage aircraft;
Main(int x,int y)
{
this.x=x;
this.y=y; 
life = 3;
r=20;
direction = new boolean[4];
aircraft=loadImage("Main.png");
}
void up()
{
if(keys['w'] && y>0)
{
y-=2;
}
}
void down()
{
if(keys['s'] && y<824)
{
y+=2;
}
}
void left()
{
if(keys['a'] && x>0)
{
x-=2;
}
}
void right()
{
if(keys['d'] && x<1024)
{
x+=2;
}
}
void display()
{
up();
down();
left();
right();
tint(255,255);
image(aircraft,x,y);
}
}
//-----------------------------------------------------------------------子弹类
class Bullet
{
int x;
int y;
int r;
int v;
boolean shoots;
int alpha;
int corrections;
PImage png;
Bullet(int x,int y,int corrections,int alpha)
{
this.alpha=alpha;
this.corrections=corrections;
this.x=x;
this.y=y;
png = loadImage("bullet.png");
png.resize(50,50);
r=5;
}
void update()
{
if(voice<=0.01)
{
voice=0.01;
}
if(voice>=0.2)
{
voice=0.2;
}
v=(int)map(voice,0.01,0.2,1,15);
println(v);
y=y-v;
}
void display()
{
tint(255,alpha);
image(png,x,y);
if(y<-10)
{
alpha=255;
r=5;
x=main.x+corrections;
y=main.y+20;
}
}
boolean check()
{
if(y<=20)
{
return true; 
}
return false;
}
void die()
{
alpha=0;
r=-100; 
}
}
//-----------------------------------------------------------------------敌人类
class Enemey
{
float x;
float y;
float v=1;
float a=1.5;
int r;
int type;
boolean exist;
int life;
PImage[] png;
PImage[] png1;
int direction;
Enemey(float x,float y)
{
png = new PImage[3];
png1 = new PImage[2];
this.x=x;
this.y=y;
r=15;
type = (int)random(0,3);
life = type+1;
String a = "Explosion.png";
String b = "enemey"+type+".png";
png[type] = loadImage(b); 
png[type].resize(50,50);
for(int i=0;i<2;i++)
{
png1[i] = loadImage(a); 
png1[i].resize(50,50);
}
}
void update()
{
if(type == 0)
v=1;
if(type == 1)
v=1.5;
if(type == 2)
v=2; 
v=v+a;
y=y+v; 
}
void display()
{
tint(255,255);
image(png[type],x,y);
}
boolean bruise()
{
if(dist(x-5,y,main.x+22.5,main.y)<main.r+r)
{
return true;
}
return false;
}
boolean check()
{
if(dist(x,y,bullet.x,bullet.y)<bullet.r+r)
{
direction = 1;
return true; 
}
if(dist(x,y,bullet1.x,bullet1.y)<bullet1.r+r)
{
direction = 2; 
return true; 
}
return false;
}
void die()
{
if(life<=0)
{ 
//explosion.display();
if(type==0)
{
score++;
}
if(type==1)
{
score+=3;
}
if(type==2)
{
score+=5;
}
for(int i=0;i<2;i++)
{
image(png1[i],x,y);
}
x = random(0,1024);
y = random(-50,-30);
direction = 0; 
life = type+999;
}
}
boolean reach()
{
if(y>height+50)
{
return true; 
}
return false;
}
}
