#Include "Protheus.ch"

User Function MTA015MNU
/*/f/
�����������������������������������������������������������������������������������������������������������������������������������������������������
<Descricao> : Ponto de entrada para atribui��o das a��es relacionadas do mBrowse
<Autor> : Wagner Mobile Costa
<Data> : 04/08/2013
<Parametros> : Nenhum
<Retorno> : Nenhum
<Processo> : Especifico Valmari - Endere�amento
<Tipo> (Menu,Trigger,Validacao,Ponto de Entrada,Genericas,Especificas ) : P
<Obs> :
�����������������������������������������������������������������������������������������������������������������������������������������������������
*/

Local nRotina := 1

If Type("aRotina") == "A"
	For nRotina := 1 To Len(aRotina)
		If aRotina[nRotina][4] == 5
			aRotina[nRotina][2] := "U_A015Deleta"
		EndIf
	Next

	Aadd(aRotina, {"Imprimir Etiqueta", "U_VALXETI('SBE', .F.)", 0, 4, 0, .F.})
EndIf

Return

User Function A015Deleta(cAlias,nReg,nOpc)
/*/f/
�����������������������������������������������������������������������������������������������������������������������������������������������������
<Descricao> : Ponto de entrada para atribui��o das a��es relacionadas do mBrowse
<Autor> : Wagner Mobile Costa
<Data> : 04/08/2013
<Parametros> : Nenhum
<Retorno> : Nenhum
<Processo> : Especifico Valmari - Endere�amento
<Tipo> (Menu,Trigger,Validacao,Ponto de Entrada,Genericas,Especificas ) : V
<Obs> :
�����������������������������������������������������������������������������������������������������������������������������������������������������
*/

Local nOpcA   := 0
Local nCntDele:= 0
Local aAC     := {"Abandona","Confirma"}
Local lRet    := .T.
Local oDlg, cQuery := ""
//��������������������������������������������������������������Ŀ
//� Monta a entrada de dados do arquivo                          �
//����������������������������������������������������������������
Private aTELA[0][0],aGETS[0]

cQuery := "SELECT COUNT(*) AS CONTADOR FROM " + RetSqlName( "SBE" ) + " "
cQuery +=  "WHERE D_E_L_E_T_ = ' ' AND BE_FILIAL = '" + xFilial( "SBE" ) + "' "
cQuery +=    "AND ((BE_XLOCPIC = '" + SBE->BE_LOCAL + "' AND BE_XENDPIC = '" + SBE->BE_LOCALIZ + "') OR "
cQuery +=         "(BE_XLOCDES = '" + SBE->BE_LOCAL + "' AND BE_XENDDES = '" + SBE->BE_LOCALIZ + "'))"

cQuery := ChangeQuery( cQuery )
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QRY",.F.,.T. )
If QRY->CONTADOR > 0
	Aviso('MATA015', "Este endere�o n�o pode ser excluido pois foi utilizado como endere�o de picking/descarte !", {'Ok'})
	QRY->(DbCloseArea())
	Return
EndIF
QRY->(DbCloseArea())

//�����������������������������������������������������������Ŀ
//� Nao e permitida a exclusao de enderecos com BD_STATUS = O �
//�������������������������������������������������������������
If SBE->BE_STATUS $ "23"
	Aviso('MATA015', "Este endereco n�o pode ser excluido porque possue o status com conteudo igual a Ocupado/Bloqueado", {'Ok'})
	lRet := .F.
EndIf

If lRet
	lRet := MA015CkSDB()
Endif

If lRet
	//��������������������������������������������Ŀ
	//� Envia para processamento dos Gets          �
	//����������������������������������������������
	nOpcA    :=0
	lConfirm :=.T.

	SoftLock(cAlias)
	RegToMemory("SBE", .F.)

	If ( Type("l015Auto") == "U" .or. !l015Auto )
		DEFINE MSDIALOG oDlg TITLE "Cadastro de Endere�os" FROM 9,0 TO 28,80 OF oMainWnd
		nOpcA:=EnChoice(cAlias,nReg,nOpc,aAC,"AC","Quanto a exclus�o ?")
		ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{|| If(A015Alert(nOpc),(nOpca := 2,oDlg:End()),)},{|| nOpca := 0,oDlg:End()})
	Else
		nOpcA := 2
	EndIf

	dbSelectArea(cAlias)
	If nOpcA == 2
		RecLock(cAlias,.F.,.T.)
		dbDelete()
	EndIf
	dbSelectArea(cAlias)
	MsUnLock()
EndIf

Return

Static Function MA015CkSDB()
/*/f/
�����������������������������������������������������������������������������������������������������������������������������������������������������
<Descricao> : Verifica se existe movimento com o endereco apos o fechamento e nao deixa excluir.
<Autor> : Nereu Humberto Jr
<Data> : 19/10/07
<Parametros> : Nenhum
<Retorno> : lRet = Retorna se o endere�o pode ser excluido
<Processo> : Padr�o
<Tipo> (Menu,Trigger,Validacao,Ponto de Entrada,Genericas,Especificas ) : V
<Obs> :
�����������������������������������������������������������������������������������������������������������������������������������������������������
*/

Local aArea     := GetArea()
Local cAliasSDB := ""
Local cArqInd   := ""
Local lQuery    := .T.
Local dDataFec  := If(FindFunction("MVUlmes"),MVUlmes(),GetMV("MV_ULMES"))
Local cLocal    := SBE->BE_LOCAL
Local cLocaliz  := SBE->BE_LOCALIZ
Local lRet      := .T.
#IFNDEF TOP
	Local cCond     := ""
	Local nIndex    := 0
#ELSE
	Local cQuery    := ""
#ENDIF

dbSelectArea("SDB")
dbSetOrder(1)
	
#IFDEF TOP
	cAliasSDB := GetNextAlias()
	cQuery    := ""
	lQuery    := .T.

	cQuery += "SELECT 1 "
	cQuery += "FROM " + RetSqlName( "SDB" ) + " SDB "
	cQuery += "WHERE "
	cQuery += "DB_FILIAL ='" + xFilial( "SDB" ) + "' AND "
	cQuery += "DB_DATA > '" + DTOS(dDataFec) + "' AND "
	cQuery += "DB_LOCAL = '" + cLocal + "' AND "
	cQuery += "DB_LOCALIZ = '" + cLocaliz + "' AND "
	cQuery += "DB_ESTORNO = ' ' AND "
	cQuery += "SDB.D_E_L_E_T_=' ' "

	cQuery := ChangeQuery( cQuery )
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSDB,.F.,.T. )

#ELSE	
	cAliasSDB := "SDB"
	cCond     := ""
	
	cCond := "DB_FILIAL=='" + xFilial( "SDB" ) + "' .And. "
	cCond += "DB_LOCAL   == '" + cLocal + "' .And. "
	cCond += "DB_LOCALIZ >= '" + cLocaliz + "' .And. "
	cCond += "DTOS(DB_DATA) > '" + DTOS(dDataFec) + "' .And. "
	cCond += "DB_ESTORNO == ' ' "

	cArqInd   := CriaTrab(NIL,.F.)
	IndRegua(cAliasSDB,cArqInd,SDB->(IndexKey()),,cCond) 
	
	nIndex := RetIndex("SDB")
	dbSetIndex(cArqInd+OrdBagExT())
	dbSetOrder(nIndex+1)
	dbGotop()	   	
  
#ENDIF

If (cAliasSDB)->(!Eof())
	lRet := .F.
	Aviso('MATA015E', "Este endere�o n�o pode ser excluido porque possui movimenta��es com data posterior ao ultimo fechamento"	, {'Ok'})
Endif
	
If lQuery
	dbSelectArea(cAliasSDB)
	dbCloseArea()
Else
	RetIndex("SDB")
	dbClearFilter()
	Ferase(cArqInd+OrdBagExt())
Endif	
dbSelectArea("SDB")
dbSetOrder(1)	

RestArea(aArea)

Return(lRet)

Static Function A015Alert(nOpc)
/*/f/
�����������������������������������������������������������������������������������������������������������������������������������������������������
<Descricao> : Verifica se existe movimento com o endereco apos o fechamento e nao deixa excluir.
<Autor> : Rodrigo de A. Sartorio
<Data> : 01/10/97
<Parametros> : Nenhum
<Retorno> : lRet = Retorna se o endere�o pode ser excluido
<Processo> : Padr�o
<Tipo> (Menu,Trigger,Validacao,Ponto de Entrada,Genericas,Especificas ) : V
<Obs> :
�����������������������������������������������������������������������������������������������������������������������������������������������������
*/

Local lRet   := .F.
Local cLinha1:= "O almoxarifado "+Alltrim(SBE->BE_LOCAL)+" localiza��o "+Alltrim(SBE->BE_LOCALIZA)+" possui "
Local cLinha2:= "saldo em estoque. Excluir esta localiza��o impedir�nova(s) "
Local cLinha3:= "distribui��es para a mesma. "
Local cLinha4:= "Confirma exclus�o ?"

//��������������������������������������������������������������Ŀ
//� Antes de deletar verificar se existe saldo na localizacao    �
//����������������������������������������������������������������
dbSelectArea("SBF")
If dbSeek(xFilial("SBF")+Alltrim(SBE->BE_LOCAL)+Alltrim(SBE->BE_LOCALIZA))
	TONE(3500,1)
	lRet := MsgYesNo(cLinha1+cLinha2+cLinha3+cLinha4,"Aten��o"+Alltrim(SBE->BE_LOCAL)+" "+Alltrim(SBE->BE_LOCALIZA))
Else
	lRet:=.T.
EndIf	

If lRet
	lRet:=A015TOK(nOpc)
EndIf

Return lRet