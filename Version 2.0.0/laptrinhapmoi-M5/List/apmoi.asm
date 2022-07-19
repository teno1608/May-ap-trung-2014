
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
	.DEF _demdaotrung=R4
	.DEF _sldao=R6
	.DEF __lcd_x=R9
	.DEF __lcd_y=R8
	.DEF __lcd_maxx=R11

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

;REGISTER BIT VARIABLES INITIALIZATION
__REG_BIT_VARS:
	.DW  0x0000

_0x76:
	.DB  0x0,0x0,0x0,0x0
_0x0:
	.DB  0x2E,0x0,0x53,0x74,0x61,0x72,0x74,0x20
	.DB  0x53,0x79,0x73,0x74,0x65,0x6D,0x2E,0x2E
	.DB  0x2E,0x2E,0x2E,0x0,0x3E,0x20,0x0,0x3E
	.DB  0x0,0x46,0x0,0x61,0x0,0x69,0x0,0x72
	.DB  0x0,0x79,0x0,0x2D,0x0,0x45,0x0,0x6C
	.DB  0x0,0x62,0x0
_0x2000003:
	.DB  0x80,0xC0

__GLOBAL_INI_TBL:
	.DW  0x01
	.DW  0x02
	.DW  __REG_BIT_VARS*2

	.DW  0x04
	.DW  0x04
	.DW  _0x76*2

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
;#include <delay.h>
;// Alphanumeric LCD Module functions
;#include <alcd.h>
;
;// Declare your global variables here
;eeprom int nhietdodat @0x10;
;eeprom int doamdat @0x35;
;eeprom int timeoff @0x3a;
;
;eeprom int nhietdodat=370;
;eeprom int doamdat=600;
;eeprom int timeoff=1;
;
;void lcd_putnum (long so,unsigned char x,unsigned char y)
; 0000 0019 {

	.CSEG
_lcd_putnum:
; 0000 001A    long a, b, c;
; 0000 001B    a = so / 100;
	RCALL SUBOPT_0x0
;	so -> Y+14
;	x -> Y+13
;	y -> Y+12
;	a -> Y+8
;	b -> Y+4
;	c -> Y+0
; 0000 001C    b = (so - 100 * a) / 10;
; 0000 001D    c = so - 100 * a - 10 * b;
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	RCALL SUBOPT_0x1
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	RCALL SUBOPT_0x2
; 0000 001E    lcd_gotoxy (x, y) ;
; 0000 001F    lcd_putchar (a + 48) ;
; 0000 0020    lcd_putchar (b + 48) ;
; 0000 0021    lcd_putsf(".");
	__POINTW1FN _0x0,0
	RCALL SUBOPT_0x3
	RCALL _lcd_putsf
; 0000 0022    lcd_putchar (c + 48) ;
	RJMP _0x2020002
; 0000 0023 }
;
;void lcd_putnum1 (long so,unsigned char x,unsigned char y)
; 0000 0026 {
_lcd_putnum1:
; 0000 0027    long a, b, c;
; 0000 0028    a = so / 100;
	RCALL SUBOPT_0x0
;	so -> Y+14
;	x -> Y+13
;	y -> Y+12
;	a -> Y+8
;	b -> Y+4
;	c -> Y+0
; 0000 0029    b = (so - 100 * a) / 10;
; 0000 002A    c = so - 100 * a - 10 * b;
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	RCALL SUBOPT_0x1
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	RCALL SUBOPT_0x2
; 0000 002B    lcd_gotoxy (x, y) ;
; 0000 002C    lcd_putchar (a + 48) ;
; 0000 002D    lcd_putchar (b + 48) ;
; 0000 002E    lcd_putchar (c + 48) ;
_0x2020002:
	LD   R30,Y
	SUBI R30,-LOW(48)
	ST   -Y,R30
	RCALL _lcd_putchar
; 0000 002F }
	ADIW R28,18
	RET
;
;#define data PIND.0
;
;long num, i, doamh, doaml, nhietdoh, nhietdol, a, nhietdo, doam;
;
;void read_am2301()
; 0000 0036      {
_read_am2301:
; 0000 0037      doamh=doaml=nhietdoh=nhietdol=0;
	__GETD1N 0x0
	RCALL SUBOPT_0x4
	RCALL SUBOPT_0x5
	RCALL SUBOPT_0x6
	RCALL SUBOPT_0x7
; 0000 0038      a=128;
	RCALL SUBOPT_0x8
; 0000 0039      DDRD=0xff;
	LDI  R30,LOW(255)
	OUT  0x11,R30
; 0000 003A      PORTD.0=0;
	CBI  0x12,0
; 0000 003B      delay_us(1000);
	__DELAY_USW 4000
; 0000 003C      PORTD.0=1;
	SBI  0x12,0
; 0000 003D      delay_us(30);
	__DELAY_USB 160
; 0000 003E      PORTD.0=0;
	CBI  0x12,0
; 0000 003F      DDRD=0b11111110;
	LDI  R30,LOW(254)
	OUT  0x11,R30
; 0000 0040      while(data==0)
_0x9:
	SBIS 0x10,0
; 0000 0041           {
; 0000 0042           }
	RJMP _0x9
; 0000 0043      while(data==1)
_0xC:
	SBIC 0x10,0
; 0000 0044           {
; 0000 0045           }
	RJMP _0xC
; 0000 0046 
; 0000 0047      while(data==0)
_0xF:
	SBIS 0x10,0
; 0000 0048           {
; 0000 0049           }
	RJMP _0xF
; 0000 004A      a=128;
	RCALL SUBOPT_0x8
; 0000 004B      for (i=0;i<8;i++)
	RCALL SUBOPT_0x9
_0x13:
	RCALL SUBOPT_0xA
	BRGE _0x14
; 0000 004C           {
; 0000 004D           TCNT0=0x00;
	RCALL SUBOPT_0xB
; 0000 004E           TCCR0=0x02;
	RCALL SUBOPT_0xC
; 0000 004F           while(data==1)
_0x15:
	SBIC 0x10,0
; 0000 0050                {
; 0000 0051                }
	RJMP _0x15
; 0000 0052           if (TCNT0 > 96) doamh = doamh + a ;
	RCALL SUBOPT_0xD
	BRLO _0x18
	RCALL SUBOPT_0xE
	LDS  R26,_doamh
	LDS  R27,_doamh+1
	LDS  R24,_doamh+2
	LDS  R25,_doamh+3
	RCALL __ADDD12
	RCALL SUBOPT_0x7
; 0000 0053           a=a/2;
_0x18:
	RCALL SUBOPT_0xF
; 0000 0054           TCNT0=0x00;
; 0000 0055           TCCR0=0x00;
	RCALL SUBOPT_0x10
; 0000 0056           while (data==0)
_0x19:
	SBIS 0x10,0
; 0000 0057                {
; 0000 0058                }
	RJMP _0x19
; 0000 0059           }
	RCALL SUBOPT_0x11
	RJMP _0x13
_0x14:
; 0000 005A      a=128;
	RCALL SUBOPT_0x8
; 0000 005B      for (i=0;i<8;i++)
	RCALL SUBOPT_0x9
_0x1D:
	RCALL SUBOPT_0xA
	BRGE _0x1E
; 0000 005C           {
; 0000 005D           TCNT0=0x00;
	RCALL SUBOPT_0xB
; 0000 005E           TCCR0=0x02;
	RCALL SUBOPT_0xC
; 0000 005F           while(data==1)
_0x1F:
	SBIC 0x10,0
; 0000 0060                {
; 0000 0061                }
	RJMP _0x1F
; 0000 0062           if (TCNT0 > 96) doaml = doaml + a ;
	RCALL SUBOPT_0xD
	BRLO _0x22
	RCALL SUBOPT_0xE
	RCALL SUBOPT_0x12
	RCALL SUBOPT_0x6
; 0000 0063           a=a/2;
_0x22:
	RCALL SUBOPT_0xF
; 0000 0064           TCNT0=0x00;
; 0000 0065           TCCR0=0x00;
	RCALL SUBOPT_0x10
; 0000 0066           while (data==0)
_0x23:
	SBIS 0x10,0
; 0000 0067                {
; 0000 0068                }
	RJMP _0x23
; 0000 0069           }
	RCALL SUBOPT_0x11
	RJMP _0x1D
_0x1E:
; 0000 006A      a=128;
	RCALL SUBOPT_0x8
; 0000 006B      for (i=0;i<8;i++)
	RCALL SUBOPT_0x9
_0x27:
	RCALL SUBOPT_0xA
	BRGE _0x28
; 0000 006C           {
; 0000 006D           TCNT0=0x00;
	RCALL SUBOPT_0xB
; 0000 006E           TCCR0=0x02;
	RCALL SUBOPT_0xC
; 0000 006F           while(data==1)
_0x29:
	SBIC 0x10,0
; 0000 0070                {
; 0000 0071                }
	RJMP _0x29
; 0000 0072           if (TCNT0 > 96) nhietdoh = nhietdoh + a ;
	RCALL SUBOPT_0xD
	BRLO _0x2C
	RCALL SUBOPT_0xE
	LDS  R26,_nhietdoh
	LDS  R27,_nhietdoh+1
	LDS  R24,_nhietdoh+2
	LDS  R25,_nhietdoh+3
	RCALL __ADDD12
	RCALL SUBOPT_0x5
; 0000 0073           a=a/2;
_0x2C:
	RCALL SUBOPT_0xF
; 0000 0074           TCNT0=0x00;
; 0000 0075           TCCR0=0x00;
	RCALL SUBOPT_0x10
; 0000 0076           while (data==0)
_0x2D:
	SBIS 0x10,0
; 0000 0077                {
; 0000 0078                }
	RJMP _0x2D
; 0000 0079           }
	RCALL SUBOPT_0x11
	RJMP _0x27
_0x28:
; 0000 007A      a=128;
	RCALL SUBOPT_0x8
; 0000 007B      for (i=0;i<8;i++)
	RCALL SUBOPT_0x9
_0x31:
	RCALL SUBOPT_0xA
	BRGE _0x32
; 0000 007C           {
; 0000 007D           TCNT0=0x00;
	RCALL SUBOPT_0xB
; 0000 007E           TCCR0=0x02;
	RCALL SUBOPT_0xC
; 0000 007F           while(data==1)
_0x33:
	SBIC 0x10,0
; 0000 0080                {
; 0000 0081                }
	RJMP _0x33
; 0000 0082           if (TCNT0 > 96) nhietdol = nhietdol + a ;
	RCALL SUBOPT_0xD
	BRLO _0x36
	RCALL SUBOPT_0xE
	RCALL SUBOPT_0x13
	RCALL SUBOPT_0x4
; 0000 0083           a=a/2;
_0x36:
	RCALL SUBOPT_0xF
; 0000 0084           TCNT0=0x00;
; 0000 0085           TCCR0=0x00;
	RCALL SUBOPT_0x10
; 0000 0086           while (data==0)
_0x37:
	SBIS 0x10,0
; 0000 0087                {
; 0000 0088                }
	RJMP _0x37
; 0000 0089           }
	RCALL SUBOPT_0x11
	RJMP _0x31
_0x32:
; 0000 008A      a=128;
	RCALL SUBOPT_0x8
; 0000 008B 
; 0000 008C      nhietdo = nhietdoh*256 + nhietdol;
	LDS  R30,_nhietdoh
	LDS  R31,_nhietdoh+1
	LDS  R22,_nhietdoh+2
	LDS  R23,_nhietdoh+3
	RCALL SUBOPT_0x14
	RCALL SUBOPT_0x13
	STS  _nhietdo,R30
	STS  _nhietdo+1,R31
	STS  _nhietdo+2,R22
	STS  _nhietdo+3,R23
; 0000 008D      doam = doamh*256 + doaml;
	LDS  R30,_doamh
	LDS  R31,_doamh+1
	LDS  R22,_doamh+2
	LDS  R23,_doamh+3
	RCALL SUBOPT_0x14
	RCALL SUBOPT_0x12
	STS  _doam,R30
	STS  _doam+1,R31
	STS  _doam+2,R22
	STS  _doam+3,R23
; 0000 008E      /*
; 0000 008F      lcd_gotoxy(0,0);
; 0000 0090      lcd_putsf("Nhiet Do: ");
; 0000 0091      lcd_putnum(nhietdo,10,0);
; 0000 0092      lcd_gotoxy(0,1);
; 0000 0093      lcd_putsf("Do Am: ");
; 0000 0094      lcd_putnum(doam,10,1);
; 0000 0095      */
; 0000 0096      DDRD=0xff;
	LDI  R30,LOW(255)
	OUT  0x11,R30
; 0000 0097      PORTD.0=1;
	SBI  0x12,0
; 0000 0098      }
	RET
;
;#define role1 PORTC.2
;#define role2 PORTC.3
;#define role3 PORTC.4
;#define role4 PORTC.5
;
;#define up1 PINB.0
;#define down1 PINC.0
;#define up2 PINB.1
;#define down2 PINC.1
;
;
;int demdaotrung=0, sldao=0;
;long time1day=0;
;bit error;
;
;// Timer1 output compare A interrupt service routine
;// Interrupt 1 second <<<
;interrupt [TIM1_COMPA] void timer1_compa_isr(void)
; 0000 00AC {
_timer1_compa_isr:
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
; 0000 00AD // Place your code here
; 0000 00AE demdaotrung++;
	MOVW R30,R4
	ADIW R30,1
	MOVW R4,R30
; 0000 00AF time1day++;
	LDI  R26,LOW(_time1day)
	LDI  R27,HIGH(_time1day)
	RCALL __GETD1P_INC
	__SUBD1N -1
	RCALL __PUTDP1_DEC
; 0000 00B0 if (time1day == 86400)
	LDS  R26,_time1day
	LDS  R27,_time1day+1
	LDS  R24,_time1day+2
	LDS  R25,_time1day+3
	__CPD2N 0x15180
	BRNE _0x3C
; 0000 00B1     {
; 0000 00B2     timeoff++;
	LDI  R26,LOW(_timeoff)
	LDI  R27,HIGH(_timeoff)
	RCALL SUBOPT_0x15
; 0000 00B3     }
; 0000 00B4 while (timeoff == 1000)
_0x3C:
_0x3D:
	LDI  R26,LOW(_timeoff)
	LDI  R27,HIGH(_timeoff)
	RCALL __EEPROMRDW
	CPI  R30,LOW(0x3E8)
	LDI  R26,HIGH(0x3E8)
	CPC  R31,R26
	BRNE _0x3F
; 0000 00B5     {
; 0000 00B6      #asm("cli")
	cli
; 0000 00B7      lcd_clear();
	RCALL _lcd_clear
; 0000 00B8      PORTC=0xff;
	LDI  R30,LOW(255)
	OUT  0x15,R30
; 0000 00B9     }
	RJMP _0x3D
_0x3F:
; 0000 00BA 
; 0000 00BB if (demdaotrung == 7195)
	LDI  R30,LOW(7195)
	LDI  R31,HIGH(7195)
	CP   R30,R4
	CPC  R31,R5
	BRNE _0x40
; 0000 00BC     {
; 0000 00BD     role3=0;
	CBI  0x15,4
; 0000 00BE     sldao++;
	MOVW R30,R6
	ADIW R30,1
	MOVW R6,R30
; 0000 00BF     }
; 0000 00C0 if (demdaotrung == 7200)
_0x40:
	LDI  R30,LOW(7200)
	LDI  R31,HIGH(7200)
	CP   R30,R4
	CPC  R31,R5
	BRNE _0x43
; 0000 00C1     {
; 0000 00C2     demdaotrung =0;
	CLR  R4
	CLR  R5
; 0000 00C3     role3=1;
	SBI  0x15,4
; 0000 00C4     }
; 0000 00C5 if (error == 0) role4=role4^1; else role4=1;
_0x43:
	SBRC R2,0
	RJMP _0x46
	LDI  R26,0
	SBIC 0x15,5
	LDI  R26,1
	LDI  R30,LOW(1)
	EOR  R30,R26
	BRNE _0x47
	CBI  0x15,5
	RJMP _0x48
_0x47:
	SBI  0x15,5
_0x48:
	RJMP _0x49
_0x46:
	SBI  0x15,5
; 0000 00C6 
; 0000 00C7 read_am2301();
_0x49:
	RCALL _read_am2301
; 0000 00C8 }
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
;
;void read_key()
; 0000 00CC     {
_read_key:
; 0000 00CD 
; 0000 00CE     while (up1==0)
_0x4C:
	SBIC 0x16,0
	RJMP _0x4E
; 0000 00CF         {
; 0000 00D0         while (down2==0)
_0x4F:
	SBIC 0x13,1
	RJMP _0x51
; 0000 00D1             {
; 0000 00D2             nhietdodat=370;
	RCALL SUBOPT_0x16
	LDI  R30,LOW(370)
	LDI  R31,HIGH(370)
	RCALL __EEPROMWRW
; 0000 00D3             doamdat=600;
	RCALL SUBOPT_0x17
	LDI  R30,LOW(600)
	LDI  R31,HIGH(600)
	RCALL __EEPROMWRW
; 0000 00D4             }
	RJMP _0x4F
_0x51:
; 0000 00D5         nhietdodat++;
	RCALL SUBOPT_0x16
	RCALL SUBOPT_0x15
; 0000 00D6         lcd_putnum(nhietdodat,7,0);
	RCALL SUBOPT_0x18
	RCALL SUBOPT_0x19
; 0000 00D7         delay_ms(300);
; 0000 00D8         }
	RJMP _0x4C
_0x4E:
; 0000 00D9     while (down1==0)
_0x52:
	SBIC 0x13,0
	RJMP _0x54
; 0000 00DA         {
; 0000 00DB         nhietdodat--;
	RCALL SUBOPT_0x18
	SBIW R30,1
	RCALL __EEPROMWRW
	ADIW R30,1
; 0000 00DC         lcd_putnum(nhietdodat,7,0);
	RCALL SUBOPT_0x18
	RCALL SUBOPT_0x19
; 0000 00DD         delay_ms(300);
; 0000 00DE         }
	RJMP _0x52
_0x54:
; 0000 00DF 
; 0000 00E0     while (up2==0)
_0x55:
	SBIC 0x16,1
	RJMP _0x57
; 0000 00E1         {
; 0000 00E2         while (down1==0)
_0x58:
	SBIC 0x13,0
	RJMP _0x5A
; 0000 00E3             {
; 0000 00E4             timeoff=0;
	LDI  R26,LOW(_timeoff)
	LDI  R27,HIGH(_timeoff)
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RCALL __EEPROMWRW
; 0000 00E5             }
	RJMP _0x58
_0x5A:
; 0000 00E6         doamdat++;
	RCALL SUBOPT_0x17
	RCALL SUBOPT_0x15
; 0000 00E7         lcd_putnum(doamdat,7,1);
	RCALL SUBOPT_0x1A
	RCALL SUBOPT_0x1B
; 0000 00E8         delay_ms(300);
; 0000 00E9         }
	RJMP _0x55
_0x57:
; 0000 00EA     while (down2==0)
_0x5B:
	SBIC 0x13,1
	RJMP _0x5D
; 0000 00EB         {
; 0000 00EC         doamdat--;
	RCALL SUBOPT_0x1A
	SBIW R30,1
	RCALL __EEPROMWRW
	ADIW R30,1
; 0000 00ED         lcd_putnum(doamdat,7,1);
	RCALL SUBOPT_0x1A
	RCALL SUBOPT_0x1B
; 0000 00EE         delay_ms(300);
; 0000 00EF         }
	RJMP _0x5B
_0x5D:
; 0000 00F0     }
	RET
;
;
;void main(void)
; 0000 00F4 {
_main:
; 0000 00F5 // Declare your local variables here
; 0000 00F6 
; 0000 00F7 // Input/Output Ports initialization
; 0000 00F8 // Port B initialization
; 0000 00F9 // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 00FA // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 00FB PORTB=0xff;
	LDI  R30,LOW(255)
	OUT  0x18,R30
; 0000 00FC DDRB=0x00;
	LDI  R30,LOW(0)
	OUT  0x17,R30
; 0000 00FD 
; 0000 00FE // Port C initialization
; 0000 00FF // Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 0100 // State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 0101 PORTC=0xff;
	LDI  R30,LOW(255)
	OUT  0x15,R30
; 0000 0102 DDRC=0b11111100;
	LDI  R30,LOW(252)
	OUT  0x14,R30
; 0000 0103 
; 0000 0104 // Port D initialization
; 0000 0105 // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 0106 // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 0107 PORTD=0x00;
	LDI  R30,LOW(0)
	OUT  0x12,R30
; 0000 0108 DDRD=0x00;
	OUT  0x11,R30
; 0000 0109 
; 0000 010A // Timer/Counter 0 initialization
; 0000 010B // Clock source: System Clock
; 0000 010C // Clock value: Timer 0 Stopped
; 0000 010D TCCR0=0x00;
	RCALL SUBOPT_0x10
; 0000 010E TCNT0=0x00;
	RCALL SUBOPT_0xB
; 0000 010F 
; 0000 0110 // Timer/Counter 1 initialization
; 0000 0111 // Clock source: System Clock
; 0000 0112 // Clock value: 15.625 kHz
; 0000 0113 // Mode: CTC top=OCR1A
; 0000 0114 // OC1A output: Discon.
; 0000 0115 // OC1B output: Discon.
; 0000 0116 // Noise Canceler: Off
; 0000 0117 // Input Capture on Falling Edge
; 0000 0118 // Timer1 Overflow Interrupt: Off
; 0000 0119 // Input Capture Interrupt: Off
; 0000 011A // Compare A Match Interrupt: On
; 0000 011B // Compare B Match Interrupt: Off
; 0000 011C TCCR1A=0x00;
	RCALL SUBOPT_0x1C
; 0000 011D TCCR1B=0x0D;
; 0000 011E TCNT1H=0x00;
; 0000 011F TCNT1L=0x00;
; 0000 0120 ICR1H=0x00;
; 0000 0121 ICR1L=0x00;
; 0000 0122 OCR1AH=0x3D;
; 0000 0123 OCR1AL=0x09;
; 0000 0124 OCR1BH=0x00;
; 0000 0125 OCR1BL=0x00;
; 0000 0126 
; 0000 0127 // Timer/Counter 2 initialization
; 0000 0128 // Clock source: System Clock
; 0000 0129 // Clock value: Timer2 Stopped
; 0000 012A // Mode: Normal top=0xFF
; 0000 012B // OC2 output: Disconnected
; 0000 012C ASSR=0x00;
	LDI  R30,LOW(0)
	OUT  0x22,R30
; 0000 012D TCCR2=0x00;
	OUT  0x25,R30
; 0000 012E TCNT2=0x00;
	OUT  0x24,R30
; 0000 012F OCR2=0x00;
	OUT  0x23,R30
; 0000 0130 
; 0000 0131 // External Interrupt(s) initialization
; 0000 0132 // INT0: Off
; 0000 0133 // INT1: Off
; 0000 0134 MCUCR=0x00;
	OUT  0x35,R30
; 0000 0135 
; 0000 0136 // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 0137 TIMSK=0x10;
	LDI  R30,LOW(16)
	OUT  0x39,R30
; 0000 0138 
; 0000 0139 // USART initialization
; 0000 013A // USART disabled
; 0000 013B UCSRB=0x00;
	LDI  R30,LOW(0)
	OUT  0xA,R30
; 0000 013C 
; 0000 013D // Analog Comparator initialization
; 0000 013E // Analog Comparator: Off
; 0000 013F // Analog Comparator Input Capture by Timer/Counter 1: Off
; 0000 0140 ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 0141 SFIOR=0x00;
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0000 0142 
; 0000 0143 // ADC initialization
; 0000 0144 // ADC disabled
; 0000 0145 ADCSRA=0x00;
	OUT  0x6,R30
; 0000 0146 
; 0000 0147 // SPI initialization
; 0000 0148 // SPI disabled
; 0000 0149 SPCR=0x00;
	OUT  0xD,R30
; 0000 014A 
; 0000 014B // TWI initialization
; 0000 014C // TWI disabled
; 0000 014D TWCR=0x00;
	OUT  0x36,R30
; 0000 014E 
; 0000 014F // Alphanumeric LCD initialization
; 0000 0150 // Connections specified in the
; 0000 0151 // Project|Configure|C Compiler|Libraries|Alphanumeric LCD menu:
; 0000 0152 // RS - PORTD Bit 7
; 0000 0153 // RD - PORTD Bit 6
; 0000 0154 // EN - PORTD Bit 5
; 0000 0155 // D4 - PORTD Bit 4
; 0000 0156 // D5 - PORTD Bit 3
; 0000 0157 // D6 - PORTD Bit 2
; 0000 0158 // D7 - PORTD Bit 1
; 0000 0159 // Characters/line: 16
; 0000 015A lcd_init(16);
	LDI  R30,LOW(16)
	ST   -Y,R30
	RCALL _lcd_init
; 0000 015B lcd_putsf("Start System.....");
	__POINTW1FN _0x0,2
	RCALL SUBOPT_0x1D
; 0000 015C lcd_gotoxy(0,1);
	RCALL SUBOPT_0x1E
	RCALL SUBOPT_0x1F
	RCALL _lcd_gotoxy
; 0000 015D lcd_putsf("> ");
	__POINTW1FN _0x0,20
	RCALL SUBOPT_0x1D
; 0000 015E delay_ms(500);
	LDI  R30,LOW(500)
	LDI  R31,HIGH(500)
	RCALL SUBOPT_0x20
; 0000 015F lcd_putsf(">");
	__POINTW1FN _0x0,23
	RCALL SUBOPT_0x1D
; 0000 0160 delay_ms(200);
	RCALL SUBOPT_0x21
; 0000 0161 lcd_putsf("F");
	__POINTW1FN _0x0,25
	RCALL SUBOPT_0x1D
; 0000 0162 delay_ms(200);
	RCALL SUBOPT_0x21
; 0000 0163 lcd_putsf("a");
	__POINTW1FN _0x0,27
	RCALL SUBOPT_0x1D
; 0000 0164 delay_ms(200);
	RCALL SUBOPT_0x21
; 0000 0165 lcd_putsf("i");
	__POINTW1FN _0x0,29
	RCALL SUBOPT_0x1D
; 0000 0166 delay_ms(200);
	RCALL SUBOPT_0x21
; 0000 0167 lcd_putsf("r");
	__POINTW1FN _0x0,31
	RCALL SUBOPT_0x1D
; 0000 0168 delay_ms(200);
	RCALL SUBOPT_0x21
; 0000 0169 lcd_putsf("y");
	__POINTW1FN _0x0,33
	RCALL SUBOPT_0x1D
; 0000 016A delay_ms(200);
	RCALL SUBOPT_0x21
; 0000 016B lcd_putsf("-");
	__POINTW1FN _0x0,35
	RCALL SUBOPT_0x1D
; 0000 016C delay_ms(200);
	RCALL SUBOPT_0x21
; 0000 016D lcd_putsf("E");
	__POINTW1FN _0x0,37
	RCALL SUBOPT_0x1D
; 0000 016E delay_ms(200);
	RCALL SUBOPT_0x21
; 0000 016F lcd_putsf("l");
	__POINTW1FN _0x0,39
	RCALL SUBOPT_0x1D
; 0000 0170 delay_ms(200);
	RCALL SUBOPT_0x21
; 0000 0171 lcd_putsf("a");
	__POINTW1FN _0x0,27
	RCALL SUBOPT_0x1D
; 0000 0172 delay_ms(200);
	RCALL SUBOPT_0x21
; 0000 0173 lcd_putsf("b");
	__POINTW1FN _0x0,41
	RCALL SUBOPT_0x1D
; 0000 0174 delay_ms(200);
	RCALL SUBOPT_0x21
; 0000 0175 lcd_putsf("> ");
	__POINTW1FN _0x0,20
	RCALL SUBOPT_0x1D
; 0000 0176 delay_ms(200);
	RCALL SUBOPT_0x21
; 0000 0177 lcd_putsf(">");
	__POINTW1FN _0x0,23
	RCALL SUBOPT_0x1D
; 0000 0178 role4=0;
	CBI  0x15,5
; 0000 0179 delay_ms(300);
	LDI  R30,LOW(300)
	LDI  R31,HIGH(300)
	RCALL SUBOPT_0x20
; 0000 017A role4=1;
	SBI  0x15,5
; 0000 017B delay_ms(1300);
	LDI  R30,LOW(1300)
	LDI  R31,HIGH(1300)
	RCALL SUBOPT_0x20
; 0000 017C lcd_clear();
	RCALL _lcd_clear
; 0000 017D // Global enable interrupts
; 0000 017E TCCR1A=0x00;
	RCALL SUBOPT_0x1C
; 0000 017F TCCR1B=0x0D;
; 0000 0180 TCNT1H=0x00;
; 0000 0181 TCNT1L=0x00;
; 0000 0182 ICR1H=0x00;
; 0000 0183 ICR1L=0x00;
; 0000 0184 OCR1AH=0x3D;
; 0000 0185 OCR1AL=0x09;
; 0000 0186 OCR1BH=0x00;
; 0000 0187 OCR1BL=0x00;
; 0000 0188 #asm("sei")
	sei
; 0000 0189 
; 0000 018A while (1)
_0x62:
; 0000 018B       {
; 0000 018C       // Place your code here
; 0000 018D         read_key();
	RCALL _read_key
; 0000 018E         lcd_gotoxy(0,0);
	RCALL SUBOPT_0x1E
	RCALL SUBOPT_0x1E
	RCALL _lcd_gotoxy
; 0000 018F 
; 0000 0190         lcd_putnum(nhietdo,1,0);
	LDS  R30,_nhietdo
	LDS  R31,_nhietdo+1
	LDS  R22,_nhietdo+2
	LDS  R23,_nhietdo+3
	RCALL __PUTPARD1
	RCALL SUBOPT_0x1F
	RCALL SUBOPT_0x1E
	RCALL _lcd_putnum
; 0000 0191         lcd_putnum(nhietdodat,7,0);
	RCALL SUBOPT_0x18
	RCALL SUBOPT_0x22
	RCALL SUBOPT_0x1E
	RCALL _lcd_putnum
; 0000 0192         lcd_gotoxy(0,1);
	RCALL SUBOPT_0x1E
	RCALL SUBOPT_0x1F
	RCALL _lcd_gotoxy
; 0000 0193 
; 0000 0194         lcd_putnum(doam,1,1);
	LDS  R30,_doam
	LDS  R31,_doam+1
	LDS  R22,_doam+2
	LDS  R23,_doam+3
	RCALL __PUTPARD1
	RCALL SUBOPT_0x1F
	RCALL SUBOPT_0x1F
	RCALL _lcd_putnum
; 0000 0195         lcd_putnum(doamdat,7,1);
	RCALL SUBOPT_0x1A
	RCALL SUBOPT_0x22
	RCALL SUBOPT_0x1F
	RCALL _lcd_putnum
; 0000 0196         lcd_putnum1(sldao,13,0);
	MOVW R30,R6
	RCALL SUBOPT_0x23
	RCALL __PUTPARD1
	LDI  R30,LOW(13)
	ST   -Y,R30
	RCALL SUBOPT_0x1E
	RCALL _lcd_putnum1
; 0000 0197 
; 0000 0198       if ( nhietdo < nhietdodat-5 ) role1=0;
	RCALL SUBOPT_0x18
	SBIW R30,5
	RCALL SUBOPT_0x24
	RCALL __CPD21
	BRGE _0x65
	CBI  0x15,2
; 0000 0199       if ( nhietdo > nhietdodat+5 ) role1=1;
_0x65:
	RCALL SUBOPT_0x18
	ADIW R30,5
	RCALL SUBOPT_0x24
	RCALL __CPD12
	BRGE _0x68
	SBI  0x15,2
; 0000 019A       if ( doam < doamdat-20 ) role2=0;
_0x68:
	RCALL SUBOPT_0x1A
	SBIW R30,20
	RCALL SUBOPT_0x25
	RCALL __CPD21
	BRGE _0x6B
	CBI  0x15,3
; 0000 019B       if ( doam > doamdat+20 ) role2=1;
_0x6B:
	RCALL SUBOPT_0x1A
	ADIW R30,20
	RCALL SUBOPT_0x25
	RCALL __CPD12
	BRGE _0x6E
	SBI  0x15,3
; 0000 019C       if ((nhietdo < 350)|(doam < 500)|(nhietdo > 385)|(doam > 800)) error=0;
_0x6E:
	RCALL SUBOPT_0x26
	__GETD1N 0x15E
	RCALL __LTD12
	MOV  R0,R30
	RCALL SUBOPT_0x27
	__GETD1N 0x1F4
	RCALL __LTD12
	OR   R0,R30
	RCALL SUBOPT_0x26
	__GETD1N 0x181
	RCALL __GTD12
	OR   R0,R30
	RCALL SUBOPT_0x27
	__GETD1N 0x320
	RCALL __GTD12
	OR   R30,R0
	BREQ _0x71
	CLT
	BLD  R2,0
; 0000 019D       else { error=1; role4=1;}
	RJMP _0x72
_0x71:
	SET
	BLD  R2,0
	SBI  0x15,5
_0x72:
; 0000 019E 
; 0000 019F       }
	RJMP _0x62
; 0000 01A0 }
_0x75:
	RJMP _0x75
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
	RCALL SUBOPT_0x28
    ld    r30,y
    swap  r30
    st    y,r30
	LD   R30,Y
	RCALL SUBOPT_0x28
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
	RCALL SUBOPT_0x29
	LDD  R9,Y+1
	LDD  R8,Y+0
	ADIW R28,2
	RET
_lcd_clear:
	LDI  R30,LOW(2)
	RCALL SUBOPT_0x29
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	RCALL SUBOPT_0x20
	LDI  R30,LOW(12)
	RCALL SUBOPT_0x29
	RCALL SUBOPT_0x1F
	RCALL __lcd_write_data
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	RCALL SUBOPT_0x20
	LDI  R30,LOW(0)
	MOV  R8,R30
	MOV  R9,R30
	RET
_lcd_putchar:
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BREQ _0x2000011
	CP   R9,R11
	BRLO _0x2000010
_0x2000011:
	RCALL SUBOPT_0x1E
	INC  R8
	ST   -Y,R8
	RCALL _lcd_gotoxy
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BREQ _0x2020001
_0x2000010:
	INC  R9
	SBI  0x12,7
	LD   R30,Y
	RCALL SUBOPT_0x29
	CBI  0x12,7
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
	LDD  R11,Y+0
	LD   R30,Y
	SUBI R30,-LOW(128)
	__PUTB1MN __base_y_G100,2
	LD   R30,Y
	SUBI R30,-LOW(192)
	__PUTB1MN __base_y_G100,3
	LDI  R30,LOW(20)
	LDI  R31,HIGH(20)
	RCALL SUBOPT_0x20
	LDI  R30,LOW(48)
	RCALL SUBOPT_0x28
	RCALL SUBOPT_0x2A
	RCALL SUBOPT_0x2A
	RCALL SUBOPT_0x2B
	LDI  R30,LOW(32)
	RCALL SUBOPT_0x28
	RCALL SUBOPT_0x2B
	LDI  R30,LOW(40)
	RCALL SUBOPT_0x29
	LDI  R30,LOW(4)
	RCALL SUBOPT_0x29
	LDI  R30,LOW(133)
	RCALL SUBOPT_0x29
	LDI  R30,LOW(6)
	RCALL SUBOPT_0x29
	RCALL _lcd_clear
_0x2020001:
	ADIW R28,1
	RET

	.ESEG

	.ORG 0x10
_nhietdodat:
	.DW  0x172

	.ORG 0x0

	.ORG 0x35
_doamdat:
	.DW  0x258

	.ORG 0x0

	.ORG 0x3A
_timeoff:
	.DW  0x1

	.ORG 0x0

	.DSEG
_i:
	.BYTE 0x4
_doamh:
	.BYTE 0x4
_doaml:
	.BYTE 0x4
_nhietdoh:
	.BYTE 0x4
_nhietdol:
	.BYTE 0x4
_a:
	.BYTE 0x4
_nhietdo:
	.BYTE 0x4
_doam:
	.BYTE 0x4
_time1day:
	.BYTE 0x4
__base_y_G100:
	.BYTE 0x4

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:49 WORDS
SUBOPT_0x0:
	SBIW R28,12
	__GETD2S 14
	__GETD1N 0x64
	RCALL __DIVD21
	__PUTD1S 8
	__GETD2N 0x64
	RCALL __MULD12
	__GETD2S 14
	RCALL __SUBD21
	__GETD1N 0xA
	RCALL __DIVD21
	__PUTD1S 4
	__GETD1S 8
	__GETD2N 0x64
	RCALL __MULD12
	__GETD2S 14
	RCALL __SWAPD12
	RCALL __SUBD12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x1:
	__GETD1S 4
	__GETD2N 0xA
	RCALL __MULD12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x2:
	RCALL __SUBD21
	RCALL __PUTD2S0
	LDD  R30,Y+13
	ST   -Y,R30
	LDD  R30,Y+13
	ST   -Y,R30
	RCALL _lcd_gotoxy
	LDD  R30,Y+8
	SUBI R30,-LOW(48)
	ST   -Y,R30
	RCALL _lcd_putchar
	LDD  R30,Y+4
	SUBI R30,-LOW(48)
	ST   -Y,R30
	RJMP _lcd_putchar

;OPTIMIZER ADDED SUBROUTINE, CALLED 38 TIMES, CODE SIZE REDUCTION:35 WORDS
SUBOPT_0x3:
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x4:
	STS  _nhietdol,R30
	STS  _nhietdol+1,R31
	STS  _nhietdol+2,R22
	STS  _nhietdol+3,R23
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x5:
	STS  _nhietdoh,R30
	STS  _nhietdoh+1,R31
	STS  _nhietdoh+2,R22
	STS  _nhietdoh+3,R23
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x6:
	STS  _doaml,R30
	STS  _doaml+1,R31
	STS  _doaml+2,R22
	STS  _doaml+3,R23
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x7:
	STS  _doamh,R30
	STS  _doamh+1,R31
	STS  _doamh+2,R22
	STS  _doamh+3,R23
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:53 WORDS
SUBOPT_0x8:
	__GETD1N 0x80
	STS  _a,R30
	STS  _a+1,R31
	STS  _a+2,R22
	STS  _a+3,R23
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:22 WORDS
SUBOPT_0x9:
	LDI  R30,LOW(0)
	STS  _i,R30
	STS  _i+1,R30
	STS  _i+2,R30
	STS  _i+3,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:40 WORDS
SUBOPT_0xA:
	LDS  R26,_i
	LDS  R27,_i+1
	LDS  R24,_i+2
	LDS  R25,_i+3
	__CPD2N 0x8
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0xB:
	LDI  R30,LOW(0)
	OUT  0x32,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xC:
	LDI  R30,LOW(2)
	OUT  0x33,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xD:
	IN   R30,0x32
	CPI  R30,LOW(0x61)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:19 WORDS
SUBOPT_0xE:
	LDS  R30,_a
	LDS  R31,_a+1
	LDS  R22,_a+2
	LDS  R23,_a+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:61 WORDS
SUBOPT_0xF:
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
	RJMP SUBOPT_0xB

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x10:
	LDI  R30,LOW(0)
	OUT  0x33,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:19 WORDS
SUBOPT_0x11:
	LDI  R26,LOW(_i)
	LDI  R27,HIGH(_i)
	RCALL __GETD1P_INC
	__SUBD1N -1
	RCALL __PUTDP1_DEC
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x12:
	LDS  R26,_doaml
	LDS  R27,_doaml+1
	LDS  R24,_doaml+2
	LDS  R25,_doaml+3
	RCALL __ADDD12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x13:
	LDS  R26,_nhietdol
	LDS  R27,_nhietdol+1
	LDS  R24,_nhietdol+2
	LDS  R25,_nhietdol+3
	RCALL __ADDD12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x14:
	__GETD2N 0x100
	RCALL __MULD12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x15:
	RCALL __EEPROMRDW
	ADIW R30,1
	RCALL __EEPROMWRW
	SBIW R30,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x16:
	LDI  R26,LOW(_nhietdodat)
	LDI  R27,HIGH(_nhietdodat)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x17:
	LDI  R26,LOW(_doamdat)
	LDI  R27,HIGH(_doamdat)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x18:
	RCALL SUBOPT_0x16
	RCALL __EEPROMRDW
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x19:
	RCALL __CWD1
	RCALL __PUTPARD1
	LDI  R30,LOW(7)
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	RCALL _lcd_putnum
	LDI  R30,LOW(300)
	LDI  R31,HIGH(300)
	RCALL SUBOPT_0x3
	RJMP _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1A:
	RCALL SUBOPT_0x17
	RCALL __EEPROMRDW
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x1B:
	RCALL __CWD1
	RCALL __PUTPARD1
	LDI  R30,LOW(7)
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	RCALL _lcd_putnum
	LDI  R30,LOW(300)
	LDI  R31,HIGH(300)
	RCALL SUBOPT_0x3
	RJMP _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x1C:
	LDI  R30,LOW(0)
	OUT  0x2F,R30
	LDI  R30,LOW(13)
	OUT  0x2E,R30
	LDI  R30,LOW(0)
	OUT  0x2D,R30
	OUT  0x2C,R30
	OUT  0x27,R30
	OUT  0x26,R30
	LDI  R30,LOW(61)
	OUT  0x2B,R30
	LDI  R30,LOW(9)
	OUT  0x2A,R30
	LDI  R30,LOW(0)
	OUT  0x29,R30
	OUT  0x28,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 15 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x1D:
	RCALL SUBOPT_0x3
	RJMP _lcd_putsf

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x1E:
	LDI  R30,LOW(0)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x1F:
	LDI  R30,LOW(1)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 18 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x20:
	RCALL SUBOPT_0x3
	RJMP _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 12 TIMES, CODE SIZE REDUCTION:20 WORDS
SUBOPT_0x21:
	LDI  R30,LOW(200)
	LDI  R31,HIGH(200)
	RJMP SUBOPT_0x20

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x22:
	RCALL __CWD1
	RCALL __PUTPARD1
	LDI  R30,LOW(7)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x23:
	RCALL __CWD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x24:
	LDS  R26,_nhietdo
	LDS  R27,_nhietdo+1
	LDS  R24,_nhietdo+2
	LDS  R25,_nhietdo+3
	RJMP SUBOPT_0x23

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x25:
	LDS  R26,_doam
	LDS  R27,_doam+1
	LDS  R24,_doam+2
	LDS  R25,_doam+3
	RJMP SUBOPT_0x23

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x26:
	LDS  R26,_nhietdo
	LDS  R27,_nhietdo+1
	LDS  R24,_nhietdo+2
	LDS  R25,_nhietdo+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x27:
	LDS  R26,_doam
	LDS  R27,_doam+1
	LDS  R24,_doam+2
	LDS  R25,_doam+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x28:
	ST   -Y,R30
	RJMP __lcd_write_nibble_G100

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x29:
	ST   -Y,R30
	RJMP __lcd_write_data

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x2A:
	__DELAY_USW 400
	LDI  R30,LOW(48)
	RJMP SUBOPT_0x28

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2B:
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

__CWD1:
	MOV  R22,R31
	ADD  R22,R22
	SBC  R22,R22
	MOV  R23,R22
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

__CPD12:
	CP   R30,R26
	CPC  R31,R27
	CPC  R22,R24
	CPC  R23,R25
	RET

__CPD21:
	CP   R26,R30
	CPC  R27,R31
	CPC  R24,R22
	CPC  R25,R23
	RET

;END OF CODE MARKER
__END_OF_CODE:
