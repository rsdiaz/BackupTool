#!/bin/bash
#***************************************************************#
#		       backupTool.sh 				#
#			Version 1.0				#
#		<robertoserrano83@gmail.com>			#
#	           Copyright 2012 robfree            		#
#    This program is free software: you can redistribute 	#
#         it and/or modify it under the terms of the 		#
#         GNU General Public License as published by		#
#         the Free Software Foundation, either version 3 	#
#    of the License, or (at your option) any later version.	#
#								#
#    This program is distributed in the hope that it will 	#
#    be useful, but WITHOUT ANY WARRANTY; without even the	#
#    implied warranty of MERCHANTABILITY or FITNESS FOR A 	#
#    PARTICULAR PURPOSE.  See the GNU General Public License	#
#    for more details.						#
#								#
#          You should have received a copy of the 		#
#    GNU General Public License along with this program.	#
#         If not, see <http://www.gnu.org/licenses/>.	        #
#								#
#	  Script que realiza backup totales    			#
#         y diferenciales automaticamente.     			#
#             Parametros del script            			#
#		-h	help		       			#
# 		-c    	Backups total y        			#
#			diferencial automatico 			#
#		-t	Backup total unico     			#
#					       			#	
#***************************************************************#

# NO modificar variables

ROOT_UID=0							# Solo usuario con $UID 0  root.
E_NOTROOT=87							# Error no root.
E_WRONG_ARGS=85							# Error no parametros.
SCRIPT_PARAMETERS="-c -h -t"					# Parametros del script.
DDAY=`date +%d`							# Dia actual.
BZ2="tar -jcvf"							# Compresion bz2.

# Estas variables SI se pueden modificar 

NOM_FILE="home-bin-"						# Termination file name ej: BackT-home-date
DIR_SAVE="/tuhome/tudirectorio /tuhome/otrodirectorio"		# Directorios a realizar backups
DIR_SAVE_LOG="/home/roberto/"					# Directorio destino archivo log
DIR_SAVE_BACKT=/home/roberto/					# Directorio destino del backup
DDAYT="01"							# Dia del mes de la copia total

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
	$FORMAT "$DIR_SAVE_BACKT"BackT-"${ARRAY2[${i}]}"`date +%d%b%y`.tar.bz2 ${ARRAY[${i}]} && echo "${ARRAY[${i}]} backup total realizado con exito `date +%d%b%y`" >> "$DIR_SAVE_LOG"backuplog.log || echo "Fallo backup total ${ARRAY[${i}]} `date +%d%b%y`" >> "$DIR_SAVE_LOG"backuplog.log
done 
}

#########################################################################
# Funcion compresion de archivos y archivos log de la copia diferencial #
#########################################################################

compress_backD() {
ELEMENTS=${#ARRAY[@]}
for (( i=0;i<$ELEMENTS;i++)); do
	$FORMAT "$DIR_SAVE_BACKT"BackD-"${ARRAY2[${i}]}""$DDAYT"`date +%b%y`-`date +%d%b%y`.tar.bz2 ${ARRAY[${i}]} -N `date +%y%m`"$DDAYT" && echo "${ARRAY[${i}]} backup diferencial realizado con exito `date +%d%b%y`" >> "$DIR_SAVE_LOG"backuplog.log || echo "Fallo backup diferencial ${ARRAY[${i}]} `date +%d%b%y`" >> "$DIR_SAVE_LOG"backuplog.log
done
}

##############################
# Funcion comprobar fecha    #
##############################

# Esta funcion prueba si es dia de copia total o diferencial

prog_main() {
if [ "$DDAY" == "$DDAYT" ]			# Si es dia 01 copia total si no copia diferencial 
then
	compress_backT				# Llamada a la funcion para la copia total 
else
	compress_backD				# Lamada a la funcion para la copia diferencial
fi 
}

############################
#          Main            #
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
