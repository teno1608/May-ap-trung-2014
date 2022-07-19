
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
	.DW  0x03F0

_0x5F:
	.DB  0x1
_0x60:
	.DB  0x2
_0x137:
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0
_0x0:
	.DB  0x54,0x3A,0x20,0x25,0x69,0x2E,0x25,0x2D
	.DB  0x75,0x25,0x0,0x20,0x20,0x3E,0x20,0x20
	.DB  0x25,0x69,0x2E,0x25,0x2D,0x75,0x25,0x0
	.DB  0x48,0x3A,0x20,0x25,0x69,0x2E,0x25,0x2D
	.DB  0x75,0x25,0x0,0x3E,0x3E,0x3E,0x3E,0x4E
	.DB  0x51,0x20,0x46,0x61,0x69,0x72,0x79,0x3C
	.DB  0x3C,0x3C,0x3C,0x0,0x44,0x61,0x6F,0x20
	.DB  0x54,0x72,0x75,0x6E,0x67,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x42,0x61,0x6E,0x67
	.DB  0x20,0x54,0x61,0x79,0x0,0x44,0x61,0x6F
	.DB  0x20,0x54,0x72,0x75,0x6E,0x67,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x54,0x75,0x20
	.DB  0x44,0x6F,0x6E,0x67,0x20,0x0
_0x2020060:
	.DB  0x1
_0x2020000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0,0x49,0x4E,0x46
	.DB  0x0
_0x2040003:
	.DB  0x80,0xC0

__GLOBAL_INI_TBL:
	.DW  0x02
	.DW  0x02
	.DW  __REG_BIT_VARS*2

	.DW  0x01
	.DW  _remember_t
	.DW  _0x5F*2

	.DW  0x01
	.DW  _remember_h
	.DW  _0x60*2

	.DW  0x0A
	.DW  0x04
	.DW  _0x137*2

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
;
;// Timer1 overflow interrupt service routine >>>>>> overflow 1ms
;interrupt [TIM1_OVF] void timer1_ovf_isr(void)
; 0000 0018 {

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
; 0000 0019 // Reinitialize Timer1 value
; 0000 001A TCNT1H=0xFF;
	RCALL SUBOPT_0x0
; 0000 001B TCNT1L=0x05;
; 0000 001C // Place your code here
; 0000 001D count_am2301++;
	MOVW R30,R4
	ADIW R30,1
	MOVW R4,R30
; 0000 001E count_key++;
	MOVW R30,R6
	ADIW R30,1
	MOVW R6,R30
; 0000 001F count_delay++;
	MOVW R30,R8
	ADIW R30,1
	MOVW R8,R30
; 0000 0020 //count_lcd++;
; 0000 0021 count_eep++;
	MOVW R30,R12
	ADIW R30,1
	MOVW R12,R30
; 0000 0022 if (count_am2301 >= 1500) { set_am2301=1; count_am2301=0;}
	LDI  R30,LOW(1500)
	LDI  R31,HIGH(1500)
	CP   R4,R30
	CPC  R5,R31
	BRLO _0x3
	SET
	BLD  R2,0
	CLR  R4
	CLR  R5
; 0000 0023 if (count_key >= 100) {set_key=1; count_key=0;}
_0x3:
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CP   R6,R30
	CPC  R7,R31
	BRLO _0x4
	SET
	BLD  R2,1
	CLR  R6
	CLR  R7
; 0000 0024 //if (count_lcd >= 100) {set_lcd=1; count_lcd=0;}
; 0000 0025 if (count_eep >= 30000)
_0x4:
	LDI  R30,LOW(30000)
	LDI  R31,HIGH(30000)
	CP   R12,R30
	CPC  R13,R31
	BRLO _0x5
; 0000 0026     {
; 0000 0027     count_egg++;
	LDI  R26,LOW(_count_egg)
	LDI  R27,HIGH(_count_egg)
	RCALL SUBOPT_0x1
	RCALL __EEPROMWRW
	SBIW R30,1
; 0000 0028     if (count_egg >= 600) {set_egg=1; count_egg=0;}
	LDI  R26,LOW(_count_egg)
	LDI  R27,HIGH(_count_egg)
	RCALL __EEPROMRDW
	CPI  R30,LOW(0x258)
	LDI  R26,HIGH(0x258)
	CPC  R31,R26
	BRLO _0x6
	SET
	BLD  R2,2
	LDI  R26,LOW(_count_egg)
	LDI  R27,HIGH(_count_egg)
	RCALL SUBOPT_0x2
; 0000 0029     count_eep=0;
_0x6:
	CLR  R12
	CLR  R13
; 0000 002A     }
; 0000 002B }
_0x5:
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
; 0000 002E     {
_reset_all:
; 0000 002F     count_am2301=0;
	CLR  R4
	CLR  R5
; 0000 0030     count_key=0;
	CLR  R6
	CLR  R7
; 0000 0031     count_lcd=0;
	CLR  R10
	CLR  R11
; 0000 0032     count_eep=0;
	CLR  R12
	CLR  R13
; 0000 0033     set_am2301=0;
	CLT
	BLD  R2,0
; 0000 0034     set_key=0;
	BLD  R2,1
; 0000 0035     set_egg=0;
	BLD  R2,2
; 0000 0036     set_lcd=0;
	BLD  R2,3
; 0000 0037     }
	RET
;
;//////////////////////////////////
;void delay_mms(int time_delay)
; 0000 003B     {
_delay_mms:
; 0000 003C     count_delay=0;
;	time_delay -> Y+0
	CLR  R8
	CLR  R9
; 0000 003D     while (count_delay<time_delay) {}
_0x7:
	LD   R30,Y
	LDD  R31,Y+1
	CP   R8,R30
	CPC  R9,R31
	BRLO _0x7
; 0000 003E     }
	RJMP _0x20C0003
;
;//////////////////////////////////
;#define loa PORTB.0
;#define ddrloa DDRB.0
;void beep(int ton , int toff , int count)
; 0000 0044 {
_beep:
; 0000 0045 int i;
; 0000 0046 for (i=0; i<count ;i++)
	RCALL __SAVELOCR2
;	ton -> Y+6
;	toff -> Y+4
;	count -> Y+2
;	i -> R16,R17
	RCALL SUBOPT_0x3
_0xB:
	RCALL SUBOPT_0x4
	BRGE _0xC
; 0000 0047     {
; 0000 0048 ddrloa=1;
	RCALL SUBOPT_0x5
; 0000 0049 loa=0;
; 0000 004A delay_mms(ton);
	RCALL _delay_mms
; 0000 004B loa=1;
	RCALL SUBOPT_0x6
; 0000 004C delay_mms(toff);
	RCALL _delay_mms
; 0000 004D     }
	RCALL SUBOPT_0x7
	RJMP _0xB
_0xC:
; 0000 004E }
	RJMP _0x20C0006
;/////
;void beepe(int ton , int toff , int count)
; 0000 0051 {
_beepe:
; 0000 0052 int i;
; 0000 0053 for (i=0; i<count ;i++)
	RCALL __SAVELOCR2
;	ton -> Y+6
;	toff -> Y+4
;	count -> Y+2
;	i -> R16,R17
	RCALL SUBOPT_0x3
_0x14:
	RCALL SUBOPT_0x4
	BRGE _0x15
; 0000 0054     {
; 0000 0055 ddrloa=1;
	RCALL SUBOPT_0x5
; 0000 0056 loa=0;
; 0000 0057 delay_ms(ton);
	RCALL _delay_ms
; 0000 0058 loa=1;
	RCALL SUBOPT_0x6
; 0000 0059 delay_ms(toff);
	RCALL _delay_ms
; 0000 005A     }
	RCALL SUBOPT_0x7
	RJMP _0x14
_0x15:
; 0000 005B }
_0x20C0006:
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
; 0000 0065      {
_read_am2301:
; 0000 0066      int i,a;
; 0000 0067      #asm("cli")
	RCALL __SAVELOCR4
;	i -> R16,R17
;	a -> R18,R19
	cli
; 0000 0068      TCCR1A=0x00;
	LDI  R30,LOW(0)
	OUT  0x2F,R30
; 0000 0069      TCCR1B=0x00;
	OUT  0x2E,R30
; 0000 006A 
; 0000 006B      a=128;
	RCALL SUBOPT_0x8
; 0000 006C      ddrdata=1;
	SBI  0x11,0
; 0000 006D      portdata=0;
	CBI  0x12,0
; 0000 006E 
; 0000 006F      //delay_ms(1);
; 0000 0070      TCCR0=0x03;
	LDI  R30,LOW(3)
	RCALL SUBOPT_0x9
; 0000 0071      TCNT0=0x00;
; 0000 0072      while (TCNT0<250) {}
_0x20:
	IN   R30,0x32
	CPI  R30,LOW(0xFA)
	BRLO _0x20
; 0000 0073      TCCR0=0x00;
	LDI  R30,LOW(0)
	RCALL SUBOPT_0x9
; 0000 0074      TCNT0=0x00;
; 0000 0075 
; 0000 0076      portdata=1;
	SBI  0x12,0
; 0000 0077 
; 0000 0078      //delay_us(30);
; 0000 0079      TCCR0=0x02;
	LDI  R30,LOW(2)
	RCALL SUBOPT_0x9
; 0000 007A      TCNT0=0x00;
; 0000 007B      while (TCNT0<60) {}
_0x25:
	IN   R30,0x32
	CPI  R30,LOW(0x3C)
	BRLO _0x25
; 0000 007C      TCCR0=0x00;
	LDI  R30,LOW(0)
	RCALL SUBOPT_0x9
; 0000 007D      TCNT0=0x00;
; 0000 007E 
; 0000 007F      portdata=0;
	CBI  0x12,0
; 0000 0080      ddrdata=0;
	CBI  0x11,0
; 0000 0081      while(data==0)
_0x2C:
	SBIS 0x10,0
; 0000 0082           {
; 0000 0083           }
	RJMP _0x2C
; 0000 0084      while(data==1)
_0x2F:
	SBIC 0x10,0
; 0000 0085           {
; 0000 0086           }
	RJMP _0x2F
; 0000 0087      while(data==0)
_0x32:
	SBIS 0x10,0
; 0000 0088           {
; 0000 0089           }
	RJMP _0x32
; 0000 008A      a=128;
	RCALL SUBOPT_0x8
; 0000 008B      for (i=0;i<8;i++)
	RCALL SUBOPT_0x3
_0x36:
	RCALL SUBOPT_0xA
	BRGE _0x37
; 0000 008C           {
; 0000 008D           TCNT2=0x00;
	RCALL SUBOPT_0xB
; 0000 008E           TCCR2=0x02;
	RCALL SUBOPT_0xC
; 0000 008F           while(data==1)
_0x38:
	SBIC 0x10,0
; 0000 0090                {
; 0000 0091                }
	RJMP _0x38
; 0000 0092           if (TCNT2 > 96) doamh = doamh + a ;
	RCALL SUBOPT_0xD
	BRLO _0x3B
	MOVW R30,R18
	LDS  R26,_doamh
	LDS  R27,_doamh+1
	LDS  R24,_doamh+2
	LDS  R25,_doamh+3
	RCALL SUBOPT_0xE
	RCALL SUBOPT_0xF
; 0000 0093           a=a/2;
_0x3B:
	RCALL SUBOPT_0x10
; 0000 0094           TCNT2=0x00;
; 0000 0095           TCCR2=0x00;
	RCALL SUBOPT_0x11
; 0000 0096           while (data==0)
_0x3C:
	SBIS 0x10,0
; 0000 0097                {
; 0000 0098                }
	RJMP _0x3C
; 0000 0099           }
	RCALL SUBOPT_0x7
	RJMP _0x36
_0x37:
; 0000 009A      a=128;
	RCALL SUBOPT_0x8
; 0000 009B      for (i=0;i<8;i++)
	RCALL SUBOPT_0x3
_0x40:
	RCALL SUBOPT_0xA
	BRGE _0x41
; 0000 009C           {
; 0000 009D           TCNT2=0x00;
	RCALL SUBOPT_0xB
; 0000 009E           TCCR2=0x02;
	RCALL SUBOPT_0xC
; 0000 009F           while(data==1)
_0x42:
	SBIC 0x10,0
; 0000 00A0                {
; 0000 00A1                }
	RJMP _0x42
; 0000 00A2           if (TCNT2 > 96) doaml = doaml + a ;
	RCALL SUBOPT_0xD
	BRLO _0x45
	MOVW R30,R18
	RCALL SUBOPT_0x12
	RCALL SUBOPT_0xE
	RCALL SUBOPT_0x13
; 0000 00A3           a=a/2;
_0x45:
	RCALL SUBOPT_0x10
; 0000 00A4           TCNT2=0x00;
; 0000 00A5           TCCR2=0x00;
	RCALL SUBOPT_0x11
; 0000 00A6           while (data==0)
_0x46:
	SBIS 0x10,0
; 0000 00A7                {
; 0000 00A8                }
	RJMP _0x46
; 0000 00A9           }
	RCALL SUBOPT_0x7
	RJMP _0x40
_0x41:
; 0000 00AA      a=128;
	RCALL SUBOPT_0x8
; 0000 00AB      for (i=0;i<8;i++)
	RCALL SUBOPT_0x3
_0x4A:
	RCALL SUBOPT_0xA
	BRGE _0x4B
; 0000 00AC           {
; 0000 00AD           TCNT2=0x00;
	RCALL SUBOPT_0xB
; 0000 00AE           TCCR2=0x02;
	RCALL SUBOPT_0xC
; 0000 00AF           while(data==1)
_0x4C:
	SBIC 0x10,0
; 0000 00B0                {
; 0000 00B1                }
	RJMP _0x4C
; 0000 00B2           if (TCNT2 > 96 ) nhietdoh = nhietdoh + a ;
	RCALL SUBOPT_0xD
	BRLO _0x4F
	MOVW R30,R18
	LDS  R26,_nhietdoh
	LDS  R27,_nhietdoh+1
	LDS  R24,_nhietdoh+2
	LDS  R25,_nhietdoh+3
	RCALL SUBOPT_0xE
	RCALL SUBOPT_0x14
; 0000 00B3           a=a/2;
_0x4F:
	RCALL SUBOPT_0x10
; 0000 00B4           TCNT2=0x00;
; 0000 00B5           TCCR2=0x00;
	RCALL SUBOPT_0x11
; 0000 00B6           while (data==0)
_0x50:
	SBIS 0x10,0
; 0000 00B7                {
; 0000 00B8                }
	RJMP _0x50
; 0000 00B9           }
	RCALL SUBOPT_0x7
	RJMP _0x4A
_0x4B:
; 0000 00BA      a=128;
	RCALL SUBOPT_0x8
; 0000 00BB      for (i=0;i<8;i++)
	RCALL SUBOPT_0x3
_0x54:
	RCALL SUBOPT_0xA
	BRGE _0x55
; 0000 00BC           {
; 0000 00BD           TCNT2=0x00;
	RCALL SUBOPT_0xB
; 0000 00BE           TCCR2=0x02;
	RCALL SUBOPT_0xC
; 0000 00BF           while(data==1)
_0x56:
	SBIC 0x10,0
; 0000 00C0                {
; 0000 00C1                }
	RJMP _0x56
; 0000 00C2           if (TCNT2 > 96) nhietdol = nhietdol + a ;
	RCALL SUBOPT_0xD
	BRLO _0x59
	MOVW R30,R18
	RCALL SUBOPT_0x15
	RCALL SUBOPT_0xE
	RCALL SUBOPT_0x16
; 0000 00C3           a=a/2;
_0x59:
	RCALL SUBOPT_0x10
; 0000 00C4           TCNT2=0x00;
; 0000 00C5           TCCR2=0x00;
	RCALL SUBOPT_0x11
; 0000 00C6           while (data==0)
_0x5A:
	SBIS 0x10,0
; 0000 00C7                {
; 0000 00C8                }
	RJMP _0x5A
; 0000 00C9           }
	RCALL SUBOPT_0x7
	RJMP _0x54
_0x55:
; 0000 00CA      nhietdo = nhietdoh*256 + nhietdol;
	LDS  R30,_nhietdoh
	LDS  R31,_nhietdoh+1
	LDS  R22,_nhietdoh+2
	LDS  R23,_nhietdoh+3
	RCALL SUBOPT_0x17
	RCALL SUBOPT_0x15
	RCALL __ADDD12
	STS  _nhietdo,R30
	STS  _nhietdo+1,R31
	STS  _nhietdo+2,R22
	STS  _nhietdo+3,R23
; 0000 00CB      doam = doamh*256 + doaml;
	LDS  R30,_doamh
	LDS  R31,_doamh+1
	LDS  R22,_doamh+2
	LDS  R23,_doamh+3
	RCALL SUBOPT_0x17
	RCALL SUBOPT_0x12
	RCALL __ADDD12
	STS  _doam,R30
	STS  _doam+1,R31
	STS  _doam+2,R22
	STS  _doam+3,R23
; 0000 00CC      doamh=doaml=nhietdoh=nhietdol=0;
	__GETD1N 0x0
	RCALL SUBOPT_0x16
	RCALL SUBOPT_0x14
	RCALL SUBOPT_0x13
	RCALL SUBOPT_0xF
; 0000 00CD      portdata=1;
	SBI  0x12,0
; 0000 00CE 
; 0000 00CF      TCCR1A=0x00;
	RCALL SUBOPT_0x18
; 0000 00D0      TCCR1B=0x03;
; 0000 00D1      TCNT1H=0xFF;
; 0000 00D2      TCNT1L=0x05;
; 0000 00D3      ICR1H=0x00;
	RCALL SUBOPT_0x19
; 0000 00D4      ICR1L=0x00;
; 0000 00D5      #asm("sei")
	sei
; 0000 00D6      }
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
;eeprom unsigned int nhietdocd=370, doamcd=600;
;char remember_t=1, remember_h=2;

	.DSEG
;
;void define_remember()
; 0000 00E7     {

	.CSEG
; 0000 00E8     if (nhietdo <= nhietdocd-2) remember_t =3;
; 0000 00E9     if((nhietdo > nhietdocd-2)&(nhietdo < nhietdocd+2)) remember_t =2;
; 0000 00EA     if (nhietdo >= nhietdocd+2) remember_t =1;
; 0000 00EB     }
;
;void control_remember()
; 0000 00EE     {
_control_remember:
; 0000 00EF 
; 0000 00F0     switch (remember_t) {
	LDS  R30,_remember_t
	RCALL SUBOPT_0x1A
; 0000 00F1         case 1:
	BRNE _0x67
; 0000 00F2             lamp=off;
	SBI  0x15,5
; 0000 00F3             fan_top=off;
	SBI  0x15,1
; 0000 00F4             fan_bottom=on;
	CBI  0x15,0
; 0000 00F5             fan_o2=off;
	SBI  0x15,2
; 0000 00F6             if (nhietdo < nhietdocd+2) remember_t=2;
	RCALL SUBOPT_0x1B
	ADIW R30,2
	RCALL SUBOPT_0x1C
	BRGE _0x70
	LDI  R30,LOW(2)
	RCALL SUBOPT_0x1D
; 0000 00F7             break;
_0x70:
	RJMP _0x66
; 0000 00F8         case 2:
_0x67:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x71
; 0000 00F9             lamp=off;
	SBI  0x15,5
; 0000 00FA             fan_top=on;
	CBI  0x15,1
; 0000 00FB             fan_bottom=on;
	CBI  0x15,0
; 0000 00FC             fan_o2=on;
	CBI  0x15,2
; 0000 00FD             if (nhietdo < nhietdocd-1) remember_t=3;
	RCALL SUBOPT_0x1B
	SBIW R30,1
	RCALL SUBOPT_0x1C
	BRGE _0x7A
	LDI  R30,LOW(3)
	RCALL SUBOPT_0x1D
; 0000 00FE             if (nhietdo >= nhietdocd+5) remember_t=1;
_0x7A:
	RCALL SUBOPT_0x1B
	ADIW R30,5
	RCALL SUBOPT_0x1C
	BRLT _0x7B
	LDI  R30,LOW(1)
	RCALL SUBOPT_0x1D
; 0000 00FF             break;
_0x7B:
	RJMP _0x66
; 0000 0100         case 3:
_0x71:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x66
; 0000 0101             lamp=on;
	CBI  0x15,5
; 0000 0102             fan_top=on;
	CBI  0x15,1
; 0000 0103             fan_bottom=on;
	CBI  0x15,0
; 0000 0104             fan_o2=on;
	CBI  0x15,2
; 0000 0105             if (nhietdo > nhietdocd+1) remember_t=2;
	RCALL SUBOPT_0x1E
	RCALL SUBOPT_0x1F
	RCALL SUBOPT_0x20
	RCALL __CPD12
	BRGE _0x85
	LDI  R30,LOW(2)
	RCALL SUBOPT_0x1D
; 0000 0106             if (nhietdo >= nhietdocd+5) remember_t=1;
_0x85:
	RCALL SUBOPT_0x1B
	ADIW R30,5
	RCALL SUBOPT_0x1C
	BRLT _0x86
	LDI  R30,LOW(1)
	RCALL SUBOPT_0x1D
; 0000 0107             break;
_0x86:
; 0000 0108         }
_0x66:
; 0000 0109 
; 0000 010A     switch (remember_h) {
	LDS  R30,_remember_h
	RCALL SUBOPT_0x1A
; 0000 010B         case 1:
	BRNE _0x8A
; 0000 010C             humidifier=on;
	CBI  0x15,3
; 0000 010D             if (doam >= doamcd+30) remember_h=2;
	RCALL SUBOPT_0x21
	ADIW R30,30
	RCALL SUBOPT_0x22
	RCALL __CPD21
	BRLT _0x8D
	LDI  R30,LOW(2)
	STS  _remember_h,R30
; 0000 010E             break;
_0x8D:
	RJMP _0x89
; 0000 010F         case 2:
_0x8A:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x89
; 0000 0110             humidifier=off;
	SBI  0x15,3
; 0000 0111             if (doam <= doamcd-30) remember_h=1;
	RCALL SUBOPT_0x21
	SBIW R30,30
	RCALL SUBOPT_0x22
	RCALL __CPD12
	BRLT _0x91
	LDI  R30,LOW(1)
	STS  _remember_h,R30
; 0000 0112             break;
_0x91:
; 0000 0113         }
_0x89:
; 0000 0114     }
	RET
;
;////////////////////////////////////////////
;#define column_1 PINB.5
;#define column_2 PINB.4
;#define row_1 PORTB.1
;#define row_2 PORTB.2
;#define row_3 PORTB.3
;
;#define column_1c PORTB.5
;#define column_2c PORTB.4
;#define row_1c PINB.1
;#define row_2c PINB.2
;#define row_3c PINB.3
;bit button_tl=1, button_tx=1, button_hl=1, button_hx=1, button_motor=1, button_sw=1;
;
;void scan_keyh(){
; 0000 0124 void scan_keyh(){
_scan_keyh:
; 0000 0125 PORTB=0xff;
	LDI  R30,LOW(255)
	OUT  0x18,R30
; 0000 0126 DDRB=0b00001110;
	LDI  R30,LOW(14)
	RCALL SUBOPT_0x23
; 0000 0127 delay_mms(2);
; 0000 0128 row_1=0;
	CBI  0x18,1
; 0000 0129 row_2=1;
	SBI  0x18,2
; 0000 012A row_3=1;
	RCALL SUBOPT_0x24
; 0000 012B delay_mms(2);
; 0000 012C if(column_1==0) button_tl=0; else button_tl=1;
	SBIC 0x16,5
	RJMP _0x98
	CLT
	RJMP _0x124
_0x98:
	SET
_0x124:
	BLD  R2,4
; 0000 012D delay_mms(2);
	RCALL SUBOPT_0x25
; 0000 012E if(column_2==0) button_hl=0; else button_hl=1;
	SBIC 0x16,4
	RJMP _0x9A
	CLT
	RJMP _0x125
_0x9A:
	SET
_0x125:
	BLD  R2,6
; 0000 012F delay_mms(2);
	RCALL SUBOPT_0x25
; 0000 0130 row_1=1;
	SBI  0x18,1
; 0000 0131 row_2=0;
	CBI  0x18,2
; 0000 0132 row_3=1;
	RCALL SUBOPT_0x24
; 0000 0133 delay_mms(2);
; 0000 0134 if(column_1==0) button_tx=0; else button_tx=1;
	SBIC 0x16,5
	RJMP _0xA2
	CLT
	RJMP _0x126
_0xA2:
	SET
_0x126:
	BLD  R2,5
; 0000 0135 delay_mms(2);
	RCALL SUBOPT_0x25
; 0000 0136 if(column_2==0) button_hx=0; else button_hx=1;
	SBIC 0x16,4
	RJMP _0xA4
	CLT
	RJMP _0x127
_0xA4:
	SET
_0x127:
	BLD  R2,7
; 0000 0137 delay_mms(2);
	RCALL SUBOPT_0x25
; 0000 0138 row_1=1;
	SBI  0x18,1
; 0000 0139 row_2=1;
	SBI  0x18,2
; 0000 013A row_3=0;
	CBI  0x18,3
; 0000 013B delay_mms(2);
	RCALL SUBOPT_0x25
; 0000 013C if(column_1==0) button_motor=0; else button_motor=1;
	SBIC 0x16,5
	RJMP _0xAC
	CLT
	RJMP _0x128
_0xAC:
	SET
_0x128:
	BLD  R3,0
; 0000 013D delay_mms(2);
	RCALL SUBOPT_0x25
; 0000 013E if(column_2==0) button_sw=0; else button_sw=1;
	SBIC 0x16,4
	RJMP _0xAE
	CLT
	RJMP _0x129
_0xAE:
	SET
_0x129:
	BLD  R3,1
; 0000 013F delay_mms(2);
	RCALL SUBOPT_0x25
; 0000 0140 row_1=1;
	SBI  0x18,1
; 0000 0141 row_2=1;
	SBI  0x18,2
; 0000 0142 row_3=1;
	SBI  0x18,3
; 0000 0143 delay_mms(2);
	RJMP _0x20C0005
; 0000 0144 }
;/////
;void scan_keyc(){
; 0000 0146 void scan_keyc(){
_scan_keyc:
; 0000 0147 PORTB=0xff;
	LDI  R30,LOW(255)
	OUT  0x18,R30
; 0000 0148 DDRB=0b00110000;
	LDI  R30,LOW(48)
	RCALL SUBOPT_0x23
; 0000 0149 delay_mms(2);
; 0000 014A column_1c=0;
	CBI  0x18,5
; 0000 014B column_2c=1;
	SBI  0x18,4
; 0000 014C delay_mms(2);
	RCALL SUBOPT_0x25
; 0000 014D if(row_1c==0) button_tl=0; else button_tl=1;
	SBIC 0x16,1
	RJMP _0xBA
	CLT
	RJMP _0x12A
_0xBA:
	SET
_0x12A:
	BLD  R2,4
; 0000 014E delay_mms(2);
	RCALL SUBOPT_0x25
; 0000 014F if(row_2c==0) button_tx=0; else button_tx=1;
	SBIC 0x16,2
	RJMP _0xBC
	CLT
	RJMP _0x12B
_0xBC:
	SET
_0x12B:
	BLD  R2,5
; 0000 0150 delay_mms(2);
	RCALL SUBOPT_0x25
; 0000 0151 if(row_3c==0) button_motor=0; else button_motor=1;
	SBIC 0x16,3
	RJMP _0xBE
	CLT
	RJMP _0x12C
_0xBE:
	SET
_0x12C:
	BLD  R3,0
; 0000 0152 delay_mms(2);
	RCALL SUBOPT_0x25
; 0000 0153 column_1c=1;
	SBI  0x18,5
; 0000 0154 column_2c=0;
	CBI  0x18,4
; 0000 0155 delay_mms(2);
	RCALL SUBOPT_0x25
; 0000 0156 if(row_1c==0) button_hl=0; else button_hl=1;
	SBIC 0x16,1
	RJMP _0xC4
	CLT
	RJMP _0x12D
_0xC4:
	SET
_0x12D:
	BLD  R2,6
; 0000 0157 delay_mms(2);
	RCALL SUBOPT_0x25
; 0000 0158 if(row_2c==0) button_hx=0; else button_hx=1;
	SBIC 0x16,2
	RJMP _0xC6
	CLT
	RJMP _0x12E
_0xC6:
	SET
_0x12E:
	BLD  R2,7
; 0000 0159 delay_mms(2);
	RCALL SUBOPT_0x25
; 0000 015A if(row_3c==0) button_sw=0; else button_sw=1;
	SBIC 0x16,3
	RJMP _0xC8
	CLT
	RJMP _0x12F
_0xC8:
	SET
_0x12F:
	BLD  R3,1
; 0000 015B delay_mms(2);
	RCALL SUBOPT_0x25
; 0000 015C column_1c=1;
	SBI  0x18,5
; 0000 015D column_2c=1;
	SBI  0x18,4
; 0000 015E delay_mms(2);
_0x20C0005:
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	RCALL SUBOPT_0x26
	RCALL _delay_mms
; 0000 015F }
	RET
;/////
;void scan_keyhdb(){
; 0000 0161 void scan_keyhdb(){
; 0000 0162 PORTB=0xff;
; 0000 0163 DDRB=0b00001110;
; 0000 0164 delay_ms(2);
; 0000 0165 row_1=0;
; 0000 0166 row_2=1;
; 0000 0167 row_3=1;
; 0000 0168 delay_ms(2);
; 0000 0169 if(column_1==0) button_tl=0; else button_tl=1;
; 0000 016A delay_ms(2);
; 0000 016B if(column_2==0) button_hl=0; else button_hl=1;
; 0000 016C delay_ms(2);
; 0000 016D row_1=1;
; 0000 016E row_2=0;
; 0000 016F row_3=1;
; 0000 0170 delay_ms(2);
; 0000 0171 if(column_1==0) button_tx=0; else button_tx=1;
; 0000 0172 delay_ms(2);
; 0000 0173 if(column_2==0) button_hx=0; else button_hx=1;
; 0000 0174 delay_ms(2);
; 0000 0175 row_1=1;
; 0000 0176 row_2=1;
; 0000 0177 row_3=0;
; 0000 0178 delay_ms(2);
; 0000 0179 if(column_1==0) button_motor=0; else button_motor=1;
; 0000 017A delay_ms(2);
; 0000 017B if(column_2==0) button_sw=0; else button_sw=1;
; 0000 017C delay_ms(2);
; 0000 017D row_1=1;
; 0000 017E row_2=1;
; 0000 017F row_3=1;
; 0000 0180 delay_ms(2);
; 0000 0181 }
;
;bit sw=0;
;void read_key()
; 0000 0185 {
_read_key:
; 0000 0186     if (sw==0)
	SBRC R3,2
	RJMP _0xF2
; 0000 0187     {
; 0000 0188     scan_keyh();
	RCALL _scan_keyh
; 0000 0189     if (button_tl ==on){
	SBRC R2,4
	RJMP _0xF3
; 0000 018A         nhietdocd++;
	RCALL SUBOPT_0x1E
	RCALL SUBOPT_0x27
; 0000 018B         beep(10,40,1);
; 0000 018C         }
; 0000 018D     if (button_tx ==on){
_0xF3:
	SBRC R2,5
	RJMP _0xF4
; 0000 018E         nhietdocd--;
	RCALL SUBOPT_0x1B
	RCALL SUBOPT_0x28
; 0000 018F         beep(10,40,1);
; 0000 0190         }
; 0000 0191     if (button_hl ==on){
_0xF4:
	SBRC R2,6
	RJMP _0xF5
; 0000 0192         doamcd=doamcd+10;
	RCALL SUBOPT_0x21
	RCALL SUBOPT_0x29
; 0000 0193         beep(10,40,1);
; 0000 0194         }
; 0000 0195     if (button_hx ==on){
_0xF5:
	SBRC R2,7
	RJMP _0xF6
; 0000 0196         doamcd=doamcd-10;
	RCALL SUBOPT_0x21
	RCALL SUBOPT_0x2A
; 0000 0197         beep(10,40,1);
; 0000 0198         }
; 0000 0199     if ((button_motor==0)&(button_sw==0)) sw=0; else sw=1;
_0xF6:
	LDI  R26,0
	SBRC R3,0
	LDI  R26,1
	LDI  R30,LOW(0)
	RCALL __EQB12
	MOV  R0,R30
	LDI  R26,0
	SBRC R3,1
	LDI  R26,1
	LDI  R30,LOW(0)
	RCALL __EQB12
	AND  R30,R0
	BREQ _0xF7
	CLT
	RJMP _0x136
_0xF7:
	SET
_0x136:
	BLD  R3,2
; 0000 019A     }
; 0000 019B     else
	RJMP _0xF9
_0xF2:
; 0000 019C     {
; 0000 019D     scan_keyc();
	RCALL _scan_keyc
; 0000 019E     if (button_tl ==on){
	SBRC R2,4
	RJMP _0xFA
; 0000 019F         nhietdocd++;
	RCALL SUBOPT_0x1E
	RCALL SUBOPT_0x27
; 0000 01A0         beep(10,40,1);
; 0000 01A1         }
; 0000 01A2     if (button_tx ==on){
_0xFA:
	SBRC R2,5
	RJMP _0xFB
; 0000 01A3         nhietdocd--;
	RCALL SUBOPT_0x1B
	RCALL SUBOPT_0x28
; 0000 01A4         beep(10,40,1);
; 0000 01A5         }
; 0000 01A6     if (button_hl ==on){
_0xFB:
	SBRC R2,6
	RJMP _0xFC
; 0000 01A7         doamcd=doamcd+10;
	RCALL SUBOPT_0x21
	RCALL SUBOPT_0x29
; 0000 01A8         beep(10,40,1);
; 0000 01A9         }
; 0000 01AA     if (button_hx ==on){
_0xFC:
	SBRC R2,7
	RJMP _0xFD
; 0000 01AB         doamcd=doamcd-10;
	RCALL SUBOPT_0x21
	RCALL SUBOPT_0x2A
; 0000 01AC         beep(10,40,1);
; 0000 01AD         }
; 0000 01AE     sw=0;
_0xFD:
	CLT
	BLD  R3,2
; 0000 01AF     }
_0xF9:
; 0000 01B0 }
	RET
;
;///////////////////////////////////////
;char display_buffer[32];
;void hienthi_lcd()
; 0000 01B5 {
_hienthi_lcd:
; 0000 01B6     sprintf(display_buffer,"T: %i.%-u%",nhietdo/10,abs(nhietdo%10));
	RCALL SUBOPT_0x2B
	__POINTW1FN _0x0,0
	RCALL SUBOPT_0x26
	RCALL SUBOPT_0x2C
	RCALL __DIVD21
	RCALL __PUTPARD1
	RCALL SUBOPT_0x2C
	RCALL SUBOPT_0x2D
; 0000 01B7     lcd_gotoxy(0,0);
	RCALL SUBOPT_0x2E
; 0000 01B8     lcd_puts(display_buffer);
	RCALL _lcd_puts
; 0000 01B9     sprintf(display_buffer,"  >  %i.%-u%",nhietdocd/10,abs(nhietdocd%10));
	RCALL SUBOPT_0x2B
	__POINTW1FN _0x0,11
	RCALL SUBOPT_0x26
	RCALL SUBOPT_0x1B
	RCALL SUBOPT_0x2F
	RCALL __DIVW21U
	RCALL SUBOPT_0x30
	RCALL SUBOPT_0x1B
	RCALL SUBOPT_0x2F
	RCALL SUBOPT_0x31
	RCALL SUBOPT_0x32
; 0000 01BA     lcd_gotoxy(7,0);
	RCALL SUBOPT_0x2E
; 0000 01BB     lcd_puts(display_buffer);
	RCALL _lcd_puts
; 0000 01BC 
; 0000 01BD     sprintf(display_buffer,"H: %i.%-u%",doam/10,abs(doam%10));
	RCALL SUBOPT_0x2B
	__POINTW1FN _0x0,24
	RCALL SUBOPT_0x26
	RCALL SUBOPT_0x33
	RCALL __DIVD21
	RCALL __PUTPARD1
	RCALL SUBOPT_0x33
	RCALL SUBOPT_0x2D
; 0000 01BE     lcd_gotoxy(0,1);
	RCALL SUBOPT_0x34
; 0000 01BF     lcd_puts(display_buffer);
	RCALL _lcd_puts
; 0000 01C0     sprintf(display_buffer,"  >  %i.%-u%",doamcd/10,abs(doamcd%10));
	RCALL SUBOPT_0x2B
	__POINTW1FN _0x0,11
	RCALL SUBOPT_0x26
	RCALL SUBOPT_0x21
	RCALL SUBOPT_0x2F
	RCALL __DIVW21U
	RCALL SUBOPT_0x30
	RCALL SUBOPT_0x21
	RCALL SUBOPT_0x2F
	RCALL SUBOPT_0x31
	RCALL SUBOPT_0x32
; 0000 01C1     lcd_gotoxy(7,1);
	RCALL SUBOPT_0x34
; 0000 01C2     lcd_puts(display_buffer);
	RCALL _lcd_puts
; 0000 01C3 
; 0000 01C4 }
	RET
;
;
;///////////////////////////////////////////////
;
;void main(void)
; 0000 01CA {
_main:
; 0000 01CB 
; 0000 01CC // Declare your local variables here
; 0000 01CD PORTB=0xff;
	LDI  R30,LOW(255)
	OUT  0x18,R30
; 0000 01CE DDRB=0b00110000;
	LDI  R30,LOW(48)
	OUT  0x17,R30
; 0000 01CF 
; 0000 01D0 PORTC=0xff;
	LDI  R30,LOW(255)
	OUT  0x15,R30
; 0000 01D1 DDRC=0xff;
	OUT  0x14,R30
; 0000 01D2 
; 0000 01D3 PORTD=0xff;
	OUT  0x12,R30
; 0000 01D4 DDRD=0x00;
	LDI  R30,LOW(0)
	OUT  0x11,R30
; 0000 01D5 
; 0000 01D6 // Timer/Counter 0 initialization
; 0000 01D7 // Clock source: System Clock
; 0000 01D8 // Clock value: Timer 0 Stopped
; 0000 01D9 TCCR0=0x00;
	RCALL SUBOPT_0x9
; 0000 01DA TCNT0=0x00;
; 0000 01DB 
; 0000 01DC // Timer/Counter 1 initialization
; 0000 01DD // Clock source: System Clock
; 0000 01DE // Clock value: 250.000 kHz
; 0000 01DF // Mode: Normal top=0xFFFF
; 0000 01E0 // OC1A output: Discon.
; 0000 01E1 // OC1B output: Discon.
; 0000 01E2 // Noise Canceler: Off
; 0000 01E3 // Input Capture on Falling Edge
; 0000 01E4 // Timer1 Overflow Interrupt: On
; 0000 01E5 // Input Capture Interrupt: Off
; 0000 01E6 // Compare A Match Interrupt: Off
; 0000 01E7 // Compare B Match Interrupt: Off
; 0000 01E8 TCCR1A=0x00;
	RCALL SUBOPT_0x18
; 0000 01E9 TCCR1B=0x03;
; 0000 01EA TCNT1H=0xFF;
; 0000 01EB TCNT1L=0x05;
; 0000 01EC ICR1H=0x00;
	RCALL SUBOPT_0x19
; 0000 01ED ICR1L=0x00;
; 0000 01EE OCR1AH=0x00;
	LDI  R30,LOW(0)
	OUT  0x2B,R30
; 0000 01EF OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 01F0 OCR1BH=0x00;
	OUT  0x29,R30
; 0000 01F1 OCR1BL=0x00;
	OUT  0x28,R30
; 0000 01F2 
; 0000 01F3 // Timer/Counter 2 initialization
; 0000 01F4 // Clock source: System Clock
; 0000 01F5 // Clock value: Timer2 Stopped
; 0000 01F6 // Mode: Normal top=0xFF
; 0000 01F7 // OC2 output: Disconnected
; 0000 01F8 ASSR=0x00;
	OUT  0x22,R30
; 0000 01F9 TCCR2=0x00;
	RCALL SUBOPT_0x11
; 0000 01FA TCNT2=0x00;
	RCALL SUBOPT_0xB
; 0000 01FB OCR2=0x00;
	LDI  R30,LOW(0)
	OUT  0x23,R30
; 0000 01FC 
; 0000 01FD // External Interrupt(s) initialization
; 0000 01FE // INT0: Off
; 0000 01FF // INT1: Off
; 0000 0200 MCUCR=0x00;
	OUT  0x35,R30
; 0000 0201 
; 0000 0202 // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 0203 TIMSK=0x04;
	LDI  R30,LOW(4)
	OUT  0x39,R30
; 0000 0204 
; 0000 0205 // USART initialization
; 0000 0206 // USART disabled
; 0000 0207 UCSRB=0x00;
	LDI  R30,LOW(0)
	OUT  0xA,R30
; 0000 0208 
; 0000 0209 // Analog Comparator initialization
; 0000 020A // Analog Comparator: Off
; 0000 020B // Analog Comparator Input Capture by Timer/Counter 1: Off
; 0000 020C ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 020D SFIOR=0x00;
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0000 020E 
; 0000 020F // ADC initialization
; 0000 0210 // ADC disabled
; 0000 0211 ADCSRA=0x00;
	OUT  0x6,R30
; 0000 0212 
; 0000 0213 // SPI initialization
; 0000 0214 // SPI disabled
; 0000 0215 SPCR=0x00;
	OUT  0xD,R30
; 0000 0216 
; 0000 0217 // TWI initialization
; 0000 0218 // TWI disabled
; 0000 0219 TWCR=0x00;
	OUT  0x36,R30
; 0000 021A 
; 0000 021B // Alphanumeric LCD initialization
; 0000 021C // Connections specified in the
; 0000 021D // Project|Configure|C Compiler|Libraries|Alphanumeric LCD menu:
; 0000 021E // RS - PORTD Bit 1
; 0000 021F // RD - PORTD Bit 2
; 0000 0220 // EN - PORTD Bit 3
; 0000 0221 // D4 - PORTD Bit 4
; 0000 0222 // D5 - PORTD Bit 5
; 0000 0223 // D6 - PORTD Bit 6
; 0000 0224 // D7 - PORTD Bit 7
; 0000 0225 // Characters/line: 16
; 0000 0226 lcd_init(16);
	LDI  R30,LOW(16)
	ST   -Y,R30
	RCALL _lcd_init
; 0000 0227 
; 0000 0228 hong1=0;
	LDI  R26,LOW(_hong1)
	LDI  R27,HIGH(_hong1)
	RCALL SUBOPT_0x2
; 0000 0229 hong2=0;
	LDI  R26,LOW(_hong2)
	LDI  R27,HIGH(_hong2)
	RCALL SUBOPT_0x2
; 0000 022A hong3=0;
	LDI  R26,LOW(_hong3)
	LDI  R27,HIGH(_hong3)
	RCALL SUBOPT_0x2
; 0000 022B 
; 0000 022C // Watchdog Timer initialization
; 0000 022D // Watchdog Timer Prescaler: OSC/2048k
; 0000 022E #pragma optsize-
; 0000 022F WDTCR=0x1F;
	LDI  R30,LOW(31)
	OUT  0x21,R30
; 0000 0230 WDTCR=0x0F;
	LDI  R30,LOW(15)
	OUT  0x21,R30
; 0000 0231 #ifdef _OPTIMIZE_SIZE_
; 0000 0232 #pragma optsize+
; 0000 0233 #endif
; 0000 0234 
; 0000 0235 // Global enable interrupts
; 0000 0236 #asm("sei")
	sei
; 0000 0237 
; 0000 0238 lcd_putsf(">>>>NQ Fairy<<<<");
	__POINTW1FN _0x0,35
	RCALL SUBOPT_0x26
	RCALL _lcd_putsf
; 0000 0239 
; 0000 023A beepe(20,80,2);
	RCALL SUBOPT_0x35
	LDI  R30,LOW(80)
	LDI  R31,HIGH(80)
	RCALL SUBOPT_0x26
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	RCALL SUBOPT_0x26
	RCALL _beepe
; 0000 023B reset_all();
	RCALL _reset_all
; 0000 023C while (1)
_0xFE:
; 0000 023D       {
; 0000 023E       if (set_am2301==1)
	SBRS R2,0
	RJMP _0x101
; 0000 023F         {
; 0000 0240         set_am2301=0;
	CLT
	BLD  R2,0
; 0000 0241         read_am2301();
	RCALL _read_am2301
; 0000 0242         control_remember();
	RCALL _control_remember
; 0000 0243         #asm("WDR");
	WDR
; 0000 0244         }
; 0000 0245 
; 0000 0246       if (set_key==1)
_0x101:
	SBRS R2,1
	RJMP _0x102
; 0000 0247         {
; 0000 0248         read_key();
	RCALL _read_key
; 0000 0249         while (button_motor == on)
_0x103:
	SBRC R3,0
	RJMP _0x105
; 0000 024A             {
; 0000 024B             motor=on;
	CBI  0x15,4
; 0000 024C             sprintf(display_buffer,"Dao Trung               Bang Tay");
	RCALL SUBOPT_0x2B
	__POINTW1FN _0x0,52
	RCALL SUBOPT_0x26
	LDI  R24,0
	RCALL _sprintf
	ADIW R28,4
; 0000 024D             lcd_gotoxy(0,0);
	LDI  R30,LOW(0)
	ST   -Y,R30
	ST   -Y,R30
	RCALL _lcd_gotoxy
; 0000 024E             lcd_puts(display_buffer);
	RCALL SUBOPT_0x2B
	RCALL _lcd_puts
; 0000 024F             delay_mms(50);
	LDI  R30,LOW(50)
	LDI  R31,HIGH(50)
	RCALL SUBOPT_0x26
	RCALL _delay_mms
; 0000 0250             read_key();
	RCALL _read_key
; 0000 0251             count_key=0;
	CLR  R6
	CLR  R7
; 0000 0252             #asm("WDR");
	WDR
; 0000 0253             }
	RJMP _0x103
_0x105:
; 0000 0254         motor=off;
	SBI  0x15,4
; 0000 0255         lcd_clear();
	RCALL _lcd_clear
; 0000 0256         delay_mms(2);
	RCALL SUBOPT_0x25
; 0000 0257         hienthi_lcd();
	RCALL _hienthi_lcd
; 0000 0258         set_key=0;
	CLT
	BLD  R2,1
; 0000 0259         }
; 0000 025A 
; 0000 025B       if (set_egg==1)
_0x102:
	SBRS R2,2
	RJMP _0x10A
; 0000 025C         {
; 0000 025D          fan_top=fan_bottom=fan_o2=lamp=humidifier=motor=off;
	SBI  0x15,4
	SBI  0x15,3
	SBI  0x15,5
	SBI  0x15,2
	SBI  0x15,0
	SBI  0x15,1
; 0000 025E          lcd_clear();
	RCALL _lcd_clear
; 0000 025F          beep(20,30,1);
	RCALL SUBOPT_0x35
	RCALL SUBOPT_0x36
	RCALL SUBOPT_0x37
; 0000 0260          lcd_putsf("Dao Trung               Tu Dong ");
	__POINTW1FN _0x0,85
	RCALL SUBOPT_0x26
	RCALL _lcd_putsf
; 0000 0261          scan_keyh();
	RCALL _scan_keyh
; 0000 0262          while (button_sw==off)
_0x117:
	SBRS R3,1
	RJMP _0x119
; 0000 0263          {
; 0000 0264          motor=on;
	CBI  0x15,4
; 0000 0265          scan_keyh();
	RCALL _scan_keyh
; 0000 0266          delay_ms(30);
	RCALL SUBOPT_0x36
	RCALL _delay_ms
; 0000 0267          }
	RJMP _0x117
_0x119:
; 0000 0268          delay_ms(100);
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	RCALL SUBOPT_0x26
	RCALL _delay_ms
; 0000 0269          while (button_sw==on)
_0x11C:
	SBRC R3,1
	RJMP _0x11E
; 0000 026A          {
; 0000 026B          motor=on;
	CBI  0x15,4
; 0000 026C          scan_keyh();
	RCALL _scan_keyh
; 0000 026D          delay_ms(30);
	RCALL SUBOPT_0x36
	RCALL _delay_ms
; 0000 026E          }
	RJMP _0x11C
_0x11E:
; 0000 026F          beep(20,30,1);
	RCALL SUBOPT_0x35
	RCALL SUBOPT_0x36
	RCALL SUBOPT_0x37
; 0000 0270 
; 0000 0271          motor=off;
	SBI  0x15,4
; 0000 0272          reset_all();
	RCALL _reset_all
; 0000 0273          set_egg=0;
	CLT
	BLD  R2,2
; 0000 0274 
; 0000 0275         }
; 0000 0276 
; 0000 0277       }
_0x10A:
	RJMP _0xFE
; 0000 0278 
; 0000 0279 }
_0x123:
	RJMP _0x123
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
_put_buff_G100:
	RCALL __SAVELOCR2
	RCALL SUBOPT_0x38
	ADIW R26,2
	RCALL __GETW1P
	SBIW R30,0
	BREQ _0x2000010
	RCALL SUBOPT_0x38
	RCALL SUBOPT_0x39
	MOVW R16,R30
	SBIW R30,0
	BREQ _0x2000012
	__CPWRN 16,17,2
	BRLO _0x2000013
	MOVW R30,R16
	SBIW R30,1
	MOVW R16,R30
	__PUTW1SNS 2,4
_0x2000012:
	RCALL SUBOPT_0x38
	ADIW R26,2
	RCALL SUBOPT_0x3A
	SBIW R30,1
	LDD  R26,Y+4
	STD  Z+0,R26
	RCALL SUBOPT_0x38
	RCALL __GETW1P
	TST  R31
	BRMI _0x2000014
	RCALL SUBOPT_0x38
	RCALL SUBOPT_0x3A
_0x2000014:
_0x2000013:
	RJMP _0x2000015
_0x2000010:
	RCALL SUBOPT_0x38
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	ST   X+,R30
	ST   X,R31
_0x2000015:
	RCALL __LOADLOCR2
	ADIW R28,5
	RET
__print_G100:
	SBIW R28,6
	RCALL __SAVELOCR6
	LDI  R17,0
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   X+,R30
	ST   X,R31
_0x2000016:
	LDD  R30,Y+18
	LDD  R31,Y+18+1
	ADIW R30,1
	STD  Y+18,R30
	STD  Y+18+1,R31
	SBIW R30,1
	LPM  R30,Z
	MOV  R18,R30
	CPI  R30,0
	BRNE PC+2
	RJMP _0x2000018
	MOV  R30,R17
	CPI  R30,0
	BRNE _0x200001C
	CPI  R18,37
	BRNE _0x200001D
	LDI  R17,LOW(1)
	RJMP _0x200001E
_0x200001D:
	RCALL SUBOPT_0x3B
_0x200001E:
	RJMP _0x200001B
_0x200001C:
	CPI  R30,LOW(0x1)
	BRNE _0x200001F
	CPI  R18,37
	BRNE _0x2000020
	RCALL SUBOPT_0x3B
	RJMP _0x20000C9
_0x2000020:
	LDI  R17,LOW(2)
	LDI  R20,LOW(0)
	LDI  R16,LOW(0)
	CPI  R18,45
	BRNE _0x2000021
	LDI  R16,LOW(1)
	RJMP _0x200001B
_0x2000021:
	CPI  R18,43
	BRNE _0x2000022
	LDI  R20,LOW(43)
	RJMP _0x200001B
_0x2000022:
	CPI  R18,32
	BRNE _0x2000023
	LDI  R20,LOW(32)
	RJMP _0x200001B
_0x2000023:
	RJMP _0x2000024
_0x200001F:
	CPI  R30,LOW(0x2)
	BRNE _0x2000025
_0x2000024:
	LDI  R21,LOW(0)
	LDI  R17,LOW(3)
	CPI  R18,48
	BRNE _0x2000026
	ORI  R16,LOW(128)
	RJMP _0x200001B
_0x2000026:
	RJMP _0x2000027
_0x2000025:
	CPI  R30,LOW(0x3)
	BREQ PC+2
	RJMP _0x200001B
_0x2000027:
	CPI  R18,48
	BRLO _0x200002A
	CPI  R18,58
	BRLO _0x200002B
_0x200002A:
	RJMP _0x2000029
_0x200002B:
	LDI  R26,LOW(10)
	MUL  R21,R26
	MOV  R21,R0
	MOV  R30,R18
	SUBI R30,LOW(48)
	ADD  R21,R30
	RJMP _0x200001B
_0x2000029:
	MOV  R30,R18
	CPI  R30,LOW(0x63)
	BRNE _0x200002F
	RCALL SUBOPT_0x3C
	RCALL SUBOPT_0x3D
	RCALL SUBOPT_0x3C
	LDD  R26,Z+4
	ST   -Y,R26
	RCALL SUBOPT_0x3E
	RJMP _0x2000030
_0x200002F:
	CPI  R30,LOW(0x73)
	BRNE _0x2000032
	RCALL SUBOPT_0x3F
	RCALL SUBOPT_0x40
	RCALL SUBOPT_0x41
	RCALL _strlen
	MOV  R17,R30
	RJMP _0x2000033
_0x2000032:
	CPI  R30,LOW(0x70)
	BRNE _0x2000035
	RCALL SUBOPT_0x3F
	RCALL SUBOPT_0x40
	RCALL SUBOPT_0x41
	RCALL _strlenf
	MOV  R17,R30
	ORI  R16,LOW(8)
_0x2000033:
	ORI  R16,LOW(2)
	ANDI R16,LOW(127)
	LDI  R19,LOW(0)
	RJMP _0x2000036
_0x2000035:
	CPI  R30,LOW(0x64)
	BREQ _0x2000039
	CPI  R30,LOW(0x69)
	BRNE _0x200003A
_0x2000039:
	ORI  R16,LOW(4)
	RJMP _0x200003B
_0x200003A:
	CPI  R30,LOW(0x75)
	BRNE _0x200003C
_0x200003B:
	LDI  R30,LOW(_tbl10_G100*2)
	LDI  R31,HIGH(_tbl10_G100*2)
	RCALL SUBOPT_0x42
	LDI  R17,LOW(5)
	RJMP _0x200003D
_0x200003C:
	CPI  R30,LOW(0x58)
	BRNE _0x200003F
	ORI  R16,LOW(8)
	RJMP _0x2000040
_0x200003F:
	CPI  R30,LOW(0x78)
	BREQ PC+2
	RJMP _0x2000071
_0x2000040:
	LDI  R30,LOW(_tbl16_G100*2)
	LDI  R31,HIGH(_tbl16_G100*2)
	RCALL SUBOPT_0x42
	LDI  R17,LOW(4)
_0x200003D:
	SBRS R16,2
	RJMP _0x2000042
	RCALL SUBOPT_0x3F
	RCALL SUBOPT_0x40
	RCALL SUBOPT_0x43
	LDD  R26,Y+11
	TST  R26
	BRPL _0x2000043
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	RCALL __ANEGW1
	RCALL SUBOPT_0x43
	LDI  R20,LOW(45)
_0x2000043:
	CPI  R20,0
	BREQ _0x2000044
	SUBI R17,-LOW(1)
	RJMP _0x2000045
_0x2000044:
	ANDI R16,LOW(251)
_0x2000045:
	RJMP _0x2000046
_0x2000042:
	RCALL SUBOPT_0x3F
	RCALL SUBOPT_0x40
	RCALL SUBOPT_0x43
_0x2000046:
_0x2000036:
	SBRC R16,0
	RJMP _0x2000047
_0x2000048:
	CP   R17,R21
	BRSH _0x200004A
	SBRS R16,7
	RJMP _0x200004B
	SBRS R16,2
	RJMP _0x200004C
	ANDI R16,LOW(251)
	MOV  R18,R20
	SUBI R17,LOW(1)
	RJMP _0x200004D
_0x200004C:
	LDI  R18,LOW(48)
_0x200004D:
	RJMP _0x200004E
_0x200004B:
	LDI  R18,LOW(32)
_0x200004E:
	RCALL SUBOPT_0x3B
	SUBI R21,LOW(1)
	RJMP _0x2000048
_0x200004A:
_0x2000047:
	MOV  R19,R17
	SBRS R16,1
	RJMP _0x200004F
_0x2000050:
	CPI  R19,0
	BREQ _0x2000052
	SBRS R16,3
	RJMP _0x2000053
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	LPM  R18,Z+
	RCALL SUBOPT_0x42
	RJMP _0x2000054
_0x2000053:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LD   R18,X+
	STD  Y+6,R26
	STD  Y+6+1,R27
_0x2000054:
	RCALL SUBOPT_0x3B
	CPI  R21,0
	BREQ _0x2000055
	SUBI R21,LOW(1)
_0x2000055:
	SUBI R19,LOW(1)
	RJMP _0x2000050
_0x2000052:
	RJMP _0x2000056
_0x200004F:
_0x2000058:
	LDI  R18,LOW(48)
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	RCALL __GETW1PF
	STD  Y+8,R30
	STD  Y+8+1,R31
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ADIW R30,2
	RCALL SUBOPT_0x42
_0x200005A:
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	CP   R26,R30
	CPC  R27,R31
	BRLO _0x200005C
	SUBI R18,-LOW(1)
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	SUB  R30,R26
	SBC  R31,R27
	RCALL SUBOPT_0x43
	RJMP _0x200005A
_0x200005C:
	CPI  R18,58
	BRLO _0x200005D
	SBRS R16,3
	RJMP _0x200005E
	SUBI R18,-LOW(7)
	RJMP _0x200005F
_0x200005E:
	SUBI R18,-LOW(39)
_0x200005F:
_0x200005D:
	SBRC R16,4
	RJMP _0x2000061
	CPI  R18,49
	BRSH _0x2000063
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,1
	BRNE _0x2000062
_0x2000063:
	RJMP _0x20000CA
_0x2000062:
	CP   R21,R19
	BRLO _0x2000067
	SBRS R16,0
	RJMP _0x2000068
_0x2000067:
	RJMP _0x2000066
_0x2000068:
	LDI  R18,LOW(32)
	SBRS R16,7
	RJMP _0x2000069
	LDI  R18,LOW(48)
_0x20000CA:
	ORI  R16,LOW(16)
	SBRS R16,2
	RJMP _0x200006A
	ANDI R16,LOW(251)
	ST   -Y,R20
	RCALL SUBOPT_0x3E
	CPI  R21,0
	BREQ _0x200006B
	SUBI R21,LOW(1)
_0x200006B:
_0x200006A:
_0x2000069:
_0x2000061:
	RCALL SUBOPT_0x3B
	CPI  R21,0
	BREQ _0x200006C
	SUBI R21,LOW(1)
_0x200006C:
_0x2000066:
	SUBI R19,LOW(1)
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,2
	BRLO _0x2000059
	RJMP _0x2000058
_0x2000059:
_0x2000056:
	SBRS R16,0
	RJMP _0x200006D
_0x200006E:
	CPI  R21,0
	BREQ _0x2000070
	SUBI R21,LOW(1)
	LDI  R30,LOW(32)
	ST   -Y,R30
	RCALL SUBOPT_0x3E
	RJMP _0x200006E
_0x2000070:
_0x200006D:
_0x2000071:
_0x2000030:
_0x20000C9:
	LDI  R17,LOW(0)
_0x200001B:
	RJMP _0x2000016
_0x2000018:
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	RCALL __GETW1P
	RCALL __LOADLOCR6
	ADIW R28,20
	RET
_sprintf:
	PUSH R15
	MOV  R15,R24
	SBIW R28,6
	RCALL __SAVELOCR4
	RCALL SUBOPT_0x44
	SBIW R30,0
	BRNE _0x2000072
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x20C0004
_0x2000072:
	MOVW R26,R28
	ADIW R26,6
	RCALL __ADDW2R15
	MOVW R16,R26
	RCALL SUBOPT_0x44
	RCALL SUBOPT_0x42
	LDI  R30,LOW(0)
	STD  Y+8,R30
	STD  Y+8+1,R30
	MOVW R26,R28
	ADIW R26,10
	RCALL __ADDW2R15
	RCALL __GETW1P
	RCALL SUBOPT_0x26
	ST   -Y,R17
	ST   -Y,R16
	LDI  R30,LOW(_put_buff_G100)
	LDI  R31,HIGH(_put_buff_G100)
	RCALL SUBOPT_0x26
	MOVW R30,R28
	ADIW R30,10
	RCALL SUBOPT_0x26
	RCALL __print_G100
	MOVW R18,R30
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R30,LOW(0)
	ST   X,R30
	MOVW R30,R18
_0x20C0004:
	RCALL __LOADLOCR4
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
	RCALL SUBOPT_0x45
    ld    r30,y
    swap  r30
    st    y,r30
	LD   R30,Y
	RCALL SUBOPT_0x45
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
	RCALL SUBOPT_0x46
	LDD  R30,Y+1
	STS  __lcd_x,R30
	LD   R30,Y
	STS  __lcd_y,R30
_0x20C0003:
	ADIW R28,2
	RET
_lcd_clear:
	LDI  R30,LOW(2)
	RCALL SUBOPT_0x46
	RCALL SUBOPT_0x47
	LDI  R30,LOW(12)
	RCALL SUBOPT_0x46
	LDI  R30,LOW(1)
	RCALL SUBOPT_0x46
	RCALL SUBOPT_0x47
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
	LDI  R30,LOW(0)
	ST   -Y,R30
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
	RCALL SUBOPT_0x46
	CBI  0x12,1
	RJMP _0x20C0001
_lcd_puts:
	ST   -Y,R17
_0x2040014:
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LD   R30,X+
	STD  Y+1,R26
	STD  Y+1+1,R27
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x2040016
	ST   -Y,R17
	RCALL _lcd_putchar
	RJMP _0x2040014
_0x2040016:
	RJMP _0x20C0002
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
_0x20C0002:
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
	RCALL SUBOPT_0x35
	RCALL _delay_ms
	LDI  R30,LOW(48)
	RCALL SUBOPT_0x45
	RCALL SUBOPT_0x48
	RCALL SUBOPT_0x48
	RCALL SUBOPT_0x49
	LDI  R30,LOW(32)
	RCALL SUBOPT_0x45
	RCALL SUBOPT_0x49
	LDI  R30,LOW(40)
	RCALL SUBOPT_0x46
	LDI  R30,LOW(4)
	RCALL SUBOPT_0x46
	LDI  R30,LOW(133)
	RCALL SUBOPT_0x46
	LDI  R30,LOW(6)
	RCALL SUBOPT_0x46
	RCALL _lcd_clear
_0x20C0001:
	ADIW R28,1
	RET

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
_doamcd:
	.DW  0x258

	.DSEG
_remember_t:
	.BYTE 0x1
_remember_h:
	.BYTE 0x1
_display_buffer:
	.BYTE 0x20
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

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1:
	RCALL __EEPROMRDW
	ADIW R30,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x2:
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RCALL __EEPROMWRW
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x3:
	__GETWRN 16,17,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x4:
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	CP   R16,R30
	CPC  R17,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x5:
	SBI  0x17,0
	CBI  0x18,0
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x6:
	SBI  0x18,0
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x7:
	__ADDWRN 16,17,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x8:
	__GETWRN 18,19,128
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x9:
	OUT  0x33,R30
	LDI  R30,LOW(0)
	OUT  0x32,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0xA:
	__CPWRN 16,17,8
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0xB:
	LDI  R30,LOW(0)
	OUT  0x24,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xC:
	LDI  R30,LOW(2)
	OUT  0x25,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xD:
	IN   R30,0x24
	CPI  R30,LOW(0x61)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0xE:
	RCALL __CWD1
	RCALL __ADDD12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xF:
	STS  _doamh,R30
	STS  _doamh+1,R31
	STS  _doamh+2,R22
	STS  _doamh+3,R23
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x10:
	MOVW R26,R18
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	RCALL __DIVW21
	MOVW R18,R30
	RJMP SUBOPT_0xB

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x11:
	LDI  R30,LOW(0)
	OUT  0x25,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x12:
	LDS  R26,_doaml
	LDS  R27,_doaml+1
	LDS  R24,_doaml+2
	LDS  R25,_doaml+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x13:
	STS  _doaml,R30
	STS  _doaml+1,R31
	STS  _doaml+2,R22
	STS  _doaml+3,R23
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x14:
	STS  _nhietdoh,R30
	STS  _nhietdoh+1,R31
	STS  _nhietdoh+2,R22
	STS  _nhietdoh+3,R23
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x15:
	LDS  R26,_nhietdol
	LDS  R27,_nhietdol+1
	LDS  R24,_nhietdol+2
	LDS  R25,_nhietdol+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x16:
	STS  _nhietdol,R30
	STS  _nhietdol+1,R31
	STS  _nhietdol+2,R22
	STS  _nhietdol+3,R23
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x17:
	__GETD2N 0x100
	RCALL __MULD12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x18:
	LDI  R30,LOW(0)
	OUT  0x2F,R30
	LDI  R30,LOW(3)
	OUT  0x2E,R30
	RJMP SUBOPT_0x0

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x19:
	LDI  R30,LOW(0)
	OUT  0x27,R30
	OUT  0x26,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1A:
	LDI  R31,0
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x1B:
	LDI  R26,LOW(_nhietdocd)
	LDI  R27,HIGH(_nhietdocd)
	RCALL __EEPROMRDW
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:28 WORDS
SUBOPT_0x1C:
	LDS  R26,_nhietdo
	LDS  R27,_nhietdo+1
	LDS  R24,_nhietdo+2
	LDS  R25,_nhietdo+3
	CLR  R22
	CLR  R23
	RCALL __CPD21
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x1D:
	STS  _remember_t,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x1E:
	LDI  R26,LOW(_nhietdocd)
	LDI  R27,HIGH(_nhietdocd)
	RJMP SUBOPT_0x1

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x1F:
	LDS  R26,_nhietdo
	LDS  R27,_nhietdo+1
	LDS  R24,_nhietdo+2
	LDS  R25,_nhietdo+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x20:
	CLR  R22
	CLR  R23
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x21:
	LDI  R26,LOW(_doamcd)
	LDI  R27,HIGH(_doamcd)
	RCALL __EEPROMRDW
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x22:
	LDS  R26,_doam
	LDS  R27,_doam+1
	LDS  R24,_doam+2
	LDS  R25,_doam+3
	RJMP SUBOPT_0x20

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x23:
	OUT  0x17,R30
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	ST   -Y,R31
	ST   -Y,R30
	RJMP _delay_mms

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x24:
	SBI  0x18,3
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	ST   -Y,R31
	ST   -Y,R30
	RJMP _delay_mms

;OPTIMIZER ADDED SUBROUTINE, CALLED 16 TIMES, CODE SIZE REDUCTION:58 WORDS
SUBOPT_0x25:
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	ST   -Y,R31
	ST   -Y,R30
	RJMP _delay_mms

;OPTIMIZER ADDED SUBROUTINE, CALLED 75 TIMES, CODE SIZE REDUCTION:72 WORDS
SUBOPT_0x26:
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x27:
	RCALL __EEPROMWRW
	SBIW R30,1
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RCALL SUBOPT_0x26
	LDI  R30,LOW(40)
	LDI  R31,HIGH(40)
	RCALL SUBOPT_0x26
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	RCALL SUBOPT_0x26
	RJMP _beep

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x28:
	SBIW R30,1
	RCALL __EEPROMWRW
	ADIW R30,1
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RCALL SUBOPT_0x26
	LDI  R30,LOW(40)
	LDI  R31,HIGH(40)
	RCALL SUBOPT_0x26
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	RCALL SUBOPT_0x26
	RJMP _beep

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x29:
	ADIW R30,10
	LDI  R26,LOW(_doamcd)
	LDI  R27,HIGH(_doamcd)
	RCALL __EEPROMWRW
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RCALL SUBOPT_0x26
	LDI  R30,LOW(40)
	LDI  R31,HIGH(40)
	RCALL SUBOPT_0x26
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	RCALL SUBOPT_0x26
	RJMP _beep

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x2A:
	SBIW R30,10
	LDI  R26,LOW(_doamcd)
	LDI  R27,HIGH(_doamcd)
	RCALL __EEPROMWRW
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RCALL SUBOPT_0x26
	LDI  R30,LOW(40)
	LDI  R31,HIGH(40)
	RCALL SUBOPT_0x26
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	RCALL SUBOPT_0x26
	RJMP _beep

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:16 WORDS
SUBOPT_0x2B:
	LDI  R30,LOW(_display_buffer)
	LDI  R31,HIGH(_display_buffer)
	RJMP SUBOPT_0x26

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x2C:
	RCALL SUBOPT_0x1F
	__GETD1N 0xA
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x2D:
	RCALL __MODD21
	RCALL SUBOPT_0x26
	RCALL _abs
	RCALL SUBOPT_0x20
	RCALL __PUTPARD1
	LDI  R24,8
	RCALL _sprintf
	ADIW R28,12
	LDI  R30,LOW(0)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2E:
	LDI  R30,LOW(0)
	ST   -Y,R30
	RCALL _lcd_gotoxy
	RJMP SUBOPT_0x2B

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x2F:
	MOVW R26,R30
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x30:
	RCALL SUBOPT_0x20
	RCALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x31:
	RCALL __MODW21U
	RCALL SUBOPT_0x26
	RCALL _abs
	RJMP SUBOPT_0x30

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x32:
	LDI  R24,8
	RCALL _sprintf
	ADIW R28,12
	LDI  R30,LOW(7)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x33:
	LDS  R26,_doam
	LDS  R27,_doam+1
	LDS  R24,_doam+2
	LDS  R25,_doam+3
	__GETD1N 0xA
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x34:
	LDI  R30,LOW(1)
	ST   -Y,R30
	RCALL _lcd_gotoxy
	RJMP SUBOPT_0x2B

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x35:
	LDI  R30,LOW(20)
	LDI  R31,HIGH(20)
	RJMP SUBOPT_0x26

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x36:
	LDI  R30,LOW(30)
	LDI  R31,HIGH(30)
	RJMP SUBOPT_0x26

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x37:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	RCALL SUBOPT_0x26
	RJMP _beep

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x38:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x39:
	ADIW R26,4
	RCALL __GETW1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x3A:
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:22 WORDS
SUBOPT_0x3B:
	ST   -Y,R18
	LDD  R30,Y+13
	LDD  R31,Y+13+1
	RCALL SUBOPT_0x26
	LDD  R30,Y+17
	LDD  R31,Y+17+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x3C:
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x3D:
	SBIW R30,4
	STD  Y+16,R30
	STD  Y+16+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x3E:
	LDD  R30,Y+13
	LDD  R31,Y+13+1
	RCALL SUBOPT_0x26
	LDD  R30,Y+17
	LDD  R31,Y+17+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3F:
	RCALL SUBOPT_0x3C
	RJMP SUBOPT_0x3D

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x40:
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	RJMP SUBOPT_0x39

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x41:
	STD  Y+6,R30
	STD  Y+6+1,R31
	RJMP SUBOPT_0x26

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x42:
	STD  Y+6,R30
	STD  Y+6+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x43:
	STD  Y+10,R30
	STD  Y+10+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x44:
	MOVW R26,R28
	ADIW R26,12
	RCALL __ADDW2R15
	RCALL __GETW1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x45:
	ST   -Y,R30
	RJMP __lcd_write_nibble_G102

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x46:
	ST   -Y,R30
	RJMP __lcd_write_data

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x47:
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	RCALL SUBOPT_0x26
	RJMP _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x48:
	__DELAY_USW 400
	LDI  R30,LOW(48)
	RJMP SUBOPT_0x45

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x49:
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

__MODW21U:
	RCALL __DIVW21U
	MOVW R30,R26
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
