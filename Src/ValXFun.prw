#Include "Protheus.Ch"

User Function CBGrvEti(cTipo,aConteudo,cID)

Local lNew
DbSelectArea('CB0')
IF cID == NIL
	While .t.
		cID := Padr(CBProxCod('MV_CODCB0'),10)
		If ! CB0->(DbSeek(xFilial("CB0")+cID))
			exit
		EndIf
	End
	lNew := .t.
	RecLock('CB0',lNew)
	CB0->CB0_DTNASC := dDataBase
Else
	If Len(Alltrim(cID)) <=  TamSx3("CB0_CODETI")[1]   // Codigo Interno
		CB0->(DbSetOrder(1))
		CB0->(DbSeek(xFilial("CB0")+cID))
		lNew := ! CB0->(DbSeek(xFilial("CB0")+Padr(cID,TamSx3("CB0_CODETI")[1])))
	ELSEIf Len(Alltrim(cID)) ==  TamSx3("CB0_CODET2")[1]-1   // Codigo Interno  pelo codigo do cliente
		CB0->(DbSetOrder(2))
		lNew := ! CB0->(DbSeek(xFilial("CB0")+Padr(cID,TamSx3("CB0_CODET2")[1])))
		CB0->(DbSetOrder(1))
	EndIf

	RecLock('CB0',lNew)
	If !lNew .and. cTipo # CB0->CB0_TIPO
		Return NIL
	EndIf
EndIf
CB0->CB0_FILIAL := xFilial("CB0")
If lNew
	CB0->CB0_CODETI := cID
	CB0->CB0_DTNASC := dDataBase
	CB0->CB0_TIPO   := cTipo
Endif

IF cTipo == '01'    // produto
	CB0->CB0_CODPRO := CBChk(aConteudo,1,CB0_CODPRO)
	CB0->CB0_QTDE   := CBChk(aConteudo,2,CB0_QTDE)
	CB0->CB0_USUARIO:= CBChk(aConteudo,3,CB0_USUARIO)
	CB0->CB0_NFENT  := CBChk(aConteudo,4,CB0_NFENT)
	CB0->CB0_SERIEE := CBChk(aConteudo,5,CB0_SERIEE)
	CB0->CB0_FORNEC := CBChk(aConteudo,6,CB0_FORNEC)
	CB0->CB0_LOJAFO := CBChk(aConteudo,7,CB0_LOJAFO)
	CB0->CB0_PEDCOM := CBChk(aConteudo,8,CB0_PEDCOM)
	CB0->CB0_LOCALI := CBChk(aConteudo,9,CB0_LOCALI)
	CB0->CB0_LOCAL  := CBChk(aConteudo,10,CB0_LOCAL)
	CB0->CB0_OP     := CBChk(aConteudo,11,CB0_OP)
	CB0->CB0_NUMSEQ := CBChk(aConteudo,12,CB0_NUMSEQ)
	CB0->CB0_XNUMSQ := CB0->CB0_NUMSEQ
	CB0->CB0_NFSAI  := CBChk(aConteudo,13,CB0_NFSAI)
	CB0->CB0_SERIES := CBChk(aConteudo,14,CB0_SERIES)
	CB0->CB0_CODET2 := CBChk(aConteudo,15,CB0_CODET2)
	CB0->CB0_LOTE   := CBChk(aConteudo,16,CB0_LOTE)
	CB0->CB0_SLOTE  := CBChk(aConteudo,17,CB0_SLOTE)
	CB0->CB0_DTVLD  := CBChk(aConteudo,18,CB0_DTVLD)
	CB0->CB0_CC     := CBChk(aConteudo,19,CB0_CC)
	CB0->CB0_LOCORI := CBChk(aConteudo,20,CB0_LOCORI)
	CB0->CB0_PALLET := CBChk(aConteudo,21,CB0_PALLET)
	CB0->CB0_OPREQ  := CBChk(aConteudo,22,CB0_OPREQ)
	CB0->CB0_NUMSER := CBChk(aConteudo,23,CB0_NUMSER)
	CB0->CB0_ORIGEM := CBChk(aConteudo,24,CB0_ORIGEM)
	If CB0->(FieldPos("CB0_ITNFE"))>0
		CB0->CB0_ITNFE  := CBChk(aConteudo,25,CB0_ITNFE)
	EndIf
	CB0->CB0_VOLUME := CBChk(aConteudo,26,CB0_VOLUME)
	CB0->CB0_XEAN14 := CBChk(aConteudo,27,CB0_XEAN14)
	CB0->CB0_XNUMCQ := CBChk(aConteudo,28,CB0_XNUMCQ)
	CB0->CB0_XDFABR := CBChk(aConteudo,29,CB0_XDFABR)
	CB0->CB0_XLOTEF := CBChk(aConteudo,30,CB0_XLOTEF)
	If Type('cProgImp')=="C" .and. cProgImp=="ACDV130"
		CB0_STATUS := "3" // Disponivel para devoluÁ„o
	EndIf
ElseIf cTipo == '02' // LOCALIZACAO
	CB0->CB0_LOCALI := CBChk(aConteudo,1,CB0_LOCALI)
	CB0->CB0_LOCAL  := CBChk(aConteudo,2,CB0_LOCAL )
ElseIf cTipo == '03' // UNITIZADOR
	CB0->CB0_DISPID := CBChk(aConteudo,1,CB0_DISPID)
ElseIf cTipo == '04' // USUARIO
	CB0->CB0_USUARIO:= CBChk(aConteudo,1,CB0_USUARIO)
ElseIf cTipo == '05' // VOLUME
	CB0->CB0_VOLUME := CBChk(aConteudo,1,CB0_VOLUME)
	CB0->CB0_PEDVEN := CBChk(aConteudo,2,CB0_PEDVEN)
	CB0->CB0_NFSAI  := CBChk(aConteudo,3,CB0_NFSAI)
	CB0->CB0_SERIES := CBChk(aConteudo,4,CB0_SERIES)
ElseIf cTipo == '06'
	CB0->CB0_TRANSP := CBChk(aConteudo,1,CB0_TRANSP)
ElseIf cTipo == '07' // VOLUME
	CB0->CB0_VOLUME := CBChk(aConteudo,1,CB0_VOLUME)
	CB0->CB0_NFENT  := CBChk(aConteudo,2,CB0_NFENT)
	CB0->CB0_SERIEE := CBChk(aConteudo,3,CB0_SERIEE)
	CB0->CB0_FORNEC := CBChk(aConteudo,4,CB0_FORNEC)
	CB0->CB0_LOJAFO := CBChk(aConteudo,5,CB0_LOJAFO)
EndIf
MsUnLock()
Return cID

Static Function CBChk(aConteudo,nItem,xDef)
local uRet := xDef
If nItem <= len(aConteudo) .and. aConteudo[nItem] <> NIL
	uRet:= aConteudo[nItem]
EndIf
Return uRet

User Function X3Titulo(cCampo)

SX3->(DbSetOrder(2))
SX3->(MsSeek(cCampo))

Return X3Titulo()

User Function EndMPrd(cBF_PRODUTO, cBF_LOCAL, cBF_LOCALIZ)
/*/f/
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
<Descricao> : Verifica se o produto j· foi utilizado no endereÁo informado
<Autor> : Wagner Mobile Costa
<Data> : 20/12/2013
<Parametros> : cBF_PRODUTO = CÛdigo do produto a ser endereÁado, cBF_LOCAL = Local de armazenamento e cBF_LOCALIZ = EndereÁo a ser verificado
<Retorno> : Nenhum
<Processo> : Especifico Valmari - EndereÁamento
<Tipo> (Menu,Trigger,Validacao,Ponto de Entrada,Genericas,Especificas ) : P
<Obs> :
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
*/

Local cES_ENDMTPD := SuperGetMv("ES_ENDMTPD", .F., "MP,BN,EB"), lRet := .T., aArea := GetArea()

SB1->(DbSetOrder(1))
SB1->(DbSeek(xFilial() + cBF_PRODUTO))

cQuery := "SELECT SUM(BF_QUANT) AS BF_QUANT FROM " + RetSqlName( "SBF" ) + " "
cQuery +=  "WHERE D_E_L_E_T_ = ' ' AND BF_FILIAL = '" + xFilial( "SBF" ) + "' AND BF_LOCAL = '" + SDA->DA_LOCAL + "' "
cQuery +=    "AND BF_PRODUTO <> '" + cBF_PRODUTO + "' "
cQuery +=    "AND BF_LOCALIZ = '" + cBF_LOCALIZ + "' AND BF_QUANT > 0"

cQuery := ChangeQuery( cQuery )
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QRY",.F.,.T. )
If QRY->BF_QUANT > 0 .And. ! SB1->B1_TIPO $ cES_ENDMTPD
   	If IsTelNet()
		VtAlert("AtenÁ„o. J· existe produto no endereÁo [" + AllTrim(cBF_LOCALIZ) + "]. Este produto deve ser armazenado em outro endereÁo !")
   	Else
		Alert("AtenÁ„o. J· existe produto no endereÁo [" + AllTrim(cBF_LOCALIZ) + "]. Este produto deve ser armazenado em outro endereÁo !")
   	EndIf
	lRet := .F.
EndIf

QRY->(DbCloseArea())
RestArea(aArea)

Return lRet