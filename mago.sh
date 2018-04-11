 #!/bin/bash
#
# magos.sh - Card Game simples em modo texto
#
# Autor	: Xerxes Lins (xerxeslins@gmail.com)
# Site	: vivaolinux.com.br/~xerxeslins
#
# -----------------------------------------------
#
# Este script foi criado quando resolvi testar arrays no bash.
# Acabou se tornando um passa-tempo simples e casual.
# 
# Cada jogador tem um baralho infinito. Cada carta representa
# uma magia ou um tipo de poção. O objetivo é reduzir os pontos
# de vida do oponente à 0 (zero) usando as cartas.
#
# Torne o script executável:
#
# $ chmod +x magos.sh
#
# Execute com:
#
# ./magos.sh
#
# Histórico:
#
# v1.0b 15-07-2016 - versão inicial ainda não foi exaustivamente testado
#
# Licença: GPL
#

function _opcao_invalida {
	clear
	echo "Opção inválida!"
	sleep 1
	clear
	_reload $1
}

function _reload {
	$1
}

function _PQTPC {
	echo "Obs.: pressione qualquer tecla para continuar"
	read -srn1
	$1
}

function _baralho {
	CARTAS=("Raio" "Bola de Fogo" "Cristal de Gelo" "Poção vermelha" "Poção azul" "Escudo de Luz" "Névoa Venenosa" "Explosão Arcana" "Cegueira" "Seta Arcana") 
}

function _sem_mana {
	if [ $PM -lt $1 ]
	then
		echo "Você não tem mana suficiente!

Precisa pelo menos de $1PM para isso.
		"
		sleep 1
		_PQTPC $2
	fi	
}

function _desc_cartas {
	clear
	echo "Descrição de cada carta:

-Raio (comum), dano 10, custo 3
-Bola de Fogo (comum), dano 15, custo 5
-Cristal de Gelo (comum), congela, custo 1
-Poção Vermelha (comum), aumenta 12 pontos de vida
-Poção Azul (comum), aumenta 5 pontos de mana
-Escudo de Luz (rara), protege, custo 1
-Névoa Venenosa (rara), envenena, custo 4
-Explosão Arcana (rara), dano 20 em todos, custo 10
-Cegueira (rara), cega, custo 2
-Seta Arcana (rara), dano 40, custo 20
"	

_PQTPC _usar_carta
}

function _sorteio_cartas {
	CONT=$2
	while [ $CONT -le $1 ]
	do
	CHANCE=$(( ( RANDOM % 100 ) +1 ))
	if [ $CHANCE -le 5 ]
	then
	CARD[$CONT]=${CARTAS[9]}
	elif [ $CHANCE -le 10 ]
		then
			CARD[$CONT]=${CARTAS[8]}
	elif [ $CHANCE -le 15 ]
		then
			CARD[$CONT]=${CARTAS[7]}
	elif [ $CHANCE -le 20 ]
		then
			CARD[$CONT]=${CARTAS[6]}
	elif [ $CHANCE -le 25 ]
		then
			CARD[$CONT]=${CARTAS[5]}
	elif [ $CHANCE -le 40 ]
		then
			CARD[$CONT]=${CARTAS[4]}
	elif [ $CHANCE -le 55 ]
		then
			CARD[$CONT]=${CARTAS[3]}
	elif [ $CHANCE -le 70 ]
		then		
			CARD[$CONT]=${CARTAS[2]}
	elif [ $CHANCE -le 85 ]
		then
			CARD[$CONT]=${CARTAS[1]}
	elif [ $CHANCE -le 100 ]
		then
		CARD[$CONT]=${CARTAS[0]}
	fi
	CONT=$(( $CONT + 1))
	done
}

function _dificuldade {
	clear
	echo "DUELO DAS CARTAS MÁGICAS
	
1 - Sou noob (︶ω︶)
2 - Eu me garanto! ლ(▀̿̿Ĺ̯̿̿▀̿ლ)
"
read -srn1 OPT
	clear
	case $OPT in
	1) DIFICULDADE=4 ;;
	2) DIFICULDADE=0 ;;
	*) _opcao_invalida _dificuldade ;;
	esac
}

function _puxar_carta {
	clear
	if [ "$PUXOU" = "sim" ]
	then
		echo "Você já puxou neste turno!
		"
	elif [ ${#CARD[@]} -lt 5 ]
	then
		echo "Puxando uma carta..."
		PUXOU="sim"
		VAZIO=${#CARD[@]}
		_sorteio_cartas $VAZIO $VAZIO
		sleep 1
		echo "
Você puxou ${CARD[$VAZIO]}
"
	else
		echo "Desculpe!
		
Sua mão já está cheia.
"
	fi
	sleep 2
	_painel
}

function _testa_empate {
	if [ $PV -le 0 ] && [ $PV_INI -le 0 ]
	then
	echo "
	Vocês dois morreram!!! (+__+) (+__+)
	
	FIM DE JOGO
	
"
	exit
	fi
}

function _testa_morte {
	if [ $PV -le 0 ]
	then
	echo "
Você morreu!!! (+__+)
		
FIM DE JOGO

"
	exit
	fi
}

function _testa_morte_ini {
	if [ $PV_INI -le 0 ]
	then
	echo "
Parabéns! Você derrotou o oponente! (*•̀ᴗ•́*)و ̑̑
		
FIM DE JOGO
"
	exit
	fi	
}

function _efeito_carta {
	clear
	INFO=$*
	echo "Você escolheu $*...
	"
	sleep 1
	if [[ $INFO = ${CARTAS[0]} ]]
	then
		_sem_mana 3 _usar_carta
		PM=$(( $PM - 3 ))
		DANO=10
		if [ "$ARMOR_INI" = "1" ]
		then
			DANO=3
			ARMOR_INI="0"
			echo "Você destruiu a proteção do oponente!
			"
			sleep 2
		fi
		echo "Você causou $DANO pontos de dano!
		"
		PV_INI=$(( $PV_INI - $DANO ))
		_testa_morte_ini
	elif [[ $INFO = ${CARTAS[1]} ]]
	then
		_sem_mana 5 _usar_carta
		PM=$(( $PM - 5 ))
		DANO=15
		if [ "$ARMOR_INI" = "1" ]
		then
			DANO=8
			ARMOR_INI="0"
			echo "Você destruiu a proteção do oponente!
			"
			sleep 2
		fi
		echo "Você causou $DANO pontos de dano!
		"
		PV_INI=$(( $PV_INI - $DANO ))
		_testa_morte_ini
	elif [[ $INFO = ${CARTAS[2]} ]]
	then
		_sem_mana 1 _usar_carta
		PM=$(( $PM - 1 ))
		if [ "$ARMOR_INI" = "1" ]
		then
			echo "Você destruiu a proteção do oponente!
			"
			sleep 2
			ARMOR_INI="0"
		else
			echo "Você congelou o oponente!
			"
			CONGELA_INI="1"
		fi
	elif [[ $INFO = ${CARTAS[3]} ]]
	then
		PV=$(( $PV + 12 ))
		echo "Você ganhou 12 pontos de vida!
		"
		if [ $PV -gt 40 ]
		then
			PV=40
		fi
	elif [[ $INFO = ${CARTAS[4]} ]]
	then
		PM=$(( $PM + 5 ))
		echo "Você ganhou 5 pontos de mana!
		"
		if [ $PM -gt 40 ]
		then
			PM=40
		fi
	elif [[ $INFO = ${CARTAS[5]} ]]
	then
		_sem_mana 1 _usar_carta
		PM=$(( $PM - 1 ))
		ARMOR="1"
		echo "Você está protegido!
		"
	elif [[ $INFO = ${CARTAS[6]} ]]
	then
		_sem_mana 4 _usar_carta
		PM=$(( $PM - 4 ))
		GAS_INI="1"
		echo "Você envenenou o oponente!
		"
	elif [[ $INFO = ${CARTAS[7]} ]]
	then
		_sem_mana 10 _usar_carta
		PM=$(( $PM - 10 ))
		echo "（（（（（（BOOOMMM））））））

A explosão atingiu a todos!
"
		sleep 2
		DANO=20
		DANO_INI=20
		if [ "$ARMOR_INI" = "1" ]
		then
			DANO_INI=13
			ARMOR_INI="0"
			echo "Você destruiu a proteção do oponente!
			"
			sleep 2
		fi
		PV_INI=$(( $PV_INI - $DANO_INI ))
		echo "Você causou $DANO_INI pontos de dano!
			"
		if [ "$ARMOR" = "1" ]
		then
			DANO=13
			ARMOR="0"
			echo "Você destruiu sua própria proteção!
			"
			sleep 2
		fi
		PV=$(( $PV - $DANO ))
		echo "Você sofreu $DANO pontos de dano!
		"
		sleep 2
		_testa_empate
		_testa_morte_ini
		_testa_morte
		
	elif [[ $INFO = ${CARTAS[8]} ]]
	then
		_sem_mana 2 _usar_carta
		PM=$(( $PM - 2 ))
		CEGO_INI="1"
		echo "Você envolveu o oponente com uma densa escuridão!
		"
	elif [[ $INFO = ${CARTAS[9]} ]]
	then
		_sem_mana 20 _usar_carta
		PM=$(( $PM - 20 ))
		#clear
		DANO=40
		if [ "$ARMOR_INI" = "1" ]
		then
			DANO=33
			ARMOR_INI="0"
			echo "Você destruiu a proteção do oponente!
			"
		fi
		echo "Você causou $DANO pontos de dano!
		"
		PV_INI=$(( $PV_INI - $DANO ))
		_testa_morte_ini
	fi
	
	#Remove a carta da mão
	unset CARD[$ESCOLHIDA]
	CARD=("${CARD[@]}")
	COUNT=$(( $COUNT + 1 ))
	sleep 2
	_PQTPC _painel
}

function _usar_carta {
		clear
		echo "Escolha uma carta para usar:
		"
		CONT=1
		for i in "${CARD[@]}"
		do
		if [ $CEGO = "0" ]
		then
			echo "$CONT - $i"
		else
			echo "$CONT - [NÃO CONSEGUE VER]"
		fi
		CONT=$(( $CONT + 1 ))
		done
		echo "
v - Voltar
d - Descrição das cartas
"
		read -srn1 OPT
		case $OPT in
		v|V) _painel ;;
		d|D) _desc_cartas ;;
		esac
		#Testa se é número e se está dentro do intervalo da mão
		EHNUMERO='^[0-9]+$'
		if [[ $OPT =~ $EHNUMERO ]] && [[ $OPT -le ${#CARD[@]} ]]
		then
			if [ $COUNT -gt 1 ]
			then
				clear
				echo "Você já usou duas cartas neste turno!
				"
				sleep 1
				_PQTPC _painel
			fi
			if [ $CEGO = "1" ]
			then
				ESCOLHIDA=$(( RANDOM % ${#CARD[@]} ))
			else
				ESCOLHIDA=$(( $OPT - 1 ))
			fi
			_efeito_carta ${CARD[$ESCOLHIDA]}
		else
			_opcao_invalida _usar_carta
		fi
}

function _encerrar {
	MANA_BONUS=$(( 2 - $COUNT ))
	if [ $PUXOU = "não" ]
	then
		MANA_BONUS=$(( $MANA_BONUS + 2 ))
	fi
	clear
	echo "Você encerrou a sua vez.

Mana bônus +$MANA_BONUS
"
	PM=$(( $PM + $MANA_BONUS ))
	if [ $PM -gt 40 ]
		then
			PM=40
	fi
	PUXOU="não"
	VEZ="pc"
	sleep 2
	_turno
}

function _status {
	SNORMAL=""
	SCONGELA=""
	SCEGO=""
	SGAS=""
	SARMOR=""
	if [ $CEGO = "0" ] && [ $GAS = "0" ] && [ $ARMOR = "0" ] && [ $CONGELA = "0" ]
	then
		SNORMAL="normal"
	fi
	if [ $CONGELA = "1" ]
	then
		SCONGELA="congelado"
	fi
	if [ $CEGO = "1" ]
	then
		SCEGO="cego "
	fi
	if [ $GAS = "1" ]
	then
		SGAS="envenenado "
	fi
	if [ $ARMOR = "1" ]
	then
		SARMOR="protegido "
	fi	
	STATUS="$SNORMAL$SCEGO$SGAS$SARMOR$SCONGELA"
	SNORMAL_INI=""
	SCONGELA_INI=""
	SCEGO_INI=""
	SGAS_INI=""
	SARMOR_INI=""
	if [ $CEGO_INI = "0" ] && [ $GAS_INI = "0" ] && [ $ARMOR_INI = "0" ] && [ $CONGELA_INI = "0" ]
	then
		SNORMAL_INI="normal"
	fi
	if [ $CONGELA_INI = "1" ]
	then
		SCONGELA_INI="congelado"
	fi
	
	if [ $CEGO_INI = "1" ]
	then
		SCEGO_INI="cego "
	fi
	if [ $GAS_INI = "1" ]
	then
		SGAS_INI="envenenado "
	fi
	if [ $ARMOR_INI = "1" ]
	
	then
		SARMOR_INI="protegido "
	fi
	STATUS_INI="$SNORMAL_INI$SCEGO_INI$SGAS_INI$SARMOR_INI$SCONGELA_INI"
}

function _barrinha {	
	CHEIO=""
	VAZIO=""
	i=1
	while [ $i -le $1 ]
	do
	CHEIO=$CHEIO▓
	i=$(( $i + 1 ))
	done
	i=$2
	while [ $i -gt $1 ]
	do
	VAZIO=$VAZIO░
	i=$(( $i - 1 ))
	done
	echo "$CHEIO$VAZIO"
}
─
function _barrinha2 {	
	CHEIO=""
	VAZIO=""
	i=1
	while [ $i -le $1 ]
	do
	CHEIO=$CHEIO═
	i=$(( $i + 1 ))
	done
	i=$2
	while [ $i -gt $1 ]
	do
	VAZIO=$VAZIO" "
	i=$(( $i - 1 ))
	done
	echo "$CHEIO$VAZIO"
}

function _painel {	
	_status
	clear
	echo "Turno #$TURNO"
LIFEBAR_INI=$(_barrinha $PV_INI 40)
MANABAR_INI=$(_barrinha2 $PM_INI 40)
LIFEBAR=$(_barrinha $PV 40)
MANABAR=$(_barrinha2 $PM 40)
_distribuicao $CARTAS_INI storage
PAINEL_CARTAS_INI=$NA_MAO
_distribuicao ${#CARD[@]} storage
PAINEL_CARTAS=$NA_MAO

echo "
Oponente : $STATUS_INI $AJUDASTATUS_INI
$LIFEBAR_INI $PV_INI $AJUDAVIDA_INI
$MANABAR_INI $PM_INI $AJUDAMANA_INI
$PAINEL_CARTAS_INI $AJUDACARTAS_INI

Você : $STATUS $AJUDASTATUS
$LIFEBAR $PV $AJUDAVIDA
$MANABAR $PM $AJUDAMANA
$PAINEL_CARTAS $AJUDACARTAS


1 - Puxar uma carta do baralho
2 - Ver/Usar cartas
3 - Encerrar

a - $AJ Ajuda"
	read -srn1 OPT
	case $OPT in
	1) _puxar_carta ;;
	2) _usar_carta ;;
	3) _encerrar ;;
	a) _ajuda ;;
	*) _opcao_invalida _painel
	esac
}

function _vez_jogador {
	CEGO_INI="0"
	COUNT_INI=0
	PUXOU_INI="não"
	clear
	echo "Sua vez!
	"
	sleep 2
	if [ $GAS = "1" ] && [ $GASOSO = "0" ]
	then
		GASOSO="1"
		PV=$(( $PV - 3))
		echo "Vida -3 (envenenado)
		"
		sleep 2
		_testa_morte
	fi
	if [ $CONGELA = "1" ]
	then
		echo "Não pode agir! (congelado)
		"
		sleep 2
		CONGELA="0"
		VEZ="pc"
		_turno
	fi
	if [ $CEGO = "1" ]
	then
		echo "Suas cartas foram viradas e embaralhadas! (cego)
		"
		sleep 4
	fi
	_painel
}

function _usar_carta_ini {
	sleep 2
	CHANCE=$(( ( RANDOM % 100 ) +1 ))
	if [ $CHANCE -le 5 ] && [ $PM_INI -ge 20 ]
	then
		echo "Usou ${CARTAS[9]}!
		"
		sleep 2
		PM_INI=$(( $PM_INI - 20 ))
		DANO=40
		if [ "$ARMOR" = "1" ]
		then
			DANO=33
			ARMOR="0"
			echo "Oponente destruiu sua proteção!
			"
			sleep 2
		fi
		PV=$(( $PV - $DANO ))
		echo "Você sofreu $DANO pontos de dano!
		"
		sleep 2
		_testa_morte
	elif [ $CHANCE -le 10 ] && [ $PM_INI -ge 2 ]
		then
		echo "Usou ${CARTAS[8]}!
		"
		sleep 2
		CEGO="1"
		PM_INI=$(( $PM_INI - 2 ))
		echo "Você foi envolvido por uma densa escuridão!
		"
		sleep 2
	elif [ $CHANCE -le 15 ] && [ $PM_INI -gt 13 ] && [ $PV_INI -ge $PV ]
		then
		PM_INI=$(( $PM_INI - 10 ))
		echo "Usou ${CARTAS[7]}!
		"
		sleep 2
		echo "（（（（（（BOOOMMM））））））
			
A explosão atingiu a todos!
"
		sleep 2	
		DANO=20
		DANO_INI=20
		if [ $ARMOR = "1" ]
		then
			DANO=13
			ARMOR="0"
			echo "Oponente destruiu sua proteção!
			"
			sleep 2
		fi
		PV=$(( $PV - $DANO ))
		echo "Você sofreu $DANO pontos de dano!
		"
		sleep 2
		if [ $ARMOR_INI = "1" ]
		then
			DANO_INI=13
			ARMOR_INI="0"
			sleep 2
			echo "Oponente destrui a própria proteção!
			"
			sleep 2
		fi
		PV_INI=$(( $PV_INI - $DANO_INI ))
		echo "Oponente sofreu $DANO_INI pontos de dano!
		"
		sleep 2
		_testa_morte
	elif [ $CHANCE -le 20 ] && [ $GAS = "0" ]
		then
		echo "Usou ${CARTAS[6]}!
		"
		sleep 2
		GAS="1"
		echo "Você foi envenenado!
		"
		sleep 2
	elif [ $CHANCE -le 25 ] && [ $ARMOR_INI = "0" ] && [ $PM_INI -ge 2 ]
		then
		echo "Usou ${CARTAS[5]}!
		"
		sleep 2
		ARMOR_INI="1"
		PM_INI=$(( $PM_INI - 2 ))
		echo "Oponente está protegido!
		"
		sleep 2
	elif [ $CHANCE -le 40 ] && [ $PM_INI -lt 26 ]
		then
		echo "Usou ${CARTAS[4]}!
		"
		sleep 2
		PM_INI=$(( $PM_INI + 5 ))
		echo "Oponente ganhou 5 pontos de mana!
		"
		if [ $PM_INI -gt 40 ]
		then
			PM_INI=40
		fi
		sleep 2
	elif [ $CHANCE -le 55 ] && [ $PV_INI -lt 33 ]
		then
		echo "Usou ${CARTAS[3]}!
		"
		sleep 2
		PV_INI=$(( $PV_INI + 12 ))
		echo "Oponente ganhou 12 pontos de vida!
		"
		if [ $PV_INI -gt 40 ]
		then
			PV_INI=40
		fi
		sleep 2
	elif [ $CHANCE -le 70 ] && [ $PM_INI -le 5 ] && [ $CONGELA = "0" ]
		then
		PM_INI=$(( $PM_INI - 5 )) 
		echo "Usou ${CARTAS[2]}!
		"
		sleep 2
		if [ "$ARMOR" = "1" ]
		then
			ARMOR="0"
			echo "Oponente destruiu sua proteção!
			"
			sleep 2
		else
			CONGELA="1"
			echo "Você está congelado!
			"
			sleep 2
		fi
	elif [ $CHANCE -le 85 ] && [ $PM_INI -ge 5 ]
		then
		PM_INI=$(( $PM_INI - 5 ))
		echo "Usou ${CARTAS[1]}!
		"
		sleep 2
		DANO=15
		if [ "$ARMOR" = "1" ]
		then
			DANO=8
			ARMOR="0"
			echo "Oponente destruiu sua proteção!
			"
			sleep 2
		fi
		echo "Você sofreu $DANO pontos de dano!
		"
		sleep 2
		PV=$(( $PV - $DANO ))
		sleep 2
		_testa_morte
	elif [ $CHANCE -le 100 ] && [ $PM_INI -ge 3 ]
		then
		PM_INI=$(( $PM_INI - 3 ))
		echo "Usou ${CARTAS[0]}!
		"
		sleep 2
		DANO=10
		if [ "$ARMOR" = "1" ]
		then
			DANO=3
			ARMOR="0"
			echo "Oponente destruiu sua proteção!
			"
			sleep 2
		fi
		PV=$(( $PV - $DANO ))
		echo "Você sofreu $DANO pontos de dano!
		"
		sleep 2
		_testa_morte
	
	else
		echo "Em dúvida... (¯―¯٥)
"
		sleep 2
		_IA
	fi
	echo "Pensando... ( ﾟｰﾟ) º0
	"
	sleep 2
	COUNT_INI=$(( $COUNT_INI + 1 ))
	CARTAS_INI=$(( $CARTAS_INI - 1))
	_IA
}

function _encerra_ini {
	MANA_BONUS=$(( 2 - COUNT_INI ))
	if [ $PUXOU_INI = "não" ]
	then
		MANA_BONUS=$(( $MANA_BONUS + 2 ))
	fi
	echo "Oponente encerrou!

Mana bônus +$MANA_BONUS
	"
	sleep 2
	PM_INI=$(( $PM_INI + MANA_BONUS ))
	if [ $PM_INI -gt 40 ]
		then
			PM=40
	fi
	_PQTPC _vez_jogador
}

function _IA {
	if [ $CARTAS_INI -lt 5 ] && [ $PUXOU_INI = "não" ]
	then
		CARTAS_INI=$(( $CARTAS_INI + 1 ))
		PUXOU_INI="sim"
		echo "Oponente puxou uma carta!
		"
	fi
    DECISION=$(( RANDOM % 10 ))
    if [ $DECISION -le $DIFICULDADE ] || [ $COUNT_INI -gt 1 ] || [ $CARTAS_INI -eq 0 ]
    then
		_encerra_ini
	else
		_usar_carta_ini
	fi
}

function _vez_pc {
	CEGO="0"
	GASOSO="0"
	COUNT=0
	clear
	echo "Vez do oponente!
	"
	sleep 1
	if [ $GAS_INI = "1" ]
	then
		PV_INI=$(( $PV_INI - 3))
		echo "Vida -3 (envenenado)
		"
		sleep 2
		_testa_morte_ini
	fi
	
	if [ $CONGELA_INI = "1" ]
	then
		echo "Não pode agir! (congelado)
		"
		sleep 2
		CONGELA_INI="0"
		VEZ="jogador"
		_turno
	fi
	if [ $CEGO_INI = "1" ]
	then
		echo "O oponente não consegue escolher bem as cartas! (cego)
		"
		sleep 2
	fi	
	_IA
}

function _distribuicao {
	unset NA_MAO
	i=1
	while [ $i -le $1 ]
	do
	if [ $2 = "show" ]
	then
		echo -ne " 🃏 "
		sleep 0.3
	elif [ $2 = "storage" ]
	then
		NA_MAO="$NA_MAO 🃏 "
	fi
	i=$(( $i + 1 ))
	done	
}

function _ajuda {
	if [ $AJ = "(✔)" ]
	then
	AJ="( )"
	unset AJUDATURNO
	unset AJUDAVIDA
	unset AJUDAMANA
	unset AJUDACARTAS
	unset AJUDASTATUS
	unset AJUDAVIDA_INI
	unset AJUDAMANA_INI
	unset AJUDACARTAS_INI
	unset AJUDASTATUS_INI
	else
	AJ="(✔)"
	AJUDATURNO="← contador de turnos"
	AJUDAVIDA="← sua vida"
	AJUDAMANA="← seu mana"
	AJUDACARTAS="← suas cartas"
	AJUDASTATUS="← seu status"	
	AJUDAVIDA_INI="← vida do oponente"
	AJUDAMANA_INI="← mana do oponente"
	AJUDACARTAS_INI="← cartas do oponente"
	AJUDASTATUS_INI="← status do oponente"
	fi
	_painel
}

function _turno {	
	TURNO=$(( $TURNO + 1 ))
	if [ $TURNO -eq 1 ]
	then	
	clear
	echo "Distribuindo cartas aleatoriamente...
	"
	sleep 2
	_sorteio_cartas 4 0 #cartas de 0 a 4 iniciando pelo contador 0
	CARTAS_INI=5
	echo "Para você:
	"
	sleep 1
	_distribuicao ${#CARD[@]} show
	echo "
	"
	sleep 1
	echo "Para o oponente:
	"
	sleep 1
	_distribuicao $CARTAS_INI show
	sleep 2
	echo "
	"
	echo "Que vença o melhor! ƪ(˘⌣˘)ʃ"
	sleep 2
	fi	
	if [ $VEZ = "jogador" ]
	then
		_vez_jogador
	elif [ $VEZ = "pc" ]
	then
		_vez_pc
	fi	
}

function _iniciativa {
	clear
	echo "Iniciativa:

o → Pedra       s → Papel       x → Tesoura
"
	read -srn1 OPT
	clear
	case $OPT in
	"o"|"O") OPT="Pedra" && WIN="Tesoura" && LOSE="Papel" ;;
	"s"|"S") OPT="Papel" && WIN="Pedra" && LOSE="Tesoura" ;;
	"x"|"X") OPT="Tesoura" && WIN="Papel" && LOSE="Pedra" ;;
	"v"|"V") OPT="TRAPACEOU" ;; #SECRET 
	*) _opcao_invalida _iniciativa ;;
	esac
	echo "Jan"
	sleep 1
	echo "ken"
	sleep 1
	echo "PO!!!"
	sleep 2
	clear
	PPT=$(( ( RANDOM % 3 ) + 1 ))
	if [ $OPT = "TRAPACEOU" ]
	then
		PPT=1
	fi
	if [ $PPT -eq 1 ]
	then
	echo "(Você) $OPT VS $WIN (Oponente)
	"
	sleep 2
	echo "A iniciativa é sua! ٩(^ᴗ^)۶
	"
	VEZ="jogador"
	sleep 2
	elif [ $PPT -eq 2 ]
	then 
	echo "(você) $OPT VS $OPT (Oponente)
	"
	sleep 1
	echo "Empatou! Jogue novamente.
	"
	sleep 1
	_PQTPC _iniciativa
	else
	echo "(você) $OPT VS $LOSE (Oponente)
	"
	sleep 1
	echo "Você perdeu! O oponente tem a iniciativa.. (╥_╥)
	"
	VEZ="pc"
	sleep 2
	fi
	TURNO=0
	PV=40
	PM=10
	PV_INI=40
	PM_INI=10
	ARMOR="0"
	ARMOR_INI="0"
	CONGELA="0"
	CONGELA_INI="0"
	GAS="0"
	GAS_INI="0"
	PUXOU="não"
	PUXOU_INI="não"
	COUNT_INI=0
	COUNT=0
	CEGO="0"
	CEGO_INI="0"
	_PQTPC _turno
}
#cria baralho
_baralho
#_vez_jogador
#dificuldade
_dificuldade
#jan-ken-po
_iniciativa

