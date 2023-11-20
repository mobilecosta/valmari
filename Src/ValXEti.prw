#Include "Protheus.ch"

User Function VALXETI(cAlias, lRePrint, cImp)
/*/f/
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
<Descricao> : Rotina para impress„o das etiquetas de endereÁamento (SD1 = Recebimento ou SD3 = ProduÁ„o)
<Autor> : Wagner Mobile Costa
<Data> : 17/08/2013
<Parametros> : cAlias = Tabela de Origem e lRePrint = Indica a reeimpress„o da etiqueta
<Retorno> : Nenhum
<Processo> : Especifico Valmari - EndereÁamento
<Tipo> (Menu,Trigger,Validacao,Ponto de Entrada,Genericas,Especificas ) : E
<Obs> :
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
*/

Local cQuery := cQueryPer := cWhere := "", aEtiquetas := {}, nVolumes := nEtiquetas := 0

Default cImp := cAlias

#DEFINE P_CB0_CODETI 	01
#DEFINE P_CB0_VOLUME 	02
#DEFINE P_CB0_VOLUMES	03
#DEFINE P_B1_COD		04
#DEFINE P_B1_DESC   	05 
#DEFINE P_LOTECTL		06
#DEFINE P_DTVALID		07
#DEFINE P_NUMSEQ 		08
#DEFINE P_QUANT  		09
#DEFINE P_XEAN14 		10
#DEFINE P_UM     		11
#DEFINE P_LOCAL  		12
#DEFINE P_NUMCQ 		13
#DEFINE P_LOCALIZ		14

//-- Recebimento de Mercadorias
If cAlias == "SD1"
	SA2->(DbSetOrder(1))
	SA2->(DbSeek(xFilial() + SF1->F1_FORNECE + SF1->F1_LOJA))

	cWhere := "WHERE SD1.D1_FILIAL = '" + xFilial("SD1") + "' AND SD1.D_E_L_E_T_ = ' ' AND SD1.D1_DOC = '" + SF1->F1_DOC + "' "
	cWhere +=   "AND SD1.D1_SERIE = '" + SF1->F1_SERIE + "' AND SD1.D1_FORNECE = '" + SF1->F1_FORNECE + "' AND SD1.D1_LOJA = '" + SF1->F1_LOJA + "'"
	
	cQuery := "SELECT COUNT(*) AS CONTADOR "
	cQuery +=   "FROM " + RetSqlName( "SD1" ) + " SD1 "
	cQuery +=   "JOIN " + RetSqlName( "CB0" ) + " CB0 ON CB0.D_E_L_E_T_ = ' ' AND CB0.CB0_FILIAL = SD1.D1_FILIAL AND CB0.CB0_XNUMSQ = SD1.D1_NUMSEQ "
	cQuery +=   "JOIN " + RetSqlName( "SB1" ) + " SB1 ON SB1.D_E_L_E_T_ = ' ' AND SB1.B1_FILIAL = '" + xFilial("SB1") + "' AND SB1.B1_COD = SD1.D1_COD "
	cQuery +=    "AND SB1.B1_LOCALIZ = 'S' "
	cQuery += cWhere	
	
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QRY",.F.,.T. )
	If (! lRePrint .And. QRY->CONTADOR > 0) .Or. (lRePrint .And. QRY->CONTADOR == 0)
		Alert("AtenÁ„o. As etiquetas de endereÁamento para a nota [" + AllTrim(SF1->F1_DOC) + "] " + If(lReprint, "n„o", "j·") + " foram geradas !")
		
		QRY->(DbCloseArea())

		Return .F.
	EndIf

	QRY->(DbCloseArea())
	
	If ! MsgYesNo("Confirma a " + If(lReprint, "reeimpress„o", "geraÁ„o") + " da(s) etiqueta(s) para o documento/sÈrie [" +;
		  AllTrim(SF1->F1_DOC) + "/" + AllTrim(SF1->F1_SERIE) + "] ?")
		Return .F.
	EndIf

	If lReprint
		cQuery := "SELECT CB0.CB0_CODPRO AS D1_COD, CB0.CB0_LOTE AS D1_LOTECTL, SB1.B1_DESC, CB0.CB0_XLOTEF AS D1_LOTEFOR, CB0.CB0_NFENT AS D1_DOC, "
		cQuery +=        "CB0.CB0_SERIEE AS D1_SERIE, CB0.CB0_DTVLD AS D1_DTVALID, CB0.CB0_XDFABR AS D1_DFABRIC, CB0.CB0_QTDE AS D1_QUANT, SD1.D1_UM, "
		cQuery +=        "CB0.CB0_XEAN14 AS D1_XEAN14, CB0.CB0_DTNASC AS D1_DTDIGIT, CB0.CB0_LOCAL AS D1_LOCAL, CB0.CB0_FORNEC AS D1_FORNECE, "
		cQuery +=        "CB0.CB0_LOJAFO AS D1_LOJA, CB0.CB0_XNUMSQ AS D1_NUMSEQ, CB0.CB0_XNUMCQ AS D1_NUMCQ, CB0.CB0_CODETI, CB0.CB0_VOLUME "
		cQuery +=   "FROM " + RetSqlName( "SD1" ) + " SD1 "
		cQuery +=   "JOIN " + RetSqlName( "CB0" ) + " CB0 ON CB0.D_E_L_E_T_ = ' ' AND CB0.CB0_FILIAL = SD1.D1_FILIAL AND CB0.CB0_XNUMSQ = SD1.D1_NUMSEQ "
		cQuery +=   "JOIN " + RetSqlName( "SB1" ) + " SB1 ON SB1.D_E_L_E_T_ = ' ' AND SB1.B1_FILIAL = '" + xFilial("SB1") + "' AND SB1.B1_COD = SD1.D1_COD AND SB1.B1_LOCALIZ = 'S' "
		cQuery += cWhere + " "
		cQuery +=  "ORDER BY CB0.CB0_CODETI, CB0_VOLUME"
		
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QRY",.F.,.T. )
	Else
		cQuery := "SELECT SD1.D1_COD, SD1.D1_LOTECTL, SB1.B1_DESC, SD1.D1_LOTEFOR, SD1.D1_DOC, SD1.D1_SERIE, SD1.D1_DTVALID, SD1.D1_DFABRIC, SD1.D1_QUANT, "
		cQuery +=        "SD1.D1_UM, SD1.D1_XEAN14, SD1.D1_DTDIGIT, "
		cQuery +=        "CASE WHEN NOT SD7.D7_NUMERO IS NULL THEN SD7.D7_LOCDEST ELSE SD1.D1_LOCAL END AS D1_LOCAL, SD1.D1_FORNECE, SD1.D1_LOJA, "
		cQuery +=        "SD1.D1_NUMSEQ, SD1.D1_NUMCQ, ' ' AS CB0_CODETI, '' AS CB0_VOLUME "
		cQuery +=   "FROM " + RetSqlName( "SD1" ) + " SD1 "
		cQuery +=   "JOIN " + RetSqlName( "SB1" ) + " SB1 ON SB1.D_E_L_E_T_ = ' ' AND SB1.B1_FILIAL = '" + xFilial("SB1") + "' AND SB1.B1_COD = SD1.D1_COD AND SB1.B1_LOCALIZ = 'S' "
		cQuery +=   "LEFT JOIN " + RetSqlName( "SD7" ) + " SD7 ON SD7.D_E_L_E_T_ = ' ' AND SD7.D7_FILIAL = SD1.D1_FILIAL AND SD7.D7_NUMERO = SD1.D1_NUMCQ "
		cQuery +=    "AND SD7.D7_NUMSEQ = SD1.D1_NUMSEQ AND SD7.D7_TIPO = 0 "
		cQuery += cWhere + " "
		cQuery +=  "ORDER BY SD1.D1_COD"
		
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QRY",.F.,.T. )
		
		If QRY->(Eof())
			Alert("AtenÁ„o. N„o existem etiquetas de endereÁamento para a nota [" + SF1->F1_DOC + "] !")
			
			QRY->(DbCloseArea())
			Return .F.
		EndIf
	EndIf
		
	TCSetField("QRY", "D1_DTVALID", "D", 8, 0)
	TCSetField("QRY", "D1_DFABRIC", "D", 8, 0)
	TCSetField("QRY", "D1_DTDIGIT", "D", 8, 0)
	M->D1_NUMSEQ := ""
	
	While ! QRY->(Eof())
		#DEFINE P_D1_LOTEFOR	15
		#DEFINE P_D1_DOC    	16
		#DEFINE P_D1_SERIE  	17
		#DEFINE P_D1_FORNECE	18
		#DEFINE P_D1_LOJA   	19
		#DEFINE P_D1_DFABRIC	20
		#DEFINE P_D1_DTDIGIT	21
	
		nVolumes ++
		Aadd(aEtiquetas, { 	QRY->CB0_CODETI /* 01 */, Val(QRY->CB0_VOLUME) /* 02 */, nVolumes /* 03 */, QRY->D1_COD /* 04 */, QRY->B1_DESC /* 05 */,;
							QRY->D1_LOTECTL /* 06 */, QRY->D1_DTVALID /* 07 */, QRY->D1_NUMSEQ /* 08 */, QRY->D1_QUANT /* 09 */, QRY->D1_XEAN14 /* 10 */,;
							QRY->D1_UM /* 11 */, QRY->D1_LOCAL /* 12 */, QRY->D1_NUMCQ /* 13 */, "" /* 14 */, QRY->D1_LOTEFOR /* 15 */, QRY->D1_DOC /* 16 */,;
							QRY->D1_SERIE /* 17 */, QRY->D1_FORNECE /* 18 */, QRY->D1_LOJA /* 19 */,  QRY->D1_DFABRIC /* 20 */, QRY->D1_DTDIGIT /* 21 */ })

		If M->D1_NUMSEQ == QRY->D1_NUMSEQ .Or. Empty(M->D1_NUMSEQ)
			For nEtiquetas := 1 To Len(aEtiquetas)
				If aEtiquetas[nEtiquetas][P_NUMSEQ] == QRY->D1_NUMSEQ .Or. Empty(M->D1_NUMSEQ)
					aEtiquetas[nEtiquetas][P_CB0_VOLUMES] := nVolumes
				EndIf
			Next
		EndIF
		
		M->D1_NUMSEQ := QRY->D1_NUMSEQ
	
		QRY->(DbSkip())
	EndDo
//-- ProduÁ„o
ElseIf cAlias == "SD3"
	cWhere := "WHERE SD3.D3_FILIAL = '" + xFilial("SD3") + "' AND SD3.D_E_L_E_T_ = ' ' AND SD3.D3_NUMSEQ = '" + SD3->D3_NUMSEQ + "' AND SD3.D3_CF = 'PR0'"
	
	cQuery := "SELECT COUNT(*) AS CONTADOR "
	cQuery +=   "FROM " + RetSqlName( "SD3" ) + " SD3 "
	cQuery +=   "JOIN " + RetSqlName( "CB0" ) + " CB0 ON CB0.D_E_L_E_T_ = ' ' AND CB0.CB0_FILIAL = SD3.D3_FILIAL AND CB0.CB0_XNUMSQ = SD3.D3_NUMSEQ "
	cQuery += cWhere
	
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QRY",.F.,.T. )
	If (! lRePrint .And. QRY->CONTADOR > 0) .Or. (lRePrint .And. QRY->CONTADOR == 0)
		Alert("AtenÁ„o. As etiquetas de endereÁamento para a ordem de produÁ„o [" + AllTrim(SD3->D3_OP) + "] " + If(lReprint, "n„o", "j·") +;
			  " foram geradas !")
		
		QRY->(DbCloseArea())

		Return .F.
	EndIf

	QRY->(DbCloseArea())
	
	If ! MsgYesNo("Confirma a " + If(lReprint, "reeimpress„o", "geraÁ„o") + " da(s) etiqueta(s) para o ordem de produÁ„o [" + AllTrim(SD3->D3_OP) + "] ?")
		Return .F.
	EndIf

	If lReprint
		cQuery := "SELECT SB1.B1_DESC, CB0.CB0_CODPRO AS D3_COD, CB0.CB0_LOTE AS D3_LOTECTL, CB0.CB0_DTVLD AS D3_DTVALID, CB0.CB0_XEAN14 AS B5_EAN141, "
		cQuery +=        "CB0.CB0_QTDE AS D3_QUANT, SD3.D3_UM, SD3.D3_NUMSEQ, CB0.CB0_LOCAL AS D3_LOCAL, CB0.CB0_OP AS D3_OP, CB0.CB0_XNUMCQ AS D7_NUMERO, "
		cQuery +=        "CB0.CB0_CODETI, CB0.CB0_VOLUME "
		cQuery +=   "FROM " + RetSqlName( "SD3" ) + " SD3 "
		cQuery +=   "JOIN " + RetSqlName( "CB0" ) + " CB0 ON CB0.D_E_L_E_T_ = ' ' AND CB0.CB0_FILIAL = SD3.D3_FILIAL AND CB0.CB0_XNUMSQ = SD3.D3_NUMSEQ "
		cQuery +=   "JOIN " + RetSqlName( "SB1" ) + " SB1 ON SB1.D_E_L_E_T_ = ' ' AND SB1.B1_FILIAL = '" + xFilial("SB1") + "' AND SB1.B1_COD = SD3.D3_COD "
		cQuery +=    "AND SB1.B1_LOCALIZ = 'S' "
		cQuery += cWhere + " "
		cQuery +=  "ORDER BY CB0.CB0_CODETI, CB0_VOLUME"

		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QRY",.F.,.T. )
	Else
		cQuery := "SELECT SB1.B1_DESC, SD3.D3_COD, SD3.D3_LOTECTL, SD3.D3_DTVALID, SB5.B5_EAN141, SD3.D3_QUANT, "
		cQuery +=        "SD3.D3_UM, SD3.D3_NUMSEQ, CASE WHEN NOT SD7.D7_NUMERO IS NULL THEN SD7.D7_LOCDEST ELSE SD3.D3_LOCAL END AS D3_LOCAL, SD3.D3_OP, "
		cQuery +=        "SD7.D7_NUMERO, '' AS CB0_CODETI, '' AS CB0_VOLUME "
		cQuery +=   "FROM " + RetSqlName( "SD3" ) + " SD3 "
		cQuery +=   "JOIN " + RetSqlName( "SB1" ) + " SB1 ON SB1.D_E_L_E_T_ = ' ' AND SB1.B1_FILIAL = '" + xFilial("SB1") + "' AND SB1.B1_COD = SD3.D3_COD "
		cQuery +=    "AND SB1.B1_LOCALIZ = 'S' "
		cQuery +=   "LEFT JOIN " + RetSqlName( "SB5" ) + " SB5 ON SB5.D_E_L_E_T_ = ' ' AND SB5.B5_FILIAL = '" + xFilial("SB5") + "' AND SB5.B5_COD = SD3.D3_COD "
		cQuery +=   "LEFT JOIN " + RetSqlName( "SD7" ) + " SD7 ON SB1.D_E_L_E_T_ = ' ' AND SD7.D7_FILIAL = SD3.D3_FILIAL AND SD7.D7_NUMSEQ = SD3.D3_NUMSEQ "
		cQuery +=    "AND SD7.D7_TIPO = 0 "
		cQuery += cWhere
		
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QRY",.F.,.T. )
		
		If QRY->(Eof())
			Alert("AtenÁ„o. N„o existem etiquetas de endereÁamento para a OP/Sequencia [" + SD3->D3_OP + "/" + SD3->D3_NUMSEQ + "] !")
			
			QRY->(DbCloseArea())
			Return .F.
		EndIf
	EndIf
		
	TCSetField("QRY", "D3_DTVALID", "D", 8, 0)
	M->D3_NUMSEQ := ""
	
	While ! QRY->(Eof())
		#DEFINE P_D3_OP	   	15

		nVolumes ++
		Aadd(aEtiquetas, { 	QRY->CB0_CODETI /* 01 */, Val(QRY->CB0_VOLUME) /* 02 */, nVolumes /* 03 */, QRY->D3_COD /* 04 */, QRY->B1_DESC /* 05 */,;
							QRY->D3_LOTECTL /* 06 */, QRY->D3_DTVALID /* 07 */, QRY->D3_NUMSEQ /* 08 */, QRY->D3_QUANT /* 09 */, QRY->B5_EAN141 /* 10 */,;
							QRY->D3_UM /* 11 */, QRY->D3_LOCAL /* 12 */, QRY->D7_NUMERO /* 13 */, "" /* 14 */, QRY->D3_OP /* 15 */ })

		If M->D3_NUMSEQ == QRY->D3_NUMSEQ .Or. Empty(M->D3_NUMSEQ)
			For nEtiquetas := 1 To Len(aEtiquetas)
				If aEtiquetas[nEtiquetas][P_NUMSEQ] == QRY->D3_NUMSEQ .Or. Empty(M->D3_NUMSEQ)
					aEtiquetas[nEtiquetas][P_CB0_VOLUMES] := nVolumes
				EndIf
			Next
		EndIF
		
		M->D3_NUMSEQ := QRY->D3_NUMSEQ
	
		QRY->(DbSkip())
	EndDo
//-- EndereÁamento
ElseIf cAlias == "SBF"
	cWhere := "WHERE SBF.BF_OK = '" + oBrowse:cMark + "'"
	
	cQuery := "SELECT COUNT(*) AS CONTADOR "
	cQuery +=   "FROM " + oCQuery:cArqTRB + " SBF "
	cQuery +=   "JOIN " + RetSqlName( "CB0" ) + " CB0 ON CB0.D_E_L_E_T_ = ' ' AND CB0.CB0_FILIAL = SBF.BF_FILIAL AND CB0.CB0_XNUMSQ = SBF.DB_NUMSEQ "
	cQuery += cWhere	
	
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QRY",.F.,.T. )
	If (! lRePrint .And. QRY->CONTADOR > 0) .Or. (lRePrint .And. QRY->CONTADOR == 0)
		Alert("AtenÁ„o. As etiquetas de endereÁamento para as sequencias selecionada(s) " + If(lReprint, "n„o", "j·") + " foram geradas !")
		
		QRY->(DbCloseArea())

		Return .F.
	EndIf

	QRY->(DbCloseArea())
	
	If ! MsgYesNo("Confirma a " + If(lReprint, "reeimpress„o", "geraÁ„o") + " da(s) etiqueta(s) selecionadas ?")
		Return .F.
	EndIf

	If lReprint
		cQuery := "SELECT CB0.CB0_CODPRO AS BF_PRODUTO, CASE WHEN SB8.B8_LOTEFOR <> ' ' THEN SB8.B8_LOTEFOR ELSE SBF.BF_LOTECTL END AS BF_LOTECTL, "
		cQuery +=        "SB8.B8_DTVALID, SB1.B1_DESC, CB0.CB0_QTDE AS BF_QUANT, SB1.B1_UM, CB0.CB0_XEAN14 AS B5_EAN141, CB0.CB0_LOCAL AS BF_LOCAL, "
		cQuery +=        "CB0.CB0_LOCALI AS BF_LOCALIZ, CB0.CB0_XNUMSQ AS DB_NUMSEQ, CB0.CB0_CODETI, CB0.CB0_VOLUME "
		cQuery +=   "FROM " + oCQuery:cArqTRB + " SBF "
		cQuery +=   "JOIN " + RetSqlName( "CB0" ) + " CB0 ON CB0.D_E_L_E_T_ = ' ' AND CB0.CB0_FILIAL = SBF.BF_FILIAL AND CB0.CB0_XNUMSQ = SBF.DB_NUMSEQ "
		cQuery +=   "JOIN " + RetSqlName( "SB1" ) + " SB1 ON SB1.D_E_L_E_T_ = ' ' AND SB1.B1_FILIAL = '" + xFilial("SB1") + "' "
		cQuery +=    "AND SB1.B1_COD = SBF.BF_PRODUTO AND SB1.B1_LOCALIZ = 'S' "
		cQuery +=   "LEFT JOIN " + RetSqlName( "SB8" ) + " SB8 ON SB8.D_E_L_E_T_ = ' ' AND SB8.B8_FILIAL = SBF.BF_FILIAL AND SB8.B8_LOTECTL = SBF.BF_LOTECTL "
		cQuery +=    "AND SB8.B8_LOCAL = SBF.BF_LOCAL AND SB8.B8_PRODUTO = SBF.BF_PRODUTO "
		cQuery += cWhere + " "
		cQuery +=  "ORDER BY SBF.DB_NUMSEQ, CB0.CB0_CODETI, CB0_VOLUME"
		
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QRY",.F.,.T. )
	Else
		cQuery := "SELECT SBF.BF_PRODUTO, CASE WHEN SB8.B8_LOTEFOR <> ' ' THEN SB8.B8_LOTEFOR ELSE SBF.BF_LOTECTL END AS BF_LOTECTL, SB8.B8_DTVALID, "
		cQuery +=        "SB8.B8_DTVALID, SB1.B1_DESC, SBF.BF_QUANT, SB1.B1_UM, SB5.B5_EAN141, SBF.BF_LOCAL, SBF.BF_LOCALIZ, SBF.DB_NUMSEQ, "
		cQuery +=        "' ' AS CB0_CODETI, '' AS CB0_VOLUME "
		cQuery +=   "FROM " + oCQuery:cArqTRB + " SBF "
		cQuery +=   "JOIN " + RetSqlName( "SB1" ) + " SB1 ON SB1.D_E_L_E_T_ = ' ' AND SB1.B1_FILIAL = '" + xFilial("SB1") + "' "
		cQuery +=    "AND SB1.B1_COD = SBF.BF_PRODUTO AND SB1.B1_LOCALIZ = 'S' "
		cQuery +=   "LEFT JOIN " + RetSqlName( "SB5" ) + " SB5 ON SB5.D_E_L_E_T_ = ' ' AND SB5.B5_FILIAL = '" + xFilial("SB5") + "' AND SB5.B5_COD = SBF.BF_PRODUTO "
		cQuery +=   "LEFT JOIN " + RetSqlName( "SB8" ) + " SB8 ON SB8.D_E_L_E_T_ = ' ' AND SB8.B8_FILIAL = SBF.BF_FILIAL AND SB8.B8_LOTECTL = SBF.BF_LOTECTL "
		cQuery +=    "AND SB8.B8_LOCAL = SBF.BF_LOCAL AND SB8.B8_PRODUTO = SBF.BF_PRODUTO "                                                                
		cQuery += cWhere + " "
		cQuery +=  "ORDER BY SBF.DB_NUMSEQ"
		
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QRY",.F.,.T. )
		
		If QRY->(Eof())
			Alert("AtenÁ„o. N„o existem etiquetas de endereÁamento para a(s) etiqueta(s) selecionada(s) !")
			
			QRY->(DbCloseArea())
			Return .F.
		EndIf
	EndIf
		
	M->DB_NUMSEQ := ""
	TCSetField("QRY", "B8_DTVALID", "D", 8, 0)
	
	While ! QRY->(Eof())
		nVolumes ++
		Aadd(aEtiquetas, { 	QRY->CB0_CODETI /* 01 */, Val(QRY->CB0_VOLUME) /* 02 */, nVolumes /* 03 */, QRY->BF_PRODUTO /* 04 */, QRY->B1_DESC /* 05 */,;
							QRY->BF_LOTECTL /* 06 */, QRY->B8_DTVALID /* 07 */, QRY->DB_NUMSEQ /* 08 */, QRY->BF_QUANT /* 09 */, QRY->B5_EAN141 /* 10 */,;
							QRY->B1_UM /* 11 */, QRY->BF_LOCAL /* 12 */, "" /* 13 */, QRY->BF_LOCALIZ /* 14 */, "" /* 15 */, "" /* 16 */, "" /* 17 */,;
							"" /* 18 */, Ctod("") /* 19 */, Ctod("") /* 20 */ })

		If M->DB_NUMSEQ == QRY->DB_NUMSEQ .Or. Empty(M->DB_NUMSEQ)
			For nEtiquetas := 1 To Len(aEtiquetas)
				If aEtiquetas[nEtiquetas][P_NUMSEQ] == QRY->DB_NUMSEQ .Or. Empty(M->DB_NUMSEQ)
					aEtiquetas[nEtiquetas][P_CB0_VOLUMES] := nVolumes
				EndIf
			Next
		EndIF
		
		M->DB_NUMSEQ := QRY->DB_NUMSEQ
	
		QRY->(DbSkip())
	EndDo
//-- EndereÁos
ElseIf cAlias == "SBE"
	DbSelectArea("CB5")
	If ! CB5SetImp(cAlias,IsTelNet())
		CBAlert("N„o foi possÌvel localizar a impressora [" + cAlias + "]")
		Return 0
	EndIF
	
	PrnEtiqueta(cAlias)

	MSCBCLOSEPRINTER()

	MsgInfo("A etiqueta do endereÁo [" + AllTrim(SBE->BE_LOCALIZ) + "] foi enviada para impressora !")
EndIf

If Select("QRY") > 0
	QRY->(DbCloseArea())

	If lReprint
		LjMsgRun("Reeimprimindo as etiquetas ...","Aguarde",{|| nEtiquetas := REtiquetas(cAlias, aEtiquetas, cImp) })
	Else
		LjMsgRun("Gerando as etiquetas ...","Aguarde",{|| nEtiquetas := GEtiquetas(cAlias, aEtiquetas, cImp) })
	EndIf
	
	MsgInfo("Foram " + If(lReprint, "reeimpressa(s) ", "gerada(s) ") + AllTrim(Str(nEtiquetas)) + " etiquetas para este documento !")
EndIf	

Return

User Function REtiquetas(cAlias, aEtiquetas, cImp)
/*/f/
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
<Descricao> : Rotina para reeimpress„o das etiquetas
<Autor> : Wagner Mobile Costa
<Data> : 25/10/2013
<Parametros> : cAlias = Tabela de Origem, aEtiquetas = Lista de Etiquetas a serem impressas e cImp = Apelido da Impressora
<Retorno> : Nenhum
<Processo> : Especifico Valmari - EndereÁamento
<Tipo> (Menu,Trigger,Validacao,Ponto de Entrada,Genericas,Especificas ) : G
<Obs> :
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
*/

REtiquetas(cAlias, aEtiquetas, cImp)

Return

Static Function REtiquetas(cAlias, aEtiquetas, cImp)
/*/f/
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
<Descricao> : Rotina para reeimpress„o das etiquetas
<Autor> : Wagner Mobile Costa
<Data> : 25/08/2013
<Parametros> : cAlias = Tabela de Origem, aEtiquetas = Lista de Etiquetas a serem impressas e cImp = Apelido da Impressora
<Retorno> : Nenhum
<Processo> : Especifico Valmari - EndereÁamento
<Tipo> (Menu,Trigger,Validacao,Ponto de Entrada,Genericas,Especificas ) : G
<Obs> :
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
*/

Local nVolume := nVolumes := nProdutos := nEtiquetas := nLinha := 0

DbSelectArea("CB5")
If ! CB5SetImp(cImp,IsTelNet())
	CBAlert("N„o foi possÌvel localizar a impressora [" + cImp + "]")
	Return 0
EndIF

For nProdutos := 1 To Len(aEtiquetas)
	M->CB0_CODETI  := aEtiquetas[nProdutos][P_CB0_CODETI]
	M->_NVOLUME    := aEtiquetas[nProdutos][P_CB0_VOLUME]
	M->_NVOLUMES   := aEtiquetas[nProdutos][P_CB0_VOLUMES]
	M->CB0_CODPRO  := aEtiquetas[nProdutos][P_B1_COD]
	M->B1_DESC	   := aEtiquetas[nProdutos][P_B1_DESC]
	M->CB0_LOTE	   := aEtiquetas[nProdutos][P_LOTECTL]
	M->CB0_DTVLD   := aEtiquetas[nProdutos][P_DTVALID]
	M->CB0_NUMSEQ  := aEtiquetas[nProdutos][P_NUMSEQ]
	M->CB0_QTDE    := aEtiquetas[nProdutos][P_QUANT]
	M->CB0_XEAN14  := aEtiquetas[nProdutos][P_XEAN14]
	M->B1_UM       := aEtiquetas[nProdutos][P_UM]
	M->CB0_LOCAL   := aEtiquetas[nProdutos][P_LOCAL]
	M->CB0_XNUMCQ  := aEtiquetas[nProdutos][P_NUMCQ]
	M->CB0_LOCALI  := aEtiquetas[nProdutos][P_LOCALIZ]

	If cAlias == "SD1"	
		M->CB0_NFENT  := aEtiquetas[nProdutos][P_D1_DOC]
		M->CB0_SERIEE := aEtiquetas[nProdutos][P_D1_SERIE]
		M->CB0_FORNEC := aEtiquetas[nProdutos][P_D1_FORNECE]
		M->CB0_LOJAFO := aEtiquetas[nProdutos][P_D1_LOJA]
		M->CB0_XLOTEF := aEtiquetas[nProdutos][P_D1_LOTEFOR]
		M->CB0_XDFABR := aEtiquetas[nProdutos][P_D1_DFABRIC]
		M->D1_DTDIGIT := aEtiquetas[nProdutos][P_D1_DTDIGIT]
	ElseIf cAlias == "SD3"
		M->CB0_OP     := aEtiquetas[nProdutos][P_D3_OP]
	EndIf

	PrnEtiqueta(cAlias)
	
	nEtiquetas ++
Next
MSCBCLOSEPRINTER()
	
Return nEtiquetas

Static Function GEtiquetas(cAlias, aEtiquetas, cImp)
/*/f/
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
<Descricao> : Rotina para geraÁ„o das etiquetas
<Autor> : Wagner Mobile Costa
<Data> : 17/08/2013
<Parametros> : cAlias = Tabela de Origem, aEtiquetas = Lista de Etiquetas a serem impressas e cImp = Apelido da Impressora
<Retorno> : Nenhum
<Processo> : Especifico Valmari - EndereÁamento
<Tipo> (Menu,Trigger,Validacao,Ponto de Entrada,Genericas,Especificas ) : G
<Obs> :
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
*/

Local nVolume := nVolumes := nProdutos := nQtdeTot := nQtdeGer := nEtiquetas := 0

DbSelectArea("CB5")
If ! CB5SetImp(cImp,IsTelNet())
	CBAlert("N„o foi possÌvel localizar a impressora [" + cImp + "]")
	Return 0
EndIF

For nProdutos := 1 To Len(aEtiquetas)
	nQtdeTot  := nQtdeGer := 0

	nQtdeTot  	  := aEtiquetas[nProdutos][P_QUANT]
	M->CB0_XEAN14 := aEtiquetas[nProdutos][P_XEAN14]
	nVolumes 	  := aEtiquetas[nProdutos][P_QUANT] / M->CB0_XEAN14

	//-- Arredonda os volumes para cima
	If nVolumes <> Int(nVolumes)
		nVolumes := Int(nVolumes) + 1
	EndIf

	//-- Considera um volume no minimo
	If nVolumes == 0
		nVolumes := 1
	EndIf

	BeginTran()
	
	For nVolume := 1 To nVolumes
		M->CB0_CODETI  := aEtiquetas[nProdutos][P_CB0_CODETI]
		M->CB_VOLUME   := aEtiquetas[nProdutos][P_CB0_VOLUME]
		M->CB_VOLUMES  := aEtiquetas[nProdutos][P_CB0_VOLUMES]
		M->CB0_CODPRO  := aEtiquetas[nProdutos][P_B1_COD]
		M->B1_DESC	   := aEtiquetas[nProdutos][P_B1_DESC]
		M->CB0_LOTE	   := aEtiquetas[nProdutos][P_LOTECTL]
		M->CB0_DTVLD   := aEtiquetas[nProdutos][P_DTVALID]
		M->CB0_NUMSEQ  := aEtiquetas[nProdutos][P_NUMSEQ]
		M->CB0_QTDE    := M->CB0_XEAN14
		M->B1_UM       := aEtiquetas[nProdutos][P_UM]
		M->CB0_LOCAL   := aEtiquetas[nProdutos][P_LOCAL]
		M->CB0_XNUMCQ  := aEtiquetas[nProdutos][P_NUMCQ]
		M->CB0_LOCALI  := aEtiquetas[nProdutos][P_LOCALIZ]
	
		M->CB0_NFENT  := ""
		M->CB0_SERIEE := ""
		M->CB0_FORNEC := ""
		M->CB0_LOJAFO := ""
		M->CB0_OP     := ""
		M->CB0_XLOTEF := ""
		M->CB0_XDFABR := Ctod("")

		If cAlias == "SD1"
			M->CB0_NFENT  := aEtiquetas[nProdutos][P_D1_DOC]
			M->CB0_SERIEE := aEtiquetas[nProdutos][P_D1_SERIE]
			M->CB0_FORNEC := aEtiquetas[nProdutos][P_D1_FORNECE]
			M->CB0_LOJAFO := aEtiquetas[nProdutos][P_D1_LOJA]
			M->CB0_XLOTEF := aEtiquetas[nProdutos][P_D1_LOTEFOR]
			M->CB0_XDFABR := aEtiquetas[nProdutos][P_D1_DFABRIC]
			M->D1_DTDIGIT := aEtiquetas[nProdutos][P_D1_DTDIGIT]
		ElseIf cAlias == "SD3"
			M->CB0_OP     := aEtiquetas[nProdutos][P_D3_OP]
		EndIf
		
		If nVolume == nVolumes
			M->CB0_QTDE := nQtdeTot - nQtdeGer
		EndIf

		M->CB0_CODETI := U_CBGrvEti("01", { 	M->CB0_CODPRO 				/* 01,CB0_CODPRO */,;
												M->CB0_QTDE 				/* 02,CB0_QTDE */,;
																			/* 03,CB0_USUARIO */,;
												M->CB0_NFENT				/* 04,CB0_NFENT */,;
												M->CB0_SERIEE				/* 05,CB0_SERIEE */,;
												M->CB0_FORNEC				/* 06,CB0_FORNEC */,;
												M->CB0_LOJAFO				/* 07,CB0_LOJAFO */,;
												/* 08,CB0_PEDCOM */,;
												M->CB0_LOCALI				/* 09,CB0_LOCALI */,;
												M->CB0_LOCAL				/* 10,CB0_LOCAL */,;
												M->CB0_OP 					/* 11,CB0_OP */,;
												M->CB0_NUMSEQ				/* 12,CB0_NUMSEQ */,;
												/* 13,CB0_NFSAI */,;
												/* 14,CB0_SERIES */,;
												/* 15,CB0_CODET2 */,;
												M->CB0_LOTE					/* 16,CB0_LOTE */,;
												/* 17,CB0_SLOTE */,;
												M->CB0_DTVLD				/* 18,CB0_DTVLD */,;
												/* 19,CB0_CC */,;
												/* 20,CB0_LOCORI */,;
												/* 21,CB0_PALLET */,;
												/* 22,CB0_OPREQ */,;
												/* 23,CB0_NUMSER */,;
												/* 24,CB0_ORIGEM */,;
												/* 25,CB0_ITNFE */,;
												StrZero(nVolume, 10) 		/* 26,CB0_VOLUME */,;
												M->CB0_XEAN14				/* 27,CB0_XEAN14 */,;
												M->CB0_XNUMCQ				/* 28,CB0_XNUMCQ */,;
												M->CB0_XDFABR				/* 29,CB0_XDFABR */,;
												M->CB0_XLOTEF				/* 30,CB0_XLOTEF */})
					
		M->_NVOLUME  := nVolume
		M->_NVOLUMES := nVolumes
		
		PrnEtiqueta(cAlias)

		nQtdeGer += M->CB0_QTDE

		nEtiquetas ++
	Next
	EndTran()
Next

//-- Dados do Produto
If File("etq" + cAlias + "sb1.ini")
	PrnEtiqueta(cAlias + "sb1")
EndIf

MSCBCLOSEPRINTER()
	
Return nEtiquetas

Static Function PrnEtiqueta(cAlias)
/*/f/
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
<Descricao> : Rotina para impress„o de etiqueta de um volume
<Autor> : Wagner Mobile Costa
<Data> : 23/08/2013
<Parametros> : Nenhum
<Retorno> : Nenhum
<Processo> : Especifico Valmari - EndereÁamento
<Tipo> (Menu,Trigger,Validacao,Ponto de Entrada,Genericas,Especificas ) : E
<Obs> :
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
*/

Local aEtiqueta := {}, nEtiqueta := 1

nHdl := FT_FUse("etq" + cAlias + ".ini")
FT_FGoTop ()
cLinha := FT_FREADLN()

Do While !FT_FEof()             
	If ! Empty(cLinha)
		aAdd (aEtiqueta, AllTrim(cLinha))
	EndIf
	
	FT_FSkip ()
	cLinha := FT_FREADLN()
EndDo
FClose(nHdl)

__LEXIT := .F.
While nEtiqueta <= Len(aEtiqueta)
	&(aEtiqueta[nEtiqueta])
	
	If __LEXIT
		Exit
	EndIf
	nEtiqueta ++
EndDo

Return

User Function CB0Filter
/*/f/
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
<Descricao> : Rotina para retorno do filtro da tabela CB0
<Autor> : Wagner Mobile Costa
<Data> : 18/08/2013
<Parametros> : Nenhum
<Retorno> : Nenhum
<Processo> : Especifico Valmari - EndereÁamento
<Tipo> (Menu,Trigger,Validacao,Ponto de Entrada,Genericas,Especificas ) : P
<Obs> :
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
*/

Local cRet := "@#.T.@#"

If FunName() == "MATA175"
	cRet := "@#CB0->CB0_XNUMCQ = '" + SD7->D7_NUMERO + "' .AND. CB0->CB0_CODET2 = ' '@#"
EndIF

Return cRet