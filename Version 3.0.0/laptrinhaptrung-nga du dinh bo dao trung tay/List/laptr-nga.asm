
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
	.DEF _count_am2301=R4
	.DEF _count_key=R6
	.DEF _count_delay=R8
	.DEF _count_lcd=R10
	.DEF _count_eep=R12

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
	RJMP 0x00
	RJMP 0x00
	RJMP _timer1_ovf_isr
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

_tbl10_G100:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G100:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0

;REGISTER BIT VARIABLES INITIALIZATION
__REG_BIT_VARS:
	.DW  0x00F0

_0x62:
	.DB  0x1
_0xCE:
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0
_0x0:
	.DB  0x2E,0x0,0x54,0x3A,0x20,0x0,0x20,0x20
	.DB  0x3E,0x20,0x20,0x0,0x48,0x3A,0x20,0x0
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x0,0x44
	.DB  0x61,0x6F,0x20,0x54,0x72,0x75,0x6E,0x67
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x54
	.DB  0x75,0x20,0x44,0x6F,0x6E,0x67,0x20,0x0
_0x2020060:
	.DB  0x1
_0x2020000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0,0x49,0x4E,0x46
	.DB  0x0
_0x2040003:
	.DB  0x80,0xC0

__GLOBAL_INI_TBL:
	.DW  0x01
	.DW  0x02
	.DW  __REG_BIT_VARS*2

	.DW  0x01
	.DW  _remember_t
	.DW  _0x62*2

	.DW  0x0A
	.DW  0x04
	.DW  _0xCE*2

	.DW  0x01
	.DW  __seed_G101
	.DW  _0x2020060*2

	.DW  0x02
	.DW  __base_y_G102
	.DW  _0x2040003*2

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
;#include <stdio.h>
;#include <stdlib.h>
;#include <delay.h>
;#include <alcd.h>
;
;eeprom unsigned int hong1,hong2,hong3;
;////////////////////////////////////////
;unsigned int count_am2301=0, count_key=0, count_delay=0, count_lcd=0, count_eep=0;
;eeprom unsigned int count_egg=0;
;bit set_am2301=0, set_key=0, set_egg=0, set_lcd=0;
;int ht_count_egg;
;
;// Timer1 overflow interrupt service routine >>>>>> overflow 1ms
;interrupt [TIM1_OVF] void timer1_ovf_isr(void)
; 0000 0019 {

	.CSEG
_timer1_ovf_isr:
	ST   -Y,R24
	ST   -Y,R25
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 001A // Reinitialize Timer1 value
; 0000 001B TCNT1H=0xFF;
	RCALL SUBOPT_0x0
; 0000 001C TCNT1L=0x05;
; 0000 001D // Place your code here
; 0000 001E count_am2301++;
	MOVW R30,R4
	ADIW R30,1
	MOVW R4,R30
; 0000 001F count_delay++;
	MOVW R30,R8
	ADIW R30,1
	MOVW R8,R30
; 0000 0020 if (count_am2301 >= 2200) { set_am2301=1; count_am2301=0; count_eep++;}
	LDI  R30,LOW(2200)
	LDI  R31,HIGH(2200)
	CP   R4,R30
	CPC  R5,R31
	BRLO _0x3
	SET
	BLD  R2,0
	CLR  R4
	CLR  R5
	MOVW R30,R12
	ADIW R30,1
	MOVW R12,R30
; 0000 0021 if (count_am2301 == 200) {set_key=1;}
_0x3:
	LDI  R30,LOW(200)
	LDI  R31,HIGH(200)
	RCALL SUBOPT_0x1
	BRNE _0x4
	RCALL SUBOPT_0x2
; 0000 0022 if (count_am2301 == 400) {set_key=1;}
_0x4:
	LDI  R30,LOW(400)
	LDI  R31,HIGH(400)
	RCALL SUBOPT_0x1
	BRNE _0x5
	RCALL SUBOPT_0x2
; 0000 0023 if (count_am2301 == 600) {set_key=1;}
_0x5:
	LDI  R30,LOW(600)
	LDI  R31,HIGH(600)
	RCALL SUBOPT_0x1
	BRNE _0x6
	RCALL SUBOPT_0x2
; 0000 0024 if (count_am2301 == 800) {set_key=1;}
_0x6:
	LDI  R30,LOW(800)
	LDI  R31,HIGH(800)
	RCALL SUBOPT_0x1
	BRNE _0x7
	RCALL SUBOPT_0x2
; 0000 0025 if (count_am2301 == 1000) {set_key=1;}
_0x7:
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	RCALL SUBOPT_0x1
	BRNE _0x8
	RCALL SUBOPT_0x2
; 0000 0026 if (count_am2301 == 1200) {set_key=1;}
_0x8:
	LDI  R30,LOW(1200)
	LDI  R31,HIGH(1200)
	RCALL SUBOPT_0x1
	BRNE _0x9
	RCALL SUBOPT_0x2
; 0000 0027 if (count_am2301 == 1400) {set_key=1;}
_0x9:
	LDI  R30,LOW(1400)
	LDI  R31,HIGH(1400)
	RCALL SUBOPT_0x1
	BRNE _0xA
	RCALL SUBOPT_0x2
; 0000 0028 if (count_am2301 == 1600) {set_key=1; #asm("WDR"); }
_0xA:
	LDI  R30,LOW(1600)
	LDI  R31,HIGH(1600)
	RCALL SUBOPT_0x1
	BRNE _0xB
	RCALL SUBOPT_0x2
	WDR
; 0000 0029 if (count_am2301 == 1800) {set_key=1;}
_0xB:
	LDI  R30,LOW(1800)
	LDI  R31,HIGH(1800)
	RCALL SUBOPT_0x1
	BRNE _0xC
	RCALL SUBOPT_0x2
; 0000 002A if (count_am2301 == 2000) {set_key=1;}
_0xC:
	LDI  R30,LOW(2000)
	LDI  R31,HIGH(2000)
	RCALL SUBOPT_0x1
	BRNE _0xD
	RCALL SUBOPT_0x2
; 0000 002B 
; 0000 002C if (count_eep >= 28)
_0xD:
	LDI  R30,LOW(28)
	LDI  R31,HIGH(28)
	CP   R12,R30
	CPC  R13,R31
	BRLO _0xE
; 0000 002D     {
; 0000 002E     count_egg++;
	RCALL SUBOPT_0x3
	ADIW R30,1
	RCALL __EEPROMWRW
	SBIW R30,1
; 0000 002F     ht_count_egg=count_egg;
	RCALL SUBOPT_0x3
	STS  _ht_count_egg,R30
	STS  _ht_count_egg+1,R31
; 0000 0030     if (count_egg >= 200 ) {set_egg=1; count_egg=0;}
	RCALL SUBOPT_0x3
	CPI  R30,LOW(0xC8)
	LDI  R26,HIGH(0xC8)
	CPC  R31,R26
	BRLO _0xF
	SET
	BLD  R2,2
	LDI  R26,LOW(_count_egg)
	LDI  R27,HIGH(_count_egg)
	RCALL SUBOPT_0x4
; 0000 0031     count_eep=0;
_0xF:
	CLR  R12
	CLR  R13
; 0000 0032     }
; 0000 0033 }
_0xE:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	LD   R25,Y+
	LD   R24,Y+
	RETI
;/////////////////////////////////
;void reset_all()
; 0000 0036     {
_reset_all:
; 0000 0037     count_am2301=0;
	CLR  R4
	CLR  R5
; 0000 0038     count_key=0;
	CLR  R6
	CLR  R7
; 0000 0039     count_lcd=0;
	CLR  R10
	CLR  R11
; 0000 003A     count_eep=0;
	CLR  R12
	CLR  R13
; 0000 003B     set_am2301=0;
	CLT
	BLD  R2,0
; 0000 003C     set_key=0;
	BLD  R2,1
; 0000 003D     set_egg=0;
	BLD  R2,2
; 0000 003E     set_lcd=0;
	BLD  R2,3
; 0000 003F     }
	RET
;
;//////////////////////////////////
;
;void delay_mms(int time_delay)
; 0000 0044     {
_delay_mms:
; 0000 0045     count_delay=0;
;	time_delay -> Y+0
	CLR  R8
	CLR  R9
; 0000 0046     while (count_delay<time_delay) {}
_0x10:
	LD   R30,Y
	LDD  R31,Y+1
	CP   R8,R30
	CPC  R9,R31
	BRLO _0x10
; 0000 0047     }
	RJMP _0x20C0002
;//////////////////////////////////
;#define loa PORTB.0
;#define ddrloa DDRB.0
;
;void beep(int ton , int toff , int count)
; 0000 004D {
_beep:
; 0000 004E int i;
; 0000 004F for (i=0; i<count ;i++)
	RCALL __SAVELOCR2
;	ton -> Y+6
;	toff -> Y+4
;	count -> Y+2
;	i -> R16,R17
	RCALL SUBOPT_0x5
_0x14:
	RCALL SUBOPT_0x6
	BRGE _0x15
; 0000 0050     {
; 0000 0051 ddrloa=1;
	RCALL SUBOPT_0x7
; 0000 0052 loa=0;
; 0000 0053 delay_mms(ton);
	RCALL _delay_mms
; 0000 0054 loa=1;
	RCALL SUBOPT_0x8
; 0000 0055 delay_mms(toff);
	RCALL _delay_mms
; 0000 0056     }
	RCALL SUBOPT_0x9
	RJMP _0x14
_0x15:
; 0000 0057 }
	RJMP _0x20C0004
;/////
;void beepe(int ton , int toff , int count)
; 0000 005A {
_beepe:
; 0000 005B int i;
; 0000 005C for (i=0; i<count ;i++)
	RCALL __SAVELOCR2
;	ton -> Y+6
;	toff -> Y+4
;	count -> Y+2
;	i -> R16,R17
	RCALL SUBOPT_0x5
_0x1D:
	RCALL SUBOPT_0x6
	BRGE _0x1E
; 0000 005D     {
; 0000 005E ddrloa=1;
	RCALL SUBOPT_0x7
; 0000 005F loa=0;
; 0000 0060 delay_ms(ton);
	RCALL _delay_ms
; 0000 0061 loa=1;
	RCALL SUBOPT_0x8
; 0000 0062 delay_ms(toff);
	RCALL _delay_ms
; 0000 0063     }
	RCALL SUBOPT_0x9
	RJMP _0x1D
_0x1E:
; 0000 0064 }
_0x20C0004:
	RCALL __LOADLOCR2
	ADIW R28,8
	RET
;
;
;//////////////////////////////////////////////////
;#define ddrdata DDRD.0
;#define portdata PORTD.0
;#define data PIND.0
;long doamh, doaml, nhietdoh, nhietdol, nhietdo, doam;
;
;void read_am2301()    // Clock value: 1382.400 kHz
; 0000 006E      {
_read_am2301:
; 0000 006F      int i,a;
; 0000 0070      #asm("cli")
	RCALL __SAVELOCR4
;	i -> R16,R17
;	a -> R18,R19
	cli
; 0000 0071      TCCR1A=0x00;
	LDI  R30,LOW(0)
	OUT  0x2F,R30
; 0000 0072      TCCR1B=0x00;
	OUT  0x2E,R30
; 0000 0073 
; 0000 0074      ddrdata=1;
	SBI  0x11,0
; 0000 0075      portdata=0;
	CBI  0x12,0
; 0000 0076      delay_ms(1);
	RCALL SUBOPT_0xA
	RCALL _delay_ms
; 0000 0077      portdata=1;
	SBI  0x12,0
; 0000 0078      delay_us(30);
	__DELAY_USB 160
; 0000 0079      portdata=0;
	CBI  0x12,0
; 0000 007A      ddrdata=0;
	CBI  0x11,0
; 0000 007B 
; 0000 007C      while(data==0){}
_0x2F:
	SBIS 0x10,0
	RJMP _0x2F
; 0000 007D      while(data==1){}
_0x32:
	SBIC 0x10,0
	RJMP _0x32
; 0000 007E      while(data==0){}
_0x35:
	SBIS 0x10,0
	RJMP _0x35
; 0000 007F      a=128;
	RCALL SUBOPT_0xB
; 0000 0080      for (i=0;i<8;i++)
_0x39:
	RCALL SUBOPT_0xC
	BRGE _0x3A
; 0000 0081           {
; 0000 0082           TCNT2=0x00;
	RCALL SUBOPT_0xD
; 0000 0083           TCCR2=0x02;
	RCALL SUBOPT_0xE
; 0000 0084           while(data==1){}
_0x3B:
	SBIC 0x10,0
	RJMP _0x3B
; 0000 0085           if (TCNT2 > 96) doamh = doamh + a ;
	RCALL SUBOPT_0xF
	BRLO _0x3E
	MOVW R30,R18
	LDS  R26,_doamh
	LDS  R27,_doamh+1
	LDS  R24,_doamh+2
	LDS  R25,_doamh+3
	RCALL SUBOPT_0x10
	RCALL SUBOPT_0x11
; 0000 0086           a=a/2;
_0x3E:
	RCALL SUBOPT_0x12
; 0000 0087           TCNT2=0x00;
; 0000 0088           TCCR2=0x00;
	RCALL SUBOPT_0x13
; 0000 0089           while (data==0){}
_0x3F:
	SBIS 0x10,0
	RJMP _0x3F
; 0000 008A           }
	RCALL SUBOPT_0x9
	RJMP _0x39
_0x3A:
; 0000 008B      a=128;
	RCALL SUBOPT_0xB
; 0000 008C      for (i=0;i<8;i++)
_0x43:
	RCALL SUBOPT_0xC
	BRGE _0x44
; 0000 008D           {
; 0000 008E           TCNT2=0x00;
	RCALL SUBOPT_0xD
; 0000 008F           TCCR2=0x02;
	RCALL SUBOPT_0xE
; 0000 0090           while(data==1){    }
_0x45:
	SBIC 0x10,0
	RJMP _0x45
; 0000 0091           if (TCNT2 > 96) doaml = doaml + a ;
	RCALL SUBOPT_0xF
	BRLO _0x48
	MOVW R30,R18
	RCALL SUBOPT_0x14
	RCALL SUBOPT_0x10
	RCALL SUBOPT_0x15
; 0000 0092           a=a/2;
_0x48:
	RCALL SUBOPT_0x12
; 0000 0093           TCNT2=0x00;
; 0000 0094           TCCR2=0x00;
	RCALL SUBOPT_0x13
; 0000 0095           while (data==0){}
_0x49:
	SBIS 0x10,0
	RJMP _0x49
; 0000 0096           }
	RCALL SUBOPT_0x9
	RJMP _0x43
_0x44:
; 0000 0097      a=128;
	RCALL SUBOPT_0xB
; 0000 0098      for (i=0;i<8;i++)
_0x4D:
	RCALL SUBOPT_0xC
	BRGE _0x4E
; 0000 0099           {
; 0000 009A           TCNT2=0x00;
	RCALL SUBOPT_0xD
; 0000 009B           TCCR2=0x02;
	RCALL SUBOPT_0xE
; 0000 009C           while(data==1){}
_0x4F:
	SBIC 0x10,0
	RJMP _0x4F
; 0000 009D           if (TCNT2 > 96 ) nhietdoh = nhietdoh + a ;
	RCALL SUBOPT_0xF
	BRLO _0x52
	MOVW R30,R18
	LDS  R26,_nhietdoh
	LDS  R27,_nhietdoh+1
	LDS  R24,_nhietdoh+2
	LDS  R25,_nhietdoh+3
	RCALL SUBOPT_0x10
	RCALL SUBOPT_0x16
; 0000 009E           a=a/2;
_0x52:
	RCALL SUBOPT_0x12
; 0000 009F           TCNT2=0x00;
; 0000 00A0           TCCR2=0x00;
	RCALL SUBOPT_0x13
; 0000 00A1           while (data==0){}
_0x53:
	SBIS 0x10,0
	RJMP _0x53
; 0000 00A2           }
	RCALL SUBOPT_0x9
	RJMP _0x4D
_0x4E:
; 0000 00A3      a=128;
	RCALL SUBOPT_0xB
; 0000 00A4      for (i=0;i<8;i++)
_0x57:
	RCALL SUBOPT_0xC
	BRGE _0x58
; 0000 00A5           {
; 0000 00A6           TCNT2=0x00;
	RCALL SUBOPT_0xD
; 0000 00A7           TCCR2=0x02;
	RCALL SUBOPT_0xE
; 0000 00A8           while(data==1){}
_0x59:
	SBIC 0x10,0
	RJMP _0x59
; 0000 00A9           if (TCNT2 > 96) nhietdol = nhietdol + a ;
	RCALL SUBOPT_0xF
	BRLO _0x5C
	MOVW R30,R18
	RCALL SUBOPT_0x17
	RCALL SUBOPT_0x10
	RCALL SUBOPT_0x18
; 0000 00AA           a=a/2;
_0x5C:
	RCALL SUBOPT_0x12
; 0000 00AB           TCNT2=0x00;
; 0000 00AC           TCCR2=0x00;
	RCALL SUBOPT_0x13
; 0000 00AD           while (data==0){}
_0x5D:
	SBIS 0x10,0
	RJMP _0x5D
; 0000 00AE           }
	RCALL SUBOPT_0x9
	RJMP _0x57
_0x58:
; 0000 00AF      nhietdo = nhietdoh*256 + nhietdol;
	LDS  R30,_nhietdoh
	LDS  R31,_nhietdoh+1
	LDS  R22,_nhietdoh+2
	LDS  R23,_nhietdoh+3
	RCALL SUBOPT_0x19
	RCALL SUBOPT_0x17
	RCALL __ADDD12
	STS  _nhietdo,R30
	STS  _nhietdo+1,R31
	STS  _nhietdo+2,R22
	STS  _nhietdo+3,R23
; 0000 00B0      doam = doamh*256 + doaml;
	LDS  R30,_doamh
	LDS  R31,_doamh+1
	LDS  R22,_doamh+2
	LDS  R23,_doamh+3
	RCALL SUBOPT_0x19
	RCALL SUBOPT_0x14
	RCALL __ADDD12
	STS  _doam,R30
	STS  _doam+1,R31
	STS  _doam+2,R22
	STS  _doam+3,R23
; 0000 00B1      doamh=doaml=nhietdoh=nhietdol=0;
	__GETD1N 0x0
	RCALL SUBOPT_0x18
	RCALL SUBOPT_0x16
	RCALL SUBOPT_0x15
	RCALL SUBOPT_0x11
; 0000 00B2      portdata=1;
	SBI  0x12,0
; 0000 00B3 
; 0000 00B4      TCNT2=0x00;
	RCALL SUBOPT_0xD
; 0000 00B5      TCCR2=0x00;
	RCALL SUBOPT_0x13
; 0000 00B6      TCCR1A=0x00;
	RCALL SUBOPT_0x1A
; 0000 00B7      TCCR1B=0x03;
; 0000 00B8      TCNT1H=0xFF;
; 0000 00B9      TCNT1L=0x05;
; 0000 00BA      ICR1H=0x00;
	RCALL SUBOPT_0x1B
; 0000 00BB      ICR1L=0x00;
; 0000 00BC      #asm("sei")
	sei
; 0000 00BD      }
	RCALL __LOADLOCR4
	ADIW R28,4
	RET
;
;
;///////////////////////////////////////////////////
;#define fan_o2 PORTC.2
;#define fan_top PORTC.1
;#define fan_bottom PORTC.0
;#define lamp PORTC.5
;#define motor PORTC.4
;#define humidifier PORTC.3
;
;#define on 0
;#define off 1
;eeprom unsigned int nhietdocd=370;
;char remember_t=1;

	.DSEG
;
;void control_remember()
; 0000 00CE     {

	.CSEG
_control_remember:
; 0000 00CF 
; 0000 00D0     switch (remember_t) {
	LDS  R30,_remember_t
	LDI  R31,0
; 0000 00D1         case 1:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x66
; 0000 00D2             lamp=off;
	SBI  0x15,5
; 0000 00D3             fan_top=off;
	SBI  0x15,1
; 0000 00D4             fan_bottom=on;
	CBI  0x15,0
; 0000 00D5             fan_o2=off;
	SBI  0x15,2
; 0000 00D6             if (nhietdo < nhietdocd+2) remember_t=2;
	RCALL SUBOPT_0x1C
	ADIW R30,2
	RCALL SUBOPT_0x1D
	BRGE _0x6F
	LDI  R30,LOW(2)
	RCALL SUBOPT_0x1E
; 0000 00D7             break;
_0x6F:
	RJMP _0x65
; 0000 00D8         case 2:
_0x66:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x70
; 0000 00D9             lamp=off;
	SBI  0x15,5
; 0000 00DA             fan_top=on;
	RCALL SUBOPT_0x1F
; 0000 00DB             fan_bottom=on;
; 0000 00DC             fan_o2=on;
; 0000 00DD             if (nhietdo < nhietdocd-1) remember_t=3;
	SBIW R30,1
	RCALL SUBOPT_0x1D
	BRGE _0x79
	LDI  R30,LOW(3)
	RCALL SUBOPT_0x1E
; 0000 00DE             if (nhietdo >= nhietdocd+5) remember_t=1;
_0x79:
	RCALL SUBOPT_0x1C
	ADIW R30,5
	RCALL SUBOPT_0x1D
	BRLT _0x7A
	LDI  R30,LOW(1)
	RCALL SUBOPT_0x1E
; 0000 00DF             break;
_0x7A:
	RJMP _0x65
; 0000 00E0         case 3:
_0x70:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x65
; 0000 00E1             lamp=on;
	CBI  0x15,5
; 0000 00E2             fan_top=on;
	RCALL SUBOPT_0x1F
; 0000 00E3             fan_bottom=on;
; 0000 00E4             fan_o2=on;
; 0000 00E5             if (nhietdo > nhietdocd+1) remember_t=2;
	ADIW R30,1
	LDS  R26,_nhietdo
	LDS  R27,_nhietdo+1
	LDS  R24,_nhietdo+2
	LDS  R25,_nhietdo+3
	CLR  R22
	CLR  R23
	RCALL __CPD12
	BRGE _0x84
	LDI  R30,LOW(2)
	RCALL SUBOPT_0x1E
; 0000 00E6             if (nhietdo >= nhietdocd+5) remember_t=1;
_0x84:
	RCALL SUBOPT_0x1C
	ADIW R30,5
	RCALL SUBOPT_0x1D
	BRLT _0x85
	LDI  R30,LOW(1)
	RCALL SUBOPT_0x1E
; 0000 00E7             break;
_0x85:
; 0000 00E8         }
_0x65:
; 0000 00E9 
; 0000 00EA     }
	RET
;
;
;///////////////////////////////////////
;
;void lcd_putnum (long so,unsigned char x,unsigned char y)
; 0000 00F0 {
_lcd_putnum:
; 0000 00F1    long a, b, c;
; 0000 00F2    a = so / 100;
	RCALL SUBOPT_0x20
;	so -> Y+14
;	x -> Y+13
;	y -> Y+12
;	a -> Y+8
;	b -> Y+4
;	c -> Y+0
; 0000 00F3    b = (so - 100 * a) / 10;
; 0000 00F4    c = so - 100 * a - 10 * b;
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	RCALL SUBOPT_0x21
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	RCALL SUBOPT_0x22
; 0000 00F5    lcd_gotoxy (x, y) ;
; 0000 00F6    lcd_putchar (a + 48) ;
; 0000 00F7    lcd_putchar (b + 48) ;
; 0000 00F8    lcd_putsf(".");
	__POINTW1FN _0x0,0
	RCALL SUBOPT_0x23
; 0000 00F9    lcd_putchar (c + 48) ;
	RJMP _0x20C0003
; 0000 00FA }
;
;void lcd_putnum2 (long so,unsigned char x,unsigned char y)
; 0000 00FD {
_lcd_putnum2:
; 0000 00FE    long a, b, c;
; 0000 00FF    a = so / 100;
	RCALL SUBOPT_0x20
;	so -> Y+14
;	x -> Y+13
;	y -> Y+12
;	a -> Y+8
;	b -> Y+4
;	c -> Y+0
; 0000 0100    b = (so - 100 * a) / 10;
; 0000 0101    c = so - 100 * a - 10 * b;
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	RCALL SUBOPT_0x21
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	RCALL SUBOPT_0x22
; 0000 0102    lcd_gotoxy (x, y) ;
; 0000 0103    lcd_putchar (a + 48) ;
; 0000 0104    lcd_putchar (b + 48) ;
; 0000 0105    lcd_putchar (c + 48) ;
_0x20C0003:
	LD   R30,Y
	SUBI R30,-LOW(48)
	ST   -Y,R30
	RCALL _lcd_putchar
; 0000 0106 }
	ADIW R28,18
	RET
;
;
;void hienthi_lcd()
; 0000 010A {
_hienthi_lcd:
; 0000 010B     lcd_gotoxy(0,0);
	RCALL SUBOPT_0x24
	RCALL SUBOPT_0x24
	RCALL _lcd_gotoxy
; 0000 010C     lcd_putsf("T: ");
	__POINTW1FN _0x0,2
	RCALL SUBOPT_0x23
; 0000 010D     lcd_putnum(nhietdo,3,0);
	LDS  R30,_nhietdo
	LDS  R31,_nhietdo+1
	LDS  R22,_nhietdo+2
	LDS  R23,_nhietdo+3
	RCALL __PUTPARD1
	LDI  R30,LOW(3)
	ST   -Y,R30
	RCALL SUBOPT_0x24
	RCALL _lcd_putnum
; 0000 010E     lcd_gotoxy(7,0);
	LDI  R30,LOW(7)
	ST   -Y,R30
	RCALL SUBOPT_0x24
	RCALL _lcd_gotoxy
; 0000 010F     lcd_putsf("  >  ");
	__POINTW1FN _0x0,6
	RCALL SUBOPT_0x23
; 0000 0110     lcd_putnum(nhietdocd,12,0);
	RCALL SUBOPT_0x1C
	CLR  R22
	CLR  R23
	RCALL __PUTPARD1
	LDI  R30,LOW(12)
	ST   -Y,R30
	RCALL SUBOPT_0x24
	RCALL _lcd_putnum
; 0000 0111     lcd_gotoxy(0,1);
	RCALL SUBOPT_0x24
	RCALL SUBOPT_0x25
	RCALL _lcd_gotoxy
; 0000 0112     lcd_putsf("H: ");
	__POINTW1FN _0x0,12
	RCALL SUBOPT_0x23
; 0000 0113     lcd_putnum(doam,3,1);
	LDS  R30,_doam
	LDS  R31,_doam+1
	LDS  R22,_doam+2
	LDS  R23,_doam+3
	RCALL __PUTPARD1
	LDI  R30,LOW(3)
	ST   -Y,R30
	RCALL SUBOPT_0x25
	RCALL _lcd_putnum
; 0000 0114     lcd_gotoxy(7,1);
	LDI  R30,LOW(7)
	ST   -Y,R30
	RCALL SUBOPT_0x25
	RCALL _lcd_gotoxy
; 0000 0115     lcd_putsf("      ");
	__POINTW1FN _0x0,16
	RCALL SUBOPT_0x23
; 0000 0116     lcd_putnum2(ht_count_egg,13,1);
	LDS  R30,_ht_count_egg
	LDS  R31,_ht_count_egg+1
	RCALL __CWD1
	RCALL __PUTPARD1
	LDI  R30,LOW(13)
	ST   -Y,R30
	RCALL SUBOPT_0x25
	RCALL _lcd_putnum2
; 0000 0117 
; 0000 0118 }
	RET
;
;////////////////////////////////////////////
;
;#define led PORTB.1
;#define button_l PINB.2
;#define button_x PINB.3
;#define button_m PINB.4
;#define button_s PINB.5
;bit button_tl=1, button_tx=1, button_motor=1, button_sw=1;
;
;void scan_key(){
; 0000 0123 void scan_key(){
_scan_key:
; 0000 0124 PORTB.2=1; PORTB.3=1; PORTB.4=1; PORTB.5=1;
	SBI  0x18,2
	SBI  0x18,3
	SBI  0x18,4
	SBI  0x18,5
; 0000 0125 DDRB=0b00000011;
	LDI  R30,LOW(3)
	OUT  0x17,R30
; 0000 0126 delay_mms(2);
	RCALL SUBOPT_0x26
; 0000 0127 if(button_l==0) button_tl=0; else button_tl=1;
	SBIC 0x16,2
	RJMP _0x8E
	CLT
	RJMP _0xC7
_0x8E:
	SET
_0xC7:
	BLD  R2,4
; 0000 0128 delay_mms(2);
	RCALL SUBOPT_0x26
; 0000 0129 if(button_x==0) button_tx=0; else button_tx=1;
	SBIC 0x16,3
	RJMP _0x90
	CLT
	RJMP _0xC8
_0x90:
	SET
_0xC8:
	BLD  R2,5
; 0000 012A delay_mms(2);
	RCALL SUBOPT_0x26
; 0000 012B if(button_m==0) button_motor=0; else button_motor=1;
	SBIC 0x16,4
	RJMP _0x92
	CLT
	RJMP _0xC9
_0x92:
	SET
_0xC9:
	BLD  R2,6
; 0000 012C delay_mms(2);
	RCALL SUBOPT_0x26
; 0000 012D if(button_s==0) button_sw=0; else button_sw=1;
	SBIC 0x16,5
	RJMP _0x94
	CLT
	RJMP _0xCA
_0x94:
	SET
_0xCA:
	BLD  R2,7
; 0000 012E delay_mms(2);
	RCALL SUBOPT_0x26
; 0000 012F }
	RET
;
;void read_key()
; 0000 0132 {
_read_key:
; 0000 0133 scan_key();
	RCALL _scan_key
; 0000 0134 if (button_tl ==on){
	SBRC R2,4
	RJMP _0x96
; 0000 0135         nhietdocd++;
	RCALL SUBOPT_0x1C
	ADIW R30,1
	RCALL __EEPROMWRW
	SBIW R30,1
; 0000 0136         beep(10,40,1);
	RCALL SUBOPT_0x27
	RCALL _beep
; 0000 0137         hienthi_lcd();
	RCALL _hienthi_lcd
; 0000 0138         }
; 0000 0139 if (button_tx ==on){
_0x96:
	SBRC R2,5
	RJMP _0x97
; 0000 013A         nhietdocd--;
	RCALL SUBOPT_0x1C
	SBIW R30,1
	RCALL __EEPROMWRW
	ADIW R30,1
; 0000 013B         beep(10,40,1);
	RCALL SUBOPT_0x27
	RCALL _beep
; 0000 013C         hienthi_lcd();
	RCALL _hienthi_lcd
; 0000 013D         }
; 0000 013E }
_0x97:
	RET
;
;
;
;///////////////////////////////////////////////
;
;eeprom int dttudong=0;
;
;void main(void)
; 0000 0147 {
_main:
; 0000 0148 
; 0000 0149 // Declare your local variables here
; 0000 014A PORTB=0b1111111;
	LDI  R30,LOW(127)
	OUT  0x18,R30
; 0000 014B DDRB=0b00000011;
	LDI  R30,LOW(3)
	OUT  0x17,R30
; 0000 014C 
; 0000 014D PORTC=0xff;
	LDI  R30,LOW(255)
	OUT  0x15,R30
; 0000 014E DDRC=0xff;
	OUT  0x14,R30
; 0000 014F 
; 0000 0150 PORTD=0xff;
	OUT  0x12,R30
; 0000 0151 DDRD=0x00;
	LDI  R30,LOW(0)
	OUT  0x11,R30
; 0000 0152 
; 0000 0153 // Timer/Counter 0 initialization
; 0000 0154 // Clock source: System Clock
; 0000 0155 // Clock value: Timer 0 Stopped
; 0000 0156 TCCR0=0x00;
	OUT  0x33,R30
; 0000 0157 TCNT0=0x00;
	OUT  0x32,R30
; 0000 0158 
; 0000 0159 // Timer/Counter 1 initialization
; 0000 015A // Clock source: System Clock
; 0000 015B // Clock value: 250.000 kHz
; 0000 015C // Mode: Normal top=0xFFFF
; 0000 015D // OC1A output: Discon.
; 0000 015E // OC1B output: Discon.
; 0000 015F // Noise Canceler: Off
; 0000 0160 // Input Capture on Falling Edge
; 0000 0161 // Timer1 Overflow Interrupt: On
; 0000 0162 // Input Capture Interrupt: Off
; 0000 0163 // Compare A Match Interrupt: Off
; 0000 0164 // Compare B Match Interrupt: Off
; 0000 0165 TCCR1A=0x00;
	RCALL SUBOPT_0x1A
; 0000 0166 TCCR1B=0x03;
; 0000 0167 TCNT1H=0xFF;
; 0000 0168 TCNT1L=0x05;
; 0000 0169 ICR1H=0x00;
	RCALL SUBOPT_0x1B
; 0000 016A ICR1L=0x00;
; 0000 016B OCR1AH=0x00;
	LDI  R30,LOW(0)
	OUT  0x2B,R30
; 0000 016C OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 016D OCR1BH=0x00;
	OUT  0x29,R30
; 0000 016E OCR1BL=0x00;
	OUT  0x28,R30
; 0000 016F 
; 0000 0170 // Timer/Counter 2 initialization
; 0000 0171 // Clock source: System Clock
; 0000 0172 // Clock value: Timer2 Stopped
; 0000 0173 // Mode: Normal top=0xFF
; 0000 0174 // OC2 output: Disconnected
; 0000 0175 ASSR=0x00;
	OUT  0x22,R30
; 0000 0176 TCCR2=0x00;
	RCALL SUBOPT_0x13
; 0000 0177 TCNT2=0x00;
	RCALL SUBOPT_0xD
; 0000 0178 OCR2=0x00;
	LDI  R30,LOW(0)
	OUT  0x23,R30
; 0000 0179 
; 0000 017A // External Interrupt(s) initialization
; 0000 017B // INT0: Off
; 0000 017C // INT1: Off
; 0000 017D MCUCR=0x00;
	OUT  0x35,R30
; 0000 017E 
; 0000 017F // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 0180 TIMSK=0x04;
	LDI  R30,LOW(4)
	OUT  0x39,R30
; 0000 0181 
; 0000 0182 // USART initialization
; 0000 0183 // USART disabled
; 0000 0184 UCSRB=0x00;
	LDI  R30,LOW(0)
	OUT  0xA,R30
; 0000 0185 
; 0000 0186 // Analog Comparator initialization
; 0000 0187 // Analog Comparator: Off
; 0000 0188 // Analog Comparator Input Capture by Timer/Counter 1: Off
; 0000 0189 ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 018A SFIOR=0x00;
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0000 018B 
; 0000 018C // ADC initialization
; 0000 018D // ADC disabled
; 0000 018E ADCSRA=0x00;
	OUT  0x6,R30
; 0000 018F 
; 0000 0190 // SPI initialization
; 0000 0191 // SPI disabled
; 0000 0192 SPCR=0x00;
	OUT  0xD,R30
; 0000 0193 
; 0000 0194 // TWI initialization
; 0000 0195 // TWI disabled
; 0000 0196 TWCR=0x00;
	OUT  0x36,R30
; 0000 0197 
; 0000 0198 // Alphanumeric LCD initialization
; 0000 0199 // Connections specified in the
; 0000 019A // Project|Configure|C Compiler|Libraries|Alphanumeric LCD menu:
; 0000 019B // RS - PORTD Bit 1
; 0000 019C // RD - PORTD Bit 2
; 0000 019D // EN - PORTD Bit 3
; 0000 019E // D4 - PORTD Bit 4
; 0000 019F // D5 - PORTD Bit 5
; 0000 01A0 // D6 - PORTD Bit 6
; 0000 01A1 // D7 - PORTD Bit 7
; 0000 01A2 // Characters/line: 16
; 0000 01A3 lcd_init(16);
	LDI  R30,LOW(16)
	ST   -Y,R30
	RCALL _lcd_init
; 0000 01A4 
; 0000 01A5 hong1=0;
	LDI  R26,LOW(_hong1)
	LDI  R27,HIGH(_hong1)
	RCALL SUBOPT_0x4
; 0000 01A6 hong2=0;
	LDI  R26,LOW(_hong2)
	LDI  R27,HIGH(_hong2)
	RCALL SUBOPT_0x4
; 0000 01A7 hong3=0;
	LDI  R26,LOW(_hong3)
	LDI  R27,HIGH(_hong3)
	RCALL SUBOPT_0x4
; 0000 01A8 
; 0000 01A9 // Watchdog Timer initialization
; 0000 01AA // Watchdog Timer Prescaler: OSC/2048k
; 0000 01AB 
; 0000 01AC #pragma optsize-
; 0000 01AD WDTCR=0x1F;
	LDI  R30,LOW(31)
	OUT  0x21,R30
; 0000 01AE WDTCR=0x0F;
	LDI  R30,LOW(15)
	OUT  0x21,R30
; 0000 01AF #ifdef _OPTIMIZE_SIZE_
; 0000 01B0 #pragma optsize+
; 0000 01B1 #endif
; 0000 01B2 
; 0000 01B3 // Global enable interrupts
; 0000 01B4 #asm("sei")
	sei
; 0000 01B5 
; 0000 01B6 beepe(20,80,1);
	RCALL SUBOPT_0x28
	LDI  R30,LOW(80)
	LDI  R31,HIGH(80)
	RCALL SUBOPT_0x29
	RCALL _beepe
; 0000 01B7 reset_all();
	RCALL _reset_all
; 0000 01B8 while (1)
_0x98:
; 0000 01B9       {
; 0000 01BA       if (set_am2301==1)
	SBRS R2,0
	RJMP _0x9B
; 0000 01BB         {
; 0000 01BC         set_am2301=0;
	CLT
	BLD  R2,0
; 0000 01BD         read_am2301();
	RCALL _read_am2301
; 0000 01BE         control_remember();
	RCALL _control_remember
; 0000 01BF         hienthi_lcd();
	RCALL _hienthi_lcd
; 0000 01C0         }
; 0000 01C1 
; 0000 01C2       if (set_key==1)
_0x9B:
	SBRS R2,1
	RJMP _0x9C
; 0000 01C3         {
; 0000 01C4         read_key();
	RCALL _read_key
; 0000 01C5         if (button_motor == on)
	SBRC R2,6
	RJMP _0x9D
; 0000 01C6             {
; 0000 01C7             if (dttudong==0) dttudong=1; else dttudong=0;
	RCALL SUBOPT_0x2A
	RCALL __EEPROMRDW
	SBIW R30,0
	BRNE _0x9E
	RCALL SUBOPT_0x2A
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	RJMP _0xCB
_0x9E:
	RCALL SUBOPT_0x2A
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
_0xCB:
	RCALL __EEPROMWRW
; 0000 01C8             beep(10,40,1);
	RCALL SUBOPT_0x27
	RCALL _beep
; 0000 01C9             }
; 0000 01CA         set_key=0;
_0x9D:
	CLT
	BLD  R2,1
; 0000 01CB         }
; 0000 01CC 
; 0000 01CD       if (dttudong==on)
_0x9C:
	RCALL SUBOPT_0x2A
	RCALL __EEPROMRDW
	SBIW R30,0
	BREQ PC+2
	RJMP _0xA0
; 0000 01CE         {
; 0000 01CF         led=1;
	SBI  0x18,1
; 0000 01D0         if (set_egg==1)
	SBRS R2,2
	RJMP _0xA3
; 0000 01D1         {
; 0000 01D2          #asm("WDR");
	WDR
; 0000 01D3          fan_top=fan_bottom=fan_o2=lamp=humidifier=motor=off;
	SBI  0x15,4
	SBI  0x15,3
	SBI  0x15,5
	SBI  0x15,2
	SBI  0x15,0
	SBI  0x15,1
; 0000 01D4          lcd_clear();
	RCALL _lcd_clear
; 0000 01D5          beep(20,30,1);
	RCALL SUBOPT_0x28
	LDI  R30,LOW(30)
	LDI  R31,HIGH(30)
	RCALL SUBOPT_0x29
	RCALL _beep
; 0000 01D6          lcd_putsf("Dao Trung               Tu Dong ");
	__POINTW1FN _0x0,23
	RCALL SUBOPT_0x23
; 0000 01D7 
; 0000 01D8          while (button_sw==off)
_0xB0:
	SBRS R2,7
	RJMP _0xB2
; 0000 01D9          {
; 0000 01DA          motor=on;
	RCALL SUBOPT_0x2B
; 0000 01DB          delay_mms(50);
; 0000 01DC          if(button_s==0) button_sw=0; else button_sw=1;
	SBIC 0x16,5
	RJMP _0xB5
	CLT
	RJMP _0xCC
_0xB5:
	SET
_0xCC:
	BLD  R2,7
; 0000 01DD          delay_mms(50);
	RCALL SUBOPT_0x2C
; 0000 01DE          #asm("WDR");
	WDR
; 0000 01DF          }
	RJMP _0xB0
_0xB2:
; 0000 01E0          delay_mms(200);
	LDI  R30,LOW(200)
	LDI  R31,HIGH(200)
	ST   -Y,R31
	ST   -Y,R30
	RCALL _delay_mms
; 0000 01E1          while (button_sw==on)
_0xB7:
	SBRC R2,7
	RJMP _0xB9
; 0000 01E2          {
; 0000 01E3          motor=on;
	RCALL SUBOPT_0x2B
; 0000 01E4          delay_mms(50);
; 0000 01E5          if(button_s==0) button_sw=0; else button_sw=1;
	SBIC 0x16,5
	RJMP _0xBC
	CLT
	RJMP _0xCD
_0xBC:
	SET
_0xCD:
	BLD  R2,7
; 0000 01E6          delay_mms(50);
	RCALL SUBOPT_0x2C
; 0000 01E7          #asm("WDR");
	WDR
; 0000 01E8          }
	RJMP _0xB7
_0xB9:
; 0000 01E9          beep(20,30,1);
	RCALL SUBOPT_0x28
	LDI  R30,LOW(30)
	LDI  R31,HIGH(30)
	RCALL SUBOPT_0x29
	RCALL _beep
; 0000 01EA          delay_mms(350);
	LDI  R30,LOW(350)
	LDI  R31,HIGH(350)
	ST   -Y,R31
	ST   -Y,R30
	RCALL _delay_mms
; 0000 01EB          motor=off;
	SBI  0x15,4
; 0000 01EC          reset_all();
	RCALL _reset_all
; 0000 01ED          set_egg=0;
	CLT
	BLD  R2,2
; 0000 01EE          while (1){}
_0xC0:
	RJMP _0xC0
; 0000 01EF         }
; 0000 01F0         } else {led=0; count_eep=0; ht_count_egg=0; set_egg=0; }
_0xA3:
	RJMP _0xC3
_0xA0:
	CBI  0x18,1
	CLR  R12
	CLR  R13
	LDI  R30,LOW(0)
	STS  _ht_count_egg,R30
	STS  _ht_count_egg+1,R30
	CLT
	BLD  R2,2
_0xC3:
; 0000 01F1 
; 0000 01F2       }
	RJMP _0x98
; 0000 01F3 
; 0000 01F4 }
_0xC6:
	RJMP _0xC6
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

	.CSEG

	.CSEG

	.DSEG

	.CSEG
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
__lcd_write_nibble_G102:
	LD   R30,Y
	ANDI R30,LOW(0x10)
	BREQ _0x2040004
	SBI  0x12,4
	RJMP _0x2040005
_0x2040004:
	CBI  0x12,4
_0x2040005:
	LD   R30,Y
	ANDI R30,LOW(0x20)
	BREQ _0x2040006
	SBI  0x12,5
	RJMP _0x2040007
_0x2040006:
	CBI  0x12,5
_0x2040007:
	LD   R30,Y
	ANDI R30,LOW(0x40)
	BREQ _0x2040008
	SBI  0x12,6
	RJMP _0x2040009
_0x2040008:
	CBI  0x12,6
_0x2040009:
	LD   R30,Y
	ANDI R30,LOW(0x80)
	BREQ _0x204000A
	SBI  0x12,7
	RJMP _0x204000B
_0x204000A:
	CBI  0x12,7
_0x204000B:
	__DELAY_USB 11
	SBI  0x12,3
	__DELAY_USB 27
	CBI  0x12,3
	__DELAY_USB 27
	RJMP _0x20C0001
__lcd_write_data:
	LD   R30,Y
	RCALL SUBOPT_0x2D
    ld    r30,y
    swap  r30
    st    y,r30
	LD   R30,Y
	RCALL SUBOPT_0x2D
	__DELAY_USW 200
	RJMP _0x20C0001
_lcd_gotoxy:
	LD   R30,Y
	LDI  R31,0
	SUBI R30,LOW(-__base_y_G102)
	SBCI R31,HIGH(-__base_y_G102)
	LD   R30,Z
	LDD  R26,Y+1
	ADD  R30,R26
	RCALL SUBOPT_0x2E
	LDD  R30,Y+1
	STS  __lcd_x,R30
	LD   R30,Y
	STS  __lcd_y,R30
_0x20C0002:
	ADIW R28,2
	RET
_lcd_clear:
	LDI  R30,LOW(2)
	RCALL SUBOPT_0x2E
	RCALL SUBOPT_0x2F
	LDI  R30,LOW(12)
	RCALL SUBOPT_0x2E
	RCALL SUBOPT_0x25
	RCALL __lcd_write_data
	RCALL SUBOPT_0x2F
	LDI  R30,LOW(0)
	STS  __lcd_y,R30
	STS  __lcd_x,R30
	RET
_lcd_putchar:
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BREQ _0x2040011
	LDS  R30,__lcd_maxx
	LDS  R26,__lcd_x
	CP   R26,R30
	BRLO _0x2040010
_0x2040011:
	RCALL SUBOPT_0x24
	LDS  R30,__lcd_y
	SUBI R30,-LOW(1)
	STS  __lcd_y,R30
	ST   -Y,R30
	RCALL _lcd_gotoxy
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BRNE _0x2040013
	RJMP _0x20C0001
_0x2040013:
_0x2040010:
	LDS  R30,__lcd_x
	SUBI R30,-LOW(1)
	STS  __lcd_x,R30
	SBI  0x12,1
	LD   R30,Y
	RCALL SUBOPT_0x2E
	CBI  0x12,1
	RJMP _0x20C0001
_lcd_putsf:
	ST   -Y,R17
_0x2040017:
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	ADIW R30,1
	STD  Y+1,R30
	STD  Y+1+1,R31
	SBIW R30,1
	LPM  R30,Z
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x2040019
	ST   -Y,R17
	RCALL _lcd_putchar
	RJMP _0x2040017
_0x2040019:
	LDD  R17,Y+0
	ADIW R28,3
	RET
_lcd_init:
	SBI  0x11,4
	SBI  0x11,5
	SBI  0x11,6
	SBI  0x11,7
	SBI  0x11,3
	SBI  0x11,1
	SBI  0x11,2
	CBI  0x12,3
	CBI  0x12,1
	CBI  0x12,2
	LD   R30,Y
	STS  __lcd_maxx,R30
	SUBI R30,-LOW(128)
	__PUTB1MN __base_y_G102,2
	LD   R30,Y
	SUBI R30,-LOW(192)
	__PUTB1MN __base_y_G102,3
	RCALL SUBOPT_0x28
	RCALL _delay_ms
	LDI  R30,LOW(48)
	RCALL SUBOPT_0x2D
	RCALL SUBOPT_0x30
	RCALL SUBOPT_0x30
	RCALL SUBOPT_0x31
	LDI  R30,LOW(32)
	RCALL SUBOPT_0x2D
	RCALL SUBOPT_0x31
	LDI  R30,LOW(40)
	RCALL SUBOPT_0x2E
	LDI  R30,LOW(4)
	RCALL SUBOPT_0x2E
	LDI  R30,LOW(133)
	RCALL SUBOPT_0x2E
	LDI  R30,LOW(6)
	RCALL SUBOPT_0x2E
	RCALL _lcd_clear
_0x20C0001:
	ADIW R28,1
	RET

	.CSEG

	.CSEG

	.CSEG

	.ESEG
_hong1:
	.BYTE 0x2
_hong2:
	.BYTE 0x2
_hong3:
	.BYTE 0x2
_count_egg:
	.DW  0x0

	.DSEG
_ht_count_egg:
	.BYTE 0x2
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
_nhietdocd:
	.DW  0x172

	.DSEG
_remember_t:
	.BYTE 0x1

	.ESEG
_dttudong:
	.DW  0x0

	.DSEG
__seed_G101:
	.BYTE 0x4
__base_y_G102:
	.BYTE 0x4
__lcd_x:
	.BYTE 0x1
__lcd_y:
	.BYTE 0x1
__lcd_maxx:
	.BYTE 0x1

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x0:
	LDI  R30,LOW(255)
	OUT  0x2D,R30
	LDI  R30,LOW(5)
	OUT  0x2C,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x1:
	CP   R30,R4
	CPC  R31,R5
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x2:
	SET
	BLD  R2,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x3:
	LDI  R26,LOW(_count_egg)
	LDI  R27,HIGH(_count_egg)
	RCALL __EEPROMRDW
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x4:
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RCALL __EEPROMWRW
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x5:
	__GETWRN 16,17,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x6:
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	CP   R16,R30
	CPC  R17,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x7:
	SBI  0x17,0
	CBI  0x18,0
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x8:
	SBI  0x18,0
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x9:
	__ADDWRN 16,17,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:16 WORDS
SUBOPT_0xA:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0xB:
	__GETWRN 18,19,128
	RJMP SUBOPT_0x5

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0xC:
	__CPWRN 16,17,8
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0xD:
	LDI  R30,LOW(0)
	OUT  0x24,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xE:
	LDI  R30,LOW(2)
	OUT  0x25,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xF:
	IN   R30,0x24
	CPI  R30,LOW(0x61)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x10:
	RCALL __CWD1
	RCALL __ADDD12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x11:
	STS  _doamh,R30
	STS  _doamh+1,R31
	STS  _doamh+2,R22
	STS  _doamh+3,R23
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x12:
	MOVW R26,R18
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	RCALL __DIVW21
	MOVW R18,R30
	RJMP SUBOPT_0xD

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x13:
	LDI  R30,LOW(0)
	OUT  0x25,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x14:
	LDS  R26,_doaml
	LDS  R27,_doaml+1
	LDS  R24,_doaml+2
	LDS  R25,_doaml+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x15:
	STS  _doaml,R30
	STS  _doaml+1,R31
	STS  _doaml+2,R22
	STS  _doaml+3,R23
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x16:
	STS  _nhietdoh,R30
	STS  _nhietdoh+1,R31
	STS  _nhietdoh+2,R22
	STS  _nhietdoh+3,R23
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x17:
	LDS  R26,_nhietdol
	LDS  R27,_nhietdol+1
	LDS  R24,_nhietdol+2
	LDS  R25,_nhietdol+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x18:
	STS  _nhietdol,R30
	STS  _nhietdol+1,R31
	STS  _nhietdol+2,R22
	STS  _nhietdol+3,R23
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x19:
	__GETD2N 0x100
	RCALL __MULD12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x1A:
	LDI  R30,LOW(0)
	OUT  0x2F,R30
	LDI  R30,LOW(3)
	OUT  0x2E,R30
	RJMP SUBOPT_0x0

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1B:
	LDI  R30,LOW(0)
	OUT  0x27,R30
	OUT  0x26,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x1C:
	LDI  R26,LOW(_nhietdocd)
	LDI  R27,HIGH(_nhietdocd)
	RCALL __EEPROMRDW
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:28 WORDS
SUBOPT_0x1D:
	LDS  R26,_nhietdo
	LDS  R27,_nhietdo+1
	LDS  R24,_nhietdo+2
	LDS  R25,_nhietdo+3
	CLR  R22
	CLR  R23
	RCALL __CPD21
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x1E:
	STS  _remember_t,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1F:
	CBI  0x15,1
	CBI  0x15,0
	CBI  0x15,2
	RJMP SUBOPT_0x1C

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:49 WORDS
SUBOPT_0x20:
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
SUBOPT_0x21:
	__GETD1S 4
	__GETD2N 0xA
	RCALL __MULD12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x22:
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

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x23:
	ST   -Y,R31
	ST   -Y,R30
	RJMP _lcd_putsf

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x24:
	LDI  R30,LOW(0)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x25:
	LDI  R30,LOW(1)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:14 WORDS
SUBOPT_0x26:
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	ST   -Y,R31
	ST   -Y,R30
	RJMP _delay_mms

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:14 WORDS
SUBOPT_0x27:
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(40)
	LDI  R31,HIGH(40)
	ST   -Y,R31
	ST   -Y,R30
	RJMP SUBOPT_0xA

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x28:
	LDI  R30,LOW(20)
	LDI  R31,HIGH(20)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x29:
	ST   -Y,R31
	ST   -Y,R30
	RJMP SUBOPT_0xA

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2A:
	LDI  R26,LOW(_dttudong)
	LDI  R27,HIGH(_dttudong)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x2B:
	CBI  0x15,4
	LDI  R30,LOW(50)
	LDI  R31,HIGH(50)
	ST   -Y,R31
	ST   -Y,R30
	RJMP _delay_mms

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x2C:
	LDI  R30,LOW(50)
	LDI  R31,HIGH(50)
	ST   -Y,R31
	ST   -Y,R30
	RJMP _delay_mms

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x2D:
	ST   -Y,R30
	RJMP __lcd_write_nibble_G102

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x2E:
	ST   -Y,R30
	RJMP __lcd_write_data

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x2F:
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	ST   -Y,R31
	ST   -Y,R30
	RJMP _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x30:
	__DELAY_USW 400
	LDI  R30,LOW(48)
	RJMP SUBOPT_0x2D

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x31:
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

__SAVELOCR4:
	ST   -Y,R19
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

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
