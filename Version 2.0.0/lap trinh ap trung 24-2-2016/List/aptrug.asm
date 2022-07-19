
;CodeVisionAVR C Compiler V2.05.0 Professional
;(C) Copyright 1998-2010 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Chip type                : ATmega8
;Program type             : Application
;Clock frequency          : 16.000000 MHz
;Memory model             : Small
;Optimize for             : Size
;(s)printf features       : int, width
;(s)scanf features        : int, width
;External RAM size        : 0
;Data Stack size          : 256 byte(s)
;Heap size                : 0 byte(s)
;Promote 'char' to 'int'  : Yes
;'char' is unsigned       : Yes
;8 bit enums              : Yes
;global 'const' stored in FLASH: No
;Enhanced core instructions    : On
;Smart register allocation     : On
;Automatic register allocation : On

	#pragma AVRPART ADMIN PART_NAME ATmega8
	#pragma AVRPART MEMORY PROG_FLASH 8192
	#pragma AVRPART MEMORY EEPROM 512
	#pragma AVRPART MEMORY INT_SRAM SIZE 1119
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

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
	.EQU GICR=0x3B
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F

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

	.EQU __SRAM_START=0x0060
	.EQU __SRAM_END=0x045F
	.EQU __DSTACK_SIZE=0x0100
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
	RCALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRD
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
	RCALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMRDW
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
	RCALL __PUTDP1
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
	RCALL __PUTDP1
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
	RCALL __PUTDP1
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
	RCALL __PUTDP1
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
	RCALL __PUTDP1
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
	RCALL __PUTDP1
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
	RCALL __PUTDP1
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
	RCALL __PUTDP1
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
	.DEF __lcd_x=R5
	.DEF __lcd_y=R4
	.DEF __lcd_maxx=R7

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	RJMP __RESET
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP _timer1_compa_isr
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00

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
	OUT  GICR,R31
	OUT  GICR,R30
	OUT  MCUCR,R30

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
	LDI  R26,__SRAM_START
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

	RJMP _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x160

	.CSEG
;/*****************************************************
;Chip type               : ATmega8
;Program type            : Application
;AVR Core Clock frequency: 16.000000 MHz
;Memory model            : Small
;External RAM size       : 0
;Data Stack size         : 256
;*****************************************************/
;
;#include <mega8.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;
;// Alphanumeric LCD Module functions
;#include <alcd.h>
;#include <delay.h>
;// Declare your global variables here
;
;#define data PIND.0
;
;volatile long num, i, a, nhietdo, doam, kiemtra;
;volatile long doamh, doaml, nhietdoh, nhietdol, kiemtrah, kiemtral;
;void read_am2301()
; 0000 0016      {

	.CSEG
_read_am2301:
; 0000 0017      doamh=doaml=nhietdoh=nhietdol=0;
	__GETD1N 0x0
	RCALL SUBOPT_0x0
	RCALL SUBOPT_0x1
	RCALL SUBOPT_0x2
	RCALL SUBOPT_0x3
; 0000 0018      a=128;
	RCALL SUBOPT_0x4
; 0000 0019      DDRD=0xff;
	LDI  R30,LOW(255)
	OUT  0x11,R30
; 0000 001A      PORTD.0=0;
	CBI  0x12,0
; 0000 001B      delay_us(1000);
	__DELAY_USW 4000
; 0000 001C      PORTD.0=1;
	SBI  0x12,0
; 0000 001D      delay_us(30);
	__DELAY_USB 160
; 0000 001E      PORTD.0=0;
	CBI  0x12,0
; 0000 001F      DDRD=0b11111110;
	LDI  R30,LOW(254)
	OUT  0x11,R30
; 0000 0020      while(data==0)
_0x9:
	SBIS 0x10,0
; 0000 0021           {
; 0000 0022           }
	RJMP _0x9
; 0000 0023      while(data==1)
_0xC:
	SBIC 0x10,0
; 0000 0024           {
; 0000 0025           }
	RJMP _0xC
; 0000 0026 
; 0000 0027      while(data==0)
_0xF:
	SBIS 0x10,0
; 0000 0028           {
; 0000 0029           }
	RJMP _0xF
; 0000 002A      a=128;
	RCALL SUBOPT_0x4
; 0000 002B      for (i=0;i<8;i++)
	RCALL SUBOPT_0x5
_0x13:
	RCALL SUBOPT_0x6
	BRGE _0x14
; 0000 002C           {
; 0000 002D           TCNT0=0x00;
	RCALL SUBOPT_0x7
; 0000 002E           TCCR0=0x02;
	RCALL SUBOPT_0x8
; 0000 002F           while(data==1)
_0x15:
	SBIC 0x10,0
; 0000 0030                {
; 0000 0031                }
	RJMP _0x15
; 0000 0032           if (TCNT0 > 96) doamh = doamh + a ;
	RCALL SUBOPT_0x9
	BRLO _0x18
	RCALL SUBOPT_0xA
	RCALL SUBOPT_0xB
	RCALL SUBOPT_0x3
; 0000 0033           a=a/2;
_0x18:
	RCALL SUBOPT_0xC
; 0000 0034           TCNT0=0x00;
; 0000 0035           TCCR0=0x00;
	RCALL SUBOPT_0xD
; 0000 0036           while (data==0)
_0x19:
	SBIS 0x10,0
; 0000 0037                {
; 0000 0038                }
	RJMP _0x19
; 0000 0039           }
	RCALL SUBOPT_0xE
	RJMP _0x13
_0x14:
; 0000 003A      a=128;
	RCALL SUBOPT_0x4
; 0000 003B      for (i=0;i<8;i++)
	RCALL SUBOPT_0x5
_0x1D:
	RCALL SUBOPT_0x6
	BRGE _0x1E
; 0000 003C           {
; 0000 003D           TCNT0=0x00;
	RCALL SUBOPT_0x7
; 0000 003E           TCCR0=0x02;
	RCALL SUBOPT_0x8
; 0000 003F           while(data==1)
_0x1F:
	SBIC 0x10,0
; 0000 0040                {
; 0000 0041                }
	RJMP _0x1F
; 0000 0042           if (TCNT0 > 96) doaml = doaml + a ;
	RCALL SUBOPT_0x9
	BRLO _0x22
	RCALL SUBOPT_0xA
	RCALL SUBOPT_0xF
	RCALL SUBOPT_0x2
; 0000 0043           a=a/2;
_0x22:
	RCALL SUBOPT_0xC
; 0000 0044           TCNT0=0x00;
; 0000 0045           TCCR0=0x00;
	RCALL SUBOPT_0xD
; 0000 0046           while (data==0)
_0x23:
	SBIS 0x10,0
; 0000 0047                {
; 0000 0048                }
	RJMP _0x23
; 0000 0049           }
	RCALL SUBOPT_0xE
	RJMP _0x1D
_0x1E:
; 0000 004A      a=128;
	RCALL SUBOPT_0x4
; 0000 004B      for (i=0;i<8;i++)
	RCALL SUBOPT_0x5
_0x27:
	RCALL SUBOPT_0x6
	BRGE _0x28
; 0000 004C           {
; 0000 004D           TCNT0=0x00;
	RCALL SUBOPT_0x7
; 0000 004E           TCCR0=0x02;
	RCALL SUBOPT_0x8
; 0000 004F           while(data==1)
_0x29:
	SBIC 0x10,0
; 0000 0050                {
; 0000 0051                }
	RJMP _0x29
; 0000 0052           if (TCNT0 > 96) nhietdoh = nhietdoh + a ;
	RCALL SUBOPT_0x9
	BRLO _0x2C
	RCALL SUBOPT_0xA
	RCALL SUBOPT_0x10
	RCALL SUBOPT_0x1
; 0000 0053           a=a/2;
_0x2C:
	RCALL SUBOPT_0xC
; 0000 0054           TCNT0=0x00;
; 0000 0055           TCCR0=0x00;
	RCALL SUBOPT_0xD
; 0000 0056           while (data==0)
_0x2D:
	SBIS 0x10,0
; 0000 0057                {
; 0000 0058                }
	RJMP _0x2D
; 0000 0059           }
	RCALL SUBOPT_0xE
	RJMP _0x27
_0x28:
; 0000 005A      a=128;
	RCALL SUBOPT_0x4
; 0000 005B      for (i=0;i<8;i++)
	RCALL SUBOPT_0x5
_0x31:
	RCALL SUBOPT_0x6
	BRGE _0x32
; 0000 005C           {
; 0000 005D           TCNT0=0x00;
	RCALL SUBOPT_0x7
; 0000 005E           TCCR0=0x02;
	RCALL SUBOPT_0x8
; 0000 005F           while(data==1)
_0x33:
	SBIC 0x10,0
; 0000 0060                {
; 0000 0061                }
	RJMP _0x33
; 0000 0062           if (TCNT0 > 96) nhietdol = nhietdol + a ;
	RCALL SUBOPT_0x9
	BRLO _0x36
	RCALL SUBOPT_0xA
	RCALL SUBOPT_0x11
	RCALL SUBOPT_0x0
; 0000 0063           a=a/2;
_0x36:
	RCALL SUBOPT_0xC
; 0000 0064           TCNT0=0x00;
; 0000 0065           TCCR0=0x00;
	RCALL SUBOPT_0xD
; 0000 0066           while (data==0)
_0x37:
	SBIS 0x10,0
; 0000 0067                {
; 0000 0068                }
	RJMP _0x37
; 0000 0069           }
	RCALL SUBOPT_0xE
	RJMP _0x31
_0x32:
; 0000 006A      a=128;
	RCALL SUBOPT_0x4
; 0000 006B      for (i=0;i<8;i++)
	RCALL SUBOPT_0x5
_0x3B:
	RCALL SUBOPT_0x6
	BRGE _0x3C
; 0000 006C           {
; 0000 006D           TCNT0=0x00;
	RCALL SUBOPT_0x7
; 0000 006E           TCCR0=0x02;
	RCALL SUBOPT_0x8
; 0000 006F           while(data==1)
_0x3D:
	SBIC 0x10,0
; 0000 0070                {
; 0000 0071                }
	RJMP _0x3D
; 0000 0072           if (TCNT0 > 96)kiemtrah = kiemtrah + a ;
	RCALL SUBOPT_0x9
	BRLO _0x40
	RCALL SUBOPT_0xA
	LDS  R26,_kiemtrah
	LDS  R27,_kiemtrah+1
	LDS  R24,_kiemtrah+2
	LDS  R25,_kiemtrah+3
	RCALL __ADDD12
	STS  _kiemtrah,R30
	STS  _kiemtrah+1,R31
	STS  _kiemtrah+2,R22
	STS  _kiemtrah+3,R23
; 0000 0073           a=a/2;
_0x40:
	RCALL SUBOPT_0xC
; 0000 0074           TCNT0=0x00;
; 0000 0075           TCCR0=0x00;
	RCALL SUBOPT_0xD
; 0000 0076           while (data==0)
_0x41:
	SBIS 0x10,0
; 0000 0077                {
; 0000 0078                }
	RJMP _0x41
; 0000 0079           }
	RCALL SUBOPT_0xE
	RJMP _0x3B
_0x3C:
; 0000 007A      a=128;
	RCALL SUBOPT_0x4
; 0000 007B 
; 0000 007C      nhietdo = nhietdoh*256 + nhietdol;
	RCALL SUBOPT_0x12
	RCALL SUBOPT_0x13
	RCALL SUBOPT_0x11
	STS  _nhietdo,R30
	STS  _nhietdo+1,R31
	STS  _nhietdo+2,R22
	STS  _nhietdo+3,R23
; 0000 007D      doam = doamh*256 + doaml;
	RCALL SUBOPT_0x14
	RCALL SUBOPT_0x13
	RCALL SUBOPT_0xF
	STS  _doam,R30
	STS  _doam+1,R31
	STS  _doam+2,R22
	STS  _doam+3,R23
; 0000 007E      /*
; 0000 007F      lcd_gotoxy(0,0);
; 0000 0080      lcd_putsf("Nhiet Do: ");
; 0000 0081      lcd_putnum(nhietdo,10,0);
; 0000 0082      lcd_gotoxy(0,1);
; 0000 0083      lcd_putsf("Do Am: ");
; 0000 0084      lcd_putnum(doam,10,1);
; 0000 0085      */
; 0000 0086      DDRD=0xff;
	LDI  R30,LOW(255)
	OUT  0x11,R30
; 0000 0087      PORTD.0=1;
	SBI  0x12,0
; 0000 0088      }
	RET
;
;void lcd_putnum (long so,unsigned char x,unsigned char y)
; 0000 008B {
_lcd_putnum:
; 0000 008C    long a, b, c;
; 0000 008D    a = so / 100;
	SBIW R28,12
;	so -> Y+14
;	x -> Y+13
;	y -> Y+12
;	a -> Y+8
;	b -> Y+4
;	c -> Y+0
	RCALL SUBOPT_0x15
	__GETD1N 0x64
	RCALL __DIVD21
	__PUTD1S 8
; 0000 008E    b = (so - 100 * a) / 10;
	RCALL SUBOPT_0x16
	RCALL __SUBD21
	__GETD1N 0xA
	RCALL __DIVD21
	__PUTD1S 4
; 0000 008F    c = so - 100 * a - 10 * b;
	RCALL SUBOPT_0x16
	RCALL __SWAPD12
	RCALL __SUBD12
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	__GETD1S 4
	__GETD2N 0xA
	RCALL __MULD12
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	RCALL __SUBD21
	RCALL __PUTD2S0
; 0000 0090    lcd_gotoxy (x, y) ;
	LDD  R30,Y+13
	ST   -Y,R30
	LDD  R30,Y+13
	RCALL SUBOPT_0x17
; 0000 0091    lcd_putchar (a + 48) ;
	LDD  R30,Y+8
	RCALL SUBOPT_0x18
; 0000 0092    lcd_putchar (b + 48) ;
	LDD  R30,Y+4
	RCALL SUBOPT_0x18
; 0000 0093    //lcd_putsf(".");
; 0000 0094    lcd_putchar (c + 48) ;
	LD   R30,Y
	RCALL SUBOPT_0x18
; 0000 0095 }
	ADIW R28,18
	RET
;
;interrupt [TIM1_COMPA] void timer1_compa_isr(void)
; 0000 0098 {
_timer1_compa_isr:
; 0000 0099 // Place your code here
; 0000 009A 
; 0000 009B //read_am2301();
; 0000 009C }
	RETI
;
;void main(void)
; 0000 009F {
_main:
; 0000 00A0 // Declare your local variables here
; 0000 00A1 
; 0000 00A2 // Input/Output Ports initialization
; 0000 00A3 // Port B initialization
; 0000 00A4 // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 00A5 // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 00A6 PORTB=0xff;
	LDI  R30,LOW(255)
	OUT  0x18,R30
; 0000 00A7 DDRB=0x00;
	LDI  R30,LOW(0)
	OUT  0x17,R30
; 0000 00A8 
; 0000 00A9 // Port C initialization
; 0000 00AA // Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 00AB // State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 00AC PORTC=0xff;
	LDI  R30,LOW(255)
	OUT  0x15,R30
; 0000 00AD DDRC=0b11111100;
	LDI  R30,LOW(252)
	OUT  0x14,R30
; 0000 00AE 
; 0000 00AF // Port D initialization
; 0000 00B0 // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 00B1 // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 00B2 PORTD=0x00;
	LDI  R30,LOW(0)
	OUT  0x12,R30
; 0000 00B3 DDRD=0x00;
	OUT  0x11,R30
; 0000 00B4 
; 0000 00B5 // Timer/Counter 0 initialization
; 0000 00B6 // Clock source: System Clock
; 0000 00B7 // Clock value: Timer 0 Stopped
; 0000 00B8 TCCR0=0x00;
	RCALL SUBOPT_0xD
; 0000 00B9 TCNT0=0x00;
	RCALL SUBOPT_0x7
; 0000 00BA 
; 0000 00BB // Timer/Counter 1 initialization
; 0000 00BC // Clock source: System Clock
; 0000 00BD // Clock value: 15.625 kHz
; 0000 00BE // Mode: CTC top=OCR1A
; 0000 00BF // OC1A output: Discon.
; 0000 00C0 // OC1B output: Discon.
; 0000 00C1 // Noise Canceler: Off
; 0000 00C2 // Input Capture on Falling Edge
; 0000 00C3 // Timer1 Overflow Interrupt: Off
; 0000 00C4 // Input Capture Interrupt: Off
; 0000 00C5 // Compare A Match Interrupt: On
; 0000 00C6 // Compare B Match Interrupt: Off
; 0000 00C7 TCCR1A=0x00;
	LDI  R30,LOW(0)
	OUT  0x2F,R30
; 0000 00C8 TCCR1B=0x0D;
	LDI  R30,LOW(13)
	OUT  0x2E,R30
; 0000 00C9 TCNT1H=0x00;
	LDI  R30,LOW(0)
	OUT  0x2D,R30
; 0000 00CA TCNT1L=0x00;
	OUT  0x2C,R30
; 0000 00CB ICR1H=0x00;
	OUT  0x27,R30
; 0000 00CC ICR1L=0x00;
	OUT  0x26,R30
; 0000 00CD OCR1AH=0x3D;
	LDI  R30,LOW(61)
	OUT  0x2B,R30
; 0000 00CE OCR1AL=0x09;
	LDI  R30,LOW(9)
	OUT  0x2A,R30
; 0000 00CF OCR1BH=0x00;
	LDI  R30,LOW(0)
	OUT  0x29,R30
; 0000 00D0 OCR1BL=0x00;
	OUT  0x28,R30
; 0000 00D1 
; 0000 00D2 // Timer/Counter 2 initialization
; 0000 00D3 // Clock source: System Clock
; 0000 00D4 // Clock value: Timer2 Stopped
; 0000 00D5 // Mode: Normal top=0xFF
; 0000 00D6 // OC2 output: Disconnected
; 0000 00D7 ASSR=0x00;
	OUT  0x22,R30
; 0000 00D8 TCCR2=0x00;
	OUT  0x25,R30
; 0000 00D9 TCNT2=0x00;
	OUT  0x24,R30
; 0000 00DA OCR2=0x00;
	OUT  0x23,R30
; 0000 00DB 
; 0000 00DC // External Interrupt(s) initialization
; 0000 00DD // INT0: Off
; 0000 00DE // INT1: Off
; 0000 00DF MCUCR=0x00;
	OUT  0x35,R30
; 0000 00E0 
; 0000 00E1 // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 00E2 TIMSK=0x10;
	LDI  R30,LOW(16)
	OUT  0x39,R30
; 0000 00E3 
; 0000 00E4 // USART initialization
; 0000 00E5 // USART disabled
; 0000 00E6 UCSRB=0x00;
	LDI  R30,LOW(0)
	OUT  0xA,R30
; 0000 00E7 
; 0000 00E8 // Analog Comparator initialization
; 0000 00E9 // Analog Comparator: Off
; 0000 00EA // Analog Comparator Input Capture by Timer/Counter 1: Off
; 0000 00EB ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 00EC SFIOR=0x00;
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0000 00ED 
; 0000 00EE // ADC initialization
; 0000 00EF // ADC disabled
; 0000 00F0 ADCSRA=0x00;
	OUT  0x6,R30
; 0000 00F1 
; 0000 00F2 // SPI initialization
; 0000 00F3 // SPI disabled
; 0000 00F4 SPCR=0x00;
	OUT  0xD,R30
; 0000 00F5 
; 0000 00F6 // TWI initialization
; 0000 00F7 // TWI disabled
; 0000 00F8 TWCR=0x00;
	OUT  0x36,R30
; 0000 00F9 
; 0000 00FA // Alphanumeric LCD initialization
; 0000 00FB // Connections specified in the
; 0000 00FC // Project|Configure|C Compiler|Libraries|Alphanumeric LCD menu:
; 0000 00FD // RS - PORTD Bit 7
; 0000 00FE // RD - PORTD Bit 6
; 0000 00FF // EN - PORTD Bit 5
; 0000 0100 // D4 - PORTD Bit 4
; 0000 0101 // D5 - PORTD Bit 3
; 0000 0102 // D6 - PORTD Bit 2
; 0000 0103 // D7 - PORTD Bit 1
; 0000 0104 // Characters/line: 16
; 0000 0105 lcd_init(16);
	LDI  R30,LOW(16)
	ST   -Y,R30
	RCALL _lcd_init
; 0000 0106 
; 0000 0107 while (1)
_0x46:
; 0000 0108       {
; 0000 0109       // Place your code here
; 0000 010A         delay_ms(1000);
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	RCALL SUBOPT_0x19
; 0000 010B         read_am2301();
	RCALL _read_am2301
; 0000 010C         kiemtra=nhietdoh+nhietdol+doamh+doaml;
	RCALL SUBOPT_0x1A
	RCALL SUBOPT_0x10
	RCALL SUBOPT_0xB
	RCALL SUBOPT_0xF
	STS  _kiemtra,R30
	STS  _kiemtra+1,R31
	STS  _kiemtra+2,R22
	STS  _kiemtra+3,R23
; 0000 010D         if (kiemtra == kiemtrah)
	RCALL SUBOPT_0x1B
	LDS  R26,_kiemtra
	LDS  R27,_kiemtra+1
	LDS  R24,_kiemtra+2
	LDS  R25,_kiemtra+3
	RCALL __CPD12
	BRNE _0x49
; 0000 010E         {
; 0000 010F         lcd_gotoxy(0,0);
	RCALL SUBOPT_0x1C
	RCALL SUBOPT_0x17
; 0000 0110         lcd_putnum (nhietdoh,0,0);
	RCALL SUBOPT_0x12
	RCALL __PUTPARD1
	RCALL SUBOPT_0x1C
	RCALL SUBOPT_0x1D
; 0000 0111 
; 0000 0112         lcd_putnum (nhietdol,5,0);
	RCALL SUBOPT_0x1A
	RCALL __PUTPARD1
	LDI  R30,LOW(5)
	ST   -Y,R30
	LDI  R30,LOW(0)
	RCALL SUBOPT_0x1D
; 0000 0113 
; 0000 0114         lcd_putnum (nhietdo,11,0);
	LDS  R30,_nhietdo
	LDS  R31,_nhietdo+1
	LDS  R22,_nhietdo+2
	LDS  R23,_nhietdo+3
	RCALL __PUTPARD1
	LDI  R30,LOW(11)
	ST   -Y,R30
	LDI  R30,LOW(0)
	RCALL SUBOPT_0x1D
; 0000 0115 
; 0000 0116         lcd_gotoxy(0,1);
	RCALL SUBOPT_0x1E
	RCALL SUBOPT_0x17
; 0000 0117         lcd_putnum (doamh,0,1);
	RCALL SUBOPT_0x14
	RCALL __PUTPARD1
	RCALL SUBOPT_0x1E
	RCALL SUBOPT_0x1D
; 0000 0118 
; 0000 0119         lcd_putnum (doaml,5,1);
	LDS  R30,_doaml
	LDS  R31,_doaml+1
	LDS  R22,_doaml+2
	LDS  R23,_doaml+3
	RCALL __PUTPARD1
	LDI  R30,LOW(5)
	ST   -Y,R30
	LDI  R30,LOW(1)
	RCALL SUBOPT_0x1D
; 0000 011A 
; 0000 011B         lcd_putnum (doam,11,1);
	LDS  R30,_doam
	LDS  R31,_doam+1
	LDS  R22,_doam+2
	LDS  R23,_doam+3
	RCALL __PUTPARD1
	LDI  R30,LOW(11)
	RJMP _0x4C
; 0000 011C 
; 0000 011D         }
; 0000 011E         else
_0x49:
; 0000 011F         {
; 0000 0120 
; 0000 0121         lcd_gotoxy(0,0);
	RCALL SUBOPT_0x1C
	RCALL SUBOPT_0x17
; 0000 0122         lcd_putnum (kiemtra,0,0);
	LDS  R30,_kiemtra
	LDS  R31,_kiemtra+1
	LDS  R22,_kiemtra+2
	LDS  R23,_kiemtra+3
	RCALL __PUTPARD1
	RCALL SUBOPT_0x1C
	RCALL SUBOPT_0x1D
; 0000 0123         lcd_gotoxy(0,1);
	RCALL SUBOPT_0x1E
	RCALL SUBOPT_0x17
; 0000 0124         lcd_putnum (kiemtrah,0,1);
	RCALL SUBOPT_0x1B
	RCALL __PUTPARD1
	LDI  R30,LOW(0)
_0x4C:
	ST   -Y,R30
	LDI  R30,LOW(1)
	RCALL SUBOPT_0x1D
; 0000 0125         }
; 0000 0126 
; 0000 0127       }
	RJMP _0x46
; 0000 0128 }
_0x4B:
	RJMP _0x4B
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif

	.DSEG

	.CSEG
__lcd_write_nibble_G100:
	LD   R30,Y
	ANDI R30,LOW(0x10)
	BREQ _0x2000004
	SBI  0x12,4
	RJMP _0x2000005
_0x2000004:
	CBI  0x12,4
_0x2000005:
	LD   R30,Y
	ANDI R30,LOW(0x20)
	BREQ _0x2000006
	SBI  0x12,3
	RJMP _0x2000007
_0x2000006:
	CBI  0x12,3
_0x2000007:
	LD   R30,Y
	ANDI R30,LOW(0x40)
	BREQ _0x2000008
	SBI  0x12,2
	RJMP _0x2000009
_0x2000008:
	CBI  0x12,2
_0x2000009:
	LD   R30,Y
	ANDI R30,LOW(0x80)
	BREQ _0x200000A
	SBI  0x12,1
	RJMP _0x200000B
_0x200000A:
	CBI  0x12,1
_0x200000B:
	__DELAY_USB 11
	SBI  0x12,5
	__DELAY_USB 27
	CBI  0x12,5
	__DELAY_USB 27
	RJMP _0x2020001
__lcd_write_data:
	LD   R30,Y
	RCALL SUBOPT_0x1F
    ld    r30,y
    swap  r30
    st    y,r30
	LD   R30,Y
	RCALL SUBOPT_0x1F
	__DELAY_USW 200
	RJMP _0x2020001
_lcd_gotoxy:
	LD   R30,Y
	LDI  R31,0
	SUBI R30,LOW(-__base_y_G100)
	SBCI R31,HIGH(-__base_y_G100)
	LD   R30,Z
	LDD  R26,Y+1
	ADD  R30,R26
	RCALL SUBOPT_0x20
	LDD  R5,Y+1
	LDD  R4,Y+0
	ADIW R28,2
	RET
_lcd_clear:
	LDI  R30,LOW(2)
	RCALL SUBOPT_0x20
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	RCALL SUBOPT_0x19
	LDI  R30,LOW(12)
	RCALL SUBOPT_0x20
	LDI  R30,LOW(1)
	RCALL SUBOPT_0x20
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	RCALL SUBOPT_0x19
	LDI  R30,LOW(0)
	MOV  R4,R30
	MOV  R5,R30
	RET
_lcd_putchar:
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BREQ _0x2000011
	CP   R5,R7
	BRLO _0x2000010
_0x2000011:
	LDI  R30,LOW(0)
	ST   -Y,R30
	INC  R4
	ST   -Y,R4
	RCALL _lcd_gotoxy
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BREQ _0x2020001
_0x2000010:
	INC  R5
	SBI  0x12,7
	LD   R30,Y
	RCALL SUBOPT_0x20
	CBI  0x12,7
	RJMP _0x2020001
_lcd_init:
	SBI  0x11,4
	SBI  0x11,3
	SBI  0x11,2
	SBI  0x11,1
	SBI  0x11,5
	SBI  0x11,7
	SBI  0x11,6
	CBI  0x12,5
	CBI  0x12,7
	CBI  0x12,6
	LDD  R7,Y+0
	LD   R30,Y
	SUBI R30,-LOW(128)
	__PUTB1MN __base_y_G100,2
	LD   R30,Y
	SUBI R30,-LOW(192)
	__PUTB1MN __base_y_G100,3
	LDI  R30,LOW(20)
	LDI  R31,HIGH(20)
	RCALL SUBOPT_0x19
	LDI  R30,LOW(48)
	RCALL SUBOPT_0x1F
	RCALL SUBOPT_0x21
	RCALL SUBOPT_0x21
	RCALL SUBOPT_0x22
	LDI  R30,LOW(32)
	RCALL SUBOPT_0x1F
	RCALL SUBOPT_0x22
	LDI  R30,LOW(40)
	RCALL SUBOPT_0x20
	LDI  R30,LOW(4)
	RCALL SUBOPT_0x20
	LDI  R30,LOW(133)
	RCALL SUBOPT_0x20
	LDI  R30,LOW(6)
	RCALL SUBOPT_0x20
	RCALL _lcd_clear
_0x2020001:
	ADIW R28,1
	RET

	.DSEG
_i:
	.BYTE 0x4
_a:
	.BYTE 0x4
_nhietdo:
	.BYTE 0x4
_doam:
	.BYTE 0x4
_kiemtra:
	.BYTE 0x4
_doamh:
	.BYTE 0x4
_doaml:
	.BYTE 0x4
_nhietdoh:
	.BYTE 0x4
_nhietdol:
	.BYTE 0x4
_kiemtrah:
	.BYTE 0x4
__base_y_G100:
	.BYTE 0x4

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x0:
	STS  _nhietdol,R30
	STS  _nhietdol+1,R31
	STS  _nhietdol+2,R22
	STS  _nhietdol+3,R23
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x1:
	STS  _nhietdoh,R30
	STS  _nhietdoh+1,R31
	STS  _nhietdoh+2,R22
	STS  _nhietdoh+3,R23
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x2:
	STS  _doaml,R30
	STS  _doaml+1,R31
	STS  _doaml+2,R22
	STS  _doaml+3,R23
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x3:
	STS  _doamh,R30
	STS  _doamh+1,R31
	STS  _doamh+2,R22
	STS  _doamh+3,R23
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:64 WORDS
SUBOPT_0x4:
	__GETD1N 0x80
	STS  _a,R30
	STS  _a+1,R31
	STS  _a+2,R22
	STS  _a+3,R23
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:30 WORDS
SUBOPT_0x5:
	LDI  R30,LOW(0)
	STS  _i,R30
	STS  _i+1,R30
	STS  _i+2,R30
	STS  _i+3,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:54 WORDS
SUBOPT_0x6:
	LDS  R26,_i
	LDS  R27,_i+1
	LDS  R24,_i+2
	LDS  R25,_i+3
	__CPD2N 0x8
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 11 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x7:
	LDI  R30,LOW(0)
	OUT  0x32,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x8:
	LDI  R30,LOW(2)
	OUT  0x33,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x9:
	IN   R30,0x32
	CPI  R30,LOW(0x61)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:26 WORDS
SUBOPT_0xA:
	LDS  R30,_a
	LDS  R31,_a+1
	LDS  R22,_a+2
	LDS  R23,_a+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0xB:
	LDS  R26,_doamh
	LDS  R27,_doamh+1
	LDS  R24,_doamh+2
	LDS  R25,_doamh+3
	RCALL __ADDD12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:82 WORDS
SUBOPT_0xC:
	LDS  R26,_a
	LDS  R27,_a+1
	LDS  R24,_a+2
	LDS  R25,_a+3
	__GETD1N 0x2
	RCALL __DIVD21
	STS  _a,R30
	STS  _a+1,R31
	STS  _a+2,R22
	STS  _a+3,R23
	RJMP SUBOPT_0x7

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xD:
	LDI  R30,LOW(0)
	OUT  0x33,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:26 WORDS
SUBOPT_0xE:
	LDI  R26,LOW(_i)
	LDI  R27,HIGH(_i)
	RCALL __GETD1P_INC
	__SUBD1N -1
	RCALL __PUTDP1_DEC
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:14 WORDS
SUBOPT_0xF:
	LDS  R26,_doaml
	LDS  R27,_doaml+1
	LDS  R24,_doaml+2
	LDS  R25,_doaml+3
	RCALL __ADDD12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x10:
	LDS  R26,_nhietdoh
	LDS  R27,_nhietdoh+1
	LDS  R24,_nhietdoh+2
	LDS  R25,_nhietdoh+3
	RCALL __ADDD12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x11:
	LDS  R26,_nhietdol
	LDS  R27,_nhietdol+1
	LDS  R24,_nhietdol+2
	LDS  R25,_nhietdol+3
	RCALL __ADDD12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x12:
	LDS  R30,_nhietdoh
	LDS  R31,_nhietdoh+1
	LDS  R22,_nhietdoh+2
	LDS  R23,_nhietdoh+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x13:
	__GETD2N 0x100
	RCALL __MULD12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x14:
	LDS  R30,_doamh
	LDS  R31,_doamh+1
	LDS  R22,_doamh+2
	LDS  R23,_doamh+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x15:
	__GETD2S 14
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x16:
	__GETD1S 8
	__GETD2N 0x64
	RCALL __MULD12
	RJMP SUBOPT_0x15

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x17:
	ST   -Y,R30
	RJMP _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x18:
	SUBI R30,-LOW(48)
	ST   -Y,R30
	RJMP _lcd_putchar

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x19:
	ST   -Y,R31
	ST   -Y,R30
	RJMP _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x1A:
	LDS  R30,_nhietdol
	LDS  R31,_nhietdol+1
	LDS  R22,_nhietdol+2
	LDS  R23,_nhietdol+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x1B:
	LDS  R30,_kiemtrah
	LDS  R31,_kiemtrah+1
	LDS  R22,_kiemtrah+2
	LDS  R23,_kiemtrah+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x1C:
	LDI  R30,LOW(0)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x1D:
	ST   -Y,R30
	RJMP _lcd_putnum

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x1E:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(1)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1F:
	ST   -Y,R30
	RJMP __lcd_write_nibble_G100

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x20:
	ST   -Y,R30
	RJMP __lcd_write_data

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x21:
	__DELAY_USW 400
	LDI  R30,LOW(48)
	RJMP SUBOPT_0x1F

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x22:
	__DELAY_USW 400
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

__ADDD12:
	ADD  R30,R26
	ADC  R31,R27
	ADC  R22,R24
	ADC  R23,R25
	RET

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

__GETD1P_INC:
	LD   R30,X+
	LD   R31,X+
	LD   R22,X+
	LD   R23,X+
	RET

__PUTDP1_DEC:
	ST   -X,R23
	ST   -X,R22
	ST   -X,R31
	ST   -X,R30
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

__CPD12:
	CP   R30,R26
	CPC  R31,R27
	CPC  R22,R24
	CPC  R23,R25
	RET

;END OF CODE MARKER
__END_OF_CODE:
