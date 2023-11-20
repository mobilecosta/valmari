#Include "Protheus.ch"
#include "apvt100.ch"

User Function VALD010
/*/f/
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
<Descricao> : Rotina para endereÁamento de recebimentos ou produÁ„o a partir da amarraÁ„o de endereÁo picking/pulm„o/descarte do cadastro de endereÁos
<Autor> : Wagner Mobile Costa
<Data> : 10/08/2013
<Parametros> : Nenhum
<Retorno> : Nenhum
<Processo> : Especifico Valmari - EndereÁamento
<Tipo> (Menu,Trigger,Validacao,Ponto de Entrada,Genericas,Especificas ) : M
<Obs> :
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
*/

Local aTela    := VTSave(), cEtiqueta := cQuery := "", aColsCB0 := {}
Local aHeadCB0 := { "Etiqueta", U_X3Titulo("CB0_QTDE") }, nPos := 1, _aCabec := {}, _aItem := {}, nOpc := 3, aEtiqueta := {}, aSize := {}
Local cPict	   := PesqPict("SBF","BF_QUANT"), cKey21 := VTDescKey(21)
Local lBlqTEnd := SuperGetMv("ES_BLQTEND", .F., .F.)

While .T.
	VTClear()
	aEtiqueta := {}
	aColsCB0  := {}

	While .T.
		cEtiqueta := Space(10)
		@ 00,00 VtSay Padc("EndereÁamento",VTMaxCol())
		@ 01,00 VtSay "Etiqueta:"
		@ 02,00 VtGet cEtiqueta pict "@!" F3 "CB0";
		Valid If(Val(cEtiqueta) > 0, (cEtiqueta := StrZero(Val(cEtiqueta), 10), .T.), .T.) .And. VldEtiqueta(cEtiqueta, aEtiqueta)

		aColsCB0 := {}
		If Len(aEtiqueta) == 0
			aadd(aColsCB0, { "", "" } )
		Else
			For nPos := 1 To Len(aEtiqueta)
				aadd(aColsCB0, { aEtiqueta[nPos][1], Trans(aEtiqueta[nPos][2], cPict) } )
			Next
		EndIf
		aSize := { Len(aColsCB0[1][1]), Len(aColsCB0[1][2]) }

		VtKeyboard(Chr(13))
		For nPos := 1 To Len(aHeadCB0)
			If aSize[nPos] < Len(AllTrim(aHeadCB0[nPos]))
				aSize[nPos] := Len(AllTrim(aHeadCB0[nPos]))
			EndIf
		Next
		VTaBrowse(3,0,VTMaxRow(),VtmaxCol(),aHeadCB0,aColsCB0, aSize )

		VtRead
		vtRestore(,,,,aTela)
		
		If (Empty(cEtiqueta) .And. Len(aEtiqueta) = 0) .Or. VtLastKey() == 27
			Return .F.
		EndIf

		If Empty(cEtiqueta)
			Exit
		EndIF

		Aadd(aEtiqueta, { cEtiqueta, SDA->DA_SALDO, CB0->(Recno()), SDA->(Recno()), CB0->CB0_CODPRO, CB0->CB0_LOCAL })
	EndDo

	DbSelectArea("CB0")
	DbSetOrder(1)
	DbGoto(aEtiqueta[1][3])

	DbSelectArea("SB1")
	DbSetOrder(1)
	DbSeek(xFilial() + CB0->CB0_CODPRO)
	M->CB0_QTDE := 0
	For nPos := 1 To Len(aEtiqueta)
		M->CB0_QTDE += aEtiqueta[nPos][2]
	Next

	SugEnd()

   	VtRestore(,,,,aTela)
	VtClear()
	M->BF_LOCALIZ := Space(Len(SBE->BE_LOCALIZ))

	@ 00,00 VtSay Padc("EndereÁamento [" + aEtiqueta[1][1] + "]",VTMaxCol())
	@ 01,00 VtSay "Produto: " + CB0->CB0_CODPRO
	@ 02,00 VtSay "Qtde: " + AllTrim(Str(M->CB0_QTDE))
	@ 03,00 VtSay "Confirme o endereÁo:"
	@ 04,00 VtGet M->BF_LOCALIZ Pict PesqPict("SBE", "BE_LOCALIZ") F3 "SBE" Valid ExistCpo("SBE", CB0->CB0_LOCAL + M->BF_LOCALIZ, 1)

   	VTSetKey(21,{|| LstEnd()}, "Apresenta lista de endereÁos permitidos")
   	VtRead

   	VtRestore(,,,,aTela)
   	If Empty(M->BF_LOCALIZ)
		Loop
   	EndIf

	DbSelectArea("SBE")
	DbSetOrder(1)
	DbSeek(xFilial() + CB0->CB0_LOCAL + M->BF_LOCALIZ)

	If lBlqTEnd
	   If SB1->B1_XTPEND $ "1,2" .And. SB1->B1_XTPEND <> SBE->BE_XTPEND
			VtAlert("AtenÁ„o. O tipo de endereÁamento do produto [" + AllTrim(CB0->CB0_CODPRO) + "] n„o È permitido para o endereÁo [" + AllTrim(M->BF_LOCALIZ) + "] !")
			Loop
		EndIf
	EndIf

	cQuery := "SELECT SUM(BF_QUANT) AS BF_QUANT FROM " + RetSqlName( "SBF" ) + " "
	cQuery +=  "WHERE D_E_L_E_T_ = ' ' AND BF_FILIAL = '" + xFilial( "SBF" ) + "' AND BF_LOCAL = '" + CB0->CB0_LOCAL + "' "
	cQuery +=    "AND BF_LOCALIZ = '" + M->BF_LOCALIZ + "' AND BF_PRODUTO <> '" + CB0->CB0_CODPRO + "' AND BF_QUANT > 0"

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QRY",.F.,.T. )
	M->BF_QUANT := QRY->BF_QUANT
	QRY->(DbCloseArea())
	If ! U_EndMPrd(CB0->CB0_CODPRO, CB0->CB0_LOCAL, M->BF_LOCALIZ)
		Loop
	EndIf

  	If ! VTYesNo("Confirma o endereÁamento do produto [" + AllTrim(CB0->CB0_CODPRO) + "] no endereÁo [" + AllTrim(M->BF_LOCALIZ) + "] ?","Aviso",.t.)
		Loop
  	EndIf

  	BeginTran()
  	For nPos := 1 To Len(aEtiqueta)
		CB0->(DbGoto(aEtiqueta[nPos][3]))
     	SDA->(DbGoto(aEtiqueta[nPos][4]))

     	VTMsg("End Etiqueta [" + aEtiqueta[nPos][1] + "] ...")
     	VTProcessMessage()

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

	  	nOpc := 3
	  	M->DB_ITEM := "0000"
	  	DbSelectArea("SDB")
	  	DbOrderNickName("DB_NUMSEQ")
	  	If DbSeek(xFilial() + CB0->(CB0_NUMSEQ + CB0_LOCAL))
			While SDB->DB_FILIAL = xFilial() .And. SDB->(DB_NUMSEQ + DB_LOCAL) == CB0->(CB0_NUMSEQ + CB0_LOCAL) .And. ! SDB->(Eof())
				If SDB->DB_PRODUTO == CB0->CB0_CODPRO .And. SDB->DB_TM <= "500" .And. SDB->DB_TIPO == "D" .And. If(Rastro(SDA->DA_PRODUTO),SDA->DA_LOTECTL==SDB->DB_LOTECTL,.T.)
					M->DB_ITEM := SDB->DB_ITEM
        	    	Aadd(_aItem, { 	{"DB_ITEM"		, SDB->DB_ITEM		, nil},;
        	    					{"DB_ESTORNO"	, SDB->DB_ESTORNO	, nil},;
	  							   	{"DB_LOCALIZ"	, SDB->DB_LOCALIZ	, nil},;
									{"DB_QUANT"		, SDB->DB_QUANT		, nil},;
									{"DB_DATA"		, SDB->DB_DATA		, nil} })
				EndIf
				
        	    SDB->(DbSkip())
         	EndDo
      	EndIf

      	M->DB_ITEM := Soma1(M->DB_ITEM)
      	Aadd(_aItem, { 	{"DB_ITEM"		, M->DB_ITEM		, nil},;
                        {"DB_LOCALIZ"	, M->BF_LOCALIZ		, nil},;
   						{"DB_QUANT"		, SDA->DA_SALDO		, nil},;
	   					{"DB_DATA"		, dDataBase			, nil},;
		   				{"DB_XCODETI"	, CB0->CB0_CODETI	, nil},;
			   			{"DB_XVOLUME"	, CB0->CB0_VOLUME	, nil} })

      	lMsErroAuto := .F.
      	MsExecAuto({|x, y, z| Mata265(x, y, z)}, _aCabec, _aItem, nOpc)
      	
      	If lMsErroAuto
         	MostraErro()
		 	DisarmTransaction()
		 	Exit
		//-- AtualizaÁ„o do endereÁo atual da etiqueta
		ElseIf TCSQLExec("UPDATE " + RetSqlName("CB0") + " " +;
       	    			    "SET CB0_LOCALI = '" + M->BF_LOCALIZ + "' " +;
			       	      "WHERE D_E_L_E_T_ = ' ' AND CB0_CODETI = '" + CB0->CB0_CODETI + "'") <> 0
			MsgAlert(TCSQLError())
			DisarmTran()
			Break
      	EndIf
   	Next
   	EndTran()
EndDo

Return

Static Function SugEnd()
/*/f/
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
<Descricao> : Apresenta endereÁo para sugest„o de endereÁamento
<Autor> : Wagner Mobile Costa
<Data> : 05/10/2013
<Parametros> : Nenhum
<Retorno> : Nenhum
<Processo> : Especifico Valmari - EndereÁamento
<Tipo> (Menu,Trigger,Validacao,Ponto de Entrada,Genericas,Especificas ) : V
<Obs> :
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
*/
Local cQuery := ""

cQuery += "SELECT BF_LOCAL, BF_LOCALIZ, SUM(BF_QUANT) AS BF_QUANT FROM " + RetSqlName( "SBF" ) + " "
cQuery +=  "WHERE D_E_L_E_T_ = ' ' AND BF_FILIAL = '" + xFilial("SBF") + "' AND BF_PRODUTO = '" + CB0->CB0_CODPRO + "' AND BF_QUANT > 0 "
cQuery +=  "GROUP BY BF_LOCAL, BF_LOCALIZ, BF_LOTECTL "
cQuery +=  "ORDER BY BF_LOCAL, BF_LOCALIZ, BF_LOTECTL"

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QRY",.F.,.T. )
M->BF_LOCALIZ := QRY->BF_LOCALIZ
QRY->(DbCloseArea())
If Empty(M->BF_LOCALIZ)
	Return
EndIf

@ 00,00 VtSay Padc("EndereÁamento [" + CB0->CB0_CODETI + "]",VTMaxCol())
@ 01,00 VtSay "Produto: " + CB0->CB0_CODPRO
@ 02,00 VtSay "Qtde: " + AllTrim(Str(M->CB0_QTDE))

@ 03,00 VtSay "EndereÁo Sugerido:"
@ 04,00 VtSay M->BF_LOCALIZ	Pict PesqPict("SBE", "BE_LOCALIZ")

@ 06,00 VtSay "Pressione qualquer tecla"
@ 07,00 VtSay "para continuar ..."

VtInkey(0)

Return	

Static Function LstEnd()
/*/f/
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
<Descricao> : Apresenta lista de endereÁos permitidos para endereÁamento
<Autor> : Wagner Mobile Costa
<Data> : 03/10/2013
<Parametros> : Nenhum
<Retorno> : Nenhum
<Processo> : Especifico Valmari - EndereÁamento
<Tipo> (Menu,Trigger,Validacao,Ponto de Entrada,Genericas,Especificas ) : V
<Obs> :
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
*/

Local aHeader := { U_X3Titulo("BE_LOCAL"), U_X3Titulo("BE_LOCALIZ"), U_X3Titulo("BF_QUANT"), U_X3Titulo("BF_EMPENHO") }, aCols := {}
Local cQuery  := "", aPict := { PesqPict("SBF","BF_QUANT"), PesqPict("SBF","BF_EMPENHO") }, aTela := VTSave()

cQuery := "SELECT SBE.BE_LOCAL, SBE.BE_LOCALIZ, COALESCE(SUM(SBFSUM.BF_QUANT), 0) AS BF_QUANT, COALESCE(SUM(SBFSUM.BF_EMPENHO), 0) AS BF_EMPENHO "
cQuery +=   "FROM " + RetSqlName( "SBE" ) + " SBE "
cQuery +=   "LEFT JOIN (SELECT BF_LOCAL, BF_LOCALIZ, BF_PRODUTO FROM " + RetSqlName( "SBF" ) + " "
cQuery +=  				"WHERE D_E_L_E_T_ = ' ' AND BF_FILIAL = '" + xFilial("SBF") + "' AND BF_QUANT > 0 "
cQuery +=  				"GROUP BY BF_LOCAL, BF_LOCALIZ, BF_PRODUTO) SBF ON SBF.BF_LOCAL = SBE.BE_LOCAL "
cQuery +=    "AND SBF.BF_LOCALIZ = SBE.BE_LOCALIZ "
cQuery +=   "LEFT JOIN (SELECT BF_LOCAL, BF_LOCALIZ, SUM(BF_QUANT) AS BF_QUANT, SUM(BF_EMPENHO) AS BF_EMPENHO FROM " + RetSqlName( "SBF" ) + " "
cQuery +=  				"WHERE D_E_L_E_T_ = ' ' AND BF_FILIAL = '" + xFilial("SBF") + "' AND BF_QUANT > 0 "
cQuery +=  				"GROUP BY BF_LOCAL, BF_LOCALIZ) SBFSUM ON SBFSUM.BF_LOCAL = SBE.BE_LOCAL "
cQuery +=    "AND SBFSUM.BF_LOCALIZ = SBE.BE_LOCALIZ "
cQuery +=  "WHERE SBE.D_E_L_E_T_ = ' ' AND SBE.BE_FILIAL = '" + xFilial("SBE") + "' "
cQuery +=    "AND (SBF.BF_PRODUTO = '" + CB0->CB0_CODPRO + "' OR SBF.BF_LOCALIZ IS NULL) "
If SB1->B1_XTPEND $ "1,2"		// 1-Picking ou 2-Pulmao
   cQuery += "AND SBE.BE_XTPEND = '" + SB1->B1_XTPEND + "' "
EndIf
cQuery +=  "GROUP BY SBE.BE_LOCAL, SBE.BE_LOCALIZ"

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QRY",.F.,.T. )

aCols := {}
While ! QRY->(Eof())
   aadd(aCols, { QRY->BE_LOCAL, QRY->BE_LOCALIZ, Trans(QRY->BF_QUANT, aPict[1]), Trans(QRY->BF_EMPENHO, aPict[2]) } )

	QRY->(DbSkip())
EndDo
QRY->(DbCloseArea())

If Len(aCols) == 0
	VtAlert("N„o existe nenhum endereÁo valido para o produto [" + CB0->CB0_CODPRO + "] !","Aviso",.t.,4000)
	Return
Else
   	aSize := { Len(aCols[1][1]), Len(aCols[1][2]), Len(aCols[1][3]), Len(aCols[1][4]) }
   	For nPos := 1 To Len(aHeader)
      	If aSize[nPos] < Len(AllTrim(aHeader[nPos]))
         	aSize[nPos] := Len(AllTrim(aHeader[nPos]))
      	EndIf
   	Next

   	nPos := VTaBrowse(3,0,VTMaxRow(),VtmaxCol(),aHeader,aCols, aSize )
   	VtRestore(,,,,aTela)
EndIf

Return

Static Function VldEtiqueta(cEtiqueta, aEtiqueta)
/*/f/
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
<Descricao> : FunÁ„o para validaÁ„o do cÛdigo da etiqueta preenchida
<Autor> : Wagner Mobile Costa
<Data> : 10/08/2013
<Parametros> : cEtiqueta = CÛdigo da Etiqueta e aEtiqueta = Lista de Etiqueta
<Retorno> : Nenhum
<Processo> : Especifico Valmari - EndereÁamento
<Tipo> (Menu,Trigger,Validacao,Ponto de Entrada,Genericas,Especificas ) : V
<Obs> :
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
*/

Local lRet := .T.

If Empty(cEtiqueta)
	Return .T.
EndIF

DbSelectArea("CB0")
DbSetOrder(1)
If ! DbSeek(xFilial() + cEtiqueta)
	VtAlert("N˙mero da etiqueta invalida !","Aviso",.t.,4000)
	lRet := .F.
Else
	If Len(aEtiqueta) > 0
		If Ascan(aEtiqueta, {|x| x[1] == cEtiqueta}) > 0
			VtAlert("A etiqueta [" + cEtiqueta + "] j· foi selecionada !","Aviso",.t.,4000)
			lRet := .F.
		EndIf

		If CB0->(CB0_CODPRO + CB0_LOCAL) <> aEtiqueta[1][5] + aEtiqueta[1][6]
			VtAlert("Para endereÁamento m˙ltiplo deve ser escolhido o mesmo produto/local [" + AllTrim(aEtiqueta[1][5]) + "/" + aEtiqueta[1][6] + "] !",;
					"Aviso",.t.,4000)
			lRet := .F.
		EndIf
	EndIf

	If Empty(CB0->CB0_OP) .And. Empty(CB0->CB0_NFENT)
		VtAlert("Etiqueta sem OP ou N˙mero de Nota !","Aviso",.t.,4000)
		lRet := .F.
	EndIf
EndIf

If lRet
	DbSelectArea("SDA")
	DbOrderNickName("DA_NUMSEQ")
	If ! DbSeek(xFilial() + CB0->(CB0_NUMSEQ + CB0_LOCAL))
		VtAlert("EndereÁamento da sequencia [" + CB0->CB0_NUMSEQ + "] n„o encontrado !","Aviso",.t.,4000)
		lRet := .F.
	ElseIf SDA->DA_SALDO == 0
		VtAlert("Saldo j· distribuido !","Aviso",.t.,4000)
		lRet := .F.
	EndIf
EndIf

Return lRet