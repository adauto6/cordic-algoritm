#include <stdio.h>
#include <math.h>

#define AG_CONST 0.6072529350
#define FIXED(X) ((long int)((X) * 65536.0))
#define FLOAT(X) ((X) / 65536.0)
#define DEG2RAD(X) 0.017453 * (X)

typedef long int fixed; /* 16.16 fixed-point */
static const fixed Angles[]={
 FIXED(45.0), FIXED(26.565), FIXED(14.0362),
 FIXED(7.12502), FIXED(3.57633), FIXED(1.78991),
 FIXED(0.895174),FIXED(0.447614),FIXED(0.223811),
 FIXED(0.111906),FIXED(0.055953),FIXED(0.027977),
 FIXED(0.013988), FIXED(0.006994) };


int main(){ 
  fixed X, Y, TargetAngle,aux;
 //unsigned Step;
 int Step;
 int x = 2;
 int y = 7;
 int v=0;
 printf("digite x:");
 scanf("%d",&x);
 while(x > 255) {
 printf("Extrapolou...");
 printf("digite x:");
 scanf("%d",&x);
 }
 printf("digite y:");
 scanf("%d",&y); 
 while (y>255){
 printf("Extraplou...");
 printf("digite y:");
 scanf("%d",&y);
 }
 X=FIXED(x); /* argc1 2 AG_CONST * cos(0) */
 Y=FIXED(y); /* argc2 7 AG_CONST * sin(0) */
 TargetAngle=FIXED(-90);
 aux = X ;
 X = Y;
 Y = - aux;
 if(y<0){v=1; X = -X;}
 for(Step=0; Step < 13; Step++)
 { fixed NewX;
 printf(" %d X: %7.5f Y: %7.5f, %7.5f %7.5f", Step,FLOAT(X), FLOAT(Y),
FLOAT(Angles[Step]), FLOAT(TargetAngle));
 if (Y < 0)
 { NewX=X - (Y >> Step);
 Y=(X >> Step) + Y;
 X=NewX;
 printf(" Valor do Angulo %f "), FLOAT(Angles[Step]);
 TargetAngle = TargetAngle + (Angles[Step]);
 printf(" soma: %f \n",FLOAT(TargetAngle));
 }
 else
 { NewX=X + (Y >> Step);
 Y=-(X >> Step) + Y;
 X=NewX;
 printf(" Valor do Angulo %f "), FLOAT(Angles[Step]);
 TargetAngle =TargetAngle - Angles[Step];
 printf(" diferenca: %f\n", FLOAT(TargetAngle));
 }
 }
 if(v==1) {TargetAngle =-(TargetAngle + FIXED(360)); }
 printf("\nCORDIC atan(%d/%d) = %7.5f\n",y,x, -FLOAT(TargetAngle) );
 return(0);
}
