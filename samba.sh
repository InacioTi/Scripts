#!/bin/bash
Ver="\033[0;31m"
Verd="\033[0;32m"
Branco="\033[0;37m"
Azul="\033[0;34m"
Ciano="\033[0;36m"
echo "1 - Verficar ou instalar Samba."
echo "2 - Ir direto para opções de Samba!"
read ESC2
case $ESC2 in
1)
printf "\t=========================================================\n"
printf "\t|Iremos verficar se todos os softwares estão instalados!|\n"
printf "\t=========================================================\n"
sleep 1.5
VAR=$(dpkg -l | grep samba | cut -c -2)
if [ $VAR = "ii" ]
then
	printf "\tServidor Samba instalado com sucesso\n"
else
	apt-get update
	apt-get install samba samba-doc smbclient
	if [ $? = "0" ]
		then
			printf "\t$Verd Servidor Samba está instalado com sucesso!!\n"
		else
			printf "\t$Ver O servidor Samba não foi instalado corretamente, repita o processo!\n"
			exit
		fi
fi
printf "\t$Verd Preparando as configurações para criar o domínio do Samba!\n"
printf "\t Iremos habilitar a opção de ACLs e compartilhamento de pastas pela rede.\n"
rm /etc/samba/smb.conf
sleep 1.5
printf "\t====================================================\n"
printf "\t$Ver|            Responda as perguntas                 |\n"
printf "\t|     Em Realm, coloque o nome de seu domíno Samba!|\n"   
printf "\t|Na parte da senha, coloque uma senha dificil, com |\n"
printf "\t|números e caracteres especiais e letras maiusculas|\n"
printf "\t$Verd====================================================\n"
/usr/bin/samba-tool domain provision --use-rfc2307 --use-xattrs=yes --interactive
printf "\t$Verd Perfeito, seu Samba já foi montado!\n"
printf "\tAgora vamos configurar seu nome de domínio\n"
printf "\tDigite o nome de seu dominio: "
read DOM
IP=$(hostname -I)
echo "domain $DOM" > /etc/resolv.conf
echo "nameserver $IP" >> /etc/resolv.conf
printf "\tEsses dados serão salvos no arquivo /etc/resolv.conf\n"
printf "\n\n"
/etc/init.d/samba restart
sleep 1.5
printf "\t$Ver===========\n"
printf "\t$Ver| Testes! |\n"
printf "\t$Ver===========\n"
printf "\n\n"
host -t SRV _ldap._tcp.$DOM
printf "\tApareceu algo como record 0 100 389? Se os números forem diferentes não importa!\n"
printf "\tO que importa é que está funcionado! Iremos PINGAR seu domínio agora.\n"
echo ""
ping -c 4 $DOM
printf "\tSe ouve resposta no ping, é por que está tudo certo, que você poderá continuar a configuração.\n"
echo ""
printf "\tIremos testar seu Kerberos e a porta de seu Host agora.\n"
NAME=$(hostname)
host -t SRV _kerberos._udp.$DOM
host -t A $NAME.$DOM
printf "\n\n"
printf "\t$Verd Seu Samba Server está funcionando corretamente.\n"
;;
2)
;;
esac
NUMB=x
while [ $NUMB != "0" ]
do
	echo ""
	printf "\t====================================\n"
	printf "\t|Escolha uma das opções da tabela: |\n"
	printf "\t====================================\n"
	echo "1 - Criar um usuário."
	echo "2 - Criar um grupo."
	echo "3 - Adicionar membros a um grupo."
	echo "4 - Remover membros de um grupo."
	echo "5 - Listar todos os grupos do Samba."
	echo "6 - Listar todos os usuários de um grupo específico."
	echo "7 - Listar todos os usuários do Samba"
	echo "8 - Colocar tempo para expirar a senha de um usuário."
	echo "9 - Apontar usuário que senhas não expiram."
	echo "10 - Help me!, Como administrar o samba pelo Windows!."
	echo "11 - Etapas para preparar um HD para ser compartilhado (Importante)."
	echo "12 - Compartilhar pasta"
	echo "0 - Sair do script."
	read ESC
		case $ESC in
	1)
		printf "\tDigite o nome do usuário: "
		read NOME
		printf "\tEscolha uma senha para o usuário, pelo padrões do Samba: "
		read SEN
		/usr/bin/samba-tool user add $NOME $SEN
		/usr/bin/samba-tool user enable $NOME
		printf "\tUsuário $NOME criado e ativado\n"
	;;
	2)
		printf "\tDigite o nome do grupo: "
		read GRU
		/usr/bin/samba-tool group add $GRU
		printf "\tGrupo $GRU criado!\n"
	;;
	3)
		printf "\t================================================\n"
		printf "\t| Para adicionar mais de um membro a um grupo  |\n"
		printf "\t|Basta colocar os nomes separados por virgulas.|\n"
		printf "\t================================================\n"
		echo ""
		printf "\tDigite o(s) nome(s) do(s) usuario(s): "
		read USU
		printf "\tPara qual grupo você irá adicionar esses usuários?: "
		read GROU
		/usr/bin/samba-tool group addmembers $GROU "$USU"
		printf "\tOs usuários: $USU foram adicionados ao grupo: $GROU\n"
	;;
	4)
		printf "\t================================================\n"
		printf "\t|  Para remover mais de um membro de um grupo  |\n"
		printf "\t|Basta colocar os nomes separados por virgulas.|\n"
		printf "\t================================================\n"
		echo ""
		printf "\tDigite o(s) nome(s) do(s) usuario(s): "
		read USU
		printf "\tDigite o grupo que esses usuários pertencem: "
		GROUP
		/usr/bin/samba-tool group removemebers $GROU "$USU"
		printf "\tOs usuários: $USU foram removidos do grupo: $GROU"
	;;
	5)
		/usr/bin/samba-tool group list
		printf "\tEsses são os grupos existentes no Samba\n"
	;;
	6)
		printf "\tDigite o nome do grupo, para ver os seus usuários: \n"
		read UN
		/usr/bin/samba-tool group listmembers $UN
	;;
	7)
		/usr/bin/samba-tool user list
	;;
	8)
		printf "\tDigite o nome do usuário: "
		read USE
		printf "\tDigite quantos dias a senha do usuário irá durar: "
		read DAY
		/usr/bin/samba-tool user setexpiry $USE --days=$DAY
		printf "\tA senha do usuário: $USE irá expirar em: $DAY\n"
	;;
	9)
		printf "\tDigite o nome do usuário: "
		NAM
		/usr/bin/samba-tool user setexpiry $NAM --noexpiry
		printf "\tA senha do usuário: NAM jamais irá expirar!"
	;;
	10)
		printf "Para você controlar o Samba pelo Windows, é necessário fazer download do pacote chamado: \n"
		printf "Remote Server Administration Tools for Windows (Versão do seu Windows) with Service Pack 1"
		printf "Depois de instalar essas ferramentas do AD, vá em 'Painel de Controle' 'Programas' 'Ativar e desativar recursos..\n"
		printf "Marque as opções 'Ferramentas de Administração de Servidores Remoto' marque tudo de dentro desta opção.\n"
		printf "Reinicie o computador. Agora iremos colocar o computador no domínio do Samba.\n"
		printf "Vá em adapatador de rede, e habilite o DNS e aponte ele para a placa de rede do Samba.\n"
		printf "Veja se consegue 'pingar' o Samba pelo IP e pelo Domínio.\n"
	
	;;
	11)
		printf "\t$Azul===============================================================================================================\n"
		printf "\t$Verd|           Precisamos preparar um HD onde irá hospedar as pastas compartilhadas dos usuários.                |\n"
		printf "\t|                                      Para tanto siga esses passos por favor:                                |\n"
		printf "\t|                                            *Desligar o Servidor                                             |\n"
		printf "\t|                                   *Colocar um disco rigido e religar o Servidor                             |\n"
		printf "\t|   *De um: ls /dev/sd* veja a letra que o S.O atribiui ao disco rigido. O sda é onde está o S.O do Servidor! |\n"
		printf "\t|    *Agora vamos particionar o seu disco rigido pelo fdisk, de o comando: fdisk /dev/sd(letra do seu disco)  |\n"
		printf "\t|   *Pressione a letra 'n' depois 'p' depois '1' depois 'ENTER' Nesta parte escolha o tamanho da partição.    |\n"
		printf "\t|                        Exemplo: +30G Estou relatando que essa partiçaõ será de 30GB.                        |\n"
		printf "\t| Para terminar, é só pressionar a letra 'w' e dar 'ENTER' Com isso você poderá responder as perguntas abaixo |\n"
		printf "\t$Azul===============================================================================================================$Branco \n"
		printf "\n\n"
		printf "$Ver\tSe você fez como o informado acima, prossiga respondendo as perguntas abaxo:\n"
		printf "\tSe você não fez! De Ctrl+C para sair do script! Pois os proxímos passos podem causar\n"
		printf "\tProplemas para o S.O, o impossibilitando de reinciar! Por isso a importancia de fazer tudo certo.\n"
		printf "\n\n"
		printf "\t$Ciano Digite o caminho até a partição que você criou em seu disco rigido: "
		read PART
		printf "\tOBS: Aceite as opções com o 'y'\n"
		mkfs.ext4 $PART
		if [ $? = 0 ]
		then 
			printf "Ok sua partição, recebeu o sistema de arquivo EXT4.\n"
			sleep 1.5
			printf "Agora vamos, configurar /etc/fstab, para essa partição sempre ser montada a cada incialização do sistema.\n"
			printf "Digite o diretorio que você quer montar essa partição: "
			read DIR
			mkdir $DIR
			echo "$PART	$DIR	auto	user_xattr,acl,barrier=1 1 1" >> /etc/fstab
			printf "$Azul\t===========\n"
			printf "\t   Teste   \n"
			printf "\t===========\n"
			printf "Analisando o sistema: "
			sleep 1
			printf "#"
			sleep 1
			printf "#"
			sleep 1
			printf "#"
			sleep 1
			printf "#"
			sleep 1
			printf "#"
			sleep 1
			printf "#"
			sleep 0.5
			printf "#"
			sleep 0.5
			printf "#"
			sleep 0.5
			printf "#"
			sleep 0.5
			printf "#"
			sleep 0.5
			printf "#"
			sleep 0.5
			printf "#"
			sleep 0.5
			printf "#"
			sleep 0.5
			printf "#"
			sleep 0.5
			printf "#"
			sleep 0.5
			printf "#"
			sleep 0.5
			printf "#"
			sleep 0.5
			printf "#"
			sleep 0.5
			printf "#"
			sleep 0.5
			printf "#"
			sleep 0.5
			printf "#"
			sleep 0.5
			printf "#"
			sleep 0.5
			printf "#"
			sleep 0.5
			printf "#"
			sleep 0.5
			printf "#"
			sleep 0.5
			printf "#"
			printf " Resposta: \n"
			printf "\n\n"
			printf "Se retornar algo, é por que deu erro em montar a partição."
			printf "Com isso basta entra no arquivo /etc/fstab e apagar a linha que tem a sua partição\n"
			printf "Possivelmente é uma das ultimas linhas!\n"
			printf "\n\n"
			printf "\t$Verd Se não retornou nada como resposta, isso é ótimo, seu disco rigido já está pronto para o uso!$Braqnco\n"
			echo ""
			
		else
			printf "EROOR!! Você digitou o caminho errado! De o comando ls /dev/sd* e veja o número da sua partição!\n"
		fi
	;;
	0)
		printf "\tObrigado por usar meu scipt!\n"
		sleep 1.2
		exit
	;;
	*)
		printf "\tOpção inválida! Tente novamente...\n"
	;;
	esac
done
