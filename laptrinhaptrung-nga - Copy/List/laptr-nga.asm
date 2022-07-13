
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
	.DEF _count_eep=R10
	.DEF _ht_count_egg=R12

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
	.DW  0x0078

_0x56:
	.DB  0x1
_0xCF:
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
_0x0:
	.DB  0x2E,0x0,0x54,0x3A,0x20,0x0,0x20,0x20
	.DB  0x3E,0x20,0x20,0x0,0x48,0x3A,0x20,0x0
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x0,0x44
	.DB  0x61,0x6F,0x20,0x54,0x72,0x75,0x6E,0x67
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x42
	.DB  0x61,0x6E,0x67,0x20,0x54,0x61,0x79,0x0
	.DB  0x44,0x61,0x6F,0x20,0x54,0x72,0x75,0x6E
	.DB  0x67,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x54,0x75,0x20,0x44,0x6F,0x6E,0x67,0x20
	.DB  0x0
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
	.DW  _0x56*2

	.DW  0x08
	.DW  0x04
	.DW  _0xCF*2

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
;unsigned int count_am2301=0, count_key=0, count_delay=0, count_eep=0;
;eeprom unsigned int count_egg=0;
;bit set_am2301=0, set_key=0, set_egg=0;
;unsigned int ht_count_egg;
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
; 0000 001F count_key++;
	MOVW R30,R6
	ADIW R30,1
	MOVW R6,R30
; 0000 0020 count_delay++;
	MOVW R30,R8
	ADIW R30,1
	MOVW R8,R30
; 0000 0021 count_eep++;
	MOVW R30,R10
	ADIW R30,1
	MOVW R10,R30
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
; 0000 0023 if (count_key >= 150) {set_key=1; count_key=0;}
_0x3:
	LDI  R30,LOW(150)
	LDI  R31,HIGH(150)
	CP   R6,R30
	CPC  R7,R31
	BRLO _0x4
	SET
	BLD  R2,1
	CLR  R6
	CLR  R7
; 0000 0024 if (count_eep >= 30000)
_0x4:
	LDI  R30,LOW(30000)
	LDI  R31,HIGH(30000)
	CP   R10,R30
	CPC  R11,R31
	BRLO _0x5
; 0000 0025     {
; 0000 0026     count_egg++;
	RCALL SUBOPT_0x1
	ADIW R30,1
	RCALL __EEPROMWRW
	SBIW R30,1
; 0000 0027     ht_count_egg=count_egg;
	RCALL SUBOPT_0x1
	MOVW R12,R30
; 0000 0028     if (count_egg >= 4) {set_egg=1; count_egg=0;}
	RCALL SUBOPT_0x1
	SBIW R30,4
	BRLO _0x6
	SET
	BLD  R2,2
	LDI  R26,LOW(_count_egg)
	LDI  R27,HIGH(_count_egg)
	RCALL SUBOPT_0x2
; 0000 0029     count_eep=0;
_0x6:
	CLR  R10
	CLR  R11
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
; 0000 0031     count_eep=0;
	CLR  R10
	CLR  R11
; 0000 0032     set_am2301=0;
	CLT
	BLD  R2,0
; 0000 0033     set_key=0;
	BLD  R2,1
; 0000 0034     set_egg=0;
	BLD  R2,2
; 0000 0035     }
	RET
;
;//////////////////////////////////
;void delay_mms(int time_delay)
; 0000 0039     {
_delay_mms:
; 0000 003A     count_delay=0;
;	time_delay -> Y+0
	CLR  R8
	CLR  R9
; 0000 003B     while (count_delay<time_delay) {}
_0x7:
	LD   R30,Y
	LDD  R31,Y+1
	CP   R8,R30
	CPC  R9,R31
	BRLO _0x7
; 0000 003C     }
	RJMP _0x20C0002
;
;//////////////////////////////////
;#define loa PORTB.0
;#define ddrloa DDRB.0
;void beep(int ton , int toff , int count)
; 0000 0042 {
_beep:
; 0000 0043 int i;
; 0000 0044 for (i=0; i<count ;i++)
	RCALL __SAVELOCR2
;	ton -> Y+6
;	toff -> Y+4
;	count -> Y+2
;	i -> R16,R17
	RCALL SUBOPT_0x3
_0xB:
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	CP   R16,R30
	CPC  R17,R31
	BRGE _0xC
; 0000 0045     {
; 0000 0046 ddrloa=1;
	SBI  0x17,0
; 0000 0047 loa=0;
	CBI  0x18,0
; 0000 0048 delay_mms(ton);
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	RCALL SUBOPT_0x4
; 0000 0049 loa=1;
	SBI  0x18,0
; 0000 004A delay_mms(toff);
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	RCALL SUBOPT_0x4
; 0000 004B     }
	RCALL SUBOPT_0x5
	RJMP _0xB
_0xC:
; 0000 004C }
	RCALL __LOADLOCR2
	ADIW R28,8
	RET
;/////
;/*
;void beepe(int ton , int toff , int count)
;{
;int i;
;for (i=0; i<count ;i++)
;    {
;ddrloa=1;
;loa=0;
;delay_ms(ton);
;loa=1;
;delay_ms(toff);
;    }
;}
;*/
;
;//////////////////////////////////////////////////
;#define ddrdata DDRD.0
;#define portdata PORTD.0
;#define data PIND.0
;long doamh, doaml, nhietdoh, nhietdol, nhietdo, doam;
;
;void read_am2301()    // Clock value: 1382.400 kHz
; 0000 0064      {
_read_am2301:
; 0000 0065      int i,a;
; 0000 0066      #asm("cli")
	RCALL __SAVELOCR4
;	i -> R16,R17
;	a -> R18,R19
	cli
; 0000 0067      TCCR1A=0x00;
	LDI  R30,LOW(0)
	OUT  0x2F,R30
; 0000 0068      TCCR1B=0x00;
	OUT  0x2E,R30
; 0000 0069 
; 0000 006A      a=128;
	RCALL SUBOPT_0x6
; 0000 006B      ddrdata=1;
	SBI  0x11,0
; 0000 006C      portdata=0;
	CBI  0x12,0
; 0000 006D 
; 0000 006E      //delay_ms(1);
; 0000 006F      TCCR0=0x03;
	LDI  R30,LOW(3)
	RCALL SUBOPT_0x7
; 0000 0070      TCNT0=0x00;
; 0000 0071      while (TCNT0<250) {}
_0x17:
	IN   R30,0x32
	CPI  R30,LOW(0xFA)
	BRLO _0x17
; 0000 0072      TCCR0=0x00;
	LDI  R30,LOW(0)
	RCALL SUBOPT_0x7
; 0000 0073      TCNT0=0x00;
; 0000 0074 
; 0000 0075      portdata=1;
	SBI  0x12,0
; 0000 0076 
; 0000 0077      //delay_us(30);
; 0000 0078      TCCR0=0x02;
	LDI  R30,LOW(2)
	RCALL SUBOPT_0x7
; 0000 0079      TCNT0=0x00;
; 0000 007A      while (TCNT0<60) {}
_0x1C:
	IN   R30,0x32
	CPI  R30,LOW(0x3C)
	BRLO _0x1C
; 0000 007B      TCCR0=0x00;
	LDI  R30,LOW(0)
	RCALL SUBOPT_0x7
; 0000 007C      TCNT0=0x00;
; 0000 007D 
; 0000 007E      portdata=0;
	CBI  0x12,0
; 0000 007F      ddrdata=0;
	CBI  0x11,0
; 0000 0080      while(data==0)
_0x23:
	SBIS 0x10,0
; 0000 0081           {
; 0000 0082           }
	RJMP _0x23
; 0000 0083      while(data==1)
_0x26:
	SBIC 0x10,0
; 0000 0084           {
; 0000 0085           }
	RJMP _0x26
; 0000 0086      while(data==0)
_0x29:
	SBIS 0x10,0
; 0000 0087           {
; 0000 0088           }
	RJMP _0x29
; 0000 0089      a=128;
	RCALL SUBOPT_0x6
; 0000 008A      for (i=0;i<8;i++)
	RCALL SUBOPT_0x3
_0x2D:
	RCALL SUBOPT_0x8
	BRGE _0x2E
; 0000 008B           {
; 0000 008C           TCNT2=0x00;
	RCALL SUBOPT_0x9
; 0000 008D           TCCR2=0x02;
	RCALL SUBOPT_0xA
; 0000 008E           while(data==1)
_0x2F:
	SBIC 0x10,0
; 0000 008F                {
; 0000 0090                }
	RJMP _0x2F
; 0000 0091           if (TCNT2 > 96) doamh = doamh + a ;
	RCALL SUBOPT_0xB
	BRLO _0x32
	MOVW R30,R18
	LDS  R26,_doamh
	LDS  R27,_doamh+1
	LDS  R24,_doamh+2
	LDS  R25,_doamh+3
	RCALL SUBOPT_0xC
	RCALL SUBOPT_0xD
; 0000 0092           a=a/2;
_0x32:
	RCALL SUBOPT_0xE
; 0000 0093           TCNT2=0x00;
; 0000 0094           TCCR2=0x00;
	RCALL SUBOPT_0xF
; 0000 0095           while (data==0)
_0x33:
	SBIS 0x10,0
; 0000 0096                {
; 0000 0097                }
	RJMP _0x33
; 0000 0098           }
	RCALL SUBOPT_0x5
	RJMP _0x2D
_0x2E:
; 0000 0099      a=128;
	RCALL SUBOPT_0x6
; 0000 009A      for (i=0;i<8;i++)
	RCALL SUBOPT_0x3
_0x37:
	RCALL SUBOPT_0x8
	BRGE _0x38
; 0000 009B           {
; 0000 009C           TCNT2=0x00;
	RCALL SUBOPT_0x9
; 0000 009D           TCCR2=0x02;
	RCALL SUBOPT_0xA
; 0000 009E           while(data==1)
_0x39:
	SBIC 0x10,0
; 0000 009F                {
; 0000 00A0                }
	RJMP _0x39
; 0000 00A1           if (TCNT2 > 96) doaml = doaml + a ;
	RCALL SUBOPT_0xB
	BRLO _0x3C
	MOVW R30,R18
	RCALL SUBOPT_0x10
	RCALL SUBOPT_0xC
	RCALL SUBOPT_0x11
; 0000 00A2           a=a/2;
_0x3C:
	RCALL SUBOPT_0xE
; 0000 00A3           TCNT2=0x00;
; 0000 00A4           TCCR2=0x00;
	RCALL SUBOPT_0xF
; 0000 00A5           while (data==0)
_0x3D:
	SBIS 0x10,0
; 0000 00A6                {
; 0000 00A7                }
	RJMP _0x3D
; 0000 00A8           }
	RCALL SUBOPT_0x5
	RJMP _0x37
_0x38:
; 0000 00A9      a=128;
	RCALL SUBOPT_0x6
; 0000 00AA      for (i=0;i<8;i++)
	RCALL SUBOPT_0x3
_0x41:
	RCALL SUBOPT_0x8
	BRGE _0x42
; 0000 00AB           {
; 0000 00AC           TCNT2=0x00;
	RCALL SUBOPT_0x9
; 0000 00AD           TCCR2=0x02;
	RCALL SUBOPT_0xA
; 0000 00AE           while(data==1)
_0x43:
	SBIC 0x10,0
; 0000 00AF                {
; 0000 00B0                }
	RJMP _0x43
; 0000 00B1           if (TCNT2 > 96 ) nhietdoh = nhietdoh + a ;
	RCALL SUBOPT_0xB
	BRLO _0x46
	MOVW R30,R18
	LDS  R26,_nhietdoh
	LDS  R27,_nhietdoh+1
	LDS  R24,_nhietdoh+2
	LDS  R25,_nhietdoh+3
	RCALL SUBOPT_0xC
	RCALL SUBOPT_0x12
; 0000 00B2           a=a/2;
_0x46:
	RCALL SUBOPT_0xE
; 0000 00B3           TCNT2=0x00;
; 0000 00B4           TCCR2=0x00;
	RCALL SUBOPT_0xF
; 0000 00B5           while (data==0)
_0x47:
	SBIS 0x10,0
; 0000 00B6                {
; 0000 00B7                }
	RJMP _0x47
; 0000 00B8           }
	RCALL SUBOPT_0x5
	RJMP _0x41
_0x42:
; 0000 00B9      a=128;
	RCALL SUBOPT_0x6
; 0000 00BA      for (i=0;i<8;i++)
	RCALL SUBOPT_0x3
_0x4B:
	RCALL SUBOPT_0x8
	BRGE _0x4C
; 0000 00BB           {
; 0000 00BC           TCNT2=0x00;
	RCALL SUBOPT_0x9
; 0000 00BD           TCCR2=0x02;
	RCALL SUBOPT_0xA
; 0000 00BE           while(data==1)
_0x4D:
	SBIC 0x10,0
; 0000 00BF                {
; 0000 00C0                }
	RJMP _0x4D
; 0000 00C1           if (TCNT2 > 96) nhietdol = nhietdol + a ;
	RCALL SUBOPT_0xB
	BRLO _0x50
	MOVW R30,R18
	RCALL SUBOPT_0x13
	RCALL SUBOPT_0xC
	RCALL SUBOPT_0x14
; 0000 00C2           a=a/2;
_0x50:
	RCALL SUBOPT_0xE
; 0000 00C3           TCNT2=0x00;
; 0000 00C4           TCCR2=0x00;
	RCALL SUBOPT_0xF
; 0000 00C5           while (data==0)
_0x51:
	SBIS 0x10,0
; 0000 00C6                {
; 0000 00C7                }
	RJMP _0x51
; 0000 00C8           }
	RCALL SUBOPT_0x5
	RJMP _0x4B
_0x4C:
; 0000 00C9      nhietdo = nhietdoh*256 + nhietdol;
	LDS  R30,_nhietdoh
	LDS  R31,_nhietdoh+1
	LDS  R22,_nhietdoh+2
	LDS  R23,_nhietdoh+3
	RCALL SUBOPT_0x15
	RCALL SUBOPT_0x13
	RCALL __ADDD12
	STS  _nhietdo,R30
	STS  _nhietdo+1,R31
	STS  _nhietdo+2,R22
	STS  _nhietdo+3,R23
; 0000 00CA      doam = doamh*256 + doaml;
	LDS  R30,_doamh
	LDS  R31,_doamh+1
	LDS  R22,_doamh+2
	LDS  R23,_doamh+3
	RCALL SUBOPT_0x15
	RCALL SUBOPT_0x10
	RCALL __ADDD12
	STS  _doam,R30
	STS  _doam+1,R31
	STS  _doam+2,R22
	STS  _doam+3,R23
; 0000 00CB      doamh=doaml=nhietdoh=nhietdol=0;
	__GETD1N 0x0
	RCALL SUBOPT_0x14
	RCALL SUBOPT_0x12
	RCALL SUBOPT_0x11
	RCALL SUBOPT_0xD
; 0000 00CC      portdata=1;
	SBI  0x12,0
; 0000 00CD 
; 0000 00CE      TCCR1A=0x00;
	RCALL SUBOPT_0x16
; 0000 00CF      TCCR1B=0x03;
; 0000 00D0      TCNT1H=0xFF;
; 0000 00D1      TCNT1L=0x05;
; 0000 00D2      ICR1H=0x00;
	RCALL SUBOPT_0x17
; 0000 00D3      ICR1L=0x00;
; 0000 00D4      #asm("sei")
	sei
; 0000 00D5      }
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
; 0000 00E6     {

	.CSEG
_control_remember:
; 0000 00E7 
; 0000 00E8     switch (remember_t) {
	LDS  R30,_remember_t
	LDI  R31,0
; 0000 00E9         case 1:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x5A
; 0000 00EA             lamp=off;
	SBI  0x15,5
; 0000 00EB             fan_top=off;
	SBI  0x15,1
; 0000 00EC             fan_bottom=on;
	CBI  0x15,0
; 0000 00ED             fan_o2=off;
	SBI  0x15,2
; 0000 00EE             if (nhietdo < nhietdocd+2) remember_t=2;
	RCALL SUBOPT_0x18
	ADIW R30,2
	RCALL SUBOPT_0x19
	BRGE _0x63
	LDI  R30,LOW(2)
	RCALL SUBOPT_0x1A
; 0000 00EF             break;
_0x63:
	RJMP _0x59
; 0000 00F0         case 2:
_0x5A:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x64
; 0000 00F1             lamp=off;
	SBI  0x15,5
; 0000 00F2             fan_top=on;
	RCALL SUBOPT_0x1B
; 0000 00F3             fan_bottom=on;
; 0000 00F4             fan_o2=on;
; 0000 00F5             if (nhietdo < nhietdocd-2) remember_t=3;
	SBIW R30,2
	RCALL SUBOPT_0x19
	BRGE _0x6D
	LDI  R30,LOW(3)
	RCALL SUBOPT_0x1A
; 0000 00F6             if (nhietdo >= nhietdocd+3) remember_t=1;
_0x6D:
	RCALL SUBOPT_0x18
	ADIW R30,3
	RCALL SUBOPT_0x19
	BRLT _0x6E
	LDI  R30,LOW(1)
	RCALL SUBOPT_0x1A
; 0000 00F7             break;
_0x6E:
	RJMP _0x59
; 0000 00F8         case 3:
_0x64:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x59
; 0000 00F9             lamp=on;
	CBI  0x15,5
; 0000 00FA             fan_top=on;
	RCALL SUBOPT_0x1B
; 0000 00FB             fan_bottom=on;
; 0000 00FC             fan_o2=on;
; 0000 00FD             if (nhietdo > nhietdocd) remember_t=2;
	LDS  R26,_nhietdo
	LDS  R27,_nhietdo+1
	LDS  R24,_nhietdo+2
	LDS  R25,_nhietdo+3
	CLR  R22
	CLR  R23
	RCALL __CPD12
	BRGE _0x78
	LDI  R30,LOW(2)
	RCALL SUBOPT_0x1A
; 0000 00FE             if (nhietdo >= nhietdocd+3) remember_t=1;
_0x78:
	RCALL SUBOPT_0x18
	ADIW R30,3
	RCALL SUBOPT_0x19
	BRLT _0x79
	LDI  R30,LOW(1)
	RCALL SUBOPT_0x1A
; 0000 00FF             break;
_0x79:
; 0000 0100         }
_0x59:
; 0000 0101 
; 0000 0102     }
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
; 0000 010D void scan_key(){
_scan_key:
; 0000 010E PORTB.2=1; PORTB.3=1; PORTB.4=1; PORTB.5=1;
	SBI  0x18,2
	SBI  0x18,3
	SBI  0x18,4
	SBI  0x18,5
; 0000 010F DDRB=0b00000011;
	LDI  R30,LOW(3)
	OUT  0x17,R30
; 0000 0110 delay_mms(2);
	RCALL SUBOPT_0x1C
; 0000 0111 if(button_l==0) button_tl=0; else button_tl=1;
	SBIC 0x16,2
	RJMP _0x82
	CLT
	RJMP _0xC6
_0x82:
	SET
_0xC6:
	BLD  R2,3
; 0000 0112 delay_mms(2);
	RCALL SUBOPT_0x1C
; 0000 0113 if(button_x==0) button_tx=0; else button_tx=1;
	SBIC 0x16,3
	RJMP _0x84
	CLT
	RJMP _0xC7
_0x84:
	SET
_0xC7:
	BLD  R2,4
; 0000 0114 delay_mms(2);
	RCALL SUBOPT_0x1C
; 0000 0115 if(button_m==0) button_motor=0; else button_motor=1;
	SBIC 0x16,4
	RJMP _0x86
	CLT
	RJMP _0xC8
_0x86:
	SET
_0xC8:
	BLD  R2,5
; 0000 0116 delay_mms(2);
	RCALL SUBOPT_0x1C
; 0000 0117 if(button_s==0) button_sw=0; else button_sw=1;
	SBIC 0x16,5
	RJMP _0x88
	CLT
	RJMP _0xC9
_0x88:
	SET
_0xC9:
	BLD  R2,6
; 0000 0118 delay_mms(2);
	RCALL SUBOPT_0x1C
; 0000 0119 }
	RET
;
;void read_key()
; 0000 011C {
_read_key:
; 0000 011D scan_key();
	RCALL _scan_key
; 0000 011E if (button_tl ==on){
	SBRC R2,3
	RJMP _0x8A
; 0000 011F         nhietdocd++;
	RCALL SUBOPT_0x18
	ADIW R30,1
	RCALL __EEPROMWRW
	SBIW R30,1
; 0000 0120         beep(10,40,1);
	RCALL SUBOPT_0x1D
; 0000 0121         }
; 0000 0122 if (button_tx ==on){
_0x8A:
	SBRC R2,4
	RJMP _0x8B
; 0000 0123         nhietdocd--;
	RCALL SUBOPT_0x18
	SBIW R30,1
	RCALL __EEPROMWRW
	ADIW R30,1
; 0000 0124         beep(10,40,1);
	RCALL SUBOPT_0x1D
; 0000 0125         }
; 0000 0126 }
_0x8B:
	RET
;
;///////////////////////////////////////
;
;void lcd_putnum (long so,unsigned char x,unsigned char y)
; 0000 012B {
_lcd_putnum:
; 0000 012C    long a, b, c;
; 0000 012D    a = so / 100;
	RCALL SUBOPT_0x1E
;	so -> Y+14
;	x -> Y+13
;	y -> Y+12
;	a -> Y+8
;	b -> Y+4
;	c -> Y+0
; 0000 012E    b = (so - 100 * a) / 10;
; 0000 012F    c = so - 100 * a - 10 * b;
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	RCALL SUBOPT_0x1F
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	RCALL SUBOPT_0x20
; 0000 0130    lcd_gotoxy (x, y) ;
; 0000 0131    lcd_putchar (a + 48) ;
; 0000 0132    lcd_putchar (b + 48) ;
; 0000 0133    lcd_putsf(".");
	__POINTW1FN _0x0,0
	RCALL SUBOPT_0x21
; 0000 0134    lcd_putchar (c + 48) ;
	RJMP _0x20C0003
; 0000 0135 }
;
;void lcd_putnum2 (long so,unsigned char x,unsigned char y)
; 0000 0138 {
_lcd_putnum2:
; 0000 0139    long a, b, c;
; 0000 013A    a = so / 100;
	RCALL SUBOPT_0x1E
;	so -> Y+14
;	x -> Y+13
;	y -> Y+12
;	a -> Y+8
;	b -> Y+4
;	c -> Y+0
; 0000 013B    b = (so - 100 * a) / 10;
; 0000 013C    c = so - 100 * a - 10 * b;
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	RCALL SUBOPT_0x1F
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	RCALL SUBOPT_0x20
; 0000 013D    lcd_gotoxy (x, y) ;
; 0000 013E    lcd_putchar (a + 48) ;
; 0000 013F    lcd_putchar (b + 48) ;
; 0000 0140    lcd_putchar (c + 48) ;
_0x20C0003:
	LD   R30,Y
	SUBI R30,-LOW(48)
	ST   -Y,R30
	RCALL _lcd_putchar
; 0000 0141 }
	ADIW R28,18
	RET
;
;//char display_buffer[32];
;void hienthi_lcd()
; 0000 0145 {
_hienthi_lcd:
; 0000 0146     lcd_gotoxy(0,0);
	RCALL SUBOPT_0x22
	RCALL SUBOPT_0x22
	RCALL _lcd_gotoxy
; 0000 0147     lcd_putsf("T: ");
	__POINTW1FN _0x0,2
	RCALL SUBOPT_0x21
; 0000 0148     lcd_putnum(nhietdo,3,0);
	LDS  R30,_nhietdo
	LDS  R31,_nhietdo+1
	LDS  R22,_nhietdo+2
	LDS  R23,_nhietdo+3
	RCALL __PUTPARD1
	LDI  R30,LOW(3)
	ST   -Y,R30
	RCALL SUBOPT_0x22
	RCALL _lcd_putnum
; 0000 0149     lcd_gotoxy(7,0);
	LDI  R30,LOW(7)
	ST   -Y,R30
	RCALL SUBOPT_0x22
	RCALL _lcd_gotoxy
; 0000 014A     lcd_putsf("  >  ");
	__POINTW1FN _0x0,6
	RCALL SUBOPT_0x21
; 0000 014B     lcd_putnum(nhietdocd,12,0);
	RCALL SUBOPT_0x18
	CLR  R22
	CLR  R23
	RCALL __PUTPARD1
	LDI  R30,LOW(12)
	ST   -Y,R30
	RCALL SUBOPT_0x22
	RCALL _lcd_putnum
; 0000 014C     lcd_gotoxy(0,1);
	RCALL SUBOPT_0x22
	RCALL SUBOPT_0x23
	RCALL _lcd_gotoxy
; 0000 014D     lcd_putsf("H: ");
	__POINTW1FN _0x0,12
	RCALL SUBOPT_0x21
; 0000 014E     lcd_putnum(doam,3,1);
	LDS  R30,_doam
	LDS  R31,_doam+1
	LDS  R22,_doam+2
	LDS  R23,_doam+3
	RCALL __PUTPARD1
	LDI  R30,LOW(3)
	ST   -Y,R30
	RCALL SUBOPT_0x23
	RCALL _lcd_putnum
; 0000 014F     lcd_gotoxy(7,1);
	LDI  R30,LOW(7)
	ST   -Y,R30
	RCALL SUBOPT_0x23
	RCALL _lcd_gotoxy
; 0000 0150     lcd_putsf("      ");
	__POINTW1FN _0x0,16
	RCALL SUBOPT_0x21
; 0000 0151     lcd_putnum2(ht_count_egg,13,1);
	MOVW R30,R12
	CLR  R22
	CLR  R23
	RCALL __PUTPARD1
	LDI  R30,LOW(13)
	ST   -Y,R30
	RCALL SUBOPT_0x23
	RCALL _lcd_putnum2
; 0000 0152 
; 0000 0153 }
	RET
;
;
;///////////////////////////////////////////////
;int count_i=0;
;eeprom int dttudong=0;
;
;void main(void)
; 0000 015B {
_main:
; 0000 015C 
; 0000 015D // Declare your local variables here
; 0000 015E PORTB=0b1111111;
	LDI  R30,LOW(127)
	OUT  0x18,R30
; 0000 015F DDRB=0b00000011;
	LDI  R30,LOW(3)
	OUT  0x17,R30
; 0000 0160 
; 0000 0161 PORTC=0xff;
	LDI  R30,LOW(255)
	OUT  0x15,R30
; 0000 0162 DDRC=0xff;
	OUT  0x14,R30
; 0000 0163 
; 0000 0164 PORTD=0xff;
	OUT  0x12,R30
; 0000 0165 DDRD=0x00;
	LDI  R30,LOW(0)
	OUT  0x11,R30
; 0000 0166 
; 0000 0167 // Timer/Counter 0 initialization
; 0000 0168 // Clock source: System Clock
; 0000 0169 // Clock value: Timer 0 Stopped
; 0000 016A TCCR0=0x00;
	RCALL SUBOPT_0x7
; 0000 016B TCNT0=0x00;
; 0000 016C 
; 0000 016D // Timer/Counter 1 initialization
; 0000 016E // Clock source: System Clock
; 0000 016F // Clock value: 250.000 kHz
; 0000 0170 // Mode: Normal top=0xFFFF
; 0000 0171 // OC1A output: Discon.
; 0000 0172 // OC1B output: Discon.
; 0000 0173 // Noise Canceler: Off
; 0000 0174 // Input Capture on Falling Edge
; 0000 0175 // Timer1 Overflow Interrupt: On
; 0000 0176 // Input Capture Interrupt: Off
; 0000 0177 // Compare A Match Interrupt: Off
; 0000 0178 // Compare B Match Interrupt: Off
; 0000 0179 TCCR1A=0x00;
	RCALL SUBOPT_0x16
; 0000 017A TCCR1B=0x03;
; 0000 017B TCNT1H=0xFF;
; 0000 017C TCNT1L=0x05;
; 0000 017D ICR1H=0x00;
	RCALL SUBOPT_0x17
; 0000 017E ICR1L=0x00;
; 0000 017F OCR1AH=0x00;
	LDI  R30,LOW(0)
	OUT  0x2B,R30
; 0000 0180 OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 0181 OCR1BH=0x00;
	OUT  0x29,R30
; 0000 0182 OCR1BL=0x00;
	OUT  0x28,R30
; 0000 0183 
; 0000 0184 // Timer/Counter 2 initialization
; 0000 0185 // Clock source: System Clock
; 0000 0186 // Clock value: Timer2 Stopped
; 0000 0187 // Mode: Normal top=0xFF
; 0000 0188 // OC2 output: Disconnected
; 0000 0189 ASSR=0x00;
	OUT  0x22,R30
; 0000 018A TCCR2=0x00;
	RCALL SUBOPT_0xF
; 0000 018B TCNT2=0x00;
	RCALL SUBOPT_0x9
; 0000 018C OCR2=0x00;
	LDI  R30,LOW(0)
	OUT  0x23,R30
; 0000 018D 
; 0000 018E // External Interrupt(s) initialization
; 0000 018F // INT0: Off
; 0000 0190 // INT1: Off
; 0000 0191 MCUCR=0x00;
	OUT  0x35,R30
; 0000 0192 
; 0000 0193 // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 0194 TIMSK=0x04;
	LDI  R30,LOW(4)
	OUT  0x39,R30
; 0000 0195 
; 0000 0196 // USART initialization
; 0000 0197 // USART disabled
; 0000 0198 UCSRB=0x00;
	LDI  R30,LOW(0)
	OUT  0xA,R30
; 0000 0199 
; 0000 019A // Analog Comparator initialization
; 0000 019B // Analog Comparator: Off
; 0000 019C // Analog Comparator Input Capture by Timer/Counter 1: Off
; 0000 019D ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 019E SFIOR=0x00;
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0000 019F 
; 0000 01A0 // ADC initialization
; 0000 01A1 // ADC disabled
; 0000 01A2 ADCSRA=0x00;
	OUT  0x6,R30
; 0000 01A3 
; 0000 01A4 // SPI initialization
; 0000 01A5 // SPI disabled
; 0000 01A6 SPCR=0x00;
	OUT  0xD,R30
; 0000 01A7 
; 0000 01A8 // TWI initialization
; 0000 01A9 // TWI disabled
; 0000 01AA TWCR=0x00;
	OUT  0x36,R30
; 0000 01AB 
; 0000 01AC // Alphanumeric LCD initialization
; 0000 01AD // Connections specified in the
; 0000 01AE // Project|Configure|C Compiler|Libraries|Alphanumeric LCD menu:
; 0000 01AF // RS - PORTD Bit 1
; 0000 01B0 // RD - PORTD Bit 2
; 0000 01B1 // EN - PORTD Bit 3
; 0000 01B2 // D4 - PORTD Bit 4
; 0000 01B3 // D5 - PORTD Bit 5
; 0000 01B4 // D6 - PORTD Bit 6
; 0000 01B5 // D7 - PORTD Bit 7
; 0000 01B6 // Characters/line: 16
; 0000 01B7 lcd_init(16);
	LDI  R30,LOW(16)
	ST   -Y,R30
	RCALL _lcd_init
; 0000 01B8 
; 0000 01B9 hong1=0;
	LDI  R26,LOW(_hong1)
	LDI  R27,HIGH(_hong1)
	RCALL SUBOPT_0x2
; 0000 01BA hong2=0;
	LDI  R26,LOW(_hong2)
	LDI  R27,HIGH(_hong2)
	RCALL SUBOPT_0x2
; 0000 01BB hong3=0;
	LDI  R26,LOW(_hong3)
	LDI  R27,HIGH(_hong3)
	RCALL SUBOPT_0x2
; 0000 01BC 
; 0000 01BD // Watchdog Timer initialization
; 0000 01BE // Watchdog Timer Prescaler: OSC/2048k
; 0000 01BF #pragma optsize-
; 0000 01C0 WDTCR=0x1F;
	LDI  R30,LOW(31)
	OUT  0x21,R30
; 0000 01C1 WDTCR=0x0F;
	LDI  R30,LOW(15)
	OUT  0x21,R30
; 0000 01C2 #ifdef _OPTIMIZE_SIZE_
; 0000 01C3 #pragma optsize+
; 0000 01C4 #endif
; 0000 01C5 
; 0000 01C6 // Global enable interrupts
; 0000 01C7 #asm("sei")
	sei
; 0000 01C8 
; 0000 01C9 //lcd_putsf(">>>>NQ Fairy<<<<");
; 0000 01CA delay_ms(10);
	RCALL SUBOPT_0x24
	RCALL SUBOPT_0x25
	RCALL _delay_ms
; 0000 01CB //beepe(20,80,2);
; 0000 01CC reset_all();
	RCALL _reset_all
; 0000 01CD while (1)
_0x8C:
; 0000 01CE    {
; 0000 01CF       if (set_am2301==1)
	SBRS R2,0
	RJMP _0x8F
; 0000 01D0         {
; 0000 01D1         set_am2301=0;
	CLT
	BLD  R2,0
; 0000 01D2         read_am2301();
	RCALL _read_am2301
; 0000 01D3         control_remember();
	RCALL _control_remember
; 0000 01D4         #asm("WDR");
	WDR
; 0000 01D5         }
; 0000 01D6 
; 0000 01D7       if (set_key==1)
_0x8F:
	SBRS R2,1
	RJMP _0x90
; 0000 01D8         {
; 0000 01D9         read_key();
	RCALL _read_key
; 0000 01DA         if (button_motor == on)
	SBRC R2,5
	RJMP _0x91
; 0000 01DB             {
; 0000 01DC             for (count_i=0; count_i<=7; count_i++)
	LDI  R30,LOW(0)
	STS  _count_i,R30
	STS  _count_i+1,R30
_0x93:
	LDS  R26,_count_i
	LDS  R27,_count_i+1
	SBIW R26,8
	BRGE _0x94
; 0000 01DD               {
; 0000 01DE                 delay_mms(50);
	RCALL SUBOPT_0x26
; 0000 01DF                 if(button_m==0) button_motor=on; else button_motor=off;
	SBIC 0x16,4
	RJMP _0x95
	CLT
	RJMP _0xCA
_0x95:
	SET
_0xCA:
	BLD  R2,5
; 0000 01E0                 delay_mms(50);
	RCALL SUBOPT_0x26
; 0000 01E1                 if(button_motor==off)
	SBRS R2,5
	RJMP _0x97
; 0000 01E2                 {
; 0000 01E3                 count_i=11;
	LDI  R30,LOW(11)
	LDI  R31,HIGH(11)
	STS  _count_i,R30
	STS  _count_i+1,R31
; 0000 01E4                 if (dttudong==0) dttudong=1; else dttudong=0;
	RCALL SUBOPT_0x27
	RCALL __EEPROMRDW
	SBIW R30,0
	BRNE _0x98
	RCALL SUBOPT_0x27
	RCALL SUBOPT_0x28
	RJMP _0xCB
_0x98:
	RCALL SUBOPT_0x27
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
_0xCB:
	RCALL __EEPROMWRW
; 0000 01E5                 }
; 0000 01E6               }
_0x97:
	LDI  R26,LOW(_count_i)
	LDI  R27,HIGH(_count_i)
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	RJMP _0x93
_0x94:
; 0000 01E7             }
; 0000 01E8 
; 0000 01E9         if (button_motor == on)
_0x91:
	SBRC R2,5
	RJMP _0x9A
; 0000 01EA             {
; 0000 01EB             lcd_clear();
	RCALL _lcd_clear
; 0000 01EC             delay_mms(10);
	RCALL SUBOPT_0x24
	RCALL SUBOPT_0x4
; 0000 01ED             lcd_putsf("Dao Trung               Bang Tay");
	__POINTW1FN _0x0,23
	RCALL SUBOPT_0x21
; 0000 01EE             motor=on;
	CBI  0x15,4
; 0000 01EF             beep(20,30,1);
	RCALL SUBOPT_0x29
; 0000 01F0             while (button_motor == on)
_0x9D:
	SBRC R2,5
	RJMP _0x9F
; 0000 01F1             {
; 0000 01F2             reset_all();
	RCALL _reset_all
; 0000 01F3             delay_mms(70);
	LDI  R30,LOW(70)
	LDI  R31,HIGH(70)
	RCALL SUBOPT_0x4
; 0000 01F4             if(button_m==0) button_motor=0; else button_motor=1;
	SBIC 0x16,4
	RJMP _0xA0
	CLT
	RJMP _0xCC
_0xA0:
	SET
_0xCC:
	BLD  R2,5
; 0000 01F5             delay_mms(70);
	LDI  R30,LOW(70)
	LDI  R31,HIGH(70)
	RCALL SUBOPT_0x4
; 0000 01F6             #asm("WDR");
	WDR
; 0000 01F7             }
	RJMP _0x9D
_0x9F:
; 0000 01F8             delay_mms(10);
	RCALL SUBOPT_0x24
	RCALL SUBOPT_0x4
; 0000 01F9             motor=off;
	SBI  0x15,4
; 0000 01FA             lcd_clear();
	RCALL _lcd_clear
; 0000 01FB             delay_mms(10);
	RCALL SUBOPT_0x24
	RCALL SUBOPT_0x4
; 0000 01FC             reset_all();
	RCALL _reset_all
; 0000 01FD             }
; 0000 01FE         if (dttudong==on) led=1;
_0x9A:
	RCALL SUBOPT_0x27
	RCALL __EEPROMRDW
	SBIW R30,0
	BRNE _0xA4
	SBI  0x18,1
; 0000 01FF             else {led=0; count_eep=0; set_egg=0; ht_count_egg=0; }
	RJMP _0xA7
_0xA4:
	CBI  0x18,1
	CLR  R10
	CLR  R11
	CLT
	BLD  R2,2
	CLR  R12
	CLR  R13
_0xA7:
; 0000 0200         hienthi_lcd();
	RCALL _hienthi_lcd
; 0000 0201         set_key=0;
	CLT
	BLD  R2,1
; 0000 0202         }
; 0000 0203 
; 0000 0204       if ((set_egg==1)&(dttudong==on))
_0x90:
	LDI  R26,0
	SBRC R2,2
	LDI  R26,1
	LDI  R30,LOW(1)
	RCALL __EQB12
	MOV  R0,R30
	RCALL SUBOPT_0x27
	RCALL __EEPROMRDW
	LDI  R26,LOW(0)
	LDI  R27,HIGH(0)
	RCALL __EQW12
	AND  R30,R0
	BREQ _0xAA
; 0000 0205         {
; 0000 0206          fan_top=fan_bottom=fan_o2=lamp=humidifier=motor=off;
	SBI  0x15,4
	SBI  0x15,3
	SBI  0x15,5
	SBI  0x15,2
	SBI  0x15,0
	SBI  0x15,1
; 0000 0207          lcd_clear();
	RCALL _lcd_clear
; 0000 0208          beep(20,30,1);
	RCALL SUBOPT_0x29
; 0000 0209          lcd_putsf("Dao Trung               Tu Dong ");
	__POINTW1FN _0x0,56
	RCALL SUBOPT_0x21
; 0000 020A          motor=on;
	CBI  0x15,4
; 0000 020B          while (button_sw==1)
_0xB9:
	SBRS R2,6
	RJMP _0xBB
; 0000 020C          {
; 0000 020D          delay_mms(50);
	RCALL SUBOPT_0x26
; 0000 020E          if(button_s==0) button_sw=0; else button_sw=1;
	SBIC 0x16,5
	RJMP _0xBC
	CLT
	RJMP _0xCD
_0xBC:
	SET
_0xCD:
	BLD  R2,6
; 0000 020F          delay_mms(50);
	RCALL SUBOPT_0x26
; 0000 0210          #asm("WDR");
	WDR
; 0000 0211          }
	RJMP _0xB9
_0xBB:
; 0000 0212          delay_mms(300);
	LDI  R30,LOW(300)
	LDI  R31,HIGH(300)
	RCALL SUBOPT_0x4
; 0000 0213          while (button_sw==0)
_0xBE:
	SBRC R2,6
	RJMP _0xC0
; 0000 0214          {
; 0000 0215          delay_mms(50);
	RCALL SUBOPT_0x26
; 0000 0216          if(button_s==0) button_sw=0; else button_sw=1;
	SBIC 0x16,5
	RJMP _0xC1
	CLT
	RJMP _0xCE
_0xC1:
	SET
_0xCE:
	BLD  R2,6
; 0000 0217          delay_mms(50);
	RCALL SUBOPT_0x26
; 0000 0218          #asm("WDR");
	WDR
; 0000 0219          }
	RJMP _0xBE
_0xC0:
; 0000 021A          delay_mms(50);
	RCALL SUBOPT_0x26
; 0000 021B          beep(20,30,1);
	RCALL SUBOPT_0x29
; 0000 021C          set_egg=0;
	CLT
	BLD  R2,2
; 0000 021D          delay_mms(300);
	LDI  R30,LOW(300)
	LDI  R31,HIGH(300)
	RCALL SUBOPT_0x4
; 0000 021E          motor=off;
	SBI  0x15,4
; 0000 021F          reset_all();
	RCALL _reset_all
; 0000 0220         }
; 0000 0221 
; 0000 0222    }
_0xAA:
	RJMP _0x8C
; 0000 0223 
; 0000 0224 }
_0xC5:
	RJMP _0xC5
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
	RCALL SUBOPT_0x2A
    ld    r30,y
    swap  r30
    st    y,r30
	LD   R30,Y
	RCALL SUBOPT_0x2A
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
	RCALL SUBOPT_0x2B
	LDD  R30,Y+1
	STS  __lcd_x,R30
	LD   R30,Y
	STS  __lcd_y,R30
_0x20C0002:
	ADIW R28,2
	RET
_lcd_clear:
	LDI  R30,LOW(2)
	RCALL SUBOPT_0x2B
	RCALL SUBOPT_0x2C
	LDI  R30,LOW(12)
	RCALL SUBOPT_0x2B
	RCALL SUBOPT_0x23
	RCALL __lcd_write_data
	RCALL SUBOPT_0x2C
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
	RCALL SUBOPT_0x22
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
	RCALL SUBOPT_0x2B
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
	LDI  R30,LOW(20)
	LDI  R31,HIGH(20)
	RCALL SUBOPT_0x25
	RCALL _delay_ms
	LDI  R30,LOW(48)
	RCALL SUBOPT_0x2A
	RCALL SUBOPT_0x2D
	RCALL SUBOPT_0x2D
	RCALL SUBOPT_0x2E
	LDI  R30,LOW(32)
	RCALL SUBOPT_0x2A
	RCALL SUBOPT_0x2E
	LDI  R30,LOW(40)
	RCALL SUBOPT_0x2B
	LDI  R30,LOW(4)
	RCALL SUBOPT_0x2B
	LDI  R30,LOW(133)
	RCALL SUBOPT_0x2B
	LDI  R30,LOW(6)
	RCALL SUBOPT_0x2B
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
_count_i:
	.BYTE 0x2

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

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x1:
	LDI  R26,LOW(_count_egg)
	LDI  R27,HIGH(_count_egg)
	RCALL __EEPROMRDW
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x2:
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RCALL __EEPROMWRW
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x3:
	__GETWRN 16,17,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 21 TIMES, CODE SIZE REDUCTION:38 WORDS
SUBOPT_0x4:
	ST   -Y,R31
	ST   -Y,R30
	RJMP _delay_mms

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x5:
	__ADDWRN 16,17,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x6:
	__GETWRN 18,19,128
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x7:
	OUT  0x33,R30
	LDI  R30,LOW(0)
	OUT  0x32,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x8:
	__CPWRN 16,17,8
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x9:
	LDI  R30,LOW(0)
	OUT  0x24,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xA:
	LDI  R30,LOW(2)
	OUT  0x25,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xB:
	IN   R30,0x24
	CPI  R30,LOW(0x61)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0xC:
	RCALL __CWD1
	RCALL __ADDD12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xD:
	STS  _doamh,R30
	STS  _doamh+1,R31
	STS  _doamh+2,R22
	STS  _doamh+3,R23
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0xE:
	MOVW R26,R18
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	RCALL __DIVW21
	MOVW R18,R30
	RJMP SUBOPT_0x9

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0xF:
	LDI  R30,LOW(0)
	OUT  0x25,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x10:
	LDS  R26,_doaml
	LDS  R27,_doaml+1
	LDS  R24,_doaml+2
	LDS  R25,_doaml+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x11:
	STS  _doaml,R30
	STS  _doaml+1,R31
	STS  _doaml+2,R22
	STS  _doaml+3,R23
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x12:
	STS  _nhietdoh,R30
	STS  _nhietdoh+1,R31
	STS  _nhietdoh+2,R22
	STS  _nhietdoh+3,R23
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x13:
	LDS  R26,_nhietdol
	LDS  R27,_nhietdol+1
	LDS  R24,_nhietdol+2
	LDS  R25,_nhietdol+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x14:
	STS  _nhietdol,R30
	STS  _nhietdol+1,R31
	STS  _nhietdol+2,R22
	STS  _nhietdol+3,R23
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x15:
	__GETD2N 0x100
	RCALL __MULD12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x16:
	LDI  R30,LOW(0)
	OUT  0x2F,R30
	LDI  R30,LOW(3)
	OUT  0x2E,R30
	RJMP SUBOPT_0x0

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x17:
	LDI  R30,LOW(0)
	OUT  0x27,R30
	OUT  0x26,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x18:
	LDI  R26,LOW(_nhietdocd)
	LDI  R27,HIGH(_nhietdocd)
	RCALL __EEPROMRDW
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:28 WORDS
SUBOPT_0x19:
	LDS  R26,_nhietdo
	LDS  R27,_nhietdo+1
	LDS  R24,_nhietdo+2
	LDS  R25,_nhietdo+3
	CLR  R22
	CLR  R23
	RCALL __CPD21
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x1A:
	STS  _remember_t,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1B:
	CBI  0x15,1
	CBI  0x15,0
	CBI  0x15,2
	RJMP SUBOPT_0x18

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x1C:
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	RJMP SUBOPT_0x4

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x1D:
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(40)
	LDI  R31,HIGH(40)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	ST   -Y,R31
	ST   -Y,R30
	RJMP _beep

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:49 WORDS
SUBOPT_0x1E:
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
SUBOPT_0x1F:
	__GETD1S 4
	__GETD2N 0xA
	RCALL __MULD12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x20:
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

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x21:
	ST   -Y,R31
	ST   -Y,R30
	RJMP _lcd_putsf

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x22:
	LDI  R30,LOW(0)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x23:
	LDI  R30,LOW(1)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x24:
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 13 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x25:
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x26:
	LDI  R30,LOW(50)
	LDI  R31,HIGH(50)
	RJMP SUBOPT_0x4

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x27:
	LDI  R26,LOW(_dttudong)
	LDI  R27,HIGH(_dttudong)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x28:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:14 WORDS
SUBOPT_0x29:
	LDI  R30,LOW(20)
	LDI  R31,HIGH(20)
	RCALL SUBOPT_0x25
	LDI  R30,LOW(30)
	LDI  R31,HIGH(30)
	RCALL SUBOPT_0x25
	RCALL SUBOPT_0x28
	RCALL SUBOPT_0x25
	RJMP _beep

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x2A:
	ST   -Y,R30
	RJMP __lcd_write_nibble_G102

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x2B:
	ST   -Y,R30
	RJMP __lcd_write_data

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2C:
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	RCALL SUBOPT_0x25
	RJMP _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x2D:
	__DELAY_USW 400
	LDI  R30,LOW(48)
	RJMP SUBOPT_0x2A

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2E:
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

__EQB12:
	CP   R30,R26
	LDI  R30,1
	BREQ __EQB12T
	CLR  R30
__EQB12T:
	RET

__EQW12:
	CP   R30,R26
	CPC  R31,R27
	LDI  R30,1
	BREQ __EQW12T
	CLR  R30
__EQW12T:
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
