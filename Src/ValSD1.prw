#Include "Protheus.ch"

User Function D1_COD_V()
/*/f/
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
<Descricao> : FunÁ„o para preenchimento do campo D1_XEAN14 a partir do cadastro de complemento de produtos ou produto x fornecedor
<Autor> : Wagner Mobile Costa
<Data> : 14/08/2013
<Parametros> : Nenhum
<Retorno> : lRet = Confirma a gravaÁ„o do campo
<Processo> : Especifico Valmari - EndereÁamento
<Tipo> (Menu,Trigger,Validacao,Ponto de Entrada,Genericas,Especificas ) : V
<Obs> :
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
*/

Local nPD1_XEAN := GdFieldPos("D1_XEAN14"), aArea := GetArea(), aAreaSA5 := SA5->(GetArea()), aAreaSB5 := SB5->(GetArea())

DbSelectArea("SA5")		// A5_FILIAL+A5_FORNECE+A5_LOJA+A5_PRODUTO
DbSetOrder(1)	
DbSeek(xFilial() + cA100For + cLoja + &(ReadVar()))
If SA5->A5_XENAN14 > 0
	aCols[n][nPD1_XEAN] := SA5->A5_XENAN14
Else
	DbSelectArea("SB5")		// B5_FILIAL+B5_COD
	DbSetOrder(1)
	DbSeek(xFilial() + &(ReadVar()))
	If SB5->B5_EAN141 > 0
		aCols[n][nPD1_XEAN] := SB5->B5_EAN141
	EndIf
EndIf

SA5->(RestArea(aAreaSA5))
SB5->(RestArea(aAreaSB5))
RestArea(aArea)

Return .T.