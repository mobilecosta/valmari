#Include "Protheus.ch"

User Function MT175FOK
/*/f/
�����������������������������������������������������������������������������������������������������������������������������������������������������
<Descricao> : Ponto de entrada para valida��o da quantidade x vinculo com a etiqueta
<Autor> : Wagner Mobile Costa
<Data> : 18/08/2013
<Parametros> : Nenhum
<Retorno> : lRet = Indica se a linha est� valida
<Processo> : Especifico Valmari - Endere�amento
<Tipo> (Menu,Trigger,Validacao,Ponto de Entrada,Genericas,Especificas ) : P
<Obs> :
�����������������������������������������������������������������������������������������������������������������������������������������������������
*/

Local lRet := .T., aAreaSB1 := SB1->(GetArea()), aArea := GetArea()
Local nPD7_TIPO := GdFieldPos("D7_TIPO"), nPD7_XETI := GdFieldPos("D7_XCODETI"), nPD7_XET2 := GdFieldPos("D7_XCODET2"), nPD7_QTDE := GdFieldPos("D7_QTDE")
Local nPD7_EST  := GdFieldPos("D7_ESTORNO")

If aCols[n][nPD7_TIPO] == 0 .Or. aCols[n][nPD7_EST] == "S" .Or. aCols[n][Len(aCols[n])]
	Return .T.
EndIf

DbSelectArea("SB1")
DbSetOrder(1)
DbSeek(xFilial() + SD7->D7_PRODUTO)
If SB1->B1_LOCALIZ == "S"
	If Empty(aCols[n][nPD7_XETI])
		Alert("Aten��o. Para produtos com endere�amento � obrigat�rio vincular a etiqueta de endere�amento !")
		lRet := .F.
	EndIf

	If lRet .And. Empty(aCols[n][nPD7_XET2])
		DbSelectArea("CB0")
		DbSetOrder(1)          	
		DbSeek(xFilial() + aCols[n][nPD7_XETI])
		If aCols[n][nPD7_QTDE] > CB0->CB0_QTDE
			Alert("Aten��o. A Quantidade informada � superior ao volume da etiqueta !")
			lRet := .F.
		EndIF
	EndIf
EndIf
	
SB1->(RestArea(aAreaSB1))
RestArea(aArea)

Return lRet