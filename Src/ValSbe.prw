#Include "Protheus.ch"

User Function BE_XTPDW()
/*/f/
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
<Descricao> : FunÁ„o para definiÁ„o condiÁ„o de acesso ao campo BE_XTPENDW
<Autor> : Wagner Mobile Costa
<Data> : 04/08/2013
<Parametros> : Nenhum
<Retorno> : lRet = Indica se o campo de ser acessado
<Processo> : Especifico Valmari - EndereÁamento
<Tipo> (Menu,Trigger,Validacao,Ponto de Entrada,Genericas,Especificas ) : V
<Obs> :
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
*/

Local lRet := .T., cQuery := ""

IF INCLUI
	Return .T.
EndIf

cQuery := "SELECT COUNT(*) AS CONTADOR FROM " + RetSqlName( "SBE" ) + " "
cQuery +=  "WHERE D_E_L_E_T_ = ' ' AND BE_FILIAL ='" + xFilial( "SBE" ) + "' "
cQuery +=    "AND ((BE_XLOCPIC = '" + SBE->BE_LOCAL + "' AND BE_XENDPIC = '" + SBE->BE_LOCALIZ + "') OR "
cQuery +=         "(BE_XLOCDES = '" + SBE->BE_LOCAL + "' AND BE_XENDDES = '" + SBE->BE_LOCALIZ + "'))"

cQuery := ChangeQuery( cQuery )
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QRY",.F.,.T. )
If QRY->CONTADOR > 0
	lRet := .F.
EndIF
QRY->(DbCloseArea())

Return lRet

User Function BE_XENDI(cBE_XTPEND)
/*/f/
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
<Descricao> : FunÁ„o para inicializaÁ„o dos campos BE_XDESPUL e BE_XDESPIC
<Autor> : Wagner Mobile Costa
<Data> : 03/08/2013
<Parametros> : Nenhum
<Retorno> : cBE_DESCRIC = Retorna descriÁ„o do campo do endereÁo
<Processo> : Especifico Valmari - EndereÁamento
<Tipo> (Menu,Trigger,Validacao,Ponto de Entrada,Genericas,Especificas ) : V
<Obs> :
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
*/

Local cBE_DESCRIC := Space(Len(SBE->BE_DESCRIC))
Local aAreaSBE 	  := SBE->(GetArea()), cChave := ""

SBE->(DbSetOrder(1))
If cBE_XTPEND = "1" .AND. ! INCLUI 	//-- Picking
	cChave := SBE->BE_XLOCPIC + SBE->BE_XENDPIC
ElseIf cBE_XTPEND = "3" .And. ! INCLUI	//-- Descarte
	cChave := SBE->BE_XLOCDES + SBE->BE_XENDDES
EndIf

If ! Empty(cChave) .And. SBE->(MsSeek(xFilial() + cChave))
	cBE_DESCRIC := SBE->BE_DESCRIC
EndIf

SBE->(RestArea(aAreaSBE))

Return cBE_DESCRIC

User Function BE_XENDV(cBE_XTPEND)
/*/f/
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
<Descricao> : FunÁ„o para validar os campos BE_XENDPUL e BE_XENDPIC
<Autor> : Wagner Mobile Costa
<Data> : 03/08/2013
<Parametros> : Nenhum
<Retorno> : lRet = Indica se o preenchimento do campo È valido
<Processo> : Especifico Valmari - EndereÁamento
<Tipo> (Menu,Trigger,Validacao,Ponto de Entrada,Genericas,Especificas ) : V
<Obs> :
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
*/

Local aAreaSBE := SBE->(GetArea()), lRet := .T., cVar := &(ReadVar())

If Empty(cVar)
	Return .T.
EndIf

DbSelectArea("SBE")
cChave := M->BE_XLOCPIC
If ReadVar() == "M->BE_XENDDES"
	cChave := M->BE_XLOCDES
EndIf
cChave += cVar

DbSeek(xFilial() + cChave)
If ! Found() .Or. SBE->BE_XTPEND <> cBE_XTPEND
	Alert("AtenÁ„o. O endereÁo [" + cVar + "] n„o È valido para este tipo endereÁamento !")
	lRet := .F.
Else
	If ReadVar() == "M->BE_XENDDES"
		M->BE_XDESDES := SBE->BE_DESCRIC
	Else
		M->BE_XDESPIC := SBE->BE_DESCRIC
	EndIf
EndIf

SBE->(RestArea(aAreaSBE))

Return lRet