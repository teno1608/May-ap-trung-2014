/*****************************************************
Chip type               : ATmega8
Program type            : Application
AVR Core Clock frequency: 16.000000 MHz
Memory model            : Small
External RAM size       : 0
Data Stack size         : 256
*****************************************************/

#include <mega8.h>

// Alphanumeric LCD Module functions
#include <alcd.h>
#include <delay.h>
#include <DHT.h>
#include <DHT.cpp>
// Declare your global variables here

#define data PIND.0

volatile long num, i, a, nhietdo, doam, kiemtra;
volatile long doamh, doaml, nhietdoh, nhietdol, kiemtrah, kiemtral;
void read_am2301()
     {
     doamh=doaml=nhietdoh=nhietdol=0;
     a=128;
     DDRD=0xff; 
     PORTD.0=0;   
     delay_us(1000);  
     PORTD.0=1; 
     delay_us(30);
     PORTD.0=0;
     DDRD=0b11111110; 
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
          TCNT0=0x00;
          TCCR0=0x02;
          while(data==1)
               {
               }
          if (TCNT0 > 96) doamh = doamh + a ; 
          a=a/2;
          TCNT0=0x00;
          TCCR0=0x00;
          while (data==0)
               {
               }
          } 
     a=128;
     for (i=0;i<8;i++)
          {
          TCNT0=0x00;
          TCCR0=0x02;
          while(data==1)
               {    
               }
          if (TCNT0 > 96) doaml = doaml + a ;
          a=a/2;
          TCNT0=0x00;
          TCCR0=0x00;
          while (data==0)
               {
               }
          }
     a=128;    
     for (i=0;i<8;i++)
          {
          TCNT0=0x00;
          TCCR0=0x02;
          while(data==1)
               {
               }
          if (TCNT0 > 96) nhietdoh = nhietdoh + a ;
          a=a/2;
          TCNT0=0x00;
          TCCR0=0x00;
          while (data==0)
               {
               }
          }
     a=128;    
     for (i=0;i<8;i++)
          {
          TCNT0=0x00;
          TCCR0=0x02;
          while(data==1)
               {
               }
          if (TCNT0 > 96) nhietdol = nhietdol + a ;
          a=a/2;
          TCNT0=0x00;
          TCCR0=0x00;
          while (data==0)
               {
               }
          }
     a=128; 
     for (i=0;i<8;i++)
          {
          TCNT0=0x00;
          TCCR0=0x02;
          while(data==1)
               {
               }
          if (TCNT0 > 96)kiemtrah = kiemtrah + a ;
          a=a/2;
          TCNT0=0x00;
          TCCR0=0x00;
          while (data==0)
               {
               }
          }
     a=128;    

     nhietdo = nhietdoh*256 + nhietdol; 
     doam = doamh*256 + doaml;
     /*
     lcd_gotoxy(0,0);
     lcd_putsf("Nhiet Do: ");
     lcd_putnum(nhietdo,10,0); 
     lcd_gotoxy(0,1);
     lcd_putsf("Do Am: ");        
     lcd_putnum(doam,10,1);
     */
     DDRD=0xff;
     PORTD.0=1;
     } 

void lcd_putnum (long so,unsigned char x,unsigned char y)
{
   long a, b, c;
   a = so / 100;
   b = (so - 100 * a) / 10;
   c = so - 100 * a - 10 * b;
   lcd_gotoxy (x, y) ;
   lcd_putchar (a + 48) ;
   lcd_putchar (b + 48) ; 
   //lcd_putsf(".");
   lcd_putchar (c + 48) ;
}
     
interrupt [TIM1_COMPA] void timer1_compa_isr(void)
{
// Place your code here

//read_am2301();
}     

void main(void)
{
// Declare your local variables here

// Input/Output Ports initialization
// Port B initialization
// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
// State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T 
PORTB=0xff;
DDRB=0x00;

// Port C initialization
// Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
// State6=T State5=T State4=T State3=T State2=T State1=T State0=T 
PORTC=0xff;
DDRC=0b11111100;

// Port D initialization
// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
// State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T 
PORTD=0x00;
DDRD=0x00;

// Timer/Counter 0 initialization
// Clock source: System Clock
// Clock value: Timer 0 Stopped
TCCR0=0x00;
TCNT0=0x00;

// Timer/Counter 1 initialization
// Clock source: System Clock
// Clock value: 15.625 kHz
// Mode: CTC top=OCR1A
// OC1A output: Discon.
// OC1B output: Discon.
// Noise Canceler: Off
// Input Capture on Falling Edge
// Timer1 Overflow Interrupt: Off
// Input Capture Interrupt: Off
// Compare A Match Interrupt: On
// Compare B Match Interrupt: Off
TCCR1A=0x00;
TCCR1B=0x0D;
TCNT1H=0x00;
TCNT1L=0x00;
ICR1H=0x00;
ICR1L=0x00;
OCR1AH=0x3D;
OCR1AL=0x09;
OCR1BH=0x00;
OCR1BL=0x00;

// Timer/Counter 2 initialization
// Clock source: System Clock
// Clock value: Timer2 Stopped
// Mode: Normal top=0xFF
// OC2 output: Disconnected
ASSR=0x00;
TCCR2=0x00;
TCNT2=0x00;
OCR2=0x00;

// External Interrupt(s) initialization
// INT0: Off
// INT1: Off
MCUCR=0x00;

// Timer(s)/Counter(s) Interrupt(s) initialization
TIMSK=0x10;

// USART initialization
// USART disabled
UCSRB=0x00;

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
// RS - PORTD Bit 7
// RD - PORTD Bit 6
// EN - PORTD Bit 5
// D4 - PORTD Bit 4
// D5 - PORTD Bit 3
// D6 - PORTD Bit 2
// D7 - PORTD Bit 1
// Characters/line: 16
lcd_init(16);

while (1)
      {
      // Place your code here 
        delay_ms(1000);
        read_am2301();
        kiemtra=nhietdoh+nhietdol+doamh+doaml;
        if (kiemtra == kiemtrah) 
        {
        lcd_gotoxy(0,0); 
        lcd_putnum (nhietdoh,0,0);
        
        lcd_putnum (nhietdol,5,0); 
        
        lcd_putnum (nhietdo,11,0);
        
        lcd_gotoxy(0,1);       
        lcd_putnum (doamh,0,1);
         
        lcd_putnum (doaml,5,1);
        
        lcd_putnum (doam,11,1);
          
        }
        else 
        {
        
        lcd_gotoxy(0,0); 
        lcd_putnum (kiemtra,0,0);
        lcd_gotoxy(0,1);       
        lcd_putnum (kiemtrah,0,1);
        }

      }
}
