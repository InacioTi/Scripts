#!/usr/bin/python3
# -*- coding: utf-8 -*-

#Code: JoseInacio -
#Github: https://github.com/InacioTi

import crypt

print ("##########SCRIPT CRACK HASH COM SALTA######")

#digite os paramentros abaixo
hashs = input("Digite a hash completa: ")
salt = input("Digite o Salt: ")
passw = open("wl.txt")

# para a linha lida no arquivo
for linha in passw:

#tirar os espacos
    linha = linha.strip()
#criar hash com a senha lida no arquivo e o salt fornecido
    has = crypt.crypt(linha,salt)
#comparar se o resultado comfere com o has completo passado
    if has == hashs:
        print("a senha é", linha)
        break
    else:
        print("Procurando...")
