#
# Generated Makefile - do not edit!
#
# Edit the Makefile in the project folder instead (../Makefile). Each target
# has a -pre and a -post target defined where you can add customized code.
#
# This makefile implements configuration specific macros and targets.


# Include project Makefile
ifeq "${IGNORE_LOCAL}" "TRUE"
# do not include local makefile. User is passing all local related variables already
else
include Makefile
# Include makefile containing local settings
ifeq "$(wildcard nbproject/Makefile-local-default.mk)" "nbproject/Makefile-local-default.mk"
include nbproject/Makefile-local-default.mk
endif
endif

# Environment
MKDIR=gnumkdir -p
RM=rm -f 
MV=mv 
CP=cp 

# Macros
CND_CONF=default
ifeq ($(TYPE_IMAGE), DEBUG_RUN)
IMAGE_TYPE=debug
OUTPUT_SUFFIX=cof
DEBUGGABLE_SUFFIX=cof
FINAL_IMAGE=dist/${CND_CONF}/${IMAGE_TYPE}/Microchip.${IMAGE_TYPE}.${OUTPUT_SUFFIX}
else
IMAGE_TYPE=production
OUTPUT_SUFFIX=hex
DEBUGGABLE_SUFFIX=cof
FINAL_IMAGE=dist/${CND_CONF}/${IMAGE_TYPE}/Microchip.${IMAGE_TYPE}.${OUTPUT_SUFFIX}
endif

# Object Directory
OBJECTDIR=build/${CND_CONF}/${IMAGE_TYPE}

# Distribution Directory
DISTDIR=dist/${CND_CONF}/${IMAGE_TYPE}

# Source Files Quoted if spaced
SOURCEFILES_QUOTED_IF_SPACED=main.asm ledarray8.asm uart_hardware.asm e2prom.asm

# Object Files Quoted if spaced
OBJECTFILES_QUOTED_IF_SPACED=${OBJECTDIR}/main.o ${OBJECTDIR}/ledarray8.o ${OBJECTDIR}/uart_hardware.o ${OBJECTDIR}/e2prom.o
POSSIBLE_DEPFILES=${OBJECTDIR}/main.o.d ${OBJECTDIR}/ledarray8.o.d ${OBJECTDIR}/uart_hardware.o.d ${OBJECTDIR}/e2prom.o.d

# Object Files
OBJECTFILES=${OBJECTDIR}/main.o ${OBJECTDIR}/ledarray8.o ${OBJECTDIR}/uart_hardware.o ${OBJECTDIR}/e2prom.o

# Source Files
SOURCEFILES=main.asm ledarray8.asm uart_hardware.asm e2prom.asm


CFLAGS=
ASFLAGS=
LDLIBSOPTIONS=

############# Tool locations ##########################################
# If you copy a project from one host to another, the path where the  #
# compiler is installed may be different.                             #
# If you open this project with MPLAB X in the new host, this         #
# makefile will be regenerated and the paths will be corrected.       #
#######################################################################
# fixDeps replaces a bunch of sed/cat/printf statements that slow down the build
FIXDEPS=fixDeps

.build-conf:  ${BUILD_SUBPROJECTS}
ifneq ($(INFORMATION_MESSAGE), )
	@echo $(INFORMATION_MESSAGE)
endif
	${MAKE}  -f nbproject/Makefile-default.mk dist/${CND_CONF}/${IMAGE_TYPE}/Microchip.${IMAGE_TYPE}.${OUTPUT_SUFFIX}

MP_PROCESSOR_OPTION=16f887
MP_LINKER_DEBUG_OPTION= 
# ------------------------------------------------------------------------------------
# Rules for buildStep: assemble
ifeq ($(TYPE_IMAGE), DEBUG_RUN)
${OBJECTDIR}/main.o: main.asm  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/main.o.d 
	@${RM} ${OBJECTDIR}/main.o 
	@${FIXDEPS} dummy.d -e "${OBJECTDIR}/main.err" $(SILENT) -c ${MP_AS} $(MP_EXTRA_AS_PRE) -d__DEBUG -d__MPLAB_DEBUGGER_SIMULATOR=1 -q -p$(MP_PROCESSOR_OPTION)  -l\"${OBJECTDIR}/main.lst\" -e\"${OBJECTDIR}/main.err\" $(ASM_OPTIONS)   -o\"${OBJECTDIR}/main.o\" \"main.asm\" 
	@${DEP_GEN} -d "${OBJECTDIR}/main.o"
	@${FIXDEPS} "${OBJECTDIR}/main.o.d" $(SILENT) -rsi ${MP_AS_DIR} -c18 
	
${OBJECTDIR}/ledarray8.o: ledarray8.asm  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/ledarray8.o.d 
	@${RM} ${OBJECTDIR}/ledarray8.o 
	@${FIXDEPS} dummy.d -e "${OBJECTDIR}/ledarray8.err" $(SILENT) -c ${MP_AS} $(MP_EXTRA_AS_PRE) -d__DEBUG -d__MPLAB_DEBUGGER_SIMULATOR=1 -q -p$(MP_PROCESSOR_OPTION)  -l\"${OBJECTDIR}/ledarray8.lst\" -e\"${OBJECTDIR}/ledarray8.err\" $(ASM_OPTIONS)   -o\"${OBJECTDIR}/ledarray8.o\" \"ledarray8.asm\" 
	@${DEP_GEN} -d "${OBJECTDIR}/ledarray8.o"
	@${FIXDEPS} "${OBJECTDIR}/ledarray8.o.d" $(SILENT) -rsi ${MP_AS_DIR} -c18 
	
${OBJECTDIR}/uart_hardware.o: uart_hardware.asm  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/uart_hardware.o.d 
	@${RM} ${OBJECTDIR}/uart_hardware.o 
	@${FIXDEPS} dummy.d -e "${OBJECTDIR}/uart_hardware.err" $(SILENT) -c ${MP_AS} $(MP_EXTRA_AS_PRE) -d__DEBUG -d__MPLAB_DEBUGGER_SIMULATOR=1 -q -p$(MP_PROCESSOR_OPTION)  -l\"${OBJECTDIR}/uart_hardware.lst\" -e\"${OBJECTDIR}/uart_hardware.err\" $(ASM_OPTIONS)   -o\"${OBJECTDIR}/uart_hardware.o\" \"uart_hardware.asm\" 
	@${DEP_GEN} -d "${OBJECTDIR}/uart_hardware.o"
	@${FIXDEPS} "${OBJECTDIR}/uart_hardware.o.d" $(SILENT) -rsi ${MP_AS_DIR} -c18 
	
${OBJECTDIR}/e2prom.o: e2prom.asm  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/e2prom.o.d 
	@${RM} ${OBJECTDIR}/e2prom.o 
	@${FIXDEPS} dummy.d -e "${OBJECTDIR}/e2prom.err" $(SILENT) -c ${MP_AS} $(MP_EXTRA_AS_PRE) -d__DEBUG -d__MPLAB_DEBUGGER_SIMULATOR=1 -q -p$(MP_PROCESSOR_OPTION)  -l\"${OBJECTDIR}/e2prom.lst\" -e\"${OBJECTDIR}/e2prom.err\" $(ASM_OPTIONS)   -o\"${OBJECTDIR}/e2prom.o\" \"e2prom.asm\" 
	@${DEP_GEN} -d "${OBJECTDIR}/e2prom.o"
	@${FIXDEPS} "${OBJECTDIR}/e2prom.o.d" $(SILENT) -rsi ${MP_AS_DIR} -c18 
	
else
${OBJECTDIR}/main.o: main.asm  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/main.o.d 
	@${RM} ${OBJECTDIR}/main.o 
	@${FIXDEPS} dummy.d -e "${OBJECTDIR}/main.err" $(SILENT) -c ${MP_AS} $(MP_EXTRA_AS_PRE) -q -p$(MP_PROCESSOR_OPTION)  -l\"${OBJECTDIR}/main.lst\" -e\"${OBJECTDIR}/main.err\" $(ASM_OPTIONS)   -o\"${OBJECTDIR}/main.o\" \"main.asm\" 
	@${DEP_GEN} -d "${OBJECTDIR}/main.o"
	@${FIXDEPS} "${OBJECTDIR}/main.o.d" $(SILENT) -rsi ${MP_AS_DIR} -c18 
	
${OBJECTDIR}/ledarray8.o: ledarray8.asm  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/ledarray8.o.d 
	@${RM} ${OBJECTDIR}/ledarray8.o 
	@${FIXDEPS} dummy.d -e "${OBJECTDIR}/ledarray8.err" $(SILENT) -c ${MP_AS} $(MP_EXTRA_AS_PRE) -q -p$(MP_PROCESSOR_OPTION)  -l\"${OBJECTDIR}/ledarray8.lst\" -e\"${OBJECTDIR}/ledarray8.err\" $(ASM_OPTIONS)   -o\"${OBJECTDIR}/ledarray8.o\" \"ledarray8.asm\" 
	@${DEP_GEN} -d "${OBJECTDIR}/ledarray8.o"
	@${FIXDEPS} "${OBJECTDIR}/ledarray8.o.d" $(SILENT) -rsi ${MP_AS_DIR} -c18 
	
${OBJECTDIR}/uart_hardware.o: uart_hardware.asm  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/uart_hardware.o.d 
	@${RM} ${OBJECTDIR}/uart_hardware.o 
	@${FIXDEPS} dummy.d -e "${OBJECTDIR}/uart_hardware.err" $(SILENT) -c ${MP_AS} $(MP_EXTRA_AS_PRE) -q -p$(MP_PROCESSOR_OPTION)  -l\"${OBJECTDIR}/uart_hardware.lst\" -e\"${OBJECTDIR}/uart_hardware.err\" $(ASM_OPTIONS)   -o\"${OBJECTDIR}/uart_hardware.o\" \"uart_hardware.asm\" 
	@${DEP_GEN} -d "${OBJECTDIR}/uart_hardware.o"
	@${FIXDEPS} "${OBJECTDIR}/uart_hardware.o.d" $(SILENT) -rsi ${MP_AS_DIR} -c18 
	
${OBJECTDIR}/e2prom.o: e2prom.asm  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/e2prom.o.d 
	@${RM} ${OBJECTDIR}/e2prom.o 
	@${FIXDEPS} dummy.d -e "${OBJECTDIR}/e2prom.err" $(SILENT) -c ${MP_AS} $(MP_EXTRA_AS_PRE) -q -p$(MP_PROCESSOR_OPTION)  -l\"${OBJECTDIR}/e2prom.lst\" -e\"${OBJECTDIR}/e2prom.err\" $(ASM_OPTIONS)   -o\"${OBJECTDIR}/e2prom.o\" \"e2prom.asm\" 
	@${DEP_GEN} -d "${OBJECTDIR}/e2prom.o"
	@${FIXDEPS} "${OBJECTDIR}/e2prom.o.d" $(SILENT) -rsi ${MP_AS_DIR} -c18 
	
endif

# ------------------------------------------------------------------------------------
# Rules for buildStep: link
ifeq ($(TYPE_IMAGE), DEBUG_RUN)
dist/${CND_CONF}/${IMAGE_TYPE}/Microchip.${IMAGE_TYPE}.${OUTPUT_SUFFIX}: ${OBJECTFILES}  nbproject/Makefile-${CND_CONF}.mk    C:/Program\ Files\ (x86)/Microchip/MPLABX/v3.25/mpasmx/LKR/16f887_g.lkr
	@${MKDIR} dist/${CND_CONF}/${IMAGE_TYPE} 
	${MP_LD} $(MP_EXTRA_LD_PRE) "C:\Program Files (x86)\Microchip\MPLABX\v3.25\mpasmx\LKR\16f887_g.lkr"  -p$(MP_PROCESSOR_OPTION)  -w -x -u_DEBUG -z__ICD2RAM=1 -m"${DISTDIR}/${PROJECTNAME}.${IMAGE_TYPE}.map"   -z__MPLAB_BUILD=1  -z__MPLAB_DEBUG=1 -z__MPLAB_DEBUGGER_SIMULATOR=1 $(MP_LINKER_DEBUG_OPTION) -odist/${CND_CONF}/${IMAGE_TYPE}/Microchip.${IMAGE_TYPE}.${OUTPUT_SUFFIX}  ${OBJECTFILES_QUOTED_IF_SPACED}     
else
dist/${CND_CONF}/${IMAGE_TYPE}/Microchip.${IMAGE_TYPE}.${OUTPUT_SUFFIX}: ${OBJECTFILES}  nbproject/Makefile-${CND_CONF}.mk   C:/Program\ Files\ (x86)/Microchip/MPLABX/v3.25/mpasmx/LKR/16f887_g.lkr
	@${MKDIR} dist/${CND_CONF}/${IMAGE_TYPE} 
	${MP_LD} $(MP_EXTRA_LD_PRE) "C:\Program Files (x86)\Microchip\MPLABX\v3.25\mpasmx\LKR\16f887_g.lkr"  -p$(MP_PROCESSOR_OPTION)  -w  -m"${DISTDIR}/${PROJECTNAME}.${IMAGE_TYPE}.map"   -z__MPLAB_BUILD=1  -odist/${CND_CONF}/${IMAGE_TYPE}/Microchip.${IMAGE_TYPE}.${DEBUGGABLE_SUFFIX}  ${OBJECTFILES_QUOTED_IF_SPACED}     
endif


# Subprojects
.build-subprojects:


# Subprojects
.clean-subprojects:

# Clean Targets
.clean-conf: ${CLEAN_SUBPROJECTS}
	${RM} -r build/default
	${RM} -r dist/default

# Enable dependency checking
.dep.inc: .depcheck-impl

DEPFILES=$(shell mplabwildcard ${POSSIBLE_DEPFILES})
ifneq (${DEPFILES},)
include ${DEPFILES}
endif
