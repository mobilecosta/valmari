#Include "Protheus.ch"

User Function MA265TDOK
/*/f/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
<Descricao> : Ponto de entrada para validar o endereçamento dos produtos
<Autor> : Wagner Mobile Costa
<Data> : 06/08/2013
<Parametros> : Nenhum
<Retorno> : Nenhum
<Processo> : Especifico Valmari - Endereçamento
<Tipo> (Menu,Trigger,Validacao,Ponto de Entrada,Genericas,Especificas ) : P
<Obs> :
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
*/

Local nPosLCLZ := GdFieldPos("DB_LOCALIZ"), nPos_RECWT := GdFieldPos("DB_REC_WT"), nPos := 1, aArea := GetArea(), cQuery := "", lRet := .T.

//-- Endereçamento do CQ permite varios produtos
If SDA->DA_LOCAL == GetMV("MV_CQ")
	Return .T.
EndIf

For nPos := 1 To Len(aCols)
	If aCols[nPos][nPos_RECWT] == 0 .And. ! aCols[nPos][Len(aCols[nPos])]
	   If ! U_EndMPrd(SDA->DA_PRODUTO, SDA->DA_LOCAL, aCols[nPos][nPosLCLZ])
         lRet := .F.
	   EndIf
	EndIf
Next

RestArea(aArea)

Return lRet