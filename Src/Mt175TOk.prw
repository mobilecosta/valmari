 #Include "Protheus.ch"

User Function MT175TOK
/*/f/
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
<Descricao> : Ponto de entrada para validaÁ„o da quantidade x vinculo com a etiqueta
<Autor> : Wagner Mobile Costa
<Data> : 18/08/2013
<Parametros> : Nenhum
<Retorno> : lRet = Indica se a linha est· valida
<Processo> : Especifico Valmari - EndereÁamento
<Tipo> (Menu,Trigger,Validacao,Ponto de Entrada,Genericas,Especificas ) : P
<Obs> :
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
*/

Local nPD7_TIPO := GdFieldPos("D7_TIPO"), nPD7_XETI := GdFieldPos("D7_XCODETI"), nPD7_XET2 := GdFieldPos("D7_XCODET2"), nPD7_QTDE := GdFieldPos("D7_QTDE")
Local lRet      := .T., nCols := nEtiqueta := 0, aEtiqueta := {}, aAreaCB0 := CB0->(GetArea()), aArea := GetArea()
Local nPD7_EST  := GdFieldPos("D7_ESTORNO")

If ! U_D7_XETIW()
	Return .T.
EndIf

For nCols := 1 To Len(aCols)
	If ! aCols[nCols][Len(aCols[nCols])] .And. Empty(aCols[nCols][nPD7_XET2]) .And. aCols[nCols][nPD7_EST] <> "S"
		nEtiqueta := Ascan(aEtiqueta, { |x| x[1] == aCols[nCols][nPD7_XETI] })
		If nEtiqueta == 0
			Aadd(aEtiqueta, { aCols[nCols][nPD7_XETI], 0, 0, 0, 0 })
			nEtiqueta := Len(aEtiqueta)
		EndIf
	
		//-- LiberaÁ„o
		If aCols[nCols][nPD7_TIPO] == 1
			aEtiqueta[nEtiqueta][2] += aCols[nCols][nPD7_QTDE]
			aEtiqueta[nEtiqueta][3] ++
		EndIf

		//-- Estorno da LiberaÁ„o
		If aCols[nCols][nPD7_TIPO] == 6
			aEtiqueta[nEtiqueta][2] -= aCols[nCols][nPD7_QTDE]
			aEtiqueta[nEtiqueta][3] --
		EndIf

		//-- RejeiÁ„o
		If aCols[nCols][nPD7_TIPO] = 2
			aEtiqueta[nEtiqueta][4] += aCols[nCols][nPD7_QTDE]
			aEtiqueta[nEtiqueta][5] ++ 
		EndIf

		//-- Estorno da RejeiÁ„o
		If aCols[nCols][nPD7_TIPO] = 7
			aEtiqueta[nEtiqueta][4] -= aCols[nCols][nPD7_QTDE]
			aEtiqueta[nEtiqueta][5] -- 
		EndIf
	EndIf
Next

DbSelectArea("CB0")
DbSetOrder(1)
For nEtiqueta := 1 To Len(aEtiqueta)
	If ! Empty(aEtiqueta[nEtiqueta][1])
		DbSeek(xFilial() + aEtiqueta[nEtiqueta][1])
		If CB0->CB0_QTDE <> aEtiqueta[nEtiqueta][2] + aEtiqueta[nEtiqueta][4] .And. aEtiqueta[nEtiqueta][2] > 0
			Alert("AtenÁ„o. A quantidade informada para etiqueta [" + aEtiqueta[nEtiqueta][1] + "] est· incorreta !")
			lRet := .F.
		EndIf
	EndIf

	If aEtiqueta[nEtiqueta][3] > 1
		Alert("AtenÁ„o. Para produtos com endereÁamento somente poder· existir um item aprovado com a quantidade total vinculado a sua etiqueta [" + aEtiqueta[nEtiqueta][1] + "] !")
		lRet := .F.
	EndIf

	If aEtiqueta[nEtiqueta][5] > 1
		Alert("AtenÁ„o. Para produtos com endereÁamento somente poder· existir um item reprovado com a quantidade total vinculado a sua etiqueta [" + aEtiqueta[nEtiqueta][1] + "] !")
		lRet := .F.
	EndIf
Next

CB0->(RestArea(aAreaCB0))
RestArea(aArea)

Return lRet