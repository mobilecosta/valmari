#Include "Protheus.ch"
#include "apvt100.ch"

User Function VALD020
/*/f/
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
<Descricao> : Rotina para transferencia das etiquetas a partir da amarraÁ„o de endereÁo picking/pulm„o/descarte do cadastro de endereÁos
<Autor> : Wagner Mobile Costa
<Data> : 11/08/2013
<Parametros> : Nenhum
<Retorno> : Nenhum
<Processo> : Especifico Valmari - EndereÁamento
<Tipo> (Menu,Trigger,Validacao,Ponto de Entrada,Genericas,Especificas ) : M
<Obs> :
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
*/

Local aTela 	:= VTSave(), cEtiqueta := cQuery := "", cPicture := PesqPict("SDB", "DB_QUANT"), aTransf := {}
Local cSLote	:= CriaVar("D3_NUMLOTE"), cNumSerie	:= CriaVar("D3_NUMSERI"), dValid := dDataBase
Local aHeader  	:= { U_X3Titulo("BE_LOCAL"), U_X3Titulo("BE_LOCALIZ"), U_X3Titulo("BE_XLOCPIC"), U_X3Titulo("BE_XENDPIC"),;
					 U_X3Titulo("BE_XLOCDES"), U_X3Titulo("BE_XENDDES"), U_X3Titulo("BF_QUANT"), U_X3Titulo("BF_EMPENHO") }, aCols := {}, aSize := {}

While .T.
	VTClear()
	
	cEtiqueta   := Space(10)
	M->CB0_QTDE := 0
	@ 00,00 VtSay Padc("Transferencia",VTMaxCol())
	@ 01,00 VtSay "Etiqueta:"
	@ 02,00 VtGet cEtiqueta pict "@!" F3 "CB0" Valid If(Val(cEtiqueta) > 0, (cEtiqueta := StrZero(Val(cEtiqueta), 10), .T.), .T.) .And. VldEtiqueta(cEtiqueta)
	@ 03,00 VtGet M->CB0_QTDE Pict cPicture Valid Positivo(M->CB0_QTDE) .And. M->CB0_QTDE <= CB0->CB0_QTDE When .F.

	VtRead
	vtRestore(,,,,aTela)

	If Empty(cEtiqueta) .Or. VtLastKey() == 27
		Return .F.
	EndIf

	M->BE_LOCAL   := Space(Len(SBE->BE_LOCAL))
	M->BE_LOCALIZ := Space(Len(SBE->BE_LOCALIZ))
	
	@ 00,00 VtSay Padc("Transferencia [" + cEtiqueta + "]",VTMaxCol())
	@ 01,00 VtSay "Produto: " + CB0->CB0_CODPRO
	@ 02,00 VtSay "Qtde: " + AllTrim(Str(M->CB0_QTDE))
	@ 03,00 VtSay "Confirme o local/endereÁo:" 
	@ 04,00 VtGet M->BE_LOCAL
	@ 04,02 VtSay "/"
	@ 04,03 VtGet M->BE_LOCALIZ	Pict PesqPict("SBE", "BE_LOCALIZ") F3 "SBE";
			Valid ExistCpo("SBE", M->BE_LOCAL + M->BE_LOCALIZ, 1)
	VtRead

	VtRestore(,,,,aTela)

	If Empty(M->BE_LOCAL) .Or. Empty(M->BE_LOCALIZ)
		Loop
	EndIf
	
	If CB0->CB0_LOCALI == M->BE_LOCALIZ .And. CB0->CB0_LOCAL == M->BE_LOCAL
		VtAlert("A transferencia n„o pode ser realizada para o mesmo endereÁo atual da etiqueta !","Aviso",.t.,4000)
		Loop
	EndIf
	
	If ! SB1->( dbSeek(xFilial("SB1") + CB0->CB0_CODPRO) )
		VtAlert('Produto "'+AllTrim(CB0->CB0_CODPRO)+'" nao localizado no cadastro de produtos.')
		Loop
	EndIf
	
	If ! VTYesNo("Confirma a transferencia do produto [" + 	AllTrim(CB0->CB0_CODPRO) + "] do endereÁo/local [" +;
															AllTrim(SDB->(DB_LOCAL + "/" + DB_LOCALIZ)) + "] para o endereÁo [" +;
															M->BE_LOCAL + "/" + AllTrim(M->BE_LOCALIZ) + "] ?","Aviso",.t.) 
	   Loop
	EndIf   
	
	VTMsg("Transf Etiqueta [" + cEtiqueta + "] ...")
	VTProcessMessage()

	aTransf	   := Array(2)
	aTransf[1] := { "", dDataBase }
	aTransf[2] := {		SB1->B1_COD					,;
						SB1->B1_DESC				,;
						SB1->B1_UM					,;
						CB0->CB0_LOCAL 				,;
						CB0->CB0_LOCALI				,;
						SB1->B1_COD					,;
						SB1->B1_DESC				,;
						SB1->B1_UM					,;
						M->BE_LOCAL  				,;
						M->BE_LOCALIZ				,;
						SDB->DB_NUMSERI				,;
						SDB->DB_LOTECTL				,;    	//lote
						SDB->DB_NUMLOTE				,;		//sublote
						SB8->B8_DTVALID				,;
						CriaVar("D3_POTENCI")		,;
						M->CB0_QTDE					,;
						CriaVar("D3_QTSEGUM")		,;
						CriaVar("D3_ESTORNO")		,;
						CriaVar("D3_NUMSEQ")		,;
						SDB->DB_LOTECTL        		,;
						SB8->B8_DTVALID }
	If IntDL()
		Aadd(aTransf[2], CriaVar("D3_SERVIC")) 
	EndIf
	Aadd(aTransf[2], CriaVar("D3_ITEMGRD"))
					
	lMsErroAuto := .F.
	lMsHelpAuto := .T.

	BeginTran()
	MSExecAuto({|x| MATA261(x)},aTransf)

	If lMsErroAuto
    	MostraErro()
		DisarmTransaction()
		Break
	//-- AtualizaÁ„o do endereÁo atual da etiqueta
	ElseIf TCSQLExec("UPDATE " + RetSqlName("CB0") + " " +;
       	    			    "SET CB0_LOCAL = '" + M->BE_LOCAL + "', CB0_LOCALI = '" + M->BE_LOCALIZ + "' " +;
		       	      "WHERE D_E_L_E_T_ = ' ' AND CB0_CODETI = '" + CB0->CB0_CODETI + "'") <> 0
		MsgAlert(TCSQLError())
		DisarmTran()
		Break
	EndIf 
	EndTran()
EndDo	
	
Return

Static Function VldEtiqueta(cEtiqueta, nQtde)
/*/f/
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
<Descricao> : FunÁ„o para validaÁ„o do cÛdigo da etiqueta preenchida
<Autor> : Wagner Mobile Costa
<Data> : 11/08/2013
<Parametros> : cEtiqueta = CÛdigo da Etiqueta e nQtde = Quantidade a ser transferida
<Retorno> : Nenhum
<Processo> : Especifico Valmari - EndereÁamento
<Tipo> (Menu,Trigger,Validacao,Ponto de Entrada,Genericas,Especificas ) : V
<Obs> :
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
*/

Local lRet := .T., aArea := GetArea()

If Empty(cEtiqueta)
	Return .T.
EndIF

DbSelectArea("CB0")
DbSetOrder(1)
If ! DbSeek(xFilial() + cEtiqueta)
	VtAlert("N˙mero da etiqueta invalida !","Aviso",.t.,4000)
	lRet := .F.
EndIf

If lRet
	DbSelectArea("SDB")
	DbOrderNickName("DB_NUMSEQ")
	If ! DbSeek(xFilial() + CB0->(CB0_NUMSEQ + CB0_LOCAL + CB0_CODETI + CB0_VOLUME))
		VtAlert("EndereÁamento da etiqueta [" + cEtiqueta + "] n„o encontrado !","Aviso",.t.,4000)
		lRet := .F.
	EndIf

	If lRet .And. ! Empty(SDB->DB_LOTECTL)
		SB8->(DbSetOrder(2))
		If ! SB8->(DbSeek(xFilial() + SDB->DB_NUMLOTE + SDB->DB_LOTECTL))
			VtAlert('Lote "'+AllTrim(SDB->DB_LOTECTL)+'" nao localizado no cadastro de lotes !')
			lRet := .F.
		EndIf
	EndIf
	
	If lRet
		DbSelectArea("SBF")
		DbSetOrder(1)			// BF_FILIAL+BF_LOCAL+BF_LOCALIZ+BF_PRODUTO+BF_NUMSERI+BF_LOTECTL+BF_NUMLOTE
		If DbSeek(xFilial() + CB0->(CB0_LOCAL + CB0_LOCALI + CB0_CODPRO) + SDB->(DB_NUMSERI + DB_LOTECTL + DB_NUMLOTE))
			If CB0->CB0_QTDE > SBF->(BF_QUANT - BF_EMPENHO)
				VtAlert("O saldo por endereÁo deste produto n„o È suficiente para realizar a transferencia !","Aviso",.t.,4000)
				lRet := .F.
			EndIf
		Else
			VtAlert("N„o existe saldo no endereÁo [" + AllTrim(CB0->CB0_LOCALI) + "] para realizar a transferencia !","Aviso",.t.,4000)
			lRet := .F.
		EndIf
	EndIf
	
	M->CB0_QTDE := CB0->CB0_QTDE
EndIf

RestArea(aArea)

Return lRet