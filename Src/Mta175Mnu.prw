#Include "Protheus.ch"

Static aEtiqueta := {}

User Function MTA175MNU
/*/f/
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
<Descricao> : Ponto de entrada para inclus„o opÁıes de menu na tela de liberaÁ„o de CQ
<Autor> : Wagner Mobile Costa
<Data> : 06/08/2013
<Parametros> : Nenhum
<Retorno> : Nenhum
<Processo> : Especifico Valmari - EndereÁamento
<Tipo> (Menu,Trigger,Validacao,Ponto de Entrada,Genericas,Especificas ) : P
<Obs> :
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
*/

Aadd(aRotina, {"Reeimprimir Etq Rejeitada", "U_A175GEtq(SD7->D7_XCODETI, SD7->D7_NUMERO, 0, .T.)", 0, 2, 0, .F.})

Return

User Function A175GEtq(cD7_XCODETI, cD7_NUMERO, nRecMax, lReprint)
/*/f/
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
<Descricao> : Rotina para reeimpress„o de etiqueta rejeitada
<Autor> : Wagner Mobile Costa
<Data> : 25/10/2013
<Parametros> : Nenhum
<Retorno> : Nenhum
<Processo> : Especifico Valmari - EndereÁamento
<Tipo> (Menu,Trigger,Validacao,Ponto de Entrada,Genericas,Especificas ) : P
<Obs> :
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
*/

Local cQuery := cNewEtiqueta := cOldEtiqueta := cReturn := cD7_XCODETI := "", nPD7_XCODETI := 0

If lReprint
	If SD7->D7_TIPO <> 2 .Or. Empty(SD7->D7_XCODETI)
		MsgInfo("Para reeimpress„o da etiqueta deve ser selecionado a linha com Tipo 2=RejeiÁ„o e etiqueta preenchida !")

		Return .F.
	EndIf

	M->D7_ORIGLAN := SD7->D7_ORIGLAN
Else
   nPD7_XCODETI := GdFieldPos("D7_XCODETI")
EndIf

aEtiqueta := {}
CB0->(DbSetOrder(1))

If ! lReprint
	// GeraÁ„o de novas etiquetas para os itens rejeitados
	cQuery := "SELECT SD7.D7_XCODETI, SUM(CASE WHEN SD7.D7_TIPO = '1' THEN SD7.D7_QTDE ELSE 0 END) AS D7_QUANT, "
	cQuery +=                        "SUM(CASE WHEN SD7.D7_TIPO = '2' THEN SD7.D7_QTDE ELSE 0 END) AS D7_QUANT_REJ, "
	cQuery +=                        "MAX(CASE WHEN SD7.D7_TIPO = '1' THEN SD7.R_E_C_N_O_ ELSE 0 END) AS D7_RECNO, "
	cQuery +=                        "MAX(CASE WHEN SD7.D7_TIPO = '2' THEN SD7.R_E_C_N_O_ ELSE 0 END) AS D7_RECNO_REJ "
	cQuery +=   "FROM " + RetSqlName( "SD7" ) + " SD7 "
	cQuery +=  "WHERE SD7.D_E_L_E_T_ = ' ' AND SD7.D7_FILIAL = '" + xFilial( "SD7" ) + "' AND SD7.D7_NUMERO = '" + cD7_NUMERO + "' AND SD7.D7_XCODETI <> '' "
	If nRecMax == 0
		cQuery += "AND SD7.D7_XCODETI = '" + SD7->D7_XCODETI + "' "
	EndIf

	cQuery +=    "AND SD7.D7_NUMERO + SD7.D7_XCODETI IN (SELECT D7_NUMERO + D7_XCODETI FROM " + RetSqlName( "SD7" ) + " "
	cQuery +=                                            "WHERE D_E_L_E_T_ = ' ' AND D7_FILIAL = '" + xFilial( "SD7" ) + "' AND D7_NUMERO = '" + cD7_NUMERO + "' "
	cQuery +=                                              "AND D7_TIPO = '2' AND D7_XCODETI <> '') "
	If nRecMax == 0
		cQuery += "AND SD7.D7_XCODETI = '" + SD7->D7_XCODETI + "' "
	Else
		For nPos := 1 To Len(aCols)
			If At("'" + aCols[nPos][nPD7_XCODETI] + "'", cD7_XCODETI) > 0
				Loop
			EndIf
			If ! Empty(cD7_XCODETI)
				cD7_XCODETI += ", "
			EndIf
			cD7_XCODETI += "'" + aCols[nPos][nPD7_XCODETI] + "'"
		Next
		
		cQuery += "AND SD7.D7_XCODETI in (" + cD7_XCODETI + ") "
	EndIf
	cQuery +=  "GROUP BY SD7.D7_XCODETI "
	cQuery += "HAVING SUM(CASE WHEN SD7.D7_TIPO = '1' AND SD7.R_E_C_N_O_ > " + AllTrim(Str(nRecMax)) + " THEN SD7.D7_QTDE ELSE 0 END) > 0"
	
	cQuery := ChangeQuery( cQuery )
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QRYSD7",.F.,.T. )
	                                                                      
	BeginTran()

	While ! QRYSD7->(Eof())
		CB0->(DbSeek(xFilial() + QRYSD7->D7_XCODETI))
	
		M->CB0_CODETI := U_CBGrvEti("01", { 	CB0->CB0_CODPRO 			/* 01,CB0_CODPRO */,;
												QRYSD7->D7_QUANT 				/* 02,CB0_QTDE */,;
												   							/* 03,CB0_USUARIO */,;
												CB0->CB0_NFENT				/* 04,CB0_NFENT */,;
												CB0->CB0_SERIEE				/* 05,CB0_SERIEE */,;
												CB0->CB0_FORNEC				/* 06,CB0_FORNEC */,;
												CB0->CB0_LOJAFO				/* 07,CB0_LOJAFO */,;
												/* 08,CB0_PEDCOM */,;
												/* 09,CB0_LOCALI */,;
												CB0->CB0_LOCAL				/* 10,CB0_LOCAL */,;
												CB0->CB0_OP 					/* 11,CB0_OP */,;
												CB0->CB0_NUMSEQ				/* 12,CB0_NUMSEQ */,;
												/* 13,CB0_NFSAI */,;
												/* 14,CB0_SERIES */,;
												QRYSD7->D7_XCODETI				 /* 15,CB0_CODET2 */,;
												CB0->CB0_LOTE				/* 16,CB0_LOTE */,;
												/* 17,CB0_SLOTE */,;
												CB0->CB0_DTVLD				/* 18,CB0_DTVLD */,;
												/* 19,CB0_CC */,;
												/* 20,CB0_LOCORI */,;
												/* 21,CB0_PALLET */,;
												/* 22,CB0_OPREQ */,;
												/* 23,CB0_NUMSER */,;
												/* 24,CB0_ORIGEM */,;
												/* 25,CB0_ITNFE */,;
												CB0->CB0_VOLUME		 		/* 26,CB0_VOLUME */,;
												CB0->CB0_XEAN14				/* 27,CB0_XEAN14 */,;
												CB0->CB0_XNUMCQ				/* 28,CB0_XNUMCQ */,;
												CB0->CB0_XDFABR				/* 29,CB0_XDFABR */,;
												CB0->CB0_XLOTEF				/* 30,CB0_XLOTEF */})
	
		If ! Empty(cNewEtiqueta)
			cNewEtiqueta += ","
		EndIf
		cNewEtiqueta += M->CB0_CODETI
	
		If ! Empty(cOldEtiqueta)
			cOldEtiqueta += ","
		EndIf
		cOldEtiqueta += QRYSD7->D7_XCODETI

		LoadEtq()		
	
		If M->D7_ORIGLAN == "CP" .Or. M->D7_ORIGLAN == "PR"
			CB0->(DbSeek(xFilial() + QRYSD7->D7_XCODETI))
			CB0->(RecLock("CB0", .F.))
			CB0->(DbDelete())
			CB0->(MsUnLock())
			
			CB0->(DbSeek(xFilial() + M->CB0_CODETI))

			SD7->(DbGoto(QRYSD7->D7_RECNO_REJ))
			SD7->(RecLock("SD7", .F.))
			SD7->D7_XCODET2 := M->CB0_CODETI
			SD7->(MsUnLock())

			SD7->(DbGoto(QRYSD7->D7_RECNO))
			SD7->(RecLock("SD7", .F.))
			SD7->D7_XCODET2 := M->CB0_CODETI
			SD7->(MsUnLock())
		EndIf
			
		QRYSD7->(DbSkip())
	EndDo
	EndTran()
	
	QRYSD7->(DbCloseArea())
Else
	CB0->(DbSeek(xFilial() + SD7->D7_XCODET2))
	LoadEtq()		
EndIf
	
U_REtiquetas(If(M->D7_ORIGLAN == "CP", "SD1", "SD3"), aEtiqueta, If(M->D7_ORIGLAN == "CP", "SD1", "SD3"))

If lReprint
	MsgInfo("A etiqueta [" + SD7->D7_XCODETI + "] foi enviada para impressora !")
ElseIf ! Empty(cNewEtiqueta)
	cReturn := "A(s) etiqueta(s)s [" + cNewEtiqueta + "] foi(ram) enviada(s) para impressora substituindo a(s) etiqueta(s) + [" + cOldEtiqueta + "] !"
EndIf

Return cReturn

Static Function LoadEtq()
/*/f/
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
<Descricao> : Rotina para reeimpress„o de etiqueta rejeitada
<Autor> : Wagner Mobile Costa
<Data> : 25/10/2013
<Parametros> : Nenhum
<Retorno> : Nenhum
<Processo> : Especifico Valmari - EndereÁamento
<Tipo> (Menu,Trigger,Validacao,Ponto de Entrada,Genericas,Especificas ) : P
<Obs> :
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
*/

Local cQuery := cWhere := "", nVolumes := 0

cQuery := "SELECT MAX(CB0_VOLUME) AS CB0_VOLUME "
cQuery +=   "FROM " + RetSqlName( "CB0" ) + " "
cQuery +=  "WHERE CB0_FILIAL = '" + xFilial("CB0") + "' AND D_E_L_E_T_ = ' ' AND CB0_XNUMSQ = '" + CB0->CB0_XNUMSQ + "' "
	
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QRY",.F.,.T. )
nVolumes := Val(QRY->CB0_VOLUME)
QRY->(DbCloseArea())	
                                                  
If M->D7_ORIGLAN == "CP"
	cWhere := "WHERE SD1.D1_FILIAL = '" + xFilial("SD1") + "' AND SD1.D_E_L_E_T_ = ' ' AND SD1.D1_DOC = '" + CB0->CB0_NFENT + "' "
	cWhere +=   "AND SD1.D1_SERIE = '" + CB0->CB0_SERIEE + "' AND SD1.D1_FORNECE = '" + CB0->CB0_FORNEC + "' AND SD1.D1_LOJA = '" + CB0->CB0_LOJAFO + "'"
	cWhere +=   "AND SD1.D1_NUMSEQ = '" + CB0->CB0_XNUMSQ + "'"

	cQuery := "SELECT CB0.CB0_CODPRO AS D1_COD, CB0.CB0_LOTE AS D1_LOTECTL, SB1.B1_DESC, CB0.CB0_XLOTEF AS D1_LOTEFOR, CB0.CB0_NFENT AS D1_DOC, "
	cQuery +=        "CB0.CB0_SERIEE AS D1_SERIE, CB0.CB0_DTVLD AS D1_DTVALID, CB0.CB0_XDFABR AS D1_DFABRIC, CB0.CB0_QTDE AS D1_QUANT, SD1.D1_UM, "
	cQuery +=        "CB0.CB0_XEAN14 AS D1_XEAN14, CB0.CB0_DTNASC AS D1_DTDIGIT, CB0.CB0_LOCAL AS D1_LOCAL, CB0.CB0_FORNEC AS D1_FORNECE, "
	cQuery +=        "CB0.CB0_LOJAFO AS D1_LOJA, CB0.CB0_XNUMSQ AS D1_NUMSEQ, CB0.CB0_XNUMCQ AS D1_NUMCQ, CB0.CB0_CODETI, CB0.CB0_VOLUME "
	cQuery +=   "FROM " + RetSqlName( "SD1" ) + " SD1 "
	cQuery +=   "JOIN " + RetSqlName( "CB0" ) + " CB0 ON CB0.D_E_L_E_T_ = ' ' AND CB0.CB0_FILIAL = SD1.D1_FILIAL AND CB0.CB0_XNUMSQ = SD1.D1_NUMSEQ "
	cQuery +=   "JOIN " + RetSqlName( "SB1" ) + " SB1 ON SB1.D_E_L_E_T_ = ' ' AND SB1.B1_FILIAL = '" + xFilial("SB1") + "' AND SB1.B1_COD = SD1.D1_COD AND SB1.B1_LOCALIZ = 'S' "
	cQuery += cWhere + " AND CB0.R_E_C_N_O_ = " + AllTrim(Str(CB0->(Recno()))) + " "
	cQuery +=  "ORDER BY CB0.CB0_CODETI, CB0_VOLUME"
	
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QRY",.F.,.T. )
	TCSetField("QRY", "D1_DTVALID", "D", 8, 0)
	TCSetField("QRY", "D1_DFABRIC", "D", 8, 0)
	TCSetField("QRY", "D1_DTDIGIT", "D", 8, 0)

	Aadd(aEtiqueta, { 	QRY->CB0_CODETI /* 01 */, Val(QRY->CB0_VOLUME) /* 02 */, nVolumes /* 03 */, QRY->D1_COD /* 04 */, QRY->B1_DESC /* 05 */,;
						QRY->D1_LOTECTL /* 06 */, QRY->D1_DTVALID /* 07 */, QRY->D1_NUMSEQ /* 08 */, QRY->D1_QUANT /* 09 */, QRY->D1_XEAN14 /* 10 */,;
						QRY->D1_UM /* 11 */, QRY->D1_LOCAL /* 12 */, QRY->D1_NUMCQ /* 13 */, "" /* 14 */, QRY->D1_LOTEFOR /* 15 */, QRY->D1_DOC /* 16 */,;
						QRY->D1_SERIE /* 17 */, QRY->D1_FORNECE /* 18 */, QRY->D1_LOJA /* 19 */,  QRY->D1_DFABRIC /* 20 */, QRY->D1_DTDIGIT /* 21 */ })

	QRY->(DbCloseArea())
ElseIf M->D7_ORIGLAN == "PR"
	cWhere := "WHERE SD3.D3_FILIAL = '" + xFilial("SD3") + "' AND SD3.D_E_L_E_T_ = ' ' AND SD3.D3_NUMSEQ = '" + CB0->CB0_XNUMSQ + "'"

	cQuery := "SELECT SB1.B1_DESC, CB0.CB0_CODPRO AS D3_COD, CB0.CB0_LOTE AS D3_LOTECTL, CB0.CB0_DTVLD AS D3_DTVALID, CB0.CB0_XEAN14 AS B5_EAN141, "
	cQuery +=        "CB0.CB0_QTDE AS D3_QUANT, SD3.D3_UM, SD3.D3_NUMSEQ, CB0.CB0_LOCAL AS D3_LOCAL, CB0.CB0_OP AS D3_OP, CB0.CB0_XNUMCQ AS D7_NUMERO, "
	cQuery +=        "CB0.CB0_CODETI, CB0.CB0_VOLUME "
	cQuery +=   "FROM " + RetSqlName( "SD3" ) + " SD3 "
	cQuery +=   "JOIN " + RetSqlName( "CB0" ) + " CB0 ON CB0.D_E_L_E_T_ = ' ' AND CB0.CB0_FILIAL = SD3.D3_FILIAL AND CB0.CB0_XNUMSQ = SD3.D3_NUMSEQ "
	cQuery +=   "JOIN " + RetSqlName( "SB1" ) + " SB1 ON SB1.D_E_L_E_T_ = ' ' AND SB1.B1_FILIAL = '" + xFilial("SB1") + "' AND SB1.B1_COD = SD3.D3_COD "
	cQuery +=    "AND SB1.B1_LOCALIZ = 'S' "
	cQuery += cWhere + " AND CB0.R_E_C_N_O_ = " + AllTrim(Str(CB0->(Recno()))) + " "
	cQuery +=  "ORDER BY CB0.CB0_CODETI, CB0_VOLUME"

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QRY",.F.,.T. )
	TCSetField("QRY", "D3_DTVALID", "D", 8, 0)

	Aadd(aEtiqueta, { 	QRY->CB0_CODETI /* 01 */, Val(QRY->CB0_VOLUME) /* 02 */, nVolumes /* 03 */, QRY->D3_COD /* 04 */, QRY->B1_DESC /* 05 */,;
						QRY->D3_LOTECTL /* 06 */, QRY->D3_DTVALID /* 07 */, QRY->D3_NUMSEQ /* 08 */, QRY->D3_QUANT /* 09 */, QRY->B5_EAN141 /* 10 */,;
						QRY->D3_UM /* 11 */, QRY->D3_LOCAL /* 12 */, QRY->D7_NUMERO /* 13 */, "" /* 14 */, QRY->D3_OP /* 15 */ })

	QRY->(DbCloseArea())
EndIf

Return