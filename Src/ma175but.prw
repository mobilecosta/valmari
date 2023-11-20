#Include "Protheus.ch"

User Function MA175BUT
/*/f/
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
<Descricao> : Ponto de entrada para inclus„o de aÁıes relacionadas na tela de liberaÁ„o do CQ
<Autor> : Wagner Mobile Costa
<Data> : 08/12/2013
<Parametros> : Nenhum
<Retorno> : aButtons = {{'RESOURCE',{|| Funcao() }, "Hint"}}
<Processo> : Especifico Valmari - EndereÁamento
<Tipo> (Menu,Trigger,Validacao,Ponto de Entrada,Genericas,Especificas ) : P
<Obs> :
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
*/

Return { {'TANQUE',{|| U_MA175ETC() }, "AprovaÁ„o em Lote"}} 

User Function MA175ETC
/*/f/
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
<Descricao> : Montagem de tela para seleÁ„o de etiquetas a serem aprovadas pelo CQ
<Autor> : Wagner Mobile Costa
<Data> : 08/12/2013
<Parametros> : Nenhum
<Retorno> : Nenhum
<Processo> : Especifico Valmari - EndereÁamento
<Tipo> (Menu,Trigger,Validacao,Ponto de Entrada,Genericas,Especificas ) : E
<Obs> :
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
*/

Local oOk    := LoadBitmap( GetResources(), 'LBOK' )
Local oNo    := LoadBitmap( GetResources(), 'LBNO' )
Local aLista := { }, cQuery := "", nOpc := nPosRej := nLista := nQtde := nCols := 0, aArea := GetArea(), cPict := "@E 9,999,999.99"
Local nPD7_TIPO := GdFieldPos("D7_TIPO"), nPD7_XETI := GdFieldPos("D7_XCODETI"), nPD7_QTDE := GdFieldPos("D7_QTDE"), cData := ""
Local cLocCQ    := PADR(GetMV('MV_CQ'),TamSx3("D7_LOCDEST")[01])

cQuery := "SELECT CB0.CB0_DTNASC, CB0.CB0_CODETI, CB0.CB0_VOLUME, CB0.CB0_QTDE - "
cQuery +=       "COALESCE((SELECT D7_QTDE FROM " + RetSqlName("SD7") + " WHERE D_E_L_E_T_ = ' ' AND D7_FILIAL = '" + xFilial("SD7") + "' "
cQuery +=                    "AND D7_NUMERO = '" + SD7->D7_NUMERO + "' AND D7_TIPO = 2 AND D7_XCODETI = CB0.CB0_CODETI), 0) AS CB0_QTDE "
cQuery +=   "FROM " + RetSqlName("CB0") + " CB0 "
cQuery +=  "WHERE CB0.D_E_L_E_T_ = ' ' AND CB0.CB0_FILIAL = '" + xFilial("CB0") + "' AND CB0.CB0_XNUMCQ = '" + SD7->D7_NUMERO + "' AND CB0.CB0_CODET2 = ' '"

cQuery := ChangeQuery( cQuery )
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QRY",.F.,.T. )
cData := Dtoc(Stod(QRY->CB0_DTNASC))
While ! Eof()
	If Ascan(aCols, {|x| x[nPD7_XETI] == QRY->CB0_CODETI .And. x[nPD7_TIPO] == 1 .And. ! x[Len(x)] }) > 0
		DbSkip()
		Loop
	EndIf

	nPosRej := Ascan(aCols, {|x| x[nPD7_XETI] == QRY->CB0_CODETI .And. x[nPD7_TIPO] == 2 .And. ! x[Len(x)] })
	nQtde   := 0
	If nPosRej > 0
		nQtde := aCols[nPosRej][nPD7_QTDE]
	EndIf
	Aadd(aLista, { .F., QRY->CB0_CODETI, QRY->CB0_VOLUME, QRY->CB0_QTDE - nQtde })
	DbSkip()
EndDo
QRY->(DbCloseArea())

RestArea(aArea)

If Len(aLista) == 0
	MsgInfo("N„o existe nenhuma etiqueta a ser aprovada pendente para aprovaÁ„o !")
	Return
EndIf

DEFINE MSDIALOG oDlg TITLE "AprovaÁ„o das Etiquetas - Gerada em [" + cData + "]" FROM 000,000 TO 450,400 PIXEL

oGrid := TPanel():New(000,000, ,oDlg, , , , , , 0, 20, .F.,.F. )
oGrid:align := CONTROL_ALIGN_ALLCLIENT

@ 005,005 LISTBOX oLbx FIELDS HEADER "", "Etiqueta", "Volume", "Quantidade"  Size 204,105 Of oGrid Pixel
oLbx:align := CONTROL_ALIGN_ALLCLIENT

oLbx:SetArray(aLista)
oLbx:bLine := {||{	If(aLista[oLbx:nAT][1], oOK, oNo),;
					aLista[oLbx:nAT][2],;
					aLista[oLbx:nAT][3],;
					Trans(aLista[oLbx:nAT][4], cPict) }}
oLbx:bLDblClick := {|| oLbx:aArray[oLbx:nAt,1] := ! oLbx:aArray[oLbx:nAt,1] }

oRodape := TPanel():New(000,000, ,oDlg, , , , , , 0, 20, .F.,.F. )
oRodape:align := CONTROL_ALIGN_BOTTOM

@ 005,050 Button "Desmarcar"	SIZE 30,10 ACTION (MarkLst(aLista, .F.))	Of oRodape PIXEL
@ 005,090 Button "Marcar"		SIZE 30,10 ACTION (MarkLst(aLista, .T.))	Of oRodape PIXEL
@ 005,130 Button "Fechar"		SIZE 28,10 ACTION (oDlg:End())  			Of oRodape PIXEL
@ 005,165 Button "Confirmar"	SIZE 28,10 ACTION (nOpc := 1, oDlg:End())   Of oRodape PIXEL
  	
ACTIVATE MSDIALOG oDlg CENTERED

If nOpc == 1
	For nLista := 1 To Len(aLista)
		If aLista[nLista][1]
			aCol := {}
			For nCols := 1 To Len(aHeader) - 2
				If AllTrim(aHeader[nCols,2]) == "D7_LOCDEST"
					Aadd(aCol, IIF(SD7->D7_ORIGLAN=="PR",SB1->B1_LOCPAD,If(cLocCQ == SD7->D7_LOCDEST,SB1->B1_LOCPAD,SD7->D7_LOCDEST)))
				ElseIf aHeader[nCols,8] == "D"
					Aadd(aCol, dDataBase)
				Else
					Aadd(aCol, CriaVar(aHeader[nCols][2], .T.))
				EndIf
			Next
			aCol[1] := StrZero(Len(aCols) + 1, 3)
			Aadd(aCol, "")
			Aadd(aCol, 0)
			Aadd(aCol, .F.)
			
			aCol[nPD7_TIPO] := 1
			aCol[nPD7_XETI] := aLista[nLista][2]
			aCol[nPD7_QTDE] := aLista[nLista][4]
			
			Aadd(aCols, AClone(aCol))
			n := Len(aCols)

			__READVAR  := "M->D7_TIPO"
			M->D7_TIPO := 1
			A175Tipo()
			
			__READVAR := "M->D7_QUANT"
			M->D7_QUANT := aLista[nLista][4]
			A175Quant()
		EndIf
	Next
	
	oGet:oBrowse:Refresh()
EndIf

Return

Static Function MarkLst(aLista, lAcao)
/*/f/
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
<Descricao> : Executa
<Autor> : Wagner Mobile Costa
<Data> : 10/12/2013
<Parametros> : aLista = Lista dos itens apresentados e lAcao = .T. = Marcar e .F. = Desmacar
<Retorno> : Nenhum
<Processo> : Especifico Valmari - EndereÁamento
<Tipo> (Menu,Trigger,Validacao,Ponto de Entrada,Genericas,Especificas ) : E
<Obs> :
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
*/

Local nLista := 1

For nLista := 1 To Len(aLista)
	aLista[nLista][1] := lAcao
Next

Return