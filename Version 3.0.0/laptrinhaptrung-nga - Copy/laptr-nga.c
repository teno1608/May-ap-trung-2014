/*****************************************************
Chip type               : ATmega8
Program type            : Application
AVR Core Clock frequency: 16.000000 MHz
Memory model            : Small
External RAM size       : 0
Data Stack size         : 256
*****************************************************/

#include <mega8.h>
#include <stdio.h>
#include <stdlib.h>
#include <delay.h>
#include <alcd.h>

eeprom unsigned int hong1,hong2,hong3;
////////////////////////////////////////
unsigned int count_am2301=0, count_key=0, count_delay=0, count_eep=0;
eeprom unsigned int count_egg=0; 
bit set_am2301=0, set_key=0, set_egg=0;
unsigned int ht_count_egg;

// Timer1 overflow interrupt service routine >>>>>> overflow 1ms
interrupt [TIM1_OVF] void timer1_ovf_isr(void)
{
// Reinitialize Timer1 value
TCNT1H=0xFF;
TCNT1L=0x05;
// Place your code here
count_am2301++;
count_key++;
count_delay++;
count_eep++;
if (count_am2301 >= 1500) { set_am2301=1; count_am2301=0;}
if (count_key >= 150) {set_key=1; count_key=0;}
if (count_eep >= 30000) 
    {  
    count_egg++;
    ht_count_egg=count_egg;
    if (count_egg >= 4) {set_egg=1; count_egg=0;}
    count_eep=0;
    } 
}
/////////////////////////////////
void reset_all()
    {
    count_am2301=0;
    count_key=0;  
    count_eep=0; 
    set_am2301=0;
    set_key=0;
    set_egg=0;
    }

//////////////////////////////////
void delay_mms(int time_delay)
    {
    count_delay=0;
    while (count_delay<time_delay) {}
    }  
    
//////////////////////////////////  
#define loa PORTB.0
#define ddrloa DDRB.0
void beep(int ton , int toff , int count)
{
int i;
for (i=0; i<count ;i++)
    {
ddrloa=1;
loa=0;
delay_mms(ton);
loa=1;
delay_mms(toff);
    }
}
/////
/*
void beepe(int ton , int toff , int count)
{
int i;
for (i=0; i<count ;i++)
    {
ddrloa=1;
loa=0;
delay_ms(ton);
loa=1;
delay_ms(toff);
    }
}
*/

//////////////////////////////////////////////////
#define ddrdata DDRD.0
#define portdata PORTD.0
#define data PIND.0
long doamh, doaml, nhietdoh, nhietdol, nhietdo, doam;

void read_am2301()    // Clock value: 1382.400 kHz
     {
     int i,a; 
     #asm("cli")
     TCCR1A=0x00;
     TCCR1B=0x00;
     
     a=128;
     ddrdata=1;
     portdata=0;
     
     //delay_ms(1); 
     TCCR0=0x03;
     TCNT0=0x00;
     while (TCNT0<250) {}  
     TCCR0=0x00;
     TCNT0=0x00;

     portdata=1; 
     
     //delay_us(30);
     TCCR0=0x02;
     TCNT0=0x00;
     while (TCNT0<60) {}
     TCCR0=0x00;
     TCNT0=0x00;
     
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
     
     TCCR1A=0x00;
     TCCR1B=0x03;
     TCNT1H=0xFF;
     TCNT1L=0x05;
     ICR1H=0x00;
     ICR1L=0x00;
     #asm("sei")
     } 
     

///////////////////////////////////////////////////
#define fan_o2 PORTC.2
#define fan_top PORTC.1
#define fan_bottom PORTC.0
#define lamp PORTC.5
#define motor PORTC.4
#define humidifier PORTC.3

#define on 0
#define off 1
eeprom unsigned int nhietdocd=370;
char remember_t=1;

void control_remember()
    {

    switch (remember_t) {
        case 1:
            lamp=off;
            fan_top=off;
            fan_bottom=on;
            fan_o2=off;
            if (nhietdo < nhietdocd+2) remember_t=2;
            break;
        case 2:
            lamp=off;
            fan_top=on;
            fan_bottom=on;
            fan_o2=on;
            if (nhietdo < nhietdocd-2) remember_t=3;
            if (nhietdo >= nhietdocd+3) remember_t=1;
            break;
        case 3:
            lamp=on;
            fan_top=on;
            fan_bottom=on;
            fan_o2=on;
            if (nhietdo > nhietdocd) remember_t=2;
            if (nhietdo >= nhietdocd+3) remember_t=1;
            break; 
        }
    
    }

////////////////////////////////////////////  

#define led PORTB.1
#define button_l PINB.2
#define button_x PINB.3 
#define button_m PINB.4
#define button_s PINB.5
bit button_tl=1, button_tx=1, button_motor=1, button_sw=1;

void scan_key(){
PORTB.2=1; PORTB.3=1; PORTB.4=1; PORTB.5=1;
DDRB=0b00000011;
delay_mms(2);
if(button_l==0) button_tl=0; else button_tl=1;
delay_mms(2); 
if(button_x==0) button_tx=0; else button_tx=1;
delay_mms(2);
if(button_m==0) button_motor=0; else button_motor=1; 
delay_mms(2);
if(button_s==0) button_sw=0; else button_sw=1;
delay_mms(2);
}

void read_key()
{
scan_key();
if (button_tl ==on){
        nhietdocd++;
        beep(10,40,1);
        }
if (button_tx ==on){
        nhietdocd--;
        beep(10,40,1);
        }   
}

///////////////////////////////////////

void lcd_putnum (long so,unsigned char x,unsigned char y)
{
   long a, b, c;
   a = so / 100;
   b = (so - 100 * a) / 10;
   c = so - 100 * a - 10 * b;
   lcd_gotoxy (x, y) ;
   lcd_putchar (a + 48) ;
   lcd_putchar (b + 48) ; 
   lcd_putsf(".");
   lcd_putchar (c + 48) ;
}

void lcd_putnum2 (long so,unsigned char x,unsigned char y)
{
   long a, b, c;
   a = so / 100;
   b = (so - 100 * a) / 10;
   c = so - 100 * a - 10 * b;
   lcd_gotoxy (x, y) ;
   lcd_putchar (a + 48) ;
   lcd_putchar (b + 48) ; 
   lcd_putchar (c + 48) ;
}

//char display_buffer[32]; 
void hienthi_lcd()
{   
    lcd_gotoxy(0,0);  
    lcd_putsf("T: ");
    lcd_putnum(nhietdo,3,0); 
    lcd_gotoxy(7,0); 
    lcd_putsf("  >  ");
    lcd_putnum(nhietdocd,12,0); 
    lcd_gotoxy(0,1);
    lcd_putsf("H: "); 
    lcd_putnum(doam,3,1);
    lcd_gotoxy(7,1); 
    lcd_putsf("      "); 
    lcd_putnum2(ht_count_egg,13,1); 
    
}


///////////////////////////////////////////////
int count_i=0;
eeprom int dttudong=0;

void main(void)
{

// Declare your local variables here
PORTB=0b1111111;
DDRB=0b00000011;

PORTC=0xff;
DDRC=0xff;
 
PORTD=0xff;
DDRD=0x00;

// Timer/Counter 0 initialization
// Clock source: System Clock
// Clock value: Timer 0 Stopped
TCCR0=0x00;
TCNT0=0x00;

// Timer/Counter 1 initialization
// Clock source: System Clock
// Clock value: 250.000 kHz
// Mode: Normal top=0xFFFF
// OC1A output: Discon.
// OC1B output: Discon.
// Noise Canceler: Off
// Input Capture on Falling Edge
// Timer1 Overflow Interrupt: On
// Input Capture Interrupt: Off
// Compare A Match Interrupt: Off
// Compare B Match Interrupt: Off
TCCR1A=0x00;
TCCR1B=0x03;
TCNT1H=0xFF;
TCNT1L=0x05;
ICR1H=0x00;
ICR1L=0x00;
OCR1AH=0x00;
OCR1AL=0x00;
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
TIMSK=0x04;

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
// RS - PORTD Bit 1
// RD - PORTD Bit 2
// EN - PORTD Bit 3
// D4 - PORTD Bit 4
// D5 - PORTD Bit 5
// D6 - PORTD Bit 6
// D7 - PORTD Bit 7
// Characters/line: 16
lcd_init(16);

hong1=0;
hong2=0;
hong3=0;

// Watchdog Timer initialization
// Watchdog Timer Prescaler: OSC/2048k
#pragma optsize-
WDTCR=0x1F;
WDTCR=0x0F;
#ifdef _OPTIMIZE_SIZE_
#pragma optsize+
#endif

// Global enable interrupts
#asm("sei")

//lcd_putsf(">>>>NQ Fairy<<<<");
delay_ms(10);
//beepe(20,80,2);
reset_all();
while (1)
   { 
      if (set_am2301==1) 
        { 
        set_am2301=0;
        read_am2301();    
        control_remember();
        #asm("WDR"); 
        } 
           
      if (set_key==1) 
        {
        read_key(); 
        if (button_motor == on) 
            {
            for (count_i=0; count_i<=7; count_i++)
              {
                delay_mms(50); 
                if(button_m==0) button_motor=on; else button_motor=off;
                delay_mms(50);
                if(button_motor==off) 
                {
                count_i=11;
                if (dttudong==0) dttudong=1; else dttudong=0; 
                } 
              }
            }
          
        if (button_motor == on)
            { 
            lcd_clear();  
            delay_mms(10); 
            lcd_putsf("Dao Trung               Bang Tay");
            motor=on; 
            beep(20,30,1);
            while (button_motor == on)
            { 
            reset_all();
            delay_mms(70); 
            if(button_m==0) button_motor=0; else button_motor=1;
            delay_mms(70);
            #asm("WDR"); 
            }
            delay_mms(10);
            motor=off;
            lcd_clear(); 
            delay_mms(10);
            reset_all();
            }       
        if (dttudong==on) led=1; 
            else {led=0; count_eep=0; set_egg=0; ht_count_egg=0; }  
        hienthi_lcd(); 
        set_key=0;     
        }
      
      if ((set_egg==1)&(dttudong==on))
        {  
         fan_top=fan_bottom=fan_o2=lamp=humidifier=motor=off;
         lcd_clear(); 
         beep(20,30,1);
         lcd_putsf("Dao Trung               Tu Dong ");
         motor=on;
         while (button_sw==1) 
         { 
         delay_mms(50);
         if(button_s==0) button_sw=0; else button_sw=1;
         delay_mms(50);  
         #asm("WDR"); 
         } 
         delay_mms(300);
         while (button_sw==0) 
         { 
         delay_mms(50);
         if(button_s==0) button_sw=0; else button_sw=1;
         delay_mms(50);
         #asm("WDR");  
         } 
         delay_mms(50);
         beep(20,30,1);
         set_egg=0;  
         delay_mms(300);
         motor=off;
         reset_all();
        } 
        
   }
        
}
