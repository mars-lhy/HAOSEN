#include <mega64.h>
#include <delay.h>
#define MAX_OCR0 244
#define MIN_OCR0 11
#define MAX_OCR2 244
#define MIN_OCR2 11
#define RXB8 1
#define TXB8 0
#define UPE 2
#define OVR 3
#define FE 4
#define UDRE 5
#define RXC 7

#define FRAMING_ERROR (1<<FE)
#define PARITY_ERROR (1<<UPE)
#define DATA_OVERRUN (1<<OVR)
#define DATA_REGISTER_EMPTY (1<<UDRE)
#define RX_COMPLETE (1<<RXC)
#define RX_BUFFER_SIZE1 8
#define max_queue_length 20


char rx_buffer1[RX_BUFFER_SIZE1];
char led_flags=0; //value displayed on the 4 leds

 int fs_b[4]={0xF0,0x30,0,0xC0};//port D fullstep sequence  
 int fs_d[4]={0,0x30,0xF0,0xC0};//port D fullstep sequence
 int wd_b[4]={0x80,0x10,0,0}; //port B wavedrive sequence
 int wd_d[4]={0,0,0x20,0x80}; //port D wavedrive sequence
 

int step1,step2; //
int step_delay=25;// delay between the steps
int default_speed=150; //default delay
int proc_time=5000; //time to execute a turn
int mot1_cnt=0; //step counters
int mot2_cnt=0;
int mot1_cnt_lim=250; //step limits
int mot2_cnt_lim=250;
int temp;
bit mot1_dir=0; //0 - bw 1- fw
bit mot2_dir=0; 
bit mot1_fs_mode=1; //0 - wave drive 1- fullstep
bit mot2_fs_mode=1;
bit enable_cnt=0; //flags  
bit enable_sync=0;
 

void mot1_stop(){     
TIMSK=TIMSK &0xFC;
PORTB=PINB&0x9F;
PORTD=PINB&0xAF;  
}

void mot2_stop(){  
TIMSK=TIMSK &0x3F;
PORTB=PINB&0x6F;
PORTD=PINB&0x5F; 
}
           
 
 
void mot1_fs_fw(){
//a mask is used not change the other bits of ports' B and D
if (step1<3) {step1++;
         PORTB=(PINB&0x6F)|(fs_b[step1]&0x90);
         PORTD=(PIND&0x5F)|(fs_d[step1]&0xA0);
       }
else {step1=0;
         PORTB=(PINB&0x6F)|(fs_b[step1]&0x90);
         PORTD=(PIND&0x5F)|(fs_d[step1]&0xA0);  
      }
}
  
void mot2_fs_bw(){
if (step2<3) { step2++;
         PORTB=(PINB&0x9F)|(fs_b[step2]&0x60);
         PORTD=(PIND&0xAF)|(fs_d[step2]&0x50);     
       }
else {step2=0;
         PORTB=(PINB&0x9F)|(fs_b[step2]&0x60);
         PORTD=(PIND&0xAF)|(fs_d[step2]&0x50);   
      }
}


void mot1_wd_fw(){
if (step1<3) { step1++;
         PORTB=(PINB&0x6F)|(fs_b[step1]&0x90);
         PORTD=(PIND&0x5F)|(fs_d[step1]&0xA0);
       }
else {step1=0;
         PORTB=(PINB&0x6F)|(fs_b[step1]&0x90);
         PORTD=(PIND&0x5F)|(fs_d[step1]&0xA0);
     }
}    

void mot2_wd_bw(){
if (step2<3) { step2++;
         PORTB=(PINB&0x9F)|(fs_b[step2]&0x60);
         PORTD=(PIND&0xAF)|(fs_d[step2]&0x50);      
       }
else {step2=0;
         PORTB=(PINB&0x9F)|(fs_b[step2]&0x60);
         PORTD=(PIND&0xAF)|(fs_d[step2]&0x50);    
      }
}                        

void mot1_fs_bw(){
if (step1>0) { step1--;
         PORTB=(PINB&0x6F)|(fs_b[step1]&0x90);
         PORTD=(PIND&0x5F)|(fs_d[step1]&0xA0);   
       }
else {step1=3;
       PORTB=(PINB&0x6F)|(fs_b[step1]&0x90);
       PORTD=(PIND&0x5F)|(fs_d[step1]&0xA0);   
      }
}

void mot2_fs_fw(){
if (step2>0) { step2--;
         PORTB=(PINB&0x9F)|(fs_b[step2]&0x60);
         PORTD=(PIND&0xAF)|(fs_d[step2]&0x50);   
       }
else {step2=3;
         PORTB=(PINB&0x9F)|(fs_b[step2]&0x60);
         PORTD=(PIND&0xAF)|(fs_d[step2]&0x50);   
      }
}


void mot1_wd_bw(){
if (step1>0) { step1--;
         PORTB=(PINB&0x6F)|(fs_b[step1]&0x90);
         PORTD=(PIND&0x5F)|(fs_d[step1]&0xA0);   
       }
else {step1=3;
         PORTB=(PINB&0x6F)|(fs_b[step1]&0x90);
         PORTD=(PIND&0x5F)|(fs_d[step1]&0xA0);   
      }
}           


void mot2_wd_fw(){
if (step2>0) { step2--;
         PORTB=(PINB&0x9F)|(fs_b[step2]&0x60);
         PORTD=(PIND&0xAF)|(fs_d[step2]&0x50);   
       }
else {step2=3;
         PORTB=(PINB&0x9F)|(fs_b[step2]&0x60);
         PORTD=(PIND&0xAF)|(fs_d[step2]&0x50);   
      }
}           


               
//using the transmission that we implemented we have determined that 
//stepping 14 times will make the care move by 1cm 0.39"
void fwd_1cm(){
int c;
for (c=0;c<14;c++){
  mot1_fs_fw();
  mot2_fs_fw();
delay_ms(step_delay);
}
}

void bwd_1cm(){
int c;
for (c=0;c<14;c++){
  mot1_fs_bw();
  mot2_fs_bw();
delay_ms(step_delay);
}
}

void fwd_left(){
OCR0=200;//sets different speeds for the motors
OCR2=140;//this will make the car turn
mot1_fs_mode=1;  mot1_dir=1;
mot2_fs_mode=1;  mot2_dir=1;    
TIMSK=TIMSK |0xc0;//start M2
TIMSK=TIMSK |0x03;//start M1
delay_ms(proc_time);//waits
mot1_stop();mot2_stop();
}  

void fwd_right(){
OCR0=140;  
OCR2=200;
mot1_fs_mode=1;  mot1_dir=1;
mot2_fs_mode=1;  mot2_dir=1;
TIMSK=TIMSK |0xc0;//start M2
TIMSK=TIMSK |0x03;//start M1
delay_ms(proc_time);
mot1_stop();mot2_stop();
}    

void bwd_left(){
OCR0=255;  
OCR2=140;
mot1_fs_mode=1;  mot1_dir=0;
mot2_fs_mode=1;  mot2_dir=0; 
TIMSK=TIMSK |0xc0;//start M2
TIMSK=TIMSK |0x03;//start M1
delay_ms(proc_time);
mot1_stop();mot2_stop();
}     

void bwd_right(){
OCR0=140;
OCR2=255; 
mot1_fs_mode=1;  mot1_dir=0;
mot2_fs_mode=1;  mot2_dir=0;
TIMSK=TIMSK |0xc0;//start M2
TIMSK=TIMSK |0x03;//start M1
delay_ms(proc_time);
mot1_stop();mot2_stop();
}


// USART1 Receiver buffer

#if RX_BUFFER_SIZE1<256
unsigned char rx_wr_index1,rx_rd_index1,rx_counter1;
#else
unsigned int rx_wr_index1,rx_rd_index1,rx_counter1;
#endif

// This flag is set on USART1 Receiver buffer overflow
bit rx_buffer_overflow1;               

// USART1 Transmitter buffer
#define TX_BUFFER_SIZE1 8
char tx_buffer1[TX_BUFFER_SIZE1];

#if TX_BUFFER_SIZE1<256
unsigned char tx_wr_index1,tx_rd_index1,tx_counter1;
#else
unsigned int tx_wr_index1,tx_rd_index1,tx_counter1;
#endif      

void process_msg(char msg);
  #pragma used+
char getchar1(void){
char data;
while (rx_counter1==0);
data=rx_buffer1[rx_rd_index1];
if (++rx_rd_index1 == RX_BUFFER_SIZE1) rx_rd_index1=0;
#asm("cli")
--rx_counter1;
#asm("sei")
return data;
}
#pragma used-

#pragma used+
void putchar1(char c){
while (tx_counter1 == TX_BUFFER_SIZE1);
#asm("cli")
if (tx_counter1 || ((UCSR1A & DATA_REGISTER_EMPTY)==0))
   {
   tx_buffer1[tx_wr_index1]=c;
   if (++tx_wr_index1 == TX_BUFFER_SIZE1) tx_wr_index1=0;
   ++tx_counter1;
   }
else
   UDR1=c;
#asm("sei")
}
#pragma used-

// Timer 0 overflow interrupt service routine
interrupt [TIM0_OVF] void timer0_ovf_isr(void)
{
}

// Timer 0 output compare interrupt service routine
interrupt [TIM0_COMP] void timer0_comp_isr(void)
{   PORTE.5=~PINE.5;     
    if ((enable_cnt)&&(mot1_cnt<mot1_cnt_lim)) mot1_cnt++;
    if (mot1_dir) if (mot1_fs_mode) mot1_fs_fw();
                  else mot1_wd_fw();
    else if (mot1_fs_mode) mot1_fs_bw();
         else  mot1_wd_bw();  
}


 
interrupt [TIM1_OVF] void timer1_ovf_isr(void){
 PORTE=(PINE&0x0F)|(led_flags&0xF0); //porte=flags0000; 
 TCNT1H=0xff;
 TCNT1L=0x00;
} 

// Timer 2 overflow interrupt service routine
interrupt [TIM2_OVF] void timer2_ovf_isr(void)
{
}

// Timer 2 output compare interrupt service routine
interrupt [TIM2_COMP] void timer2_comp_isr(void){                        
  PORTE.4=~PINE.4;  
  if ((enable_cnt)&&(mot2_cnt<mot2_cnt_lim)) mot2_cnt++;
  if (mot2_dir) if (mot2_fs_mode) mot2_fs_fw();
                else mot2_wd_fw();
  else if (mot2_fs_mode) mot2_fs_bw();
       else  mot2_wd_bw();     
}
     


// USART1 Receiver interrupt service routine
interrupt [USART1_RXC] void usart1_rx_isr(void)
{
char status,data,a;
status=UCSR1A;
data=UDR1;
if ((status & (FRAMING_ERROR | PARITY_ERROR | DATA_OVERRUN))==0)
   {
   rx_buffer1[rx_wr_index1]=data;
   if (++rx_wr_index1 == RX_BUFFER_SIZE1) rx_wr_index1=0;
   if (++rx_counter1 == RX_BUFFER_SIZE1)
      {
      rx_counter1=0;
      rx_buffer_overflow1=1;
      
      };  
   a=getchar1();
   process_msg(a);   
   };
}




// USART1 Transmitter interrupt service routine
interrupt [USART1_TXC] void usart1_tx_isr(void)
{
if (tx_counter1)
   {
   --tx_counter1;
   UDR1=tx_buffer1[tx_rd_index1];
   if (++tx_rd_index1 == TX_BUFFER_SIZE1) tx_rd_index1=0;
   };
}
       
interrupt [EXT_INT7] void ext_int7_isr(void)

{    
mot1_dir=1;
mot2_dir=1;
mot1_fs_mode=1;
mot2_fs_mode=1;
OCR0=200;
OCR2=140; 
mot1_cnt=mot2_cnt=0;
enable_cnt=1;
TIMSK=TIMSK |0x03;//enable timer0 for the motor 1
TIMSK=TIMSK |0xc0;//enable timer2 for the motor 2
enable_sync=1;       
}        

interrupt [EXT_INT6] void ext_int6_isr(void)
{    
mot1_dir=1;
mot2_dir=1;
mot1_fs_mode=1;
mot2_fs_mode=1;
OCR2=200;
OCR0=140; 
mot1_cnt=mot2_cnt=0;
enable_cnt=1;
TIMSK=TIMSK |0x03;//enable timer0 for the motor 1
TIMSK=TIMSK |0xc0;//enable timer2 for the motor 2
enable_sync=1;      
}


void main(void)
{
PORTA=0x00;
DDRA=0x00;

PORTB=0x00;
DDRB=0xF0;

PORTC=0x00;
DDRC=0x00;

PORTD=0x00;
DDRD=0xf0;

PORTE=0xc0;
DDRE=0x3F;

PORTF=0x00;
DDRF=0x00;

PORTG=0x00;
DDRG=0x00;

// Timer/Counter 0 initialization
// Clock source: System Clock
// Clock value: 7.813 kHz
// Mode: CTC top=OCR0
// OC0 output: Disconnected
ASSR=0x00;
TCCR0=0x0F;
TCNT0=0x00;
OCR0=150;

// Timer/Counter 1 initialization
// Clock source: System Clock
// Clock value: 7.813 kHz
// Mode: Normal top=FFFFh
// OC1A output: Discon.
// OC1B output: Discon.
// OC1C output: Discon.
// Noise Canceler: Off
// Input Capture on Falling Edge
// Timer 1 Overflow Interrupt: On
// Input Capture Interrupt: Off
// Compare A Match Interrupt: Off
// Compare B Match Interrupt: Off
// Compare C Match Interrupt: Off
TCCR1A=0x00;
TCCR1B=0x05;
TCNT1H=0xF5;
TCNT1L=0x00;
ICR1H=0x00;
ICR1L=0x00;
OCR1AH=0x00;
OCR1AL=0x00;
OCR1BH=0x00;
OCR1BL=0x00;
OCR1CH=0x00;
OCR1CL=0x00;

// Timer/Counter 2 initialization
// Clock source: System Clock
// Clock value: 7.813 kHz
// Mode: CTC top=OCR0
// OC0 output: Disconnected
TCCR2=0x0D;
TCNT2=0x00;
OCR2=150;

// Timer/Counter 3 initialization
// Clock source: System Clock
// Clock value: Timer 3 Stopped
// Mode: Normal top=FFFFh
// Noise Canceler: Off
// Input Capture on Falling Edge
// OC3A output: Discon.
// OC3B output: Discon.
// OC3C output: Discon.
// Timer 3 Overflow Interrupt: Off
// Input Capture Interrupt: Off
// Compare A Match Interrupt: Off
// Compare B Match Interrupt: Off
// Compare C Match Interrupt: Off
TCCR3A=0x00;
TCCR3B=0x00;
TCNT3H=0x00;
TCNT3L=0x00;
ICR3H=0x00;
ICR3L=0x00;
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
// INT7 Mode: Falling Edge
EICRA=0x00;
EICRB=0xF0;
EIMSK=0xC0;
EIFR=0xC0;

// Timer(s)/Counter(s) Interrupt(s) initialization
TIMSK=0x00;  //timer 0 1
ETIMSK=0x00;

// USART1 initialization
// Communication Parameters: 8 Data, 1 Stop, No Parity
// USART1 Receiver: On
// USART1 Transmitter: On
// USART1 Mode: Asynchronous
// USART1 Baud rate: 9600
UCSR1A=0x00;
UCSR1B=0xD8;
UCSR1C=0x06;
UBRR1H=0x00;
UBRR1L=0x33; 

// Analog Comparator initialization
// Analog Comparator: Off
// Analog Comparator Input Capture by Timer/Counter 1: Off
ACSR=0x80;
SFIOR=0x00;

// Global enable interrupts
#asm("sei")

while (1){  
if ((enable_sync)&&( (mot1_cnt>=mot1_cnt_lim) ||(mot1_cnt>=mot1_cnt_lim) )) {
enable_sync=0;
mot1_dir=!mot1_dir;
mot2_dir=!mot2_dir;
OCR0=OCR2=default_speed;
}
};//end while



}//end main
                    

void process_msg(char msg){   
 if (msg==0xC0) led_flags=0;       
 if (msg==0xC1) led_flags=0x10;
 if (msg==0xC2) led_flags=0x20;
 if (msg==0xC3) led_flags=0x30;
 if (msg==0xCF) led_flags=0xF0;
 if (msg==0xC4) TIMSK=TIMSK &0x3F;//stop dimming ..disable t2 OC OF  00 on bits 7,6
 if (msg==0xC5) TIMSK=TIMSK |0xC0;//start dimming   
 if (msg==0xC8) TIMSK=TIMSK &0xFB;//disable updating leds ..disable t1 OF intr  0 on bit 2
 if (msg==0xC9) TIMSK=TIMSK |0x04;//enable updating leds
       
 if (msg==0xD0) {mot1_stop();}        
 if (msg==0xE0) {mot2_stop();}                  
 if (msg==0xF0) {mot1_stop();mot2_stop();}  
                 
 if (msg==0xD1) {mot1_fs_fw();} 
 if (msg==0xD2) {mot1_fs_bw();} 
 if (msg==0xD3) {mot1_wd_fw();} 
 if (msg==0xD4) {mot1_wd_bw();}  

 if (msg==0xE1) {mot2_fs_fw();} 
 if (msg==0xE2) {mot2_fs_bw();} 
 if (msg==0xE3) {mot2_wd_fw();} 
 if (msg==0xE4) {mot2_wd_bw();} 
                 
 if (msg==0xDA) {if (OCR0<MAX_OCR0) OCR0++;} // step delay++
 if (msg==0xDD) {if (OCR0>MIN_OCR0) OCR0-- ;} // step delay--
 if (msg==0xEA) {if (OCR2<MAX_OCR2) OCR2++;} //LM step delay++
 if (msg==0xED) {if (OCR2>MIN_OCR2) OCR2-- ;} //LM step delay--
 if (msg==0xFA) {if (proc_time<65000)proc_time+=500; 
                }     
 if (msg==0xFD) {if (proc_time>1000)proc_time+=500;
                }                                    
 if (msg==0xCA) {if ((OCR0<MAX_OCR0)&&(OCR2<MAX_OCR0)){OCR0+=10; OCR2+=10;};
                } ;    
 if (msg==0xCD) {if ((OCR0>MIN_OCR0)&&(OCR2>MIN_OCR0)) {OCR0-=10; OCR2-=10;};
                };                                    
                


 if (msg==0xDF) {mot1_fs_mode=1;mot1_dir=1;//set step mode fullstep and direction fwd
                 TIMSK=TIMSK |0x03;//enable timer0 for the left motor 
                 }   
 if (msg==0xDB) {mot1_fs_mode=1;mot1_dir=0;//set step mode fs and direction back
                 TIMSK=TIMSK |0x03;//enable timer0 OC intr for the left motor 
                 }  
 if (msg==0xDE) {mot1_fs_mode=0;  mot1_dir=1;     //wave-drive fwd
                   TIMSK=TIMSK |0x03;//enable timer0 OC intr for the left motor 
                   }   
 if (msg==0xDC) {mot1_fs_mode=0;  mot1_dir=0;    //wave-drive bkwd
                TIMSK=TIMSK |0x03;//enable timer0 OC intr for the left motor 
                }  

 if (msg==0xEF) {mot2_fs_mode=1;  mot2_dir=1;TIMSK=TIMSK |0xc0;}//set step mode, direction and enable timer2   
 if (msg==0xEB) {mot2_fs_mode=1;  mot2_dir=0;TIMSK=TIMSK |0xc0;} //set step mode fs and direction back  
 if (msg==0xEE) {mot2_fs_mode=0;  mot2_dir=1;TIMSK=TIMSK |0xc0;} //wave-drive fwd  
 if (msg==0xEC) {mot2_fs_mode=0;  mot2_dir=0;TIMSK=TIMSK |0xc0;} //wave-drive bkwd

 if (msg==0xFF) {fwd_1cm();
                mot1_stop();}         //fwd speed=LM1 speed
 if (msg==0xFB) {bwd_1cm();
                 mot2_stop();}  
 if (msg==0xF5) {            //fwd 1 step
                 mot1_fs_fw();
                 mot2_fs_fw();
                 delay_ms(50);  
                 mot1_stop();
                 mot2_stop();}                   
                 
 if (msg==0xF6) {mot1_fs_bw();//bwd 1 step
                 mot2_fs_bw();
                 delay_ms(50);
                 mot1_stop();
                 mot2_stop();}  
 if (msg==0xF7) {mot1_fs_mode=1;mot1_dir=1;//set step mode fullstep and direction fwd
                 mot2_fs_mode=1;mot2_dir=1;
                 OCR2=OCR0; //M2 speed =  m1 speed
                TIMSK=TIMSK |0x03;//enable timer0 for the motor 1
                TIMSK=TIMSK |0xc0;//enable timer2 for the motor 2
 }  
 if (msg==0xF8) {OCR2=OCR0;
                 mot1_fs_mode=1;mot1_dir=0;//set step mode fs and direction back
                 mot2_fs_mode=1;mot2_dir=0;                 
                 TIMSK=TIMSK |0x03;//enable timer0 OC intr for the left motor 
                 TIMSK=TIMSK |0xc0;//enable timer2 for the motor 2
                }     
 if (msg==0xF1) {fwd_left();
                }  
 if (msg==0xF2) {fwd_right();
                }   
 if (msg==0xF3) {bwd_right();
                }                                  
 if (msg==0xF4) {bwd_left();
                }  
}