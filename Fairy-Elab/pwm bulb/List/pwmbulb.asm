
;CodeVisionAVR C Compiler V2.05.0 Professional
;(C) Copyright 1998-2010 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Chip type                : ATmega64
;Program type             : Application
;Clock frequency          : 11,059200 MHz
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
	.DEF _k=R5
	.DEF __lcd_x=R4
	.DEF __lcd_y=R7
	.DEF __lcd_maxx=R6

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
	JMP  0x00

_0x0:
	.DB  0x2D,0x0,0x4E,0x51,0x20,0x46,0x61,0x69
	.DB  0x72,0x79,0x0
_0x2000003:
	.DB  0x80,0xC0

__GLOBAL_INI_TBL:
	.DW  0x02
	.DW  __base_y_G100
	.DW  _0x2000003*2

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
;Chip type               : ATmega64
;Program type            : Application
;AVR Core Clock frequency: 11,059200 MHz
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
;#include <delay.h>
;// Declare your global variables here
;
;unsigned char k;
;long int i;
;
;void lcd_putnum (long int so,unsigned char x,unsigned char y)
; 0000 0015 {

	.CSEG
_lcd_putnum:
; 0000 0016    long int a, b, c, d, e;
; 0000 0017    lcd_gotoxy (x, y) ;
	SBIW R28,20
;	so -> Y+22
;	x -> Y+21
;	y -> Y+20
;	a -> Y+16
;	b -> Y+12
;	c -> Y+8
;	d -> Y+4
;	e -> Y+0
	LDD  R30,Y+21
	ST   -Y,R30
	LDD  R30,Y+21
	ST   -Y,R30
	CALL _lcd_gotoxy
; 0000 0018    if (so<0) {lcd_putsf("-"); so=-so; }
	LDD  R26,Y+25
	TST  R26
	BRPL _0x3
	__POINTW1FN _0x0,0
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_putsf
	__GETD1S 22
	CALL __ANEGD1
	__PUTD1S 22
; 0000 0019    a = so / 10000;
_0x3:
	CALL SUBOPT_0x0
	__GETD1N 0x2710
	CALL __DIVD21
	__PUTD1S 16
; 0000 001A    b = (so - 10000 * a) / 1000;
	CALL SUBOPT_0x1
	CALL __SUBD21
	__GETD1N 0x3E8
	CALL __DIVD21
	__PUTD1S 12
; 0000 001B    c = (so - 10000 * a - 1000 * b) / 100;
	CALL SUBOPT_0x1
	CALL SUBOPT_0x2
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x3
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __SUBD21
	__GETD1N 0x64
	CALL __DIVD21
	__PUTD1S 8
; 0000 001C    d = (so - 10000 * a - 1000 * b - 100 * c) / 10;
	CALL SUBOPT_0x1
	CALL SUBOPT_0x2
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x3
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL SUBOPT_0x2
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x4
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __SUBD21
	__GETD1N 0xA
	CALL __DIVD21
	__PUTD1S 4
; 0000 001D    e = so - 10000 * a - 1000 * b - 100 * c - 10 * d;
	CALL SUBOPT_0x1
	CALL SUBOPT_0x2
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x3
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL SUBOPT_0x2
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x4
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL SUBOPT_0x2
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	__GETD1S 4
	__GETD2N 0xA
	CALL __MULD12
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __SUBD21
	CALL __PUTD2S0
; 0000 001E    if(so>10000)  lcd_putchar (a + 48) ;
	RCALL SUBOPT_0x0
	__CPD2N 0x2711
	BRLT _0x4
	LDD  R30,Y+16
	CALL SUBOPT_0x5
; 0000 001F    if(so>1000) lcd_putchar (b + 48) ;
_0x4:
	RCALL SUBOPT_0x0
	__CPD2N 0x3E9
	BRLT _0x5
	LDD  R30,Y+12
	RCALL SUBOPT_0x5
; 0000 0020    if(so>100) lcd_putchar (c + 48) ;
_0x5:
	RCALL SUBOPT_0x0
	__CPD2N 0x65
	BRLT _0x6
	LDD  R30,Y+8
	RCALL SUBOPT_0x5
; 0000 0021    if(so>10) lcd_putchar (d + 48) ;
_0x6:
	RCALL SUBOPT_0x0
	__CPD2N 0xB
	BRLT _0x7
	LDD  R30,Y+4
	RCALL SUBOPT_0x5
; 0000 0022    lcd_putchar (e + 48) ;
_0x7:
	LD   R30,Y
	RCALL SUBOPT_0x5
; 0000 0023 }
	ADIW R28,26
	RET
;
;void beep()
; 0000 0026 {
_beep:
; 0000 0027 DDRC.7=1;
	SBI  0x14,7
; 0000 0028 PORTC.7=0;
	CBI  0x15,7
; 0000 0029 delay_ms(30);
	LDI  R30,LOW(30)
	LDI  R31,HIGH(30)
	RCALL SUBOPT_0x6
; 0000 002A PORTC.7=1;
	SBI  0x15,7
; 0000 002B delay_ms(70);
	LDI  R30,LOW(70)
	LDI  R31,HIGH(70)
	RCALL SUBOPT_0x6
; 0000 002C }
	RET
;
;void main(void)
; 0000 002F {
_main:
; 0000 0030 // Declare your local variables here
; 0000 0031 
; 0000 0032 // Input/Output Ports initialization
; 0000 0033 // Port A initialization
; 0000 0034 // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 0035 // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 0036 PORTA=0x00;
	LDI  R30,LOW(0)
	OUT  0x1B,R30
; 0000 0037 DDRA=0x00;
	OUT  0x1A,R30
; 0000 0038 
; 0000 0039 // Port B initialization
; 0000 003A // Func7=In Func6=In Func5=Out Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 003B // State7=T State6=T State5=0 State4=T State3=T State2=T State1=T State0=T
; 0000 003C PORTB=0xff;
	LDI  R30,LOW(255)
	OUT  0x18,R30
; 0000 003D DDRB=0xff;
	OUT  0x17,R30
; 0000 003E 
; 0000 003F // Port C initialization
; 0000 0040 // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 0041 // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 0042 PORTC=0x00;
	LDI  R30,LOW(0)
	OUT  0x15,R30
; 0000 0043 DDRC=0x00;
	OUT  0x14,R30
; 0000 0044 
; 0000 0045 // Port D initialization
; 0000 0046 // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 0047 // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 0048 PORTD=0x00;
	OUT  0x12,R30
; 0000 0049 DDRD=0x00;
	OUT  0x11,R30
; 0000 004A 
; 0000 004B // Port E initialization
; 0000 004C // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 004D // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 004E PORTE=0x00;
	OUT  0x3,R30
; 0000 004F DDRE=0x00;
	OUT  0x2,R30
; 0000 0050 
; 0000 0051 // Port F initialization
; 0000 0052 // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 0053 // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 0054 PORTF=0x00;
	STS  98,R30
; 0000 0055 DDRF=0x00;
	STS  97,R30
; 0000 0056 
; 0000 0057 // Port G initialization
; 0000 0058 // Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 0059 // State4=T State3=T State2=T State1=T State0=T
; 0000 005A PORTG=0x00;
	STS  101,R30
; 0000 005B DDRG=0x00;
	STS  100,R30
; 0000 005C 
; 0000 005D // Timer/Counter 0 initialization
; 0000 005E // Clock source: System Clock
; 0000 005F // Clock value: Timer 0 Stopped
; 0000 0060 // Mode: Normal top=0xFF
; 0000 0061 // OC0 output: Disconnected
; 0000 0062 ASSR=0x00;
	OUT  0x30,R30
; 0000 0063 TCCR0=0x00;
	OUT  0x33,R30
; 0000 0064 TCNT0=0x00;
	OUT  0x32,R30
; 0000 0065 OCR0=0x00;
	OUT  0x31,R30
; 0000 0066 
; 0000 0067 // Timer/Counter 1 initialization
; 0000 0068 // Clock source: System Clock
; 0000 0069 // Clock value: 11059,200 kHz
; 0000 006A // Mode: Fast PWM top=ICR1
; 0000 006B // OC1A output: Inverted
; 0000 006C // OC1B output: Discon.
; 0000 006D // OC1C output: Discon.
; 0000 006E // Noise Canceler: Off
; 0000 006F // Input Capture on Falling Edge
; 0000 0070 // Timer1 Overflow Interrupt: Off
; 0000 0071 // Input Capture Interrupt: Off
; 0000 0072 // Compare A Match Interrupt: Off
; 0000 0073 // Compare B Match Interrupt: Off
; 0000 0074 // Compare C Match Interrupt: Off
; 0000 0075 TCCR1A=0xC2;
	LDI  R30,LOW(194)
	OUT  0x2F,R30
; 0000 0076 TCCR1B=0x19;
	LDI  R30,LOW(25)
	OUT  0x2E,R30
; 0000 0077 TCNT1H=0x00;
	LDI  R30,LOW(0)
	OUT  0x2D,R30
; 0000 0078 TCNT1L=0x00;
	OUT  0x2C,R30
; 0000 0079 ICR1H=0x00;
	OUT  0x27,R30
; 0000 007A ICR1L=0x00;
	OUT  0x26,R30
; 0000 007B ICR1=60000;
	LDI  R30,LOW(60000)
	LDI  R31,HIGH(60000)
	OUT  0x26+1,R31
	OUT  0x26,R30
; 0000 007C OCR1AH=0x00;
	LDI  R30,LOW(0)
	OUT  0x2B,R30
; 0000 007D OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 007E OCR1BH=0x00;
	OUT  0x29,R30
; 0000 007F OCR1BL=0x00;
	OUT  0x28,R30
; 0000 0080 OCR1CH=0x00;
	STS  121,R30
; 0000 0081 OCR1CL=0x00;
	STS  120,R30
; 0000 0082 
; 0000 0083 // Timer/Counter 2 initialization
; 0000 0084 // Clock source: System Clock
; 0000 0085 // Clock value: Timer2 Stopped
; 0000 0086 // Mode: Normal top=0xFF
; 0000 0087 // OC2 output: Disconnected
; 0000 0088 TCCR2=0x00;
	OUT  0x25,R30
; 0000 0089 TCNT2=0x00;
	OUT  0x24,R30
; 0000 008A OCR2=0x00;
	OUT  0x23,R30
; 0000 008B 
; 0000 008C // Timer/Counter 3 initialization
; 0000 008D // Clock source: System Clock
; 0000 008E // Clock value: Timer3 Stopped
; 0000 008F // Mode: Normal top=0xFFFF
; 0000 0090 // OC3A output: Discon.
; 0000 0091 // OC3B output: Discon.
; 0000 0092 // OC3C output: Discon.
; 0000 0093 // Noise Canceler: Off
; 0000 0094 // Input Capture on Falling Edge
; 0000 0095 // Timer3 Overflow Interrupt: Off
; 0000 0096 // Input Capture Interrupt: Off
; 0000 0097 // Compare A Match Interrupt: Off
; 0000 0098 // Compare B Match Interrupt: Off
; 0000 0099 // Compare C Match Interrupt: Off
; 0000 009A TCCR3A=0x00;
	STS  139,R30
; 0000 009B TCCR3B=0x00;
	STS  138,R30
; 0000 009C TCNT3H=0x00;
	STS  137,R30
; 0000 009D TCNT3L=0x00;
	STS  136,R30
; 0000 009E ICR3H=0x00;
	STS  129,R30
; 0000 009F ICR3L=0x00;
	STS  128,R30
; 0000 00A0 OCR3AH=0x00;
	STS  135,R30
; 0000 00A1 OCR3AL=0x00;
	STS  134,R30
; 0000 00A2 OCR3BH=0x00;
	STS  133,R30
; 0000 00A3 OCR3BL=0x00;
	STS  132,R30
; 0000 00A4 OCR3CH=0x00;
	STS  131,R30
; 0000 00A5 OCR3CL=0x00;
	STS  130,R30
; 0000 00A6 
; 0000 00A7 // External Interrupt(s) initialization
; 0000 00A8 // INT0: Off
; 0000 00A9 // INT1: Off
; 0000 00AA // INT2: Off
; 0000 00AB // INT3: Off
; 0000 00AC // INT4: Off
; 0000 00AD // INT5: Off
; 0000 00AE // INT6: Off
; 0000 00AF // INT7: Off
; 0000 00B0 EICRA=0x00;
	STS  106,R30
; 0000 00B1 EICRB=0x00;
	OUT  0x3A,R30
; 0000 00B2 EIMSK=0x00;
	OUT  0x39,R30
; 0000 00B3 
; 0000 00B4 // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 00B5 TIMSK=0x00;
	OUT  0x37,R30
; 0000 00B6 
; 0000 00B7 ETIMSK=0x00;
	STS  125,R30
; 0000 00B8 
; 0000 00B9 // USART0 initialization
; 0000 00BA // USART0 disabled
; 0000 00BB UCSR0B=0x00;
	OUT  0xA,R30
; 0000 00BC 
; 0000 00BD // USART1 initialization
; 0000 00BE // USART1 disabled
; 0000 00BF UCSR1B=0x00;
	STS  154,R30
; 0000 00C0 
; 0000 00C1 // Analog Comparator initialization
; 0000 00C2 // Analog Comparator: Off
; 0000 00C3 // Analog Comparator Input Capture by Timer/Counter 1: Off
; 0000 00C4 ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 00C5 SFIOR=0x00;
	LDI  R30,LOW(0)
	OUT  0x20,R30
; 0000 00C6 
; 0000 00C7 // ADC initialization
; 0000 00C8 // ADC disabled
; 0000 00C9 ADCSRA=0x00;
	OUT  0x6,R30
; 0000 00CA 
; 0000 00CB // SPI initialization
; 0000 00CC // SPI disabled
; 0000 00CD SPCR=0x00;
	OUT  0xD,R30
; 0000 00CE 
; 0000 00CF // TWI initialization
; 0000 00D0 // TWI disabled
; 0000 00D1 TWCR=0x00;
	STS  116,R30
; 0000 00D2 
; 0000 00D3 // Alphanumeric LCD initialization
; 0000 00D4 // Connections specified in the
; 0000 00D5 // Project|Configure|C Compiler|Libraries|Alphanumeric LCD menu:
; 0000 00D6 // RS - PORTE Bit 0
; 0000 00D7 // RD - PORTE Bit 1
; 0000 00D8 // EN - PORTE Bit 2
; 0000 00D9 // D4 - PORTE Bit 4
; 0000 00DA // D5 - PORTE Bit 5
; 0000 00DB // D6 - PORTE Bit 6
; 0000 00DC // D7 - PORTE Bit 7
; 0000 00DD // Characters/line: 20
; 0000 00DE lcd_init(20);
	LDI  R30,LOW(20)
	ST   -Y,R30
	RCALL _lcd_init
; 0000 00DF 
; 0000 00E0 lcd_putsf("NQ Fairy");
	__POINTW1FN _0x0,2
	ST   -Y,R31
	ST   -Y,R30
	RCALL _lcd_putsf
; 0000 00E1 for (k=0;k<4;k++) beep();
	CLR  R5
_0xF:
	LDI  R30,LOW(4)
	CP   R5,R30
	BRSH _0x10
	RCALL _beep
	INC  R5
	RJMP _0xF
_0x10:
; 0000 00E2 lcd_clear();
	RCALL _lcd_clear
; 0000 00E3 delay_ms(500);
	LDI  R30,LOW(500)
	LDI  R31,HIGH(500)
	RCALL SUBOPT_0x6
; 0000 00E4 
; 0000 00E5 while (1)
_0x11:
; 0000 00E6       {
; 0000 00E7       // Place your code here
; 0000 00E8       /*
; 0000 00E9       PORTB.7=1;
; 0000 00EA       delay_ms(10);
; 0000 00EB       PORTB.7=0;
; 0000 00EC       delay_ms(10);
; 0000 00ED       */
; 0000 00EE 
; 0000 00EF 
; 0000 00F0       i=0;
	LDI  R30,LOW(0)
	STS  _i,R30
	STS  _i+1,R30
	STS  _i+2,R30
	STS  _i+3,R30
; 0000 00F1       while (i<=60000 )
_0x14:
	LDS  R26,_i
	LDS  R27,_i+1
	LDS  R24,_i+2
	LDS  R25,_i+3
	__CPD2N 0xEA61
	BRGE _0x16
; 0000 00F2         {
; 0000 00F3         i=i+50;
	RCALL SUBOPT_0x7
	__ADDD1N 50
	RCALL SUBOPT_0x8
; 0000 00F4         OCR1A=i;
; 0000 00F5         lcd_putnum(OCR1A,0,0);
; 0000 00F6         delay_ms(10);
; 0000 00F7         }
	RJMP _0x14
_0x16:
; 0000 00F8       while (i>=0 )
_0x17:
	LDS  R26,_i+3
	TST  R26
	BRMI _0x19
; 0000 00F9         {
; 0000 00FA         i=i-50;
	RCALL SUBOPT_0x7
	__SUBD1N 50
	RCALL SUBOPT_0x8
; 0000 00FB         OCR1A=i;
; 0000 00FC         lcd_putnum(OCR1A,0,0);
; 0000 00FD         delay_ms(10);
; 0000 00FE         }
	RJMP _0x17
_0x19:
; 0000 00FF 
; 0000 0100       }
	RJMP _0x11
; 0000 0101 }
_0x1A:
	RJMP _0x1A
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
	SBI  0x3,4
	RJMP _0x2000005
_0x2000004:
	CBI  0x3,4
_0x2000005:
	LD   R30,Y
	ANDI R30,LOW(0x20)
	BREQ _0x2000006
	SBI  0x3,5
	RJMP _0x2000007
_0x2000006:
	CBI  0x3,5
_0x2000007:
	LD   R30,Y
	ANDI R30,LOW(0x40)
	BREQ _0x2000008
	SBI  0x3,6
	RJMP _0x2000009
_0x2000008:
	CBI  0x3,6
_0x2000009:
	LD   R30,Y
	ANDI R30,LOW(0x80)
	BREQ _0x200000A
	SBI  0x3,7
	RJMP _0x200000B
_0x200000A:
	CBI  0x3,7
_0x200000B:
	__DELAY_USB 7
	SBI  0x3,2
	__DELAY_USB 18
	CBI  0x3,2
	__DELAY_USB 18
	RJMP _0x2020001
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
	__DELAY_USB 184
	RJMP _0x2020001
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
	LDD  R4,Y+1
	LDD  R7,Y+0
	ADIW R28,2
	RET
_lcd_clear:
	LDI  R30,LOW(2)
	RCALL SUBOPT_0x9
	LDI  R30,LOW(12)
	ST   -Y,R30
	RCALL __lcd_write_data
	LDI  R30,LOW(1)
	RCALL SUBOPT_0x9
	LDI  R30,LOW(0)
	MOV  R7,R30
	MOV  R4,R30
	RET
_lcd_putchar:
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BREQ _0x2000011
	CP   R4,R6
	BRLO _0x2000010
_0x2000011:
	LDI  R30,LOW(0)
	ST   -Y,R30
	INC  R7
	ST   -Y,R7
	RCALL _lcd_gotoxy
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BRNE _0x2000013
	RJMP _0x2020001
_0x2000013:
_0x2000010:
	INC  R4
	SBI  0x3,0
	LD   R30,Y
	ST   -Y,R30
	RCALL __lcd_write_data
	CBI  0x3,0
	RJMP _0x2020001
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
	LDD  R17,Y+0
	ADIW R28,3
	RET
_lcd_init:
	SBI  0x2,4
	SBI  0x2,5
	SBI  0x2,6
	SBI  0x2,7
	SBI  0x2,2
	SBI  0x2,0
	SBI  0x2,1
	CBI  0x3,2
	CBI  0x3,0
	CBI  0x3,1
	LDD  R6,Y+0
	LD   R30,Y
	SUBI R30,-LOW(128)
	__PUTB1MN __base_y_G100,2
	LD   R30,Y
	SUBI R30,-LOW(192)
	__PUTB1MN __base_y_G100,3
	LDI  R30,LOW(20)
	LDI  R31,HIGH(20)
	RCALL SUBOPT_0x6
	RCALL SUBOPT_0xA
	RCALL SUBOPT_0xA
	RCALL SUBOPT_0xA
	LDI  R30,LOW(32)
	ST   -Y,R30
	RCALL __lcd_write_nibble_G100
	__DELAY_USW 276
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
_0x2020001:
	ADIW R28,1
	RET

	.DSEG
_i:
	.BYTE 0x4
__base_y_G100:
	.BYTE 0x4

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x0:
	__GETD2S 22
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:27 WORDS
SUBOPT_0x1:
	__GETD1S 16
	__GETD2N 0x2710
	CALL __MULD12
	RJMP SUBOPT_0x0

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x2:
	CALL __SWAPD12
	CALL __SUBD12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x3:
	__GETD1S 12
	__GETD2N 0x3E8
	CALL __MULD12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x4:
	__GETD1S 8
	__GETD2N 0x64
	CALL __MULD12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x5:
	SUBI R30,-LOW(48)
	ST   -Y,R30
	RJMP _lcd_putchar

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x6:
	ST   -Y,R31
	ST   -Y,R30
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x7:
	LDS  R30,_i
	LDS  R31,_i+1
	LDS  R22,_i+2
	LDS  R23,_i+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:25 WORDS
SUBOPT_0x8:
	STS  _i,R30
	STS  _i+1,R31
	STS  _i+2,R22
	STS  _i+3,R23
	LDS  R30,_i
	LDS  R31,_i+1
	OUT  0x2A+1,R31
	OUT  0x2A,R30
	IN   R30,0x2A
	IN   R31,0x2A+1
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	LDI  R30,LOW(0)
	ST   -Y,R30
	ST   -Y,R30
	CALL _lcd_putnum
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RJMP SUBOPT_0x6

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x9:
	ST   -Y,R30
	RCALL __lcd_write_data
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	RJMP SUBOPT_0x6

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0xA:
	LDI  R30,LOW(48)
	ST   -Y,R30
	RCALL __lcd_write_nibble_G100
	__DELAY_USW 276
	RET


	.CSEG
_delay_ms:
	ld   r30,y+
	ld   r31,y+
	adiw r30,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0xACD
	wdr
	sbiw r30,1
	brne __delay_ms0
__delay_ms1:
	ret

__SUBD12:
	SUB  R30,R26
	SBC  R31,R27
	SBC  R22,R24
	SBC  R23,R25
	RET

__SUBD21:
	SUB  R26,R30
	SBC  R27,R31
	SBC  R24,R22
	SBC  R25,R23
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

__PUTD2S0:
	ST   Y,R26
	STD  Y+1,R27
	STD  Y+2,R24
	STD  Y+3,R25
	RET

__PUTPARD1:
	ST   -Y,R23
	ST   -Y,R22
	ST   -Y,R31
	ST   -Y,R30
	RET

__SWAPD12:
	MOV  R1,R24
	MOV  R24,R22
	MOV  R22,R1
	MOV  R1,R25
	MOV  R25,R23
	MOV  R23,R1

__SWAPW12:
	MOV  R1,R27
	MOV  R27,R31
	MOV  R31,R1

__SWAPB12:
	MOV  R1,R26
	MOV  R26,R30
	MOV  R30,R1
	RET

;END OF CODE MARKER
__END_OF_CODE:
