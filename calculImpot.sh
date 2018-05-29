#!/bin/bash

SALARY_BRUT=0
TYPE="NONCADRE"
COEF=23

##
## Error Function
##
error(){ 
    echo "ERREUR : parametres invalides !" >&2 
    echo "utilisez l'option -h pour en savoir plus" >&2 
    exit 1 
} 

##
## Usage Function
##
usage(){ 
    echo "Usage $0 -t <type> -s <salaire brut annuel>"
    echo "Exemple sh calculImpot.sh -t CADRE -s 50000"
    echo "-h : afficher l'aide" 
} 

##
## IsCadre
##
##
IsCadre(){
	if [ "$TYPE" = "CADRE" ]; then
		COEF=25
	fi
}

##
## calculImpot
##
##
calculImpot(){
    RESULT=0
    if [ $NET_IMPOSABLE -le  9807 ]; then
		RESULT=0
    elif [ $NET_IMPOSABLE -ge  9807 ] && [ $NET_IMPOSABLE -le  27086 ]; then
        SUM=$(($NET_IMPOSABLE-9807))
        RESULT=$(($SUM*14/100))
    elif [ $NET_IMPOSABLE -ge  27086 ] && [ $NET_IMPOSABLE -le  72617 ]; then
        STR01=$((27086-9807))
        TR01=$(($STR01*14/100))
        STR02=$(($NET_IMPOSABLE-27086))
        TR02=$(($STR02*30/100))
        RESULT=$(($TR01+$TR02))
    elif [ $NET_IMPOSABLE -ge  72617 ] && [ $NET_IMPOSABLE -le 153783 ]; then
        STR01=$((27086-9807))
        TR01=$(($STR01*14/100))
        STR02=$((72617-27086))
        TR02=$(($STR02*30/100))
        STR03=$(($NET_IMPOSABLE-72617))
        TR03=$(($STR03*41/100))
        RESULT=$(($TR01+$TR02+$TR03))
    else
        STR01=$((27086-9807))
        TR01=$(($STR01*14/100))
        STR02=$((72617-27086))
        TR02=$(($STR02*30/100))
        STR03=$((153783-72617))
        TR03=$(($STR03*41/100))
        STR04=$(($NET_IMPOSABLE-153783))
        TR04=$(($STR04*45/100))
        RESULT=$(($TR01+$TR02+$TR03+$TR04))
	fi
    echo "Vous devez payer $RESULT €"
}

##
## Run Function
## this function contains the core of our script
##
run(){
    IsCadre
    SALARY_BRUT_MENSUEL=$(($SALARY_BRUT/12))
    echo "Vous êtes un $TYPE et votre salaire brut est de $SALARY_BRUT_MENSUEL €"
    SALARY_NET=$(($SALARY_BRUT_MENSUEL-$SALARY_BRUT_MENSUEL*$COEF/100))
    NET_IMPOSABLE=$(($SALARY_NET*12))
    echo "Votre salaire net est de $SALARY_NET € votre net imposable est de $NET_IMPOSABLE €"
    calculImpot
}

##
## Main
##

# Pas de paramètre 
[ $# -lt 1 ] && error

while getopts ":t:s:h" option; do 
    case "$option" in 
        h) usage ;; 
	    t) TYPE=$OPTARG;;	
        s) SALARY_BRUT=$OPTARG; run ;;
        :) error ;; # il manque une valeur ($option = 'f' ici) 
        *) error ;; 
    esac 
done


