#!/bin/bash

# Fuga da Mina v1.0b
# 
# Neste joguinho você controla um mineiro representado pela "@".
# A mina está prestes a desabar. Você tem um tempo para fugir.
# Você deve levar o mineiro até a saída "s".
# 
# Quando estiver sem caminho, pode usar a picareta e quebrar as
# paredes. Mas elas possuem uma "resistência" e a cada tentativa
# o tempo corre.
# 
# Caso encontre algum "T" no caminho, você ganha um tempinho extra.
#
# Autor: Xerxes Lins (xerxeslins@gmail.com)
#		 www.vivaolinux.com.br/~xerxeslins

function _cria_mapa {
	for i in {0..9}  #linhas
	do
		for j in {0..14} #colunas
		do
		SORT=$(( ( RANDOM % 2 ) ))
		if [ $SORT -eq 0 ]
		then
			TILE="#"
		else
			TILE="."
		fi
		if [ $j = 0 ] || [ $i = 0 ] || [ $j = 14 ] || [ $i = 9 ]
		then
			TILE="x"
		fi
		eval LINHA$i[$j]=$TILE
		done
	done
}

function _nasce_personagem {
	x=1
	y=$(( ( RANDOM % 8 ) + 1 ))
	eval LINHA$y[$x]="@"
	TEMPO=20
}
function _tempo_extra {
	x=$(( ( RANDOM % 12 ) + 1 ))
	y=$(( ( RANDOM % 8 ) + 1 ))
	eval LINHA$y[$x]="T"
	TEMPO=20
}
function _saida {
	xs=14
	ys=$(( ( RANDOM % 8 ) + 1 ))
	eval LINHA$ys[$xs]="S"
}

function _desenha_mapa {
	clear
	echo "Tempo restante: $TEMPO"
	echo ""
	echo "$MSG"
	echo ""
	for i in {0..9}
	do
		VAR=$(eval echo LINHA$i[@])
		echo -ne "${!VAR}\n"
	done
}
function _pick_crock {
	SORT=$(( ( RANDOM % 5 ) ))
	if [[ $SORT -le 0 ]]
	then 
		echo 0
	else
		echo 1
	fi	
}
function _sorteia_pedra {
	SORT=$(( ( RANDOM % 10 ) ))
	if [[ $SORT -le 0 ]]
	then 
		SURPRESA="T"
	else
		SURPRESA="."
	fi	
}
function _desmorona {
	for i in {0..9}
	do
		for j in {0..14}
		do
		eval LINHA$i[$j]="#"
		done
	done
}
function _gameover {
	_desmorona
	MSG="MORREU SOTERRADO!"
	_desenha_mapa
	sleep 2
	tput cnorm
	exit
}
function _vitoria {
	MSG="VOCÊ CONSEGUIU!"
	_desenha_mapa
	exit
}

function _play {

while [ "$INPUT" != "x" ]
do

	if [ $TEMPO -lt 0 ]
	then
	TEMPO=0
	_gameover
	fi
	
	TEMPO=$(( $TEMPO - 1))
	MSG=""
	read  -n1 -s INPUT
	if [ $INPUT = a ]
	then
		VAR=$(eval echo LINHA$y[$(( $x - 1 ))])
		if [ "${!VAR}" = "." ]
		then
			eval LINHA$y[$x]="."
			x=$(( $x - 1 ))
			y=$y
			eval LINHA$y[$x]="@"
		elif [ "${!VAR}" = "#" ]
		then
			if [ $(_pick_crock) = 0 ]
			then
				_sorteia_pedra
				eval LINHA$y[$x - 1]="$SURPRESA"
				MSG="Crock!"
				_desenha_mapa
			else
				MSG="Pick!"
				_desenha_mapa
			fi
		elif [ "${!VAR}" = "S" ]
			then
			eval LINHA$y[$x]="."
			x=$(( $x - 1 ))
			y=$y
			eval LINHA$y[$x]="@"
			_desenha_mapa
			_vitoria
		elif [ "${!VAR}" = "T" ]
			then
			eval LINHA$y[$x]="."
			x=$(( $x - 1 ))
			y=$y
			eval LINHA$y[$x]="@"
			TEMPO=$(( $TEMPO + 5 ))
			MSG="Tempo +5"
			_desenha_mapa
			
		fi
	fi
	if [ $INPUT = d ]
	then
		VAR=$(eval echo LINHA$y[$(( $x + 1 ))])
		if [ "${!VAR}" = "." ]
		then
			eval LINHA$y[$x]="."
			x=$(( $x + 1 ))
			y=$y
			eval LINHA$y[$x]="@"
			elif [ "${!VAR}" = "#" ]
		then
			if [ $(_pick_crock) = 0 ]
			then
				_sorteia_pedra
				eval LINHA$y[$x + 1]="$SURPRESA"
				MSG="Crock!"
				_desenha_mapa
			else
				MSG="Pick!"
				_desenha_mapa
			fi
		elif [ "${!VAR}" = "S" ]
			then
			eval LINHA$y[$x]="."
			x=$(( $x + 1 ))
			y=$y
			eval LINHA$y[$x]="@"
			_desenha_mapa
			_vitoria
		elif [ "${!VAR}" = "T" ]
			then
			eval LINHA$y[$x]="."
			x=$(( $x + 1 ))
			y=$y
			eval LINHA$y[$x]="@"
			TEMPO=$(( $TEMPO + 5 ))
			MSG="Tempo +5"
			_desenha_mapa
			
		fi
	fi
	if [ $INPUT = w ]
	then
		VAR=$(eval echo LINHA$(( $y - 1))[$x])
		if [ "${!VAR}" = "." ]
		then
			eval LINHA$y[$x]="."
			x=$x
			y=$(( $y - 1 ))
			eval LINHA$y[$x]="@"
			elif [ "${!VAR}" = "#" ]
		then
			if [ $(_pick_crock) = 0 ]
			then
				_sorteia_pedra
				eval LINHA$(( $y - 1))[$x]="$SURPRESA"
				MSG="Crock!"
				_desenha_mapa
			else
				MSG="Pick!"
				_desenha_mapa
			fi
		elif [ "${!VAR}" = "S" ]
			then
			eval LINHA$y[$x]="."
			x=$x
			y=$(( $y - 1 ))
			eval LINHA$y[$x]="@"
			_desenha_mapa
			_vitoria
		elif [ "${!VAR}" = "T" ]
			then
			eval LINHA$y[$x]="."
			x=$x
			y=$(( $y - 1 ))
			eval LINHA$y[$x]="@"
			TEMPO=$(( $TEMPO + 5 ))
			MSG="Tempo +5"
			_desenha_mapa
			
		fi
	fi
	if [ $INPUT = s ]
	then
		VAR=$(eval echo LINHA$(( $y + 1))[$x])
		if [ "${!VAR}" = "." ]
		then
			eval LINHA$y[$x]="."
			x=$x
			y=$(( $y + 1 ))
			eval LINHA$y[$x]="@"
			elif [ "${!VAR}" = "#" ]
		then
			if [ $(_pick_crock) = 0 ]
			then
				_sorteia_pedra
				eval LINHA$(( $y + 1))[$x]="$SURPRESA"
				MSG="Crock!"
				_desenha_mapa
			else
				MSG="Pick!"
				_desenha_mapa
			fi
		elif [ "${!VAR}" = "S" ]
			then
			eval LINHA$y[$x]="."
			x=$x
			y=$(( $y + 1 ))
			eval LINHA$y[$x]="@"
			_desenha_mapa
			_vitoria

		elif [ "${!VAR}" = "T" ]
			then
			eval LINHA$y[$x]="."
			x=$x
			y=$(( $y + 1 ))
			eval LINHA$y[$x]="@"
			TEMPO=$(( $TEMPO + 5 ))
			MSG="Tempo +5"
			_desenha_mapa

		fi
	fi
	clear
	_desenha_mapa
done
}
tput civis
_cria_mapa
for i in {1..3}
do
	_tempo_extra
done
_nasce_personagem
_saida
MSG="Mova o @ até a saída (S) usando A D W S"
_desenha_mapa
_play
