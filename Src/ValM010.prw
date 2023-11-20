#Include "totvs.ch"

User Function VALM010
/*/f/
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
<Descricao> : Rotina para geraÁ„o do endereÁamento de um produto
<Autor> : Wagner Mobile Costa
<Data> : 06/01/2014
<Parametros> : Nenhum
<Retorno> : Nenhum
<Processo> : Especifico Valmari - EndereÁamento
<Tipo> (Menu,Trigger,Validacao,Ponto de Entrada,Genericas,Especificas ) : M
<Obs> :
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
*/

Local aParam := {	{ 1 ,"Local"	  , "01"      , "99" 	 ,""  ,"" ,".T." ,100 ,.T. },;
                  { 1 ,"EndereÁo"  , "DESCARTE", "" 	 ,""  ,"" ,".T." ,100 ,.T. },;
                  { 1 ,"Tipo de Produto", "PA" , "" 	    ,""  ,"" ,".T." , 55 ,.T. } }


Private cCadastro := "EndereÁamento Automatico"

If ! ParamBox(aParam ,"Parametros")
   Return
EndIf

mv_par02 := Left(mv_par02 + Space(Len(SBF->BF_LOCALIZ)), Len(SBF->BF_LOCALIZ))

BeginSql Alias "QRY"

SELECT SB2.B2_COD, SB2.B2_LOCAL, SB8.B8_SALDO, SBF.BF_QUANT, SB1.B1_RASTRO
  FROM %table:SB2% SB2
  JOIN %table:SB1% SB1 ON SB1.B1_COD = SB2.B2_COD AND SB1.B1_FILIAL = %Exp:xFilial("SB1")% AND SB1.B1_MSBLQL = '2' AND SB1.D_E_L_E_T_ = ' ' 
    AND SB1.B1_TIPO = %Exp:mv_par03% AND SB1.B1_LOCALIZ = 'S'
  LEFT JOIN (SELECT B8_FILIAL, B8_LOCAL, B8_PRODUTO, SUM(B8_SALDO) AS B8_SALDO
               FROM %table:SB8% WHERE D_E_L_E_T_ = ' '
              GROUP BY B8_FILIAL, B8_LOCAL, B8_PRODUTO
             HAVING SUM(B8_SALDO) > 0) SB8 ON SB8.B8_PRODUTO = SB2.B2_COD AND SB8.B8_FILIAL = SB2.B2_FILIAL
   AND SB8.B8_LOCAL = SB2.B2_LOCAL
  LEFT JOIN (SELECT BF_FILIAL, BF_LOCAL, BF_PRODUTO, SUM(BF_QUANT) AS BF_QUANT
               FROM %table:SBF%
              WHERE D_E_L_E_T_ = ' '
              GROUP BY BF_FILIAL, BF_LOCAL, BF_PRODUTO) SBF ON SBF.BF_PRODUTO = SB2.B2_COD AND SBF.BF_FILIAL = SB2.B2_FILIAL AND SBF.BF_LOCAL = SB2.B2_LOCAL
   AND SBF.BF_QUANT != 0
 WHERE SB2.D_E_L_E_T_ = ' ' AND SB2.B2_FILIAL = %Exp:xFilial("SB2")%
   AND CASE WHEN SB1.B1_RASTRO = 'N' AND COALESCE(SBF.BF_QUANT, 0) < COALESCE(SB2.B2_QATU, 0) THEN 1 ELSE 
       CASE WHEN SB1.B1_RASTRO <> 'N' AND COALESCE(SBF.BF_QUANT, 0) < COALESCE(SB8.B8_SALDO, 0) THEN 1 ELSE 0 END END = 1
   AND SB2.B2_QATU != 0                             
   AND SB2.B2_LOCAL = %Exp:mv_par01%
 ORDER BY SB2.B2_FILIAL, SB2.B2_COD

EndSql

While ! QRY->(Eof())
   Processa({|lEnd| MA805Process()},"Saldos por Localizacao","Criando saldos [" + AllTrim(QRY->B2_COD) + "]",.F.)

   QRY->(DbSkip())
EndDo

QRY->(DbCloseArea())

Return

Return(NIL)

Static Function MA805Process(lEnd)
// Obtem numero sequencial do movimento

LOCAL cNumSeq:=ProxNum(),i
// Numero do Item do Movimento
Local cCounter	:=	StrZero(0,TamSx3('DB_ITEM')[1])

If QRY->B1_RASTRO = "N"

BeginSql Alias "QRYSBF"
SELECT SB2.B2_COD AS B8_PRODUTO, SB2.B2_LOCAL AS B8_LOCAL, %Exp:''% AS B8_LOTECTL, SB2.B2_QATU AS B8_QUANT
  FROM %table:SB2% SB2
 WHERE SB2.D_E_L_E_T_ = ' ' AND SB2.B2_FILIAL = %Exp:xFilial("SB2")% AND SB2.B2_COD = %Exp:QRY->B2_COD% AND SB2.B2_LOCAL = %Exp:QRY->B2_LOCAL%
   AND SB2.B2_QATU > 0
EndSql

Else

BeginSql Alias "QRYSBF"

SELECT SB8.B8_PRODUTO, SB8.B8_LOCAL, SB8.B8_LOTECTL, SB8.B8_SALDO - COALESCE(SBF.BF_QUANT, 0) AS B8_QUANT
  FROM %table:SB8% SB8
  LEFT JOIN (SELECT BF_FILIAL, BF_PRODUTO, BF_LOCAL, BF_LOTECTL, SUM(BF_QUANT) AS BF_QUANT
               FROM %table:SBF%
              WHERE BF_FILIAL = %Exp:xFilial("SBF")% AND D_E_L_E_T_ = ' ' AND BF_PRODUTO = %Exp:QRY->B2_COD% AND BF_LOCAL = %Exp:QRY->B2_LOCAL%
              GROUP BY BF_FILIAL, BF_PRODUTO, BF_LOCAL, BF_LOTECTL) SBF ON SBF.BF_FILIAL = SB8.B8_FILIAL AND SBF.BF_PRODUTO = SB8.B8_PRODUTO
   AND SBF.BF_LOCAL = SB8.B8_LOCAL AND SBF.BF_LOTECTL = SB8.B8_LOTECTL
 WHERE SB8.D_E_L_E_T_ = ' ' AND SB8.B8_FILIAL = %Exp:xFilial("SB8")% AND SB8.B8_PRODUTO = %Exp:QRY->B2_COD% AND SB8.B8_LOCAL = %Exp:QRY->B2_LOCAL% 
   AND SB8.B8_SALDO > 0 AND SB8.B8_SALDO <> COALESCE(SBF.BF_QUANT, 0)

EndSql
EndIf

ProcRegua(QRYSBF->(LastRec()))

// Varre o ACols gravando o SDB
BeginTran()

While ! QRYSBF->(Eof())
	IncProc()

   cCounter := Soma1(cCounter)

	//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
	//≥Cria registro de movimentacao por Localizacao (SDB)           ≥
	//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
	CriaSDB( QRYSBF->B8_PRODUTO,;	// Produto
            QRYSBF->B8_LOCAL,;	// Armazem
				QRYSBF->B8_QUANT,;	// Quantidade
				mv_par02,;	         // Localizacao
				"",;	               // Numero de Serie
				Dtos(dDataBase),;		// Doc
				"1",;		            // Serie
				"",;			         // Cliente / Fornecedor
				"",;			         // Loja
				"",;			         // Tipo NF
				"ACE",;			      // Origem do Movimento
				dDataBase,;		      // Data
				QRYSBF->B8_LOTECTL,;	// Lote
				"",;                 // Sub-Lote
				cNumSeq,;		      // Numero Sequencial
				"499",;			      // Tipo do Movimento
				"M",;			         // Tipo do Movimento (Distribuicao/Movimento)
				cCounter,;		      // Item
				.F.,;			         // Flag que indica se e' mov. estorno
				0,;				      // Quantidade empenhado
				0)		               // Quantidade segunda UM

	//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
	//≥Soma saldo em estoque por localizacao fisica (SBF)            ≥
	//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
	GravaSBF("SDB")
	QRYSBF->(DbSkip())	
EndDo
EndTran()

QRYSBF->(DbCloseArea())

Return(NIL)