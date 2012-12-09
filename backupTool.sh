#!/bin/bash
#**********************************************#
#		      backupTool.sh            #
#	        Written by gdsr                #
#		     Dec 06, 2012	       #
#            Version: 1.0                      #
#		<obertoserrano83@gmail.com>    #
#	    Script que realiza backup totales  #
#         y diferenciales automaticamente.     #
#             Script parateters:               #
#		-h	help		       #
# 		-c    	Backups  	       #	
#**********************************************#
# Only user root

# NOT modify these variables
ROOT_UID=0					# Only user with $UID 0 have root privileges.
E_NOTROOT=87					# Non-root error.
E_WRONG_ARGS=85					# Not parameters error.
SCRIPT_PARAMETERS="-c -h -t"			# Script-parameters.
DDAY=`date +%d`					# Current day
BZ2="jcvf" 					# Compression bz2
# These variables can be modified
NOM_FILE="home-bin-"				# Termination file name ej: BackT-home-date
DIR_SAVE="/home/roberto/bin"			# Directorios a realizar backups
DIR_SAVE_LOG="/home/roberto/"			# Directorio destino archivo log
DIR_SAVE_BACKT=/home/roberto/			# Directorio destino del backup
DDAYT="01"					# Dia del mes de la copia total
# Declaro array con los directorios a copiar y nombres de archivo
# Arrays no modificar
ARRAY=( $DIR_SAVE )
ARRAY2=( $NOM_FILE )
##########################
# Funcion comprobar root #
##########################
comp_root() {
# Run as root, of course.
if [ "$UID" -ne "$ROOT_UID" ]
then
	echo "Must be root to run this script."
	exit $E_NOTROOT
	
fi
}
#####################################################################
# Funcion compresion de archivos y archivos log  de la copia total  #
#####################################################################
compress_backT() {
# get number of elements in the array
ELEMENTS=${#ARRAY[@]}
# echo each element in array 
# for loop
for (( i=0;i<$ELEMENTS;i++)); do
	tar -$FORMAT "$DIR_SAVE_BACKT"BackT-"${ARRAY2[${i}]}"`date +%d%b%y`.tar.bz2 ${ARRAY[${i}]} && echo "${ARRAY[${i}]} backup total realizado con exito `date +%d%b%y`" >> "$DIR_SAVE_LOG"backuplog.log || echo "Fallo backup total ${ARRAY[${i}]} `date +%d%b%y`" >> "$DIR_SAVE_LOG"backuplog.log
done 
}
#########################################################################
# Funcion compresion de archivos y archivos log de la copia diferencial #
#########################################################################
compress_backD() {
ELEMENTS=${#ARRAY[@]}
for (( i=0;i<$ELEMENTS;i++)); do
	tar -$FORMAT "$DIR_SAVE_BACKT"BackD-"${ARRAY2[${i}]}""$DDAYT"`date +%b%y`-`date +%d%b%y`.tar.bz2 ${ARRAY[${i}]} -N `date +%y%m`"$DDAYT" && echo "${ARRAY[${i}]} backup diferencial realizado con exito `date +%d%b%y`" >> "$DIR_SAVE_LOG"backuplog.log || echo "Fallo backup diferencial ${ARRAY[${i}]} `date +%d%b%y`" >> "$DIR_SAVE_LOG"backuplog.log
done
}
##############################
# Funcion programa principal #
##############################
prog_main() {
if [ "$DDAY" == "01" ]			# Si es dia 01 copia total si no copia diferencial 
then
	compress_backT				# Llamada a la funcion para la copia total 
else
	compress_backD				# Lamada a la funcion para la copia diferencial
fi 
}
############################
#          MAIN            #
############################
# Comprobamos parametros 
if [ $# -ne 1 ]
then
echo "Usage: `basename $0` $SCRIPT_PARAMETERS"
echo "`basename $0` -h for help"
# `basename $0` is the script's filename.
exit $E_WRONG_ARGS
fi
# Parametro -h  para ayuda 
if [ $1 == "-h" ] 
then 
echo "Usage: `basename $0` [-OPTIONS]"
echo "Options:"
echo 
echo -e " -h\tPara la ayuda."
echo -e " -v\tRealiza backups total y diferencial en formato bz2 automaticamente segun configuracion"
echo -e " -t\tRealiza un total unico en formato bz2 segun configuracion"
exit
fi
# Parametro -c para realizar copia automatica total y diferencial en formato bz2
if [[ $1 == "-c" ]]; then
	FORMAT=$BZ2
	comp_root
	prog_main
fi
# Parametro -t para relizar copia total unica en formato bz2
if [[ $1 == "-t" ]]; then
	FORMAT=$BZ2
	compress_backT
fi
echo "OK..."			# OK ... xd
exit 0
