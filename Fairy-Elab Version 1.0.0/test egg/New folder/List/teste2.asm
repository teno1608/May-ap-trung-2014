
;CodeVisionAVR C Compiler V2.05.0 Professional
;(C) Copyright 1998-2010 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Chip type                : ATmega64
;Program type             : Application
;Clock frequency          : 16.000000 MHz
;Memory model             : Small
;Optimize for             : Size
;(s)printf features       : int, width
;(s)scanf features        : int, width
;External RAM size        : 0
;Data Stack size          : 1024 byte(s)
;Heap size                : 0 byte(s)
;Promote 'char' to 'int'  : Yes
;'char' is unsigned       : Yes
;8 bit enums              : Yes
;global 'const' stored in FLASH: No
;Enhanced core instructions    : On
;Smart register allocation     : On
;Automatic register allocation : On

	#pragma AVRPART ADMIN PART_NAME ATmega64
	#pragma AVRPART MEMORY PROG_FLASH 65536
	#pragma AVRPART MEMORY EEPROM 2048
	#pragma AVRPART MEMORY INT_SRAM SIZE 4351
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x100

	#define CALL_SUPPORTED 1

	.LISTMAC
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU USR=0xB
	.EQU UDR=0xC
	.EQU SPSR=0xE
	.EQU SPDR=0xF
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU EECR=0x1C
	.EQU EEDR=0x1D
	.EQU EEARL=0x1E
	.EQU EEARH=0x1F
	.EQU WDTCR=0x21
	.EQU MCUCR=0x35
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F
	.EQU XMCRA=0x6D
	.EQU XMCRB=0x6C

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.EQU __SRAM_START=0x0100
	.EQU __SRAM_END=0x10FF
	.EQU __DSTACK_SIZE=0x0400
	.EQU __HEAP_SIZE=0x0000
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ANDI R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ORI  R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __CLRD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+(@1))
	LDI  R31,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	LDI  R22,BYTE3(2*@0+(@1))
	LDI  R23,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+(@2))
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+(@3))
	LDI  R@1,HIGH(@2+(@3))
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+(@3))
	LDI  R@1,HIGH(@2*2+(@3))
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+(@1)
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+(@1)
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	LDS  R22,@0+(@1)+2
	LDS  R23,@0+(@1)+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+(@2)
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+(@3)
	LDS  R@1,@2+(@3)+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+(@1)
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	LDS  R24,@0+(@1)+2
	LDS  R25,@0+(@1)+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+(@1),R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	STS  @0+(@1)+2,R22
	STS  @0+(@1)+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+(@1),R0
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+(@1),R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+(@1),R@2
	STS  @0+(@1)+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTBSR
	STD  Y+@1,R@0
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	CALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMRDW
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R26,SPL
	IN   R27,SPH
	ADIW R26,@0+1
	LD   R30,X+
	LD   R31,X
	.ENDM

	.MACRO __GETD1STACK
	IN   R26,SPL
	IN   R27,SPH
	ADIW R26,@0+1
	LD   R30,X+
	LD   R31,X+
	LD   R22,X
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOVW R26,R@0
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	CALL __PUTDP1
	.ENDM


	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOVW R30,R0
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOVW R26,R0
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __GETBRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __MULBRR
	MULS R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRRU
	MUL  R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRR0
	MULS R@0,R@1
	.ENDM

	.MACRO __MULBRRU0
	MUL  R@0,R@1
	.ENDM

	.MACRO __MULBNWRU
	LDI  R26,@2
	MUL  R26,R@0
	MOVW R30,R0
	MUL  R26,R@1
	ADD  R31,R0
	.ENDM

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF _demcb=R4
	.DEF _demwdog=R6
	.DEF _demquat=R8
	.DEF _demdtr=R10
	.DEF _select=R13
	.DEF __lcd_x=R12

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	JMP  __RESET
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  _timer0_ovf_isr
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00

_tbl10_G101:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G101:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0

;REGISTER BIT VARIABLES INITIALIZATION
__REG_BIT_VARS:
	.DW  0x0000

_0x74:
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0
_0x0:
	.DB  0x46,0x61,0x69,0x72,0x79,0x2D,0x45,0x6C
	.DB  0x61,0x62,0x0,0x4E,0x68,0x69,0x65,0x74
	.DB  0x20,0x44,0x6F,0x3A,0x25,0x36,0x69,0x2E
	.DB  0x25,0x2D,0x75,0x25,0x63,0x43,0xA,0x44
	.DB  0x6F,0x20,0x41,0x6D,0x3A,0x25,0x39,0x69
	.DB  0x2E,0x25,0x2D,0x75,0x25,0x25,0x0,0x44
	.DB  0x61,0x6F,0x3A,0x20,0x25,0x2D,0x69,0x0
	.DB  0x25,0x2D,0x75,0x0,0x4E,0x51,0x20,0x46
	.DB  0x61,0x69,0x72,0x79,0x0
_0x2000003:
	.DB  0x80,0xC0
_0x2040060:
	.DB  0x1
_0x2040000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0,0x49,0x4E,0x46
	.DB  0x0

__GLOBAL_INI_TBL:
	.DW  0x01
	.DW  0x02
	.DW  __REG_BIT_VARS*2

	.DW  0x0B
	.DW  _0x5C
	.DW  _0x0*2

	.DW  0x0A
	.DW  0x04
	.DW  _0x74*2

	.DW  0x02
	.DW  __base_y_G100
	.DW  _0x2000003*2

	.DW  0x01
	.DW  __seed_G102
	.DW  _0x2040060*2

_0xFFFFFFFF:
	.DW  0

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  MCUCR,R31
	OUT  MCUCR,R30
	STS  XMCRB,R30

;DISABLE WATCHDOG
	LDI  R31,0x18
	OUT  WDTCR,R31
	OUT  WDTCR,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(__CLEAR_SRAM_SIZE)
	LDI  R25,HIGH(__CLEAR_SRAM_SIZE)
	LDI  R26,LOW(__SRAM_START)
	LDI  R27,HIGH(__SRAM_START)
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
	BRNE __CLEAR_SRAM

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM  R24,Z+
	LPM  R25,Z+
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM  R26,Z+
	LPM  R27,Z+
	LPM  R0,Z+
	LPM  R1,Z+
	MOVW R22,R30
	MOVW R30,R0
__GLOBAL_INI_LOOP:
	LPM  R0,Z+
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOVW R30,R22
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30
	LDI  R30,HIGH(__SRAM_END-__HEAP_SIZE)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)
	LDI  R29,HIGH(__SRAM_START+__DSTACK_SIZE)

	JMP  _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x500

	.CSEG
;/*****************************************************
;
;Chip type               : ATmega64
;Program type            : Application
;AVR Core Clock frequency: 16.000000 MHz
;Memory model            : Small
;External RAM size       : 0
;Data Stack size         : 1024
;*****************************************************/
;
;#include <mega64.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x20
	.EQU __sm_mask=0x1C
	.EQU __sm_powerdown=0x10
	.EQU __sm_powersave=0x18
	.EQU __sm_standby=0x14
	.EQU __sm_ext_standby=0x1C
	.EQU __sm_adc_noise_red=0x08
	.SET power_ctrl_reg=mcucr
	#endif
;
;// Alphanumeric LCD Module functions
;#include <alcd.h>
;#include <stdio.h>
;#include <stdlib.h>
;#include <delay.h>
;// Declare your global variables here
;
;void beep()
; 0000 0015 {

	.CSEG
_beep:
; 0000 0016 DDRC.7=1;
	SBI  0x14,7
; 0000 0017 PORTC.7=0;
	CBI  0x15,7
; 0000 0018 delay_ms(30);
	LDI  R30,LOW(30)
	LDI  R31,HIGH(30)
	CALL SUBOPT_0x0
; 0000 0019 PORTC.7=1;
	SBI  0x15,7
; 0000 001A delay_ms(70);
	LDI  R30,LOW(70)
	LDI  R31,HIGH(70)
	RJMP _0x20C0004
; 0000 001B }
;
;///////////////////////////////////////
;#define ddrdata DDRC.6
;#define portdata PORTC.6
;#define data PINC.6
;long doamh, doaml, nhietdoh, nhietdol, nhietdo, doam;
;void read_am2301()   // Clock value: 1382.400 kHz
; 0000 0023      {
_read_am2301:
; 0000 0024      int i,a;
; 0000 0025      a=128;
	CALL __SAVELOCR4
;	i -> R16,R17
;	a -> R18,R19
	__GETWRN 18,19,128
; 0000 0026      ddrdata=1;
	SBI  0x14,6
; 0000 0027      portdata=0;
	CBI  0x15,6
; 0000 0028      delay_us(1000);
	__DELAY_USW 4000
; 0000 0029      portdata=1;
	SBI  0x15,6
; 0000 002A      delay_us(30);
	__DELAY_USB 160
; 0000 002B      portdata=0;
	CBI  0x15,6
; 0000 002C      ddrdata=0;
	CBI  0x14,6
; 0000 002D      while(data==0)
_0x13:
	SBIS 0x13,6
; 0000 002E           {
; 0000 002F           }
	RJMP _0x13
; 0000 0030      while(data==1)
_0x16:
	SBIC 0x13,6
; 0000 0031           {
; 0000 0032           }
	RJMP _0x16
; 0000 0033      while(data==0)
_0x19:
	SBIS 0x13,6
; 0000 0034           {
; 0000 0035           }
	RJMP _0x19
; 0000 0036      a=128;
	CALL SUBOPT_0x1
; 0000 0037      for (i=0;i<8;i++)
_0x1D:
	__CPWRN 16,17,8
	BRGE _0x1E
; 0000 0038           {
; 0000 0039           TCNT2=0x00;
	CALL SUBOPT_0x2
; 0000 003A           TCCR2=0x02;
; 0000 003B           while(data==1)
_0x1F:
	SBIC 0x13,6
; 0000 003C                {
; 0000 003D                }
	RJMP _0x1F
; 0000 003E           if (TCNT2 > 96) doamh = doamh + a ;
	IN   R30,0x24
	CPI  R30,LOW(0x61)
	BRLO _0x22
	MOVW R30,R18
	LDS  R26,_doamh
	LDS  R27,_doamh+1
	LDS  R24,_doamh+2
	LDS  R25,_doamh+3
	CALL SUBOPT_0x3
	CALL SUBOPT_0x4
; 0000 003F           a=a/2;
_0x22:
	CALL SUBOPT_0x5
; 0000 0040           TCNT2=0x00;
; 0000 0041           TCCR2=0x00;
; 0000 0042           while (data==0)
_0x23:
	SBIS 0x13,6
; 0000 0043                {
; 0000 0044                }
	RJMP _0x23
; 0000 0045           }
	__ADDWRN 16,17,1
	RJMP _0x1D
_0x1E:
; 0000 0046      a=128;
	CALL SUBOPT_0x1
; 0000 0047      for (i=0;i<8;i++)
_0x27:
	__CPWRN 16,17,8
	BRGE _0x28
; 0000 0048           {
; 0000 0049           TCNT2=0x00;
	CALL SUBOPT_0x2
; 0000 004A           TCCR2=0x02;
; 0000 004B           while(data==1)
_0x29:
	SBIC 0x13,6
; 0000 004C                {
; 0000 004D                }
	RJMP _0x29
; 0000 004E           if (TCNT2 > 96) doaml = doaml + a ;
	IN   R30,0x24
	CPI  R30,LOW(0x61)
	BRLO _0x2C
	MOVW R30,R18
	CALL SUBOPT_0x6
	CALL SUBOPT_0x3
	CALL SUBOPT_0x7
; 0000 004F           a=a/2;
_0x2C:
	CALL SUBOPT_0x5
; 0000 0050           TCNT2=0x00;
; 0000 0051           TCCR2=0x00;
; 0000 0052           while (data==0)
_0x2D:
	SBIS 0x13,6
; 0000 0053                {
; 0000 0054                }
	RJMP _0x2D
; 0000 0055           }
	__ADDWRN 16,17,1
	RJMP _0x27
_0x28:
; 0000 0056      a=128;
	CALL SUBOPT_0x1
; 0000 0057      for (i=0;i<8;i++)
_0x31:
	__CPWRN 16,17,8
	BRGE _0x32
; 0000 0058           {
; 0000 0059           TCNT2=0x00;
	CALL SUBOPT_0x2
; 0000 005A           TCCR2=0x02;
; 0000 005B           while(data==1)
_0x33:
	SBIC 0x13,6
; 0000 005C                {
; 0000 005D                }
	RJMP _0x33
; 0000 005E           if (TCNT2 > 96 ) nhietdoh = nhietdoh + a ;
	IN   R30,0x24
	CPI  R30,LOW(0x61)
	BRLO _0x36
	MOVW R30,R18
	LDS  R26,_nhietdoh
	LDS  R27,_nhietdoh+1
	LDS  R24,_nhietdoh+2
	LDS  R25,_nhietdoh+3
	CALL SUBOPT_0x3
	CALL SUBOPT_0x8
; 0000 005F           a=a/2;
_0x36:
	CALL SUBOPT_0x5
; 0000 0060           TCNT2=0x00;
; 0000 0061           TCCR2=0x00;
; 0000 0062           while (data==0)
_0x37:
	SBIS 0x13,6
; 0000 0063                {
; 0000 0064                }
	RJMP _0x37
; 0000 0065           }
	__ADDWRN 16,17,1
	RJMP _0x31
_0x32:
; 0000 0066      a=128;
	CALL SUBOPT_0x1
; 0000 0067      for (i=0;i<8;i++)
_0x3B:
	__CPWRN 16,17,8
	BRGE _0x3C
; 0000 0068           {
; 0000 0069           TCNT2=0x00;
	CALL SUBOPT_0x2
; 0000 006A           TCCR2=0x02;
; 0000 006B           while(data==1)
_0x3D:
	SBIC 0x13,6
; 0000 006C                {
; 0000 006D                }
	RJMP _0x3D
; 0000 006E           if (TCNT2 > 96) nhietdol = nhietdol + a ;
	IN   R30,0x24
	CPI  R30,LOW(0x61)
	BRLO _0x40
	MOVW R30,R18
	CALL SUBOPT_0x9
	CALL SUBOPT_0x3
	CALL SUBOPT_0xA
; 0000 006F           a=a/2;
_0x40:
	CALL SUBOPT_0x5
; 0000 0070           TCNT2=0x00;
; 0000 0071           TCCR2=0x00;
; 0000 0072           while (data==0)
_0x41:
	SBIS 0x13,6
; 0000 0073                {
; 0000 0074                }
	RJMP _0x41
; 0000 0075           }
	__ADDWRN 16,17,1
	RJMP _0x3B
_0x3C:
; 0000 0076      nhietdo = nhietdoh*256 + nhietdol;
	LDS  R30,_nhietdoh
	LDS  R31,_nhietdoh+1
	LDS  R22,_nhietdoh+2
	LDS  R23,_nhietdoh+3
	CALL SUBOPT_0xB
	CALL SUBOPT_0x9
	CALL __ADDD12
	STS  _nhietdo,R30
	STS  _nhietdo+1,R31
	STS  _nhietdo+2,R22
	STS  _nhietdo+3,R23
; 0000 0077      doam = doamh*256 + doaml;
	LDS  R30,_doamh
	LDS  R31,_doamh+1
	LDS  R22,_doamh+2
	LDS  R23,_doamh+3
	CALL SUBOPT_0xB
	CALL SUBOPT_0x6
	CALL __ADDD12
	STS  _doam,R30
	STS  _doam+1,R31
	STS  _doam+2,R22
	STS  _doam+3,R23
; 0000 0078      doamh=doaml=nhietdoh=nhietdol=0;
	__GETD1N 0x0
	CALL SUBOPT_0xA
	CALL SUBOPT_0x8
	CALL SUBOPT_0x7
	CALL SUBOPT_0x4
; 0000 0079      portdata=1;
	SBI  0x15,6
; 0000 007A      }
	CALL __LOADLOCR4
	ADIW R28,4
	RET
;
;///////////////////////////////////////
;#define daotrung PORTB.4
;#define ctht1 PIND.6
;#define ctht2 PIND.7
;
;eeprom char hong1=0x00, hong2=0xff, hong3=0x7f, hong4=0xff;
;eeprom int solandtr=0;
;eeprom unsigned char dempdtr=0;
;
;int demcb=0, demwdog=0, demquat=0, demdtr=0 ;
;bit kichquat=0;
;
;interrupt [TIM0_OVF] void timer0_ovf_isr(void)
; 0000 0089 {
_timer0_ovf_isr:
	ST   -Y,R0
	ST   -Y,R1
	ST   -Y,R15
	ST   -Y,R22
	ST   -Y,R23
	ST   -Y,R24
	ST   -Y,R25
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 008A // Reinitialize Timer 0 value
; 0000 008B TCNT0=0x27;
	LDI  R30,LOW(39)
	OUT  0x32,R30
; 0000 008C // Place your code here
; 0000 008D demdtr++;
	MOVW R30,R10
	ADIW R30,1
	MOVW R10,R30
; 0000 008E demcb++;
	MOVW R30,R4
	ADIW R30,1
	MOVW R4,R30
; 0000 008F demwdog++;
	MOVW R30,R6
	ADIW R30,1
	MOVW R6,R30
; 0000 0090 demquat++;
	MOVW R30,R8
	ADIW R30,1
	MOVW R8,R30
; 0000 0091 if (demwdog >=50)
	LDI  R30,LOW(50)
	LDI  R31,HIGH(50)
	CP   R6,R30
	CPC  R7,R31
	BRLT _0x46
; 0000 0092     {
; 0000 0093     demwdog=0;
	CLR  R6
	CLR  R7
; 0000 0094     #asm("WDR") ;
	WDR
; 0000 0095     }
; 0000 0096 if (demcb >=100)
_0x46:
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CP   R4,R30
	CPC  R5,R31
	BRLT _0x47
; 0000 0097     {
; 0000 0098     demcb=0;
	CLR  R4
	CLR  R5
; 0000 0099     read_am2301();
	RCALL _read_am2301
; 0000 009A     };
_0x47:
; 0000 009B 
; 0000 009C switch (demquat)
	MOVW R30,R8
; 0000 009D     {
; 0000 009E     case 3 :
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x4B
; 0000 009F         kichquat=1;
	SET
	BLD  R2,0
; 0000 00A0         break;
	RJMP _0x4A
; 0000 00A1     case 600 :
_0x4B:
	CPI  R30,LOW(0x258)
	LDI  R26,HIGH(0x258)
	CPC  R31,R26
	BRNE _0x4C
; 0000 00A2         kichquat=0;
	CLT
	BLD  R2,0
; 0000 00A3         break;
	RJMP _0x4A
; 0000 00A4     case 5000 :
_0x4C:
	CPI  R30,LOW(0x1388)
	LDI  R26,HIGH(0x1388)
	CPC  R31,R26
	BRNE _0x4A
; 0000 00A5         demquat=0;
	CLR  R8
	CLR  R9
; 0000 00A6         break;
; 0000 00A7     }
_0x4A:
; 0000 00A8 
; 0000 00A9 }
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	LD   R25,Y+
	LD   R24,Y+
	LD   R23,Y+
	LD   R22,Y+
	LD   R15,Y+
	LD   R1,Y+
	LD   R0,Y+
	RETI
;
;//////////////////////////////////
;char select=0;
;void kiemtradr()
; 0000 00AE {
_kiemtradr:
; 0000 00AF     if (demdtr >=9000)
	LDI  R30,LOW(9000)
	LDI  R31,HIGH(9000)
	CP   R10,R30
	CPC  R11,R31
	BRLT _0x4E
; 0000 00B0     {
; 0000 00B1     demdtr=0;
	CLR  R10
	CLR  R11
; 0000 00B2     dempdtr++;
	CALL SUBOPT_0xC
	SUBI R30,-LOW(1)
	CALL __EEPROMWRB
	SUBI R30,LOW(1)
; 0000 00B3     if (dempdtr >=60)
	CALL SUBOPT_0xC
	CPI  R30,LOW(0x3C)
	BRLO _0x4F
; 0000 00B4         {
; 0000 00B5         dempdtr=0;
	LDI  R26,LOW(_dempdtr)
	LDI  R27,HIGH(_dempdtr)
	LDI  R30,LOW(0)
	CALL __EEPROMWRB
; 0000 00B6         solandtr++;
	LDI  R26,LOW(_solandtr)
	LDI  R27,HIGH(_solandtr)
	CALL __EEPROMRDW
	ADIW R30,1
	CALL __EEPROMWRW
	SBIW R30,1
; 0000 00B7         if ((ctht1==0)|((ctht1==1)&(ctht1==1))) {select=1;}
	LDI  R26,0
	SBIC 0x10,6
	LDI  R26,1
	LDI  R30,LOW(0)
	CALL __EQB12
	MOV  R1,R30
	CALL SUBOPT_0xD
	MOV  R0,R30
	CALL SUBOPT_0xD
	AND  R30,R0
	OR   R30,R1
	BREQ _0x50
	LDI  R30,LOW(1)
	MOV  R13,R30
; 0000 00B8         if (ctht2==0) {select=2;}
_0x50:
	SBIC 0x10,7
	RJMP _0x51
	LDI  R30,LOW(2)
	MOV  R13,R30
; 0000 00B9         daotrung=0;
_0x51:
	CBI  0x18,4
; 0000 00BA         beep();
	RCALL _beep
; 0000 00BB         }
; 0000 00BC     }
_0x4F:
; 0000 00BD       if (select==1) {if (ctht2==0) {beep(); daotrung=1; select=0;}}
_0x4E:
	LDI  R30,LOW(1)
	CP   R30,R13
	BRNE _0x54
	SBIC 0x10,7
	RJMP _0x55
	RCALL _beep
	SBI  0x18,4
	CLR  R13
_0x55:
; 0000 00BE       if (select==2) {if (ctht1==0) {beep(); daotrung=1; select=0;}}
_0x54:
	LDI  R30,LOW(2)
	CP   R30,R13
	BRNE _0x58
	SBIC 0x10,6
	RJMP _0x59
	RCALL _beep
	SBI  0x18,4
	CLR  R13
_0x59:
; 0000 00BF }
_0x58:
	RET
;
;/////////////////////////////////
;char display_buffer[80];
;void hienthilcd()
; 0000 00C4 {
_hienthilcd:
; 0000 00C5     lcd_clear();
	CALL _lcd_clear
; 0000 00C6     lcd_gotoxy(5,0);
	LDI  R30,LOW(5)
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	CALL _lcd_gotoxy
; 0000 00C7     lcd_puts("Fairy-Elab");
	__POINTW1MN _0x5C,0
	CALL SUBOPT_0xE
; 0000 00C8     sprintf(display_buffer,"Nhiet Do:%6i.%-u%cC\nDo Am:%9i.%-u%%",
; 0000 00C9     nhietdo/10,abs(nhietdo%10),0xdf,doam/10,abs(doam%10),0xdf);
	__POINTW1FN _0x0,11
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0xF
	CALL __DIVD21
	CALL __PUTPARD1
	CALL SUBOPT_0xF
	CALL SUBOPT_0x10
	CALL SUBOPT_0x11
	CALL __DIVD21
	CALL __PUTPARD1
	CALL SUBOPT_0x11
	CALL SUBOPT_0x10
	LDI  R24,24
	CALL _sprintf
	ADIW R28,28
; 0000 00CA     lcd_gotoxy(0,1);
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(1)
	CALL SUBOPT_0x12
; 0000 00CB     lcd_puts(display_buffer);
; 0000 00CC     sprintf(display_buffer,"Dao: %-i",solandtr);
	__POINTW1FN _0x0,47
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(_solandtr)
	LDI  R27,HIGH(_solandtr)
	CALL __EEPROMRDW
	CALL SUBOPT_0x13
; 0000 00CD     lcd_gotoxy(0,3);
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(3)
	CALL SUBOPT_0x12
; 0000 00CE     lcd_puts(display_buffer);
; 0000 00CF     sprintf(display_buffer,"%-u",dempdtr);
	__POINTW1FN _0x0,56
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0xC
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	LDI  R24,4
	CALL _sprintf
	ADIW R28,8
; 0000 00D0     lcd_gotoxy(10,3);
	LDI  R30,LOW(10)
	ST   -Y,R30
	LDI  R30,LOW(3)
	CALL SUBOPT_0x12
; 0000 00D1     lcd_puts(display_buffer);
; 0000 00D2     sprintf(display_buffer,"%-i",demdtr);
	__POINTW1FN _0x0,52
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R10
	CALL SUBOPT_0x13
; 0000 00D3     lcd_gotoxy(15,3);
	LDI  R30,LOW(15)
	ST   -Y,R30
	LDI  R30,LOW(3)
	ST   -Y,R30
	CALL _lcd_gotoxy
; 0000 00D4     lcd_puts(display_buffer);
	LDI  R30,LOW(_display_buffer)
	LDI  R31,HIGH(_display_buffer)
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_puts
; 0000 00D5     delay_ms(50);
	LDI  R30,LOW(50)
	LDI  R31,HIGH(50)
_0x20C0004:
	ST   -Y,R31
	ST   -Y,R30
	CALL _delay_ms
; 0000 00D6 }
	RET

	.DSEG
_0x5C:
	.BYTE 0xB
;
;void main(void)
; 0000 00D9 {

	.CSEG
_main:
; 0000 00DA // Declare your local variables here
; 0000 00DB unsigned char k, biennd;
; 0000 00DC 
; 0000 00DD // Input/Output Ports initialization
; 0000 00DE // Port A initialization
; 0000 00DF // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 00E0 // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 00E1 PORTA=0x00;
;	k -> R17
;	biennd -> R16
	LDI  R30,LOW(0)
	OUT  0x1B,R30
; 0000 00E2 DDRA=0x00;
	OUT  0x1A,R30
; 0000 00E3 
; 0000 00E4 // Port B initialization
; 0000 00E5 // Func7=Out Func6=Out Func5=Out Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 00E6 // State7=0 State6=0 State5=0 State4=T State3=T State2=T State1=T State0=T
; 0000 00E7 PORTB=0xff;
	LDI  R30,LOW(255)
	OUT  0x18,R30
; 0000 00E8 DDRB=0xff;
	OUT  0x17,R30
; 0000 00E9 
; 0000 00EA // Port C initialization
; 0000 00EB // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 00EC // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 00ED PORTC=0b00010000;
	LDI  R30,LOW(16)
	OUT  0x15,R30
; 0000 00EE DDRC=0b00001111;
	LDI  R30,LOW(15)
	OUT  0x14,R30
; 0000 00EF 
; 0000 00F0 // Port D initialization
; 0000 00F1 // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 00F2 // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 00F3 PORTD=0xff;
	LDI  R30,LOW(255)
	OUT  0x12,R30
; 0000 00F4 DDRD=0x00;
	LDI  R30,LOW(0)
	OUT  0x11,R30
; 0000 00F5 
; 0000 00F6 // Port E initialization
; 0000 00F7 // Func7=In Func6=In Func5=Out Func4=Out Func3=Out Func2=In Func1=In Func0=In
; 0000 00F8 // State7=T State6=T State5=0 State4=0 State3=0 State2=T State1=T State0=T
; 0000 00F9 PORTE=0xff;
	LDI  R30,LOW(255)
	OUT  0x3,R30
; 0000 00FA DDRE=0xff;
	OUT  0x2,R30
; 0000 00FB 
; 0000 00FC // Port F initialization
; 0000 00FD // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 00FE // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 00FF PORTF=0x00;
	LDI  R30,LOW(0)
	STS  98,R30
; 0000 0100 DDRF=0x00;
	STS  97,R30
; 0000 0101 
; 0000 0102 // Port G initialization
; 0000 0103 // Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 0104 // State4=T State3=T State2=T State1=T State0=T
; 0000 0105 PORTG=0x00;
	STS  101,R30
; 0000 0106 DDRG=0x00;
	STS  100,R30
; 0000 0107 
; 0000 0108 // Timer/Counter 0 initialization
; 0000 0109 // Clock source: System Clock
; 0000 010A // Clock value: 10.800 kHz
; 0000 010B // Mode: Normal top=0xFF
; 0000 010C // OC0 output: Disconnected
; 0000 010D ASSR=0x00;
	OUT  0x30,R30
; 0000 010E TCCR0=0x07;
	LDI  R30,LOW(7)
	OUT  0x33,R30
; 0000 010F TCNT0=0x27;
	LDI  R30,LOW(39)
	OUT  0x32,R30
; 0000 0110 OCR0=0x00;
	LDI  R30,LOW(0)
	OUT  0x31,R30
; 0000 0111 
; 0000 0112 // Timer/Counter 1 initialization
; 0000 0113 // Clock source: System Clock
; 0000 0114 // Clock value: 11059,200 kHz
; 0000 0115 // Mode: Fast PWM top=ICR1
; 0000 0116 // OC1A output: Inverted
; 0000 0117 // OC1B output: Inverted
; 0000 0118 // OC1C output: Inverted
; 0000 0119 // Noise Canceler: Off
; 0000 011A // Input Capture on Falling Edge
; 0000 011B // Timer1 Overflow Interrupt: Off
; 0000 011C // Input Capture Interrupt: Off
; 0000 011D // Compare A Match Interrupt: Off
; 0000 011E // Compare B Match Interrupt: Off
; 0000 011F // Compare C Match Interrupt: Off
; 0000 0120 TCCR1A=0xFE;
	LDI  R30,LOW(254)
	OUT  0x2F,R30
; 0000 0121 TCCR1B=0x19;
	LDI  R30,LOW(25)
	OUT  0x2E,R30
; 0000 0122 TCNT1H=0x00;
	LDI  R30,LOW(0)
	OUT  0x2D,R30
; 0000 0123 TCNT1L=0x00;
	OUT  0x2C,R30
; 0000 0124 ICR1H=0x00;
	OUT  0x27,R30
; 0000 0125 ICR1L=0x00;
	OUT  0x26,R30
; 0000 0126 ICR1=50000;
	LDI  R30,LOW(50000)
	LDI  R31,HIGH(50000)
	OUT  0x26+1,R31
	OUT  0x26,R30
; 0000 0127 OCR1AH=0x00;
	LDI  R30,LOW(0)
	OUT  0x2B,R30
; 0000 0128 OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 0129 OCR1BH=0x00;
	OUT  0x29,R30
; 0000 012A OCR1BL=0x00;
	OUT  0x28,R30
; 0000 012B OCR1CH=0x00;
	CALL SUBOPT_0x14
; 0000 012C OCR1CL=0x00;
; 0000 012D 
; 0000 012E // Timer/Counter 2 initialization
; 0000 012F // Clock source: System Clock
; 0000 0130 // Clock value: Timer2 Stopped
; 0000 0131 // Mode: Normal top=0xFF
; 0000 0132 // OC2 output: Disconnected
; 0000 0133 TCCR2=0x00;
	LDI  R30,LOW(0)
	OUT  0x25,R30
; 0000 0134 TCNT2=0x00;
	OUT  0x24,R30
; 0000 0135 OCR2=0x00;
	OUT  0x23,R30
; 0000 0136 
; 0000 0137 // Timer/Counter 3 initialization
; 0000 0138 // Clock source: System Clock
; 0000 0139 // Clock value: 11059,200 kHz
; 0000 013A // Mode: Fast PWM top=ICR3
; 0000 013B // OC3A output: Inverted
; 0000 013C // OC3B output: Inverted
; 0000 013D // OC3C output: Inverted
; 0000 013E // Noise Canceler: Off
; 0000 013F // Input Capture on Falling Edge
; 0000 0140 // Timer3 Overflow Interrupt: Off
; 0000 0141 // Input Capture Interrupt: Off
; 0000 0142 // Compare A Match Interrupt: Off
; 0000 0143 // Compare B Match Interrupt: Off
; 0000 0144 // Compare C Match Interrupt: Off
; 0000 0145 TCCR3A=0xFE;
	LDI  R30,LOW(254)
	STS  139,R30
; 0000 0146 TCCR3B=0x19;
	LDI  R30,LOW(25)
	STS  138,R30
; 0000 0147 TCNT3H=0x00;
	LDI  R30,LOW(0)
	STS  137,R30
; 0000 0148 TCNT3L=0x00;
	STS  136,R30
; 0000 0149 ICR3H=0xc3;
	LDI  R30,LOW(195)
	STS  129,R30
; 0000 014A ICR3L=0x50;
	LDI  R30,LOW(80)
	STS  128,R30
; 0000 014B OCR3AH=0x00;
	LDI  R30,LOW(0)
	STS  135,R30
; 0000 014C OCR3AL=0x00;
	STS  134,R30
; 0000 014D OCR3BH=0x00;
	CALL SUBOPT_0x15
; 0000 014E OCR3BL=0x00;
; 0000 014F OCR3CH=0x00;
; 0000 0150 OCR3CL=0x00;
; 0000 0151 
; 0000 0152 // External Interrupt(s) initialization
; 0000 0153 // INT0: Off
; 0000 0154 // INT1: Off
; 0000 0155 // INT2: Off
; 0000 0156 // INT3: Off
; 0000 0157 // INT4: Off
; 0000 0158 // INT5: Off
; 0000 0159 // INT6: Off
; 0000 015A // INT7: Off
; 0000 015B EICRA=0x00;
	LDI  R30,LOW(0)
	STS  106,R30
; 0000 015C EICRB=0x00;
	OUT  0x3A,R30
; 0000 015D EIMSK=0x00;
	OUT  0x39,R30
; 0000 015E 
; 0000 015F // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 0160 TIMSK=0x01;
	LDI  R30,LOW(1)
	OUT  0x37,R30
; 0000 0161 
; 0000 0162 ETIMSK=0x00;
	LDI  R30,LOW(0)
	STS  125,R30
; 0000 0163 
; 0000 0164 // USART0 initialization
; 0000 0165 // USART0 disabled
; 0000 0166 UCSR0B=0x00;
	OUT  0xA,R30
; 0000 0167 
; 0000 0168 // USART1 initialization
; 0000 0169 // USART1 disabled
; 0000 016A UCSR1B=0x00;
	STS  154,R30
; 0000 016B 
; 0000 016C // Analog Comparator initialization
; 0000 016D // Analog Comparator: Off
; 0000 016E // Analog Comparator Input Capture by Timer/Counter 1: Off
; 0000 016F ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 0170 SFIOR=0x00;
	LDI  R30,LOW(0)
	OUT  0x20,R30
; 0000 0171 
; 0000 0172 // ADC initialization
; 0000 0173 // ADC disabled
; 0000 0174 ADCSRA=0x00;
	OUT  0x6,R30
; 0000 0175 
; 0000 0176 // SPI initialization
; 0000 0177 // SPI disabled
; 0000 0178 SPCR=0x00;
	OUT  0xD,R30
; 0000 0179 
; 0000 017A // TWI initialization
; 0000 017B // TWI disabled
; 0000 017C TWCR=0x00;
	STS  116,R30
; 0000 017D 
; 0000 017E // Alphanumeric LCD initialization
; 0000 017F // Connections specified in the
; 0000 0180 // Project|Configure|C Compiler|Libraries|Alphanumeric LCD menu:
; 0000 0181 // RS - PORTA Bit 0
; 0000 0182 // RD - PORTA Bit 1
; 0000 0183 // EN - PORTA Bit 2
; 0000 0184 // D4 - PORTA Bit 4
; 0000 0185 // D5 - PORTA Bit 5
; 0000 0186 // D6 - PORTA Bit 6
; 0000 0187 // D7 - PORTA Bit 7
; 0000 0188 // Characters/line: 20
; 0000 0189 lcd_init(20);
	LDI  R30,LOW(20)
	ST   -Y,R30
	RCALL _lcd_init
; 0000 018A 
; 0000 018B lcd_putsf("NQ Fairy");
	__POINTW1FN _0x0,60
	ST   -Y,R31
	ST   -Y,R30
	RCALL _lcd_putsf
; 0000 018C for (k=0;k<4;k++) beep();
	LDI  R17,LOW(0)
_0x5E:
	CPI  R17,4
	BRSH _0x5F
	RCALL _beep
	SUBI R17,-1
	RJMP _0x5E
_0x5F:
; 0000 018D lcd_clear();
	RCALL _lcd_clear
; 0000 018E 
; 0000 018F // Watchdog Timer initialization
; 0000 0190 // Watchdog Timer Prescaler: OSC/2048k
; 0000 0191 #pragma optsize-
; 0000 0192 WDTCR=0x1F;
	LDI  R30,LOW(31)
	OUT  0x21,R30
; 0000 0193 WDTCR=0x0F;
	LDI  R30,LOW(15)
	OUT  0x21,R30
; 0000 0194 #ifdef _OPTIMIZE_SIZE_
; 0000 0195 #pragma optsize+
; 0000 0196 #endif
; 0000 0197 
; 0000 0198 #asm("sei")
	sei
; 0000 0199 
; 0000 019A hong1=0x00;
	LDI  R26,LOW(_hong1)
	LDI  R27,HIGH(_hong1)
	LDI  R30,LOW(0)
	CALL __EEPROMWRB
; 0000 019B hong2=0xff;
	LDI  R26,LOW(_hong2)
	LDI  R27,HIGH(_hong2)
	LDI  R30,LOW(255)
	CALL __EEPROMWRB
; 0000 019C hong3=0x7f;
	LDI  R26,LOW(_hong3)
	LDI  R27,HIGH(_hong3)
	LDI  R30,LOW(127)
	CALL __EEPROMWRB
; 0000 019D hong4=0xff;
	LDI  R26,LOW(_hong4)
	LDI  R27,HIGH(_hong4)
	LDI  R30,LOW(255)
	CALL __EEPROMWRB
; 0000 019E 
; 0000 019F read_am2301();
	RCALL _read_am2301
; 0000 01A0 while (1)
_0x60:
; 0000 01A1       {
; 0000 01A2       if (nhietdo<373)
	CALL SUBOPT_0x16
	__CPD2N 0x175
	BRGE _0x63
; 0000 01A3        {
; 0000 01A4        kichquat=0;
	CLT
	BLD  R2,0
; 0000 01A5 
; 0000 01A6        OCR3BH=0;
	CALL SUBOPT_0x15
; 0000 01A7        OCR3BL=0;
; 0000 01A8 
; 0000 01A9        OCR3CH=0;
; 0000 01AA        OCR3CL=0;
; 0000 01AB        }
; 0000 01AC       if (nhietdo<=365) biennd=1;
_0x63:
	CALL SUBOPT_0x16
	__CPD2N 0x16E
	BRGE _0x64
	LDI  R16,LOW(1)
; 0000 01AD       if ((nhietdo>365)&(nhietdo<368)) biennd=2;
_0x64:
	CALL SUBOPT_0x16
	__GETD1N 0x16D
	CALL __GTD12
	MOV  R0,R30
	CALL SUBOPT_0x16
	__GETD1N 0x170
	CALL __LTD12
	AND  R30,R0
	BREQ _0x65
	LDI  R16,LOW(2)
; 0000 01AE       if (nhietdo>=368) biennd=3;
_0x65:
	CALL SUBOPT_0x16
	__CPD2N 0x170
	BRLT _0x66
	LDI  R16,LOW(3)
; 0000 01AF       if (kichquat==1)
_0x66:
	SBRS R2,0
	RJMP _0x67
; 0000 01B0         {
; 0000 01B1         OCR3BH=0x55;
	LDI  R30,LOW(85)
	STS  133,R30
; 0000 01B2         OCR3BL=0xf0;
	LDI  R30,LOW(240)
	STS  132,R30
; 0000 01B3 
; 0000 01B4         OCR3CH=0x2e;
	LDI  R30,LOW(46)
	STS  131,R30
; 0000 01B5         OCR3CL=0xe0;
	LDI  R30,LOW(224)
	RJMP _0x72
; 0000 01B6         }
; 0000 01B7       else
_0x67:
; 0000 01B8         {
; 0000 01B9         OCR3BH=0;
	LDI  R30,LOW(0)
	STS  133,R30
; 0000 01BA         OCR3BL=0;
	STS  132,R30
; 0000 01BB 
; 0000 01BC         OCR3CH=0;
	STS  131,R30
; 0000 01BD         OCR3CL=0;
_0x72:
	STS  130,R30
; 0000 01BE         }
; 0000 01BF 
; 0000 01C0       switch (biennd)
	MOV  R30,R16
	LDI  R31,0
; 0000 01C1         {
; 0000 01C2             case 1 :
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x6C
; 0000 01C3                 OCR1A=40000;
	LDI  R30,LOW(40000)
	LDI  R31,HIGH(40000)
	OUT  0x2A+1,R31
	OUT  0x2A,R30
; 0000 01C4 
; 0000 01C5                 OCR1CH=0x9c;
	LDI  R30,LOW(156)
	STS  121,R30
; 0000 01C6                 OCR1CL=0x40;
	LDI  R30,LOW(64)
	STS  120,R30
; 0000 01C7 
; 0000 01C8                 break;
	RJMP _0x6B
; 0000 01C9             case 2 :
_0x6C:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x6D
; 0000 01CA                 OCR1A=0;
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	OUT  0x2A+1,R31
	OUT  0x2A,R30
; 0000 01CB 
; 0000 01CC                 OCR1CH=0;
	CALL SUBOPT_0x14
; 0000 01CD                 OCR1CL=0;
; 0000 01CE 
; 0000 01CF                 break;
	RJMP _0x6B
; 0000 01D0             case 3 :
_0x6D:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x6B
; 0000 01D1                 OCR3BH=0x9c;
	LDI  R30,LOW(156)
	STS  133,R30
; 0000 01D2                 OCR3BL=0x40;
	LDI  R30,LOW(64)
	STS  132,R30
; 0000 01D3 
; 0000 01D4                 OCR3CH=0x9c;
	LDI  R30,LOW(156)
	STS  131,R30
; 0000 01D5                 OCR3CL=0x40;
	LDI  R30,LOW(64)
	STS  130,R30
; 0000 01D6                 break;
; 0000 01D7         };
_0x6B:
; 0000 01D8       if (doam < 750)
	LDS  R26,_doam
	LDS  R27,_doam+1
	LDS  R24,_doam+2
	LDS  R25,_doam+3
	__CPD2N 0x2EE
	BRGE _0x6F
; 0000 01D9         {
; 0000 01DA         OCR1B=50000;
	LDI  R30,LOW(50000)
	LDI  R31,HIGH(50000)
	RJMP _0x73
; 0000 01DB         }
; 0000 01DC       else
_0x6F:
; 0000 01DD         {
; 0000 01DE         OCR1B=0;
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
_0x73:
	OUT  0x28+1,R31
	OUT  0x28,R30
; 0000 01DF         }
; 0000 01E0 
; 0000 01E1       kiemtradr();
	RCALL _kiemtradr
; 0000 01E2       hienthilcd();
	RCALL _hienthilcd
; 0000 01E3 
; 0000 01E4       }
	RJMP _0x60
; 0000 01E5 }
_0x71:
	RJMP _0x71
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x20
	.EQU __sm_mask=0x1C
	.EQU __sm_powerdown=0x10
	.EQU __sm_powersave=0x18
	.EQU __sm_standby=0x14
	.EQU __sm_ext_standby=0x1C
	.EQU __sm_adc_noise_red=0x08
	.SET power_ctrl_reg=mcucr
	#endif

	.DSEG

	.CSEG
__lcd_write_nibble_G100:
	LD   R30,Y
	ANDI R30,LOW(0x10)
	BREQ _0x2000004
	SBI  0x1B,4
	RJMP _0x2000005
_0x2000004:
	CBI  0x1B,4
_0x2000005:
	LD   R30,Y
	ANDI R30,LOW(0x20)
	BREQ _0x2000006
	SBI  0x1B,5
	RJMP _0x2000007
_0x2000006:
	CBI  0x1B,5
_0x2000007:
	LD   R30,Y
	ANDI R30,LOW(0x40)
	BREQ _0x2000008
	SBI  0x1B,6
	RJMP _0x2000009
_0x2000008:
	CBI  0x1B,6
_0x2000009:
	LD   R30,Y
	ANDI R30,LOW(0x80)
	BREQ _0x200000A
	SBI  0x1B,7
	RJMP _0x200000B
_0x200000A:
	CBI  0x1B,7
_0x200000B:
	__DELAY_USB 11
	SBI  0x1B,2
	__DELAY_USB 27
	CBI  0x1B,2
	__DELAY_USB 27
	RJMP _0x20C0002
__lcd_write_data:
	LD   R30,Y
	ST   -Y,R30
	RCALL __lcd_write_nibble_G100
    ld    r30,y
    swap  r30
    st    y,r30
	LD   R30,Y
	ST   -Y,R30
	RCALL __lcd_write_nibble_G100
	__DELAY_USW 200
	RJMP _0x20C0002
_lcd_gotoxy:
	LD   R30,Y
	LDI  R31,0
	SUBI R30,LOW(-__base_y_G100)
	SBCI R31,HIGH(-__base_y_G100)
	LD   R30,Z
	LDD  R26,Y+1
	ADD  R30,R26
	ST   -Y,R30
	RCALL __lcd_write_data
	LDD  R12,Y+1
	LD   R30,Y
	STS  __lcd_y,R30
	ADIW R28,2
	RET
_lcd_clear:
	LDI  R30,LOW(2)
	CALL SUBOPT_0x17
	LDI  R30,LOW(12)
	ST   -Y,R30
	RCALL __lcd_write_data
	LDI  R30,LOW(1)
	CALL SUBOPT_0x17
	LDI  R30,LOW(0)
	STS  __lcd_y,R30
	MOV  R12,R30
	RET
_lcd_putchar:
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BREQ _0x2000011
	LDS  R30,__lcd_maxx
	CP   R12,R30
	BRLO _0x2000010
_0x2000011:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDS  R30,__lcd_y
	SUBI R30,-LOW(1)
	STS  __lcd_y,R30
	ST   -Y,R30
	RCALL _lcd_gotoxy
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BRNE _0x2000013
	RJMP _0x20C0002
_0x2000013:
_0x2000010:
	INC  R12
	SBI  0x1B,0
	LD   R30,Y
	ST   -Y,R30
	RCALL __lcd_write_data
	CBI  0x1B,0
	RJMP _0x20C0002
_lcd_puts:
	ST   -Y,R17
_0x2000014:
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LD   R30,X+
	STD  Y+1,R26
	STD  Y+1+1,R27
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x2000016
	ST   -Y,R17
	RCALL _lcd_putchar
	RJMP _0x2000014
_0x2000016:
	RJMP _0x20C0003
_lcd_putsf:
	ST   -Y,R17
_0x2000017:
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	ADIW R30,1
	STD  Y+1,R30
	STD  Y+1+1,R31
	SBIW R30,1
	LPM  R30,Z
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x2000019
	ST   -Y,R17
	RCALL _lcd_putchar
	RJMP _0x2000017
_0x2000019:
_0x20C0003:
	LDD  R17,Y+0
	ADIW R28,3
	RET
_lcd_init:
	SBI  0x1A,4
	SBI  0x1A,5
	SBI  0x1A,6
	SBI  0x1A,7
	SBI  0x1A,2
	SBI  0x1A,0
	SBI  0x1A,1
	CBI  0x1B,2
	CBI  0x1B,0
	CBI  0x1B,1
	LD   R30,Y
	STS  __lcd_maxx,R30
	SUBI R30,-LOW(128)
	__PUTB1MN __base_y_G100,2
	LD   R30,Y
	SUBI R30,-LOW(192)
	__PUTB1MN __base_y_G100,3
	LDI  R30,LOW(20)
	LDI  R31,HIGH(20)
	CALL SUBOPT_0x0
	CALL SUBOPT_0x18
	CALL SUBOPT_0x18
	CALL SUBOPT_0x18
	LDI  R30,LOW(32)
	ST   -Y,R30
	RCALL __lcd_write_nibble_G100
	__DELAY_USW 400
	LDI  R30,LOW(40)
	ST   -Y,R30
	RCALL __lcd_write_data
	LDI  R30,LOW(4)
	ST   -Y,R30
	RCALL __lcd_write_data
	LDI  R30,LOW(133)
	ST   -Y,R30
	RCALL __lcd_write_data
	LDI  R30,LOW(6)
	ST   -Y,R30
	RCALL __lcd_write_data
	RCALL _lcd_clear
_0x20C0002:
	ADIW R28,1
	RET
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x20
	.EQU __sm_mask=0x1C
	.EQU __sm_powerdown=0x10
	.EQU __sm_powersave=0x18
	.EQU __sm_standby=0x14
	.EQU __sm_ext_standby=0x1C
	.EQU __sm_adc_noise_red=0x08
	.SET power_ctrl_reg=mcucr
	#endif

	.CSEG
_put_buff_G101:
	ST   -Y,R17
	ST   -Y,R16
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,2
	CALL __GETW1P
	SBIW R30,0
	BREQ _0x2020010
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,4
	CALL __GETW1P
	MOVW R16,R30
	SBIW R30,0
	BREQ _0x2020012
	__CPWRN 16,17,2
	BRLO _0x2020013
	MOVW R30,R16
	SBIW R30,1
	MOVW R16,R30
	__PUTW1SNS 2,4
_0x2020012:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,2
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	SBIW R30,1
	LDD  R26,Y+4
	STD  Z+0,R26
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	CALL __GETW1P
	TST  R31
	BRMI _0x2020014
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
_0x2020014:
_0x2020013:
	RJMP _0x2020015
_0x2020010:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	ST   X+,R30
	ST   X,R31
_0x2020015:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,5
	RET
__print_G101:
	SBIW R28,6
	CALL __SAVELOCR6
	LDI  R17,0
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   X+,R30
	ST   X,R31
_0x2020016:
	LDD  R30,Y+18
	LDD  R31,Y+18+1
	ADIW R30,1
	STD  Y+18,R30
	STD  Y+18+1,R31
	SBIW R30,1
	LPM  R30,Z
	MOV  R18,R30
	CPI  R30,0
	BRNE PC+3
	JMP _0x2020018
	MOV  R30,R17
	CPI  R30,0
	BRNE _0x202001C
	CPI  R18,37
	BRNE _0x202001D
	LDI  R17,LOW(1)
	RJMP _0x202001E
_0x202001D:
	CALL SUBOPT_0x19
_0x202001E:
	RJMP _0x202001B
_0x202001C:
	CPI  R30,LOW(0x1)
	BRNE _0x202001F
	CPI  R18,37
	BRNE _0x2020020
	CALL SUBOPT_0x19
	RJMP _0x20200C9
_0x2020020:
	LDI  R17,LOW(2)
	LDI  R20,LOW(0)
	LDI  R16,LOW(0)
	CPI  R18,45
	BRNE _0x2020021
	LDI  R16,LOW(1)
	RJMP _0x202001B
_0x2020021:
	CPI  R18,43
	BRNE _0x2020022
	LDI  R20,LOW(43)
	RJMP _0x202001B
_0x2020022:
	CPI  R18,32
	BRNE _0x2020023
	LDI  R20,LOW(32)
	RJMP _0x202001B
_0x2020023:
	RJMP _0x2020024
_0x202001F:
	CPI  R30,LOW(0x2)
	BRNE _0x2020025
_0x2020024:
	LDI  R21,LOW(0)
	LDI  R17,LOW(3)
	CPI  R18,48
	BRNE _0x2020026
	ORI  R16,LOW(128)
	RJMP _0x202001B
_0x2020026:
	RJMP _0x2020027
_0x2020025:
	CPI  R30,LOW(0x3)
	BREQ PC+3
	JMP _0x202001B
_0x2020027:
	CPI  R18,48
	BRLO _0x202002A
	CPI  R18,58
	BRLO _0x202002B
_0x202002A:
	RJMP _0x2020029
_0x202002B:
	LDI  R26,LOW(10)
	MUL  R21,R26
	MOV  R21,R0
	MOV  R30,R18
	SUBI R30,LOW(48)
	ADD  R21,R30
	RJMP _0x202001B
_0x2020029:
	MOV  R30,R18
	CPI  R30,LOW(0x63)
	BRNE _0x202002F
	CALL SUBOPT_0x1A
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	LDD  R26,Z+4
	ST   -Y,R26
	CALL SUBOPT_0x1B
	RJMP _0x2020030
_0x202002F:
	CPI  R30,LOW(0x73)
	BRNE _0x2020032
	CALL SUBOPT_0x1A
	CALL SUBOPT_0x1C
	CALL _strlen
	MOV  R17,R30
	RJMP _0x2020033
_0x2020032:
	CPI  R30,LOW(0x70)
	BRNE _0x2020035
	CALL SUBOPT_0x1A
	CALL SUBOPT_0x1C
	CALL _strlenf
	MOV  R17,R30
	ORI  R16,LOW(8)
_0x2020033:
	ORI  R16,LOW(2)
	ANDI R16,LOW(127)
	LDI  R19,LOW(0)
	RJMP _0x2020036
_0x2020035:
	CPI  R30,LOW(0x64)
	BREQ _0x2020039
	CPI  R30,LOW(0x69)
	BRNE _0x202003A
_0x2020039:
	ORI  R16,LOW(4)
	RJMP _0x202003B
_0x202003A:
	CPI  R30,LOW(0x75)
	BRNE _0x202003C
_0x202003B:
	LDI  R30,LOW(_tbl10_G101*2)
	LDI  R31,HIGH(_tbl10_G101*2)
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R17,LOW(5)
	RJMP _0x202003D
_0x202003C:
	CPI  R30,LOW(0x58)
	BRNE _0x202003F
	ORI  R16,LOW(8)
	RJMP _0x2020040
_0x202003F:
	CPI  R30,LOW(0x78)
	BREQ PC+3
	JMP _0x2020071
_0x2020040:
	LDI  R30,LOW(_tbl16_G101*2)
	LDI  R31,HIGH(_tbl16_G101*2)
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R17,LOW(4)
_0x202003D:
	SBRS R16,2
	RJMP _0x2020042
	CALL SUBOPT_0x1A
	CALL SUBOPT_0x1D
	LDD  R26,Y+11
	TST  R26
	BRPL _0x2020043
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	CALL __ANEGW1
	STD  Y+10,R30
	STD  Y+10+1,R31
	LDI  R20,LOW(45)
_0x2020043:
	CPI  R20,0
	BREQ _0x2020044
	SUBI R17,-LOW(1)
	RJMP _0x2020045
_0x2020044:
	ANDI R16,LOW(251)
_0x2020045:
	RJMP _0x2020046
_0x2020042:
	CALL SUBOPT_0x1A
	CALL SUBOPT_0x1D
_0x2020046:
_0x2020036:
	SBRC R16,0
	RJMP _0x2020047
_0x2020048:
	CP   R17,R21
	BRSH _0x202004A
	SBRS R16,7
	RJMP _0x202004B
	SBRS R16,2
	RJMP _0x202004C
	ANDI R16,LOW(251)
	MOV  R18,R20
	SUBI R17,LOW(1)
	RJMP _0x202004D
_0x202004C:
	LDI  R18,LOW(48)
_0x202004D:
	RJMP _0x202004E
_0x202004B:
	LDI  R18,LOW(32)
_0x202004E:
	CALL SUBOPT_0x19
	SUBI R21,LOW(1)
	RJMP _0x2020048
_0x202004A:
_0x2020047:
	MOV  R19,R17
	SBRS R16,1
	RJMP _0x202004F
_0x2020050:
	CPI  R19,0
	BREQ _0x2020052
	SBRS R16,3
	RJMP _0x2020053
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	LPM  R18,Z+
	STD  Y+6,R30
	STD  Y+6+1,R31
	RJMP _0x2020054
_0x2020053:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LD   R18,X+
	STD  Y+6,R26
	STD  Y+6+1,R27
_0x2020054:
	CALL SUBOPT_0x19
	CPI  R21,0
	BREQ _0x2020055
	SUBI R21,LOW(1)
_0x2020055:
	SUBI R19,LOW(1)
	RJMP _0x2020050
_0x2020052:
	RJMP _0x2020056
_0x202004F:
_0x2020058:
	LDI  R18,LOW(48)
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	CALL __GETW1PF
	STD  Y+8,R30
	STD  Y+8+1,R31
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ADIW R30,2
	STD  Y+6,R30
	STD  Y+6+1,R31
_0x202005A:
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	CP   R26,R30
	CPC  R27,R31
	BRLO _0x202005C
	SUBI R18,-LOW(1)
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	SUB  R30,R26
	SBC  R31,R27
	STD  Y+10,R30
	STD  Y+10+1,R31
	RJMP _0x202005A
_0x202005C:
	CPI  R18,58
	BRLO _0x202005D
	SBRS R16,3
	RJMP _0x202005E
	SUBI R18,-LOW(7)
	RJMP _0x202005F
_0x202005E:
	SUBI R18,-LOW(39)
_0x202005F:
_0x202005D:
	SBRC R16,4
	RJMP _0x2020061
	CPI  R18,49
	BRSH _0x2020063
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,1
	BRNE _0x2020062
_0x2020063:
	RJMP _0x20200CA
_0x2020062:
	CP   R21,R19
	BRLO _0x2020067
	SBRS R16,0
	RJMP _0x2020068
_0x2020067:
	RJMP _0x2020066
_0x2020068:
	LDI  R18,LOW(32)
	SBRS R16,7
	RJMP _0x2020069
	LDI  R18,LOW(48)
_0x20200CA:
	ORI  R16,LOW(16)
	SBRS R16,2
	RJMP _0x202006A
	ANDI R16,LOW(251)
	ST   -Y,R20
	CALL SUBOPT_0x1B
	CPI  R21,0
	BREQ _0x202006B
	SUBI R21,LOW(1)
_0x202006B:
_0x202006A:
_0x2020069:
_0x2020061:
	CALL SUBOPT_0x19
	CPI  R21,0
	BREQ _0x202006C
	SUBI R21,LOW(1)
_0x202006C:
_0x2020066:
	SUBI R19,LOW(1)
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,2
	BRLO _0x2020059
	RJMP _0x2020058
_0x2020059:
_0x2020056:
	SBRS R16,0
	RJMP _0x202006D
_0x202006E:
	CPI  R21,0
	BREQ _0x2020070
	SUBI R21,LOW(1)
	LDI  R30,LOW(32)
	ST   -Y,R30
	CALL SUBOPT_0x1B
	RJMP _0x202006E
_0x2020070:
_0x202006D:
_0x2020071:
_0x2020030:
_0x20200C9:
	LDI  R17,LOW(0)
_0x202001B:
	RJMP _0x2020016
_0x2020018:
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	CALL __GETW1P
	CALL __LOADLOCR6
	ADIW R28,20
	RET
_sprintf:
	PUSH R15
	MOV  R15,R24
	SBIW R28,6
	CALL __SAVELOCR4
	CALL SUBOPT_0x1E
	SBIW R30,0
	BRNE _0x2020072
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x20C0001
_0x2020072:
	MOVW R26,R28
	ADIW R26,6
	CALL __ADDW2R15
	MOVW R16,R26
	CALL SUBOPT_0x1E
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R30,LOW(0)
	STD  Y+8,R30
	STD  Y+8+1,R30
	MOVW R26,R28
	ADIW R26,10
	CALL __ADDW2R15
	CALL __GETW1P
	ST   -Y,R31
	ST   -Y,R30
	ST   -Y,R17
	ST   -Y,R16
	LDI  R30,LOW(_put_buff_G101)
	LDI  R31,HIGH(_put_buff_G101)
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R28
	ADIW R30,10
	ST   -Y,R31
	ST   -Y,R30
	RCALL __print_G101
	MOVW R18,R30
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R30,LOW(0)
	ST   X,R30
	MOVW R30,R18
_0x20C0001:
	CALL __LOADLOCR4
	ADIW R28,10
	POP  R15
	RET

	.CSEG
_abs:
    ld   r30,y+
    ld   r31,y+
    sbiw r30,0
    brpl __abs0
    com  r30
    com  r31
    adiw r30,1
__abs0:
    ret

	.DSEG

	.CSEG

	.CSEG

	.CSEG
_strlen:
    ld   r26,y+
    ld   r27,y+
    clr  r30
    clr  r31
strlen0:
    ld   r22,x+
    tst  r22
    breq strlen1
    adiw r30,1
    rjmp strlen0
strlen1:
    ret
_strlenf:
    clr  r26
    clr  r27
    ld   r30,y+
    ld   r31,y+
strlenf0:
	lpm  r0,z+
    tst  r0
    breq strlenf1
    adiw r26,1
    rjmp strlenf0
strlenf1:
    movw r30,r26
    ret

	.CSEG

	.DSEG
_doamh:
	.BYTE 0x4
_doaml:
	.BYTE 0x4
_nhietdoh:
	.BYTE 0x4
_nhietdol:
	.BYTE 0x4
_nhietdo:
	.BYTE 0x4
_doam:
	.BYTE 0x4

	.ESEG
_hong1:
	.DB  0x0
_hong2:
	.DB  0xFF
_hong3:
	.DB  0x7F
_hong4:
	.DB  0xFF
_solandtr:
	.DW  0x0
_dempdtr:
	.DB  0x0

	.DSEG
_display_buffer:
	.BYTE 0x50
__base_y_G100:
	.BYTE 0x4
__lcd_y:
	.BYTE 0x1
__lcd_maxx:
	.BYTE 0x1
__seed_G102:
	.BYTE 0x4

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x0:
	ST   -Y,R31
	ST   -Y,R30
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1:
	__GETWRN 18,19,128
	__GETWRN 16,17,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x2:
	LDI  R30,LOW(0)
	OUT  0x24,R30
	LDI  R30,LOW(2)
	OUT  0x25,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x3:
	CALL __CWD1
	CALL __ADDD12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x4:
	STS  _doamh,R30
	STS  _doamh+1,R31
	STS  _doamh+2,R22
	STS  _doamh+3,R23
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x5:
	MOVW R26,R18
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CALL __DIVW21
	MOVW R18,R30
	LDI  R30,LOW(0)
	OUT  0x24,R30
	OUT  0x25,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x6:
	LDS  R26,_doaml
	LDS  R27,_doaml+1
	LDS  R24,_doaml+2
	LDS  R25,_doaml+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x7:
	STS  _doaml,R30
	STS  _doaml+1,R31
	STS  _doaml+2,R22
	STS  _doaml+3,R23
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x8:
	STS  _nhietdoh,R30
	STS  _nhietdoh+1,R31
	STS  _nhietdoh+2,R22
	STS  _nhietdoh+3,R23
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x9:
	LDS  R26,_nhietdol
	LDS  R27,_nhietdol+1
	LDS  R24,_nhietdol+2
	LDS  R25,_nhietdol+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xA:
	STS  _nhietdol,R30
	STS  _nhietdol+1,R31
	STS  _nhietdol+2,R22
	STS  _nhietdol+3,R23
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xB:
	__GETD2N 0x100
	CALL __MULD12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xC:
	LDI  R26,LOW(_dempdtr)
	LDI  R27,HIGH(_dempdtr)
	CALL __EEPROMRDB
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xD:
	LDI  R26,0
	SBIC 0x10,6
	LDI  R26,1
	LDI  R30,LOW(1)
	CALL __EQB12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0xE:
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_puts
	LDI  R30,LOW(_display_buffer)
	LDI  R31,HIGH(_display_buffer)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0xF:
	LDS  R26,_nhietdo
	LDS  R27,_nhietdo+1
	LDS  R24,_nhietdo+2
	LDS  R25,_nhietdo+3
	__GETD1N 0xA
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x10:
	CALL __MODD21
	ST   -Y,R31
	ST   -Y,R30
	CALL _abs
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	__GETD1N 0xDF
	CALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x11:
	LDS  R26,_doam
	LDS  R27,_doam+1
	LDS  R24,_doam+2
	LDS  R25,_doam+3
	__GETD1N 0xA
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x12:
	ST   -Y,R30
	CALL _lcd_gotoxy
	LDI  R30,LOW(_display_buffer)
	LDI  R31,HIGH(_display_buffer)
	RJMP SUBOPT_0xE

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x13:
	CALL __CWD1
	CALL __PUTPARD1
	LDI  R24,4
	CALL _sprintf
	ADIW R28,8
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x14:
	LDI  R30,LOW(0)
	STS  121,R30
	STS  120,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x15:
	LDI  R30,LOW(0)
	STS  133,R30
	STS  132,R30
	STS  131,R30
	STS  130,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x16:
	LDS  R26,_nhietdo
	LDS  R27,_nhietdo+1
	LDS  R24,_nhietdo+2
	LDS  R25,_nhietdo+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x17:
	ST   -Y,R30
	CALL __lcd_write_data
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	RJMP SUBOPT_0x0

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x18:
	LDI  R30,LOW(48)
	ST   -Y,R30
	CALL __lcd_write_nibble_G100
	__DELAY_USW 400
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x19:
	ST   -Y,R18
	LDD  R30,Y+13
	LDD  R31,Y+13+1
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+17
	LDD  R31,Y+17+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x1A:
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	SBIW R30,4
	STD  Y+16,R30
	STD  Y+16+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x1B:
	LDD  R30,Y+13
	LDD  R31,Y+13+1
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+17
	LDD  R31,Y+17+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x1C:
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ADIW R26,4
	CALL __GETW1P
	STD  Y+6,R30
	STD  Y+6+1,R31
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x1D:
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ADIW R26,4
	CALL __GETW1P
	STD  Y+10,R30
	STD  Y+10+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1E:
	MOVW R26,R28
	ADIW R26,12
	CALL __ADDW2R15
	CALL __GETW1P
	RET


	.CSEG
_delay_ms:
	ld   r30,y+
	ld   r31,y+
	adiw r30,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0xFA0
	wdr
	sbiw r30,1
	brne __delay_ms0
__delay_ms1:
	ret

__ADDW2R15:
	CLR  R0
	ADD  R26,R15
	ADC  R27,R0
	RET

__ADDD12:
	ADD  R30,R26
	ADC  R31,R27
	ADC  R22,R24
	ADC  R23,R25
	RET

__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
	RET

__ANEGD1:
	COM  R31
	COM  R22
	COM  R23
	NEG  R30
	SBCI R31,-1
	SBCI R22,-1
	SBCI R23,-1
	RET

__CWD1:
	MOV  R22,R31
	ADD  R22,R22
	SBC  R22,R22
	MOV  R23,R22
	RET

__EQB12:
	CP   R30,R26
	LDI  R30,1
	BREQ __EQB12T
	CLR  R30
__EQB12T:
	RET

__LTD12:
	CP   R26,R30
	CPC  R27,R31
	CPC  R24,R22
	CPC  R25,R23
	LDI  R30,1
	BRLT __LTD12T
	CLR  R30
__LTD12T:
	RET

__GTD12:
	CP   R30,R26
	CPC  R31,R27
	CPC  R22,R24
	CPC  R23,R25
	LDI  R30,1
	BRLT __GTD12T
	CLR  R30
__GTD12T:
	RET

__MULD12U:
	MUL  R23,R26
	MOV  R23,R0
	MUL  R22,R27
	ADD  R23,R0
	MUL  R31,R24
	ADD  R23,R0
	MUL  R30,R25
	ADD  R23,R0
	MUL  R22,R26
	MOV  R22,R0
	ADD  R23,R1
	MUL  R31,R27
	ADD  R22,R0
	ADC  R23,R1
	MUL  R30,R24
	ADD  R22,R0
	ADC  R23,R1
	CLR  R24
	MUL  R31,R26
	MOV  R31,R0
	ADD  R22,R1
	ADC  R23,R24
	MUL  R30,R27
	ADD  R31,R0
	ADC  R22,R1
	ADC  R23,R24
	MUL  R30,R26
	MOV  R30,R0
	ADD  R31,R1
	ADC  R22,R24
	ADC  R23,R24
	RET

__MULD12:
	RCALL __CHKSIGND
	RCALL __MULD12U
	BRTC __MULD121
	RCALL __ANEGD1
__MULD121:
	RET

__DIVW21U:
	CLR  R0
	CLR  R1
	LDI  R25,16
__DIVW21U1:
	LSL  R26
	ROL  R27
	ROL  R0
	ROL  R1
	SUB  R0,R30
	SBC  R1,R31
	BRCC __DIVW21U2
	ADD  R0,R30
	ADC  R1,R31
	RJMP __DIVW21U3
__DIVW21U2:
	SBR  R26,1
__DIVW21U3:
	DEC  R25
	BRNE __DIVW21U1
	MOVW R30,R26
	MOVW R26,R0
	RET

__DIVW21:
	RCALL __CHKSIGNW
	RCALL __DIVW21U
	BRTC __DIVW211
	RCALL __ANEGW1
__DIVW211:
	RET

__DIVD21U:
	PUSH R19
	PUSH R20
	PUSH R21
	CLR  R0
	CLR  R1
	CLR  R20
	CLR  R21
	LDI  R19,32
__DIVD21U1:
	LSL  R26
	ROL  R27
	ROL  R24
	ROL  R25
	ROL  R0
	ROL  R1
	ROL  R20
	ROL  R21
	SUB  R0,R30
	SBC  R1,R31
	SBC  R20,R22
	SBC  R21,R23
	BRCC __DIVD21U2
	ADD  R0,R30
	ADC  R1,R31
	ADC  R20,R22
	ADC  R21,R23
	RJMP __DIVD21U3
__DIVD21U2:
	SBR  R26,1
__DIVD21U3:
	DEC  R19
	BRNE __DIVD21U1
	MOVW R30,R26
	MOVW R22,R24
	MOVW R26,R0
	MOVW R24,R20
	POP  R21
	POP  R20
	POP  R19
	RET

__DIVD21:
	RCALL __CHKSIGND
	RCALL __DIVD21U
	BRTC __DIVD211
	RCALL __ANEGD1
__DIVD211:
	RET

__MODD21:
	CLT
	SBRS R25,7
	RJMP __MODD211
	COM  R26
	COM  R27
	COM  R24
	COM  R25
	SUBI R26,-1
	SBCI R27,-1
	SBCI R24,-1
	SBCI R25,-1
	SET
__MODD211:
	SBRC R23,7
	RCALL __ANEGD1
	RCALL __DIVD21U
	MOVW R30,R26
	MOVW R22,R24
	BRTC __MODD212
	RCALL __ANEGD1
__MODD212:
	RET

__CHKSIGNW:
	CLT
	SBRS R31,7
	RJMP __CHKSW1
	RCALL __ANEGW1
	SET
__CHKSW1:
	SBRS R27,7
	RJMP __CHKSW2
	COM  R26
	COM  R27
	ADIW R26,1
	BLD  R0,0
	INC  R0
	BST  R0,0
__CHKSW2:
	RET

__CHKSIGND:
	CLT
	SBRS R23,7
	RJMP __CHKSD1
	RCALL __ANEGD1
	SET
__CHKSD1:
	SBRS R25,7
	RJMP __CHKSD2
	CLR  R0
	COM  R26
	COM  R27
	COM  R24
	COM  R25
	ADIW R26,1
	ADC  R24,R0
	ADC  R25,R0
	BLD  R0,0
	INC  R0
	BST  R0,0
__CHKSD2:
	RET

__GETW1P:
	LD   R30,X+
	LD   R31,X
	SBIW R26,1
	RET

__GETW1PF:
	LPM  R0,Z+
	LPM  R31,Z
	MOV  R30,R0
	RET

__PUTPARD1:
	ST   -Y,R23
	ST   -Y,R22
	ST   -Y,R31
	ST   -Y,R30
	RET

__EEPROMRDW:
	ADIW R26,1
	RCALL __EEPROMRDB
	MOV  R31,R30
	SBIW R26,1

__EEPROMRDB:
	SBIC EECR,EEWE
	RJMP __EEPROMRDB
	PUSH R31
	IN   R31,SREG
	CLI
	OUT  EEARL,R26
	OUT  EEARH,R27
	SBI  EECR,EERE
	IN   R30,EEDR
	OUT  SREG,R31
	POP  R31
	RET

__EEPROMWRW:
	RCALL __EEPROMWRB
	ADIW R26,1
	PUSH R30
	MOV  R30,R31
	RCALL __EEPROMWRB
	POP  R30
	SBIW R26,1
	RET

__EEPROMWRB:
	SBIS EECR,EEWE
	RJMP __EEPROMWRB1
	WDR
	RJMP __EEPROMWRB
__EEPROMWRB1:
	IN   R25,SREG
	CLI
	OUT  EEARL,R26
	OUT  EEARH,R27
	SBI  EECR,EERE
	IN   R24,EEDR
	CP   R30,R24
	BREQ __EEPROMWRB0
	OUT  EEDR,R30
	SBI  EECR,EEMWE
	SBI  EECR,EEWE
__EEPROMWRB0:
	OUT  SREG,R25
	RET

__SAVELOCR6:
	ST   -Y,R21
__SAVELOCR5:
	ST   -Y,R20
__SAVELOCR4:
	ST   -Y,R19
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR6:
	LDD  R21,Y+5
__LOADLOCR5:
	LDD  R20,Y+4
__LOADLOCR4:
	LDD  R19,Y+3
__LOADLOCR3:
	LDD  R18,Y+2
__LOADLOCR2:
	LDD  R17,Y+1
	LD   R16,Y
	RET

;END OF CODE MARKER
__END_OF_CODE:
