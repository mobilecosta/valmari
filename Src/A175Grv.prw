#Include "Protheus.ch"

User Function A175GRV
/*/f/
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
<Descricao> : Ponto de entrada para confirmaÁ„o das etiquetas com endereÁamento
<Autor> : Wagner Mobile Costa
<Data> : 18/08/2013
<Parametros> : Nenhum
<Retorno> : Nenhum
<Processo> : Especifico Valmari - EndereÁamento
<Tipo> (Menu,Trigger,Validacao,Ponto de Entrada,Genericas,Especificas ) : P
<Obs> :
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
*/

Local cMV_DIST := GetMv("MV_DISTAUT"), cMV_CQ := GetMv("MV_CQ"), aArea := GetArea(), aAreaSDA := SDA->(GetArea()), aAreaSD7 := SD7->(GetArea())
Local nPD7_REC_WT := GdFieldPos("D7_REC_WT"), nPD7_XCODETI := GdFieldPos("D7_XCODETI"), nCols := 1, nRecMax := 0, cEtq := ""

DbSelectArea("SB1")
DbSetOrder(1)
DbSeek(xFilial() + SD7->D7_PRODUTO)
If SB1->B1_LOCALIZ <> "S"
   Return
EndIf

SD7->(DbSetOrder(1))

BeginTran()
M->D7_ORIGLAN := ""

While SD7->D7_FILIAL = xFilial("SD7") .And. SD7->D7_NUMERO == cA175Num .And. ! SD7->(Eof())
	M->D7_ORIGLAN := SD7->D7_ORIGLAN

	If SD7->D7_TIPO <> 2 .Or. Ascan(aCols, {|x| x[nPD7_REC_WT] == SD7->(Recno()) }) > 0 .Or. SD7->D7_LOCDEST <> cMV_CQ
		SD7->(DbSkip())
		Loop
	EndIf

	DbSelectArea("SDA")		// DA_NUMSEQ+DA_LOCAL
	DbSetOrder(2)
	If ! DbSeek(xfilial("SDA") + SD7->D7_NUMSEQ, .F.)
		Alert("Registro do endereÁamento [" + SD7->D7_NUMSEQ + "] n„o localizado !")
		Return
	EndIf
	
	_aCabec	:= {}
	_aItem	:= {}
	Aadd(_aCabec, {"DA_PRODUTO"	, SDA->DA_PRODUTO	, nil})
	Aadd(_aCabec, {"DA_QTDORI"	, SDA->DA_QTDORI	, nil})
	Aadd(_aCabec, {"DA_SALDO"	, SDA->DA_SALDO		, nil})
	Aadd(_aCabec, {"DA_DATA"	, SDA->DA_DATA		, nil})
	Aadd(_aCabec, {"DA_LOTECTL"	, SDA->DA_LOTECTL	, nil})
	Aadd(_aCabec, {"DA_NUMLOTE"	, SDA->DA_NUMLOTE	, nil})
	Aadd(_aCabec, {"DA_LOCAL"	, SDA->DA_LOCAL		, nil})
	Aadd(_aCabec, {"DA_DOC"		, SDA->DA_DOC		, nil})
	Aadd(_aCabec, {"DA_SERIE"	, SDA->DA_SERIE		, nil})
	Aadd(_aCabec, {"DA_CLIFOR"	, SDA->DA_CLIFOR	, nil})
	Aadd(_aCabec, {"DA_LOJA"	, SDA->DA_LOJA		, nil})
	Aadd(_aCabec, {"DA_TIPONF"	, SDA->DA_TIPONF	, nil})
	Aadd(_aCabec, {"DA_ORIGEM"	, SDA->DA_ORIGEM	, nil})
	Aadd(_aCabec, {"DA_NUMSEQ"	, SDA->DA_NUMSEQ	, nil})
	Aadd(_aCabec, {"DA_QTSEGUM"	, SDA->DA_QTSEGUM	, nil})
	Aadd(_aCabec, {"DA_QTDORI2"	, SDA->DA_QTDORI2	, nil})
	
	Aadd(_aItem, {"DB_ITEM"		, "0001"			, nil})
	Aadd(_aItem, {"DB_LOCALIZ"	, Substring(cMV_DIST, 3, Len(cMV_DIST)), nil})
	Aadd(_aItem, {"DB_QUANT"	, SDA->DA_SALDO		, nil})
	Aadd(_aItem, {"DB_DATA"		, dDataBase			, nil})
	
	lMsErroAuto := .F.
	
	MsExecAuto({|x, y, z| Mata265(x, y, z)}, _aCabec, {_aItem}, 3)
	IF lMsErroAuto
		DisarmTran()
		MostraErro()
		Break
	EndIf
	
	SD7->(DbSkip())
EndDo

For nCols := 1 To Len(aCols)
	nRecMax := Max(nRecMax, aCols[nCols][nPD7_REC_WT])
Next

If TCSQLExec("UPDATE " + RetSqlName("CB0") + " " +;
       	        "SET CB0_NUMSEQ = SD7.D7_NUMSEQ, CB0_LOCAL = SD7.D7_LOCDEST " +;
               "FROM " + RetSqlName("SD7") + " SD7 " +;
       	      "WHERE " + RetSqlName("CB0") + ".D_E_L_E_T_ = ' ' AND CB0_XNUMCQ = '" + cA175Num + "' AND SD7.D7_NUMERO = '" + cA175Num + "' " +;
       	        "AND SD7.D7_NUMERO = CB0_XNUMCQ AND SD7.D7_XCODETI = CB0_CODETI AND SD7.D7_TIPO = 1 " +;
       	        "AND SD7.R_E_C_N_O_ > " + AllTrim(Str(nRecMax))) <> 0
	MsgAlert(TCSQLError())
	DisarmTran()
	Break
EndIf

cEtq := U_A175GEtq("", cA175Num, nRecMax, .F.)

EndTran()

If ! Empty(cEtq)
	MsgInfo(cEtq)
EndIf

SD7->(RestArea(aAreaSD7))
SDA->(RestArea(aAreaSDA))
RestArea(aArea)

Return