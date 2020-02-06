![N|Solid](logo_ioasys.png)

[![Build Status](https://travis-ci.org/anderlentz/appempresas.svg?branch=master)](https://travis-ci.org/anderlentz/appempresas)

# README #

Estes documento README tem como objetivo fornecer as informações necessárias para realização do projeto Empresas.

### ESCOPO DO PROJETO ###

* Deve ser criado um aplicativo iOS utilizando Objective C ou Swift com as seguintes especificações:
* Login e acesso de Usuário já registrado
	* Para o login usamos padrões OAuth 2.0. Na resposta de sucesso do login a api retornará 3 custom headers (access-token, client, uid);
	* Para ter acesso as demais APIS precisamos enviar esses 3 custom headers para a API autorizar a requisição;
* Listagem de Empresas
* Detalhamento de Empresas

### Informações Importantes ###

* Integração disponível a partir de uma collection para Postman (https://www.getpostman.com/apps) disponível neste repositório.

### Dados para Teste ###

* Servidor: https://empresas.ioasys.com.br/api
* Versão da API: v1
* Usuário de Teste: testeapple@ioasys.com.br
* Senha de Teste : 12341234

