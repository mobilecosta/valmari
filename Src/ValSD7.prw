#Include "Protheus.ch"

User Function D7_XETIV
/*/f/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
<Descricao> : Validação da digitação do campo D7_XCODETI
<Autor> : Wagner Mobile Costa
<Data> : 18/08/2013
<Parametros> : Nenhum
<Retorno> : lRet = Indica se a digitação está valida
<Processo> : Especifico Valmari - Endereçamento
<Tipo> (Menu,Trigger,Validacao,Ponto de Entrada,Genericas,Especificas ) : P
<Obs> :
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
*/

Local lRet := .T., aAreaCB0 := CB0->(GetArea()), aArea := GetArea(), nPD7_TIPO := GdFieldPos("D7_TIPO")

DbSelectArea("CB0")
DbSetOrder(1)
If ! DbSeek(xFilial() + &(ReadVar()))
	Alert("Atenção. Etiqueta selecionada invalida !")
	lRet := .F.
EndIf

If lRet
	If CB0->CB0_XNUMCQ <> SD7->D7_NUMERO
		Alert("Atenção. Esta etiqueta não se refere a esta liberação de CQ !")
		lRet := .F.
	EndIf
EndIf

CB0->(RestArea(aAreaCB0))
RestArea(aArea)

Return lRet

User Function D7_XETIW
/*/f/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
<Descricao> : Validação do acesso ao campo D7_XCODETI
<Autor> : Wagner Mobile Costa
<Data> : 18/08/2013
<Parametros> : Nenhum
<Retorno> : lRet = Indica se o campo poderá ser acessado
<Processo> : Especifico Valmari - Endereçamento
<Tipo> (Menu,Trigger,Validacao,Ponto de Entrada,Genericas,Especificas ) : P
<Obs> :
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
*/

Local lRet := .F., aAreaSB1 := SB1->(GetArea()), aArea := GetArea()

DbSelectArea("SB1")
DbSetOrder(1)
DbSeek(xFilial() + SD7->D7_PRODUTO)
If SB1->B1_LOCALIZ == "S" .And. SD7->D7_ORIGLAN $ "CP,PR"
	lRet := .T.
EndIf

SB1->(RestArea(aAreaSB1))
RestArea(aArea)

Return lRet