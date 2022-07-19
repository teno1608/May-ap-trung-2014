/*****************************************************
Chip type               : ATmega64
Program type            : Application
AVR Core Clock frequency: 11,059200 MHz
Memory model            : Small
External RAM size       : 0
Data Stack size         : 1024
*****************************************************/

#include <mega64.h>

// Alphanumeric LCD Module functions
#include <alcd.h>
#include <stdio.h>
#include <stdlib.h>
#include <delay.h>
// Declare your global variables here

void beep()
{
DDRC.7=1;
PORTC.7=0;
delay_ms(30);
PORTC.7=1;
delay_ms(70);
}

///////////////////////////////////////
#define ddrdata DDRC.6
#define portdata PORTC.6
#define data PINC.6
long doamh, doaml, nhietdoh, nhietdol, nhietdo, doam;
void read_am2301()   // Clock value: 1382.400 kHz
     {
     int i,a;
     a=128;
     ddrdata=1;
     portdata=0;
     delay_us(1000);
     portdata=1;
     delay_us(30);
     portdata=0;
     ddrdata=0;
     while(data==0)
          {
          }
     while(data==1)
          {
          }
     while(data==0)
          {
          }
     a=128;
     for (i=0;i<8;i++)
          {
          TCNT2=0x00;
          TCCR2=0x02;
          while(data==1)
               {
               }
          if (TCNT2 > 96) doamh = doamh + a ;
          a=a/2;
          TCNT2=0x00;
          TCCR2=0x00;
          while (data==0)
               {
               }
          } 
     a=128;
     for (i=0;i<8;i++)
          {
          TCNT2=0x00;
          TCCR2=0x02;
          while(data==1)
               {    
               }
          if (TCNT2 > 96) doaml = doaml + a ;
          a=a/2;
          TCNT2=0x00;
          TCCR2=0x00;
          while (data==0)
               {
               }
          }
     a=128;    
     for (i=0;i<8;i++)
          {
          TCNT2=0x00;
          TCCR2=0x02;
          while(data==1)
               {
               }
          if (TCNT2 > 96 ) nhietdoh = nhietdoh + a ;
          a=a/2;
          TCNT2=0x00;
          TCCR2=0x00;
          while (data==0)
               {
               }
          }
     a=128;    
     for (i=0;i<8;i++)
          {
          TCNT2=0x00;
          TCCR2=0x02;
          while(data==1)
               {
               }
          if (TCNT2 > 96) nhietdol = nhietdol + a ;
          a=a/2;
          TCNT2=0x00;
          TCCR2=0x00;
          while (data==0)
               {
               }
          } 
     nhietdo = nhietdoh*256 + nhietdol; 
     doam = doamh*256 + doaml;
     doamh=doaml=nhietdoh=nhietdol=0;
     portdata=1;
     } 
     
///////////////////////////////////////
#define daotrung PORTB.4
#define ctht1 PIND.6
#define ctht2 PIND.7
 
eeprom char hong1=0x00, hong2=0xff, hong3=0x7f, hong4=0xff;
eeprom int solandtr=0;
eeprom unsigned char dempdtr=0;

int demcb=0, demwdog=0, demquat=0, demdtr=0 ;
bit kichquat=0;
 
interrupt [TIM0_OVF] void timer0_ovf_isr(void)
{
// Reinitialize Timer 0 value
TCNT0=0x27;
// Place your code here
demdtr++; 
demcb++; 
demwdog++;
demquat++;
if (demwdog >=50) 
    {
    demwdog=0;
    #asm("WDR") ; 
    }                                          
if (demcb >=100)
    {
    demcb=0;
    read_am2301();
    };

switch (demquat)
    {
    case 3 :
        kichquat=1; 
        break;
    case 600 :
        kichquat=0; 
        break;    
    case 5000 :
        demquat=0;
        break;            
    }
   
}

//////////////////////////////////
char select=0;
void kiemtradr()
{
    if (demdtr >=9000)
    {         
    demdtr=0;
    dempdtr++;
    if (dempdtr >=60) 
        {
        dempdtr=0;    
        solandtr++;
        if ((ctht1==0)|((ctht1==1)&(ctht1==1))) {select=1;}
        if (ctht2==0) {select=2;}
        daotrung=0;
        beep();
        } 
    }    
      if (select==1) {if (ctht2==0) {beep(); daotrung=1; select=0;}}
      if (select==2) {if (ctht1==0) {beep(); daotrung=1; select=0;}} 
}

/////////////////////////////////
char display_buffer[80]; 
void hienthilcd()
{   
    lcd_clear();
    lcd_gotoxy(5,0);
    lcd_puts("Fairy-Elab");
    sprintf(display_buffer,"Nhiet Do:%6i.%-u%cC\nDo Am:%9i.%-u%%",
    nhietdo/10,abs(nhietdo%10),0xdf,doam/10,abs(doam%10),0xdf);
    lcd_gotoxy(0,1);
    lcd_puts(display_buffer);
    sprintf(display_buffer,"Dao: %-i",solandtr);
    lcd_gotoxy(0,3);                                       
    lcd_puts(display_buffer);
    sprintf(display_buffer,"%-u",dempdtr);
    lcd_gotoxy(10,3);                                       
    lcd_puts(display_buffer);
    sprintf(display_buffer,"%-i",demdtr);
    lcd_gotoxy(15,3);                                       
    lcd_puts(display_buffer);
    delay_ms(50);
}

void main(void)
{
// Declare your local variables here
unsigned char k, biennd;

// Input/Output Ports initialization
// Port A initialization
// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
// State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T 
PORTA=0x00;
DDRA=0x00;

// Port B initialization
// Func7=Out Func6=Out Func5=Out Func4=In Func3=In Func2=In Func1=In Func0=In 
// State7=0 State6=0 State5=0 State4=T State3=T State2=T State1=T State0=T 
PORTB=0xff;
DDRB=0xff;

// Port C initialization                         
// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
// State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T 
PORTC=0b00010000;
DDRC=0b00001111;

// Port D initialization
// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
// State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T 
PORTD=0xff;
DDRD=0x00;

// Port E initialization
// Func7=In Func6=In Func5=Out Func4=Out Func3=Out Func2=In Func1=In Func0=In 
// State7=T State6=T State5=0 State4=0 State3=0 State2=T State1=T State0=T 
PORTE=0xff;
DDRE=0xff;

// Port F initialization
// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
// State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T 
PORTF=0x00;
DDRF=0x00;

// Port G initialization
// Func4=In Func3=In Func2=In Func1=In Func0=In 
// State4=T State3=T State2=T State1=T State0=T 
PORTG=0x00;
DDRG=0x00;

// Timer/Counter 0 initialization
// Clock source: System Clock
// Clock value: 10.800 kHz
// Mode: Normal top=0xFF
// OC0 output: Disconnected
ASSR=0x00;
TCCR0=0x07;
TCNT0=0x27;
OCR0=0x00;

// Timer/Counter 1 initialization
// Clock source: System Clock
// Clock value: 11059,200 kHz
// Mode: Fast PWM top=ICR1
// OC1A output: Inverted
// OC1B output: Inverted
// OC1C output: Inverted
// Noise Canceler: Off
// Input Capture on Falling Edge
// Timer1 Overflow Interrupt: Off
// Input Capture Interrupt: Off
// Compare A Match Interrupt: Off
// Compare B Match Interrupt: Off
// Compare C Match Interrupt: Off
TCCR1A=0xFE;
TCCR1B=0x19;
TCNT1H=0x00;
TCNT1L=0x00;
ICR1H=0x00;
ICR1L=0x00;
ICR1=50000;
OCR1AH=0x00;
OCR1AL=0x00;
OCR1BH=0x00;
OCR1BL=0x00;
OCR1CH=0x00;
OCR1CL=0x00;

// Timer/Counter 2 initialization
// Clock source: System Clock
// Clock value: Timer2 Stopped
// Mode: Normal top=0xFF
// OC2 output: Disconnected
TCCR2=0x00;
TCNT2=0x00;
OCR2=0x00;

// Timer/Counter 3 initialization
// Clock source: System Clock
// Clock value: 11059,200 kHz
// Mode: Fast PWM top=ICR3
// OC3A output: Inverted
// OC3B output: Inverted
// OC3C output: Inverted
// Noise Canceler: Off
// Input Capture on Falling Edge
// Timer3 Overflow Interrupt: Off
// Input Capture Interrupt: Off
// Compare A Match Interrupt: Off
// Compare B Match Interrupt: Off
// Compare C Match Interrupt: Off
TCCR3A=0xFE;
TCCR3B=0x19;
TCNT3H=0x00;
TCNT3L=0x00;
ICR3H=0xc3;
ICR3L=0x50;
OCR3AH=0x00;
OCR3AL=0x00;
OCR3BH=0x00;
OCR3BL=0x00;
OCR3CH=0x00;
OCR3CL=0x00;

// External Interrupt(s) initialization
// INT0: Off
// INT1: Off
// INT2: Off
// INT3: Off
// INT4: Off
// INT5: Off
// INT6: Off
// INT7: Off
EICRA=0x00;
EICRB=0x00;
EIMSK=0x00;

// Timer(s)/Counter(s) Interrupt(s) initialization
TIMSK=0x01;

ETIMSK=0x00;

// USART0 initialization
// USART0 disabled
UCSR0B=0x00;

// USART1 initialization
// USART1 disabled
UCSR1B=0x00;

// Analog Comparator initialization
// Analog Comparator: Off
// Analog Comparator Input Capture by Timer/Counter 1: Off
ACSR=0x80;
SFIOR=0x00;

// ADC initialization
// ADC disabled
ADCSRA=0x00;

// SPI initialization
// SPI disabled
SPCR=0x00;

// TWI initialization
// TWI disabled
TWCR=0x00;

// Alphanumeric LCD initialization
// Connections specified in the
// Project|Configure|C Compiler|Libraries|Alphanumeric LCD menu:
// RS - PORTA Bit 0
// RD - PORTA Bit 1
// EN - PORTA Bit 2
// D4 - PORTA Bit 4
// D5 - PORTA Bit 5
// D6 - PORTA Bit 6
// D7 - PORTA Bit 7
// Characters/line: 20
lcd_init(20);

lcd_putsf("NQ Fairy");
for (k=0;k<4;k++) beep();
lcd_clear(); 

// Watchdog Timer initialization
// Watchdog Timer Prescaler: OSC/2048k
#pragma optsize-
WDTCR=0x1F;
WDTCR=0x0F;
#ifdef _OPTIMIZE_SIZE_
#pragma optsize+
#endif

#asm("sei")

hong1=0x00;
hong2=0xff;
hong3=0x7f;
hong4=0xff;

read_am2301();
while (1)
      {  
      if (nhietdo<373)
       {
       kichquat=0;
       
       OCR3BH=0;
       OCR3BL=0;  
        
       OCR3CH=0;
       OCR3CL=0;
       }
      if (nhietdo<=375) biennd=1;
      if ((nhietdo>375)&(nhietdo<378)) biennd=2; 
      if (nhietdo>=378) biennd=3;
      if (kichquat==1) 
        { 
        OCR3BH=0x55;
        OCR3BL=0xf0;  
        
        OCR3CH=0x2e;
        OCR3CL=0xe0;
        } 
      else 
        {
        OCR3BH=0;
        OCR3BL=0;  
        
        OCR3CH=0;
        OCR3CL=0;
        }  
      
      switch (biennd)
        {
            case 1 : 
                OCR1A=40000;
        
                OCR1CH=0x9c;
                OCR1CL=0x40; 
        
                break;
            case 2 :
                OCR1A=0;
        
                OCR1CH=0;
                OCR1CL=0; 
        
                break;
            case 3 :   
                OCR3BH=0x9c;
                OCR3BL=0x40;  
        
                OCR3CH=0x9c;
                OCR3CL=0x40;
                break;
        };
      if (doam < 600) 
        {  
        OCR1B=50000;
        }
      else
        {  
        OCR1B=0;
        }  
       
      kiemtradr();
      hienthilcd();
      
      }
}
