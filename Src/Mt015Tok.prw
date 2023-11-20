#Include "Protheus.ch"

User Function MT015TOK
/*/f/
�����������������������������������������������������������������������������������������������������������������������������������������������������
<Descricao> : Ponto de entrada para valida��o do preenchimento dos campos de endere�o de picking e descarte
<Autor> : Wagner Mobile Costa
<Data> : 03/08/2013
<Parametros> : Nenhum
<Retorno> : Nenhum
<Processo> : Especifico Valmari - Endere�amento
<Tipo> (Menu,Trigger,Validacao,Ponto de Entrada,Genericas,Especificas ) : V
<Obs> :
�����������������������������������������������������������������������������������������������������������������������������������������������������
*/

Local lRet := .T.

//-- Endere�o Pulm�o
If M->BE_XTPEND == "2"
	If Empty(M->BE_XLOCPIC) .Or. Empty(M->BE_XENDPIC)
		Alert("O local e endere�o de picking � obrigat�rio para endere�o do tipo pulm�o !")
		lRet := .F.
	EndIf
Else
	// Limpa o endere�o de picking/descarte
	M->BE_XLOCPIC := Space(Len(M->BE_XLOCPIC))
	M->BE_XENDPIC := Space(Len(M->BE_XENDPIC))
	M->BE_XLOCDES := Space(Len(M->BE_XLOCDES))
	M->BE_XENDDES := Space(Len(M->BE_XENDDES))
EndIf

Return lRet