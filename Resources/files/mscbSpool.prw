#INCLUDE "mscbspool.ch" 
#INCLUDE "TBICONN.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TCBROWSE.CH"


/*****************************************************************************************************/
// funcoes para controle do SPOOL
/*****************************************************************************************************/
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Descri‡…o ³ PLANO DE MELHORIA CONTINUA                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ITEM PMC  ³ Responsavel              ³ Data         |BOPS:             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³      01  ³                          ³              |                  ³±±
±±³      02  ³Erike Yuri da Silva       ³29/03/2006    |00000092318       ³±±
±±³      03  ³                          ³              |                  ³±±
±±³      04  ³                          ³              |                  ³±±
±±³      05  ³                          ³              |                  ³±±
±±³      06  ³                          ³              |                  ³±±
±±³      07  ³                          ³              |                  ³±±
±±³      08  ³Erike Yuri da Silva       ³29/03/2006    |00000092318       ³±±
±±³      09  ³                          ³              |                  ³±±
±±³      10  ³                          ³              |                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/	

User FUNCTION CBSpool(cParam)
Local oItens
Local oFont
Local oBar
Local oAni, oLogo,oUserBar
Local cMenuBmp := GetMenuBmp()

PUBLIC oMainWnd
PUBLIC lLeft := .F.
Private oMonitor
Private oMenuSPool
Private cTitulo:= OemToAnsi(STR0001) //"Spool de impressao de etiquetas "
Private lSai   := .t.
Private lPausa := .f.
Private cFilaI := Space(30)
Private cPathS := "\IMPTER"
Private cImp   := ""
Private cPorta := ""
Private cTam   := Space(15)
Private cDriveWin:= "Sim"
Private cSettings:= Space(20)
Private cLimLixeira:= "99999999"


Private aItens:=CarregaItens()[1]
Private afile :=CarregaItens()[2]

PRIVATE AdvFont
PRIVATE __cInterNet := Nil
Private nModulo := 99
Private cModulo := ""
Private cVersao := GetVersao()
Private tInicio := TIME()
Private cUserName :=""
// variaveis par a nova versao
Private dDataBase := MsDate()
PRIVATE oShortList
Private oMsgItem0,oMsgItem1,oMsgItem2,oMsgItem3,oMsgItem4


// variaveis necessarias para rotina de impressao
Private aUser
Private aRegistros	:= {}
//Private aReturn	:=  { "Zebrado", 1,"Administracao", 2, 3, 1, "",1 }
Private aReturn	:=  { "Zebrado", 1,"Administracao", 2, 2, 1, "",1 }
Private rptfolha := ""
//------------------------------------
Private cParamSp:= If(cParam==NIL,'',cParam)

PswOrder(1)
PswSeek("000000")
__Ap5NoMv(.T.)
aUser := PswRet()
__Ap5NoMv(.F.)

Private aEmpresas  := Aclone(aUser[2][6])
Private __RELDIR   := Trim(aUser[2][3])
Private __DRIVER   := AllTrim(aUser[2][4])
Private __IDIOMA   := aUser[2][2]
Private __GRPUSER  := ""
Private __VLDUSER  := aUser[1][6]
Private __ALTPSW   := aUser[1][8]
Private __CUSERID  := aUser[1][1]
Private __NUSERACS := aUser[1][15]
Private __AIMPRESS := {aUser[2][8],aUser[2][9],aUser[2][10],aUser[2][12]}
Private __LDIRACS  := aUser[2][13]
Private __CRDD     := RDDSetDefault()
Private oTimer
Public cArqEmp     := "SIGAMAT.EMP"

OpenSm0()
dbSelectArea("SM0")
SM0->(DbGotop())
RpcSetType(3)
RpcSetEnv (SM0->M0_CODIGO,FWGETCODFILIAL, , , , , , , , .F., .F. )

SetsDefault()
DEFINE FONT AdvFont NAME "MS Sans Serif" SIZE 0, -9
DEFINE WINDOW oMainWnd FROM 1, 1 TO 22, 75 TITLE cTitulo+STR0002 //NOMAXIMIZE //"- Aguarde...."

MENU oMenu IMAGE cMenuBmp
  MENUITEM OemToAnsi(STR0049) ACTION lPausa := .f.					//"Ativar"
  MENUITEM OemToAnsi(STR0050) ACTION lPausa := .t.					//"Desativar"
  MENUITEM OemToAnsi(STR0051) ACTION Parametros()					//"Parametros"
  MENUITEM OemToAnsi(STR0052) ACTION Prioridade()					//"Prioridade"
  MENUITEM OemToAnsi(STR0053) ACTION (Pausa(),AtuTela(.t.))		//"Pausar"
  MENUITEM OemToAnsi(STR0054) ACTION Excluir()						//"Excluir"
  MENUITEM OemToAnsi(STR0055) ACTION Lixeira(1)						//"Restaurar Lixeira"
  MENUITEM OemToAnsi(STR0056) ACTION Lixeira(2)						//"Limpar Lixeira"
  MENUITEM OemToAnsi(STR0057) ACTION (lSai:= .t.,oMainWnd:End())	//"Sair"
ENDMENU

oMenu:align:= CONTROL_ALIGN_LEFT
oMainWnd:SetMenu( oMenu )
oMainWnd:SetColor(CLR_BLACK,CLR_WHITE)
oMainWnd:Cargo := oShortList
oMainWnd:oFont := AdvFont
oMainWnd:nClrText := 0
oMainWnd:lEscClose := .F.
MainToolBar(@oBar)

oMainWnd:ReadClientCoors()

oMonitor := TCBrowse():New(50,65,200,200,,,,oMainWnd,,,,,,,,,,,,.t.,,.t.,)
oMonitor:align := CONTROL_ALIGN_ALLCLIENT
oMonitor:nClrBackFocus := GetSysColor( 13 )
oMonitor:nClrForeFocus := GetSysColor( 14 )
oMonitor:SetArray( aItens )

ADD COLUMN TO oMonitor HEADER STR0003		OEM DATA {|| aItens[oMonitor:nAt,1] } ALIGN LEFT SIZE  25 PIXELS //"Status"
ADD COLUMN TO oMonitor HEADER "!"			OEM DATA {|| aItens[oMonitor:nAt,2] } ALIGN LEFT SIZE  10 PIXELS
ADD COLUMN TO oMonitor HEADER STR0004		OEM DATA {|| aItens[oMonitor:nAt,3] } ALIGN LEFT SIZE  25 PIXELS //"Usuario"
ADD COLUMN TO oMonitor HEADER STR0005		OEM DATA {|| aItens[oMonitor:nAt,4] } ALIGN LEFT SIZE 100 PIXELS //"Nome"
ADD COLUMN TO oMonitor HEADER STR0006		OEM DATA {|| aItens[oMonitor:nAt,5] } ALIGN LEFT SIZE  40 PIXELS //"Tamanho"
ADD COLUMN TO oMonitor HEADER STR0007  		OEM DATA {|| aItens[oMonitor:nAt,6] } ALIGN LEFT SIZE 100 PIXELS //"Descricao"
ADD COLUMN TO oMonitor HEADER STR0008		OEM DATA {|| aItens[oMonitor:nAt,7] } ALIGN LEFT SIZE  40 PIXELS //"Data"
ADD COLUMN TO oMonitor HEADER STR0009	  	OEM DATA {|| aItens[oMonitor:nAt,8] } ALIGN LEFT SIZE  40 PIXELS //"Hora"
ADD COLUMN TO oMonitor HEADER STR0010		OEM DATA {|| aItens[oMonitor:nAt,9] } ALIGN LEFT SIZE  40 PIXELS //"Arquivo"
oMonitor:bLDblClick := {|| Pausa(),AtuTela()}


SET MESSAGE OF oMainWnd TO cTitulo NOINSET FONT oFont
DEFINE MSGITEM oMsgItem0 OF oMainWnd:oMsgBar PROMPT dDataBase SIZE 60
DEFINE MSGITEM oMsgItem1 OF oMainWnd:oMsgBar PROMPT STR0006+": " SIZE 170 //"Tamanho"
DEFINE MSGITEM oMsgItem2 OF oMainWnd:oMsgBar PROMPT STR0034+": " SIZE 180 //"Porta"
DEFINE MSGITEM oMsgItem3 OF oMainWnd:oMsgBar PROMPT STR0031+": " SIZE 150 //"Impressora"
DEFINE MSGITEM oMsgItem4 OF oMainWnd:oMsgBar PROMPT STR0032+": " SIZE 150 //"Fila"

DEFINE TIMER oTimer INTERVAL 1000 ACTION Gerencia() OF oMainWnd
ACTIVATE WINDOW oMainWnd MAXIMIZED valid (__cInternet:=NIL, Final(STR0011)) ON INIT (CargaIni(),AtuTela(),oTimer:Activate()) //"Termino Normal"

RELEASE OBJECTS oFont

Return nil

Static Function Pausa()
Local cAntes := MemoRead(aItens[oMonitor:nAt,11])
If	Subs(cAntes,52,10) == Padr("PAUSA",10)
	cAntes := Stuff(cAntes,52,10,"OK        ")      // status
Else
	cAntes := Stuff(cAntes,52,10,"PAUSA     ")      // status
EndIf
MemoWrite(aItens[oMonitor:nAt,11],cAntes)
Return

Static Function Gerencia()
Local nI := 0
Local nSemaforo:=0
nI := 0
oTimer:Deactivate()

If Empty(cFilaI) .or. Empty(cImp) .or. Empty(cPorta) .or. Empty(cPathS)
	lPausa := .t.
EndIf
If	lSai
	lSai   := .F.
	While !lSai
		ProcessMessage()
		If	lPausa
			If	! Alltrim(oMainWnd:cCaption) == Alltrim(cTitulo)
				If	nSemaforo >= 0
					Fclose(nSemaforo)
					FErase(Alltrim(cPathS)+"\"+Alltrim(cImp)+"\"+Alltrim(cFilaI)+"\SPOOL.SEM")
				EndIf
				oMainWnd:cCaption := cTitulo
				oMainWnd:Refresh()
			EndIf
			AtuTela()
		Else
			If	! Alltrim(oMainWnd:cCaption) == Alltrim(cTitulo+STR0013) //" (Ativado)"
				nSemaforo := MSFCreate(Alltrim(cPathS)+"\"+Alltrim(cImp)+"\"+Alltrim(cFilaI)+"\SPOOL.SEM")
				If	nSemaforo < 0
					__cInternet := NIL
					MsgAlert(STR0012) //" Esta fila esta ativa em outra janela "
					lPausa:= .t.
					sleep(50)
					Loop
				EndIf
				oMainWnd:cCaption := cTitulo+STR0013 //" (Ativado)"
				oMainWnd:Refresh()
			EndIf
			AtuTela()
			If	Len(aFile) > 0
				Imprime()
			EndIf
		EndIf
		Sleep(50)
	EndDo
	If	nSemaforo >= 0
		Fclose(nSemaforo)
		FErase(Alltrim(cPathS)+"\"+Alltrim(cImp)+"\"+Alltrim(cFilaI)+"\SPOOL.SEM")
	EndIf
EndIf
Return .T.

Static Function Imprime()
Local NX
Local aImpressao,aDelete
Local cPath := Alltrim(cPathS)+"\"+Alltrim(cImp)+"\"+Alltrim(cFilaI)+"\"
Local nPos
Local cconteudo
Local nLimite
Static xaArq:={}

aImpressao := Directory(cPath+Left(aFile[1,1],8)+".*")
aImpressao := aSort(aImpressao,,,{|x,y| x[1] < y[1]})
For nX := 1 to Len(aImpressao)
	If	Subs(aImpressao[nX,1],10) =="0000"                                                                                              //      +-----.T.  server
		If	ascan(xaArq,aImpressao[nX,1]) == 0                                                                                             //      V
			aadd(xaArq,aImpressao[nX,1])
			If	Left(cDriveWin,1)# "N"
				__cInternet:=NIL
				SetPrint(,aImpressao[nX,1],nil ,STR0058,aImpressao[nX,1],'','',.F.,"",.F.,"P",nil    ,.f.,nil ,'EPSON.DRV',.T.,.f.,Alltrim(cPorta)) //"Impressao de Etiqueta"
				SetDefault(aReturn,"")
			Else
				cModelo:=AllTrim(Subs(Memoread(cPath+aImpressao[nX,1]),63,20))
				If	Empty(cModelo)
					cModelo:="ALLEGRO"
					U_MSCBPRINTER(cModelo,Alltrim(cPorta)+":"+Alltrim(cSettings),,,.F.,,,,,,,)
					U_MSCBCHKSTATUS(.f.)
				Else
					U_MSCBPRINTER(cModelo,Alltrim(cPorta)+":"+Alltrim(cSettings),,,.F.,,,,,,,)
					U_MSCBCHKSTATUS(.t.)
				EndIf
			EndIf
		EndIf
		Loop
	EndIf
	If	Upper(Alltrim(Subs(aImpressao[nX,1],10))) =="END"
		nPos := ascan(xaArq,Left(aImpressao[nX,1],8)+".0000")
		If	nPos#0
			adel(xaArq,nPos)
			xaArq := aSize(xaArq,Len(xaArq)-1)
		EndIf
		If	Left(cDriveWin,1)# "N"
			// deletar o item do array xaArq
			Set device to Screen
			If aReturn[5]==1
				dbCommitAll()
				SET PRINTER TO
				OurSpool(wnrel)
			EndIf
			MS_FLUSH()
		Else
			U_MSCBClosePrinter()
		EndIf
		If	File(cPath+"impresso\"+Left(aImpressao[nX,1],8)+".0000")
			FErase(cPath+"impresso\"+Left(aImpressao[nX,1],8)+".0000")
		EndIf
		FRename(cPath+Left(aImpressao[nX,1],8)+".0000",cPath+"impresso\"+Left(aImpressao[nX,1],8)+".0000")
		If	File(cPath+"impresso\"+Left(aImpressao[nX,1],8)+".END")
			FErase(cPath+"impresso\"+Left(aImpressao[nX,1],8)+".END")
		EndIf
		FRename(cPath+Left(aImpressao[nX,1],8)+".END",cPath+"impresso\"+Left(aImpressao[nX,1],8)+".END")
		Exit
	EndIf
	cConteudo :=""
	While Empty(cConteudo)
		cConteudo := MemoRead(cPath+aImpressao[nX,1])
		Sleep(100)
	End
	If	Left(cDriveWin,1)# "N"
		If	FindFunction("RAWPRINTOUT")
			RawPrintOut(cConteudo)
		Else
			PrintOut(0,0,cconteudo)
		EndIf
	Else
		U_MSCBWrite(NIL,"ABRE")
		U_MSCBWrite(cconteudo)
		U_MSCBWrite(NIL,"FECHA")
	EndIf
	If	File(cPath+"impresso\"+aImpressao[nX,1])
		FErase(cPath+"impresso\"+aImpressao[nX,1])
	EndIf
	FRename(cPath+aImpressao[nX,1],cPath+"impresso\"+aImpressao[nX,1])
	Exit
Next

nLimite := Val(cLimLixeira)
aDelete := Directory(cPath+"impresso\"+"*.0000")
aDelete := aSort(aDelete,,,{|x,y| x[1] < y[1]})
For nX := 1 to Len(aDelete)-nLimite
	aEval(Directory(cPath+"impresso\"+Left(aDelete[nX,1],8)+".*"),{ |x|FErase(cPath+"impresso\"+x[1]) })
Next
Return

Static Function AtuTela(lforcaRefresh)
Local aItensAnt:={}
If	lforcaRefresh == NIL
	lforcaRefresh := .f.
EndIf
aItensAnt := Aclone(aItens)
aItens:=CarregaItens()[1]
afile :=CarregaItens()[2]
If	Len(aItens) # Len(aItensAnt) .or. aItens[1,1] # aItensAnt[1,1] .or. lforcaRefresh
	oMonitor:SetArray(aItens)
	oMonitor:bLine := { || {aItens[oMonitor:nAt,1],aItens[oMonitor:nAt,2],aItens[oMonitor:nAt,3],aItens[oMonitor:nAt,4],aItens[oMonitor:nAt,5],aItens[oMonitor:nAt,6],aItens[oMonitor:nAt,7],aItens[oMonitor:nAt,8],aItens[oMonitor:nAt,9],aItens[oMonitor:nAt,10]}}
	oMonitor:Refresh()
EndIf
Return

Static Function CarregaItens()
Local aImpressao
Local nX         := 0
Local aCabec     := {}
Local cLinha     := ""
Local nH         := 0
Local cCodUsu    := ""
Local cUsuario   := ""
Local cSize      := ""
Local cDesc      := ""
Local cStatus    := ""
Local cPriori    := ""
Local cPath      := Alltrim(cPathS)+"\"+Alltrim(cImp)+"\"+Alltrim(cFilaI)+"\"
Local aImpFiltro := {}

aImpressao := Directory(cPath+"*.0000")
For nX := 1 to Len(aImpressao)
	nH := FOpen(cPath+aImpressao[nX,1])
	cLinha := Space(62)
	FRead(nH,@cLinha,62)
	FClose(nH)
	// codusunome           tamanho        descricao      status    !
	// *     *              *              *              *         *
	// 12345612345678901234512345678901234512345678901234512345678901
	//         1          2         3         4         5         6
	// 12345678901234567890123456789012345678901234567890123456789012
	cCodUsu := Left(cLinha,6)
	cUsuario:= Subs(cLinha,7,15)
	cSize   := Subs(cLinha,22,15)
	cDesc   := Subs(cLinha,37,15)
	cStatus := Subs(cLinha,52,10)
	cPriori := Subs(cLinha,62,1)
	cData   := Dtoc(aImpressao[nX,3])
	cHora   := aImpressao[nX,4]
	nQtde   := len(Directory(cPath+Left(aImpressao[nX,1],8)+".*"))-2
	aadd(aCabec,{cStatus,cPriori,cCodUsu,cUsuario,cSize,cDesc,cData,cHora,aImpressao[nX,1],Str(nqtde,5),cPath+aImpressao[nX,1],cPriori})
	// If	cStatus # Padr("PAUSA",10) .and. Upper(Alltrim(cSize)) == Upper(Alltrim(cTam))
		aadd(aImpFiltro,{aImpressao[nX,1],cPriori})
	// EndIf
Next
aCabec     := Asort(aCabec,,,{|x,y| x[12]+x[11] < y[12]+y[11]})
aImpFiltro := Asort(aImpFiltro,,,{|x,y| x[2]+x[1] < y[2]+y[1]})
If	Len(aCabec)==0
	aadd(aCabec, { '','','','', '','','','','','',''})
EndIf
Return {aCabec,aImpFiltro}

Static Function CargaIni()
Local cIniFile := "C:\MSCBSPOOL.INI"
cFilaI      := GetPvProfString("SETUP"+cParamSp, "FILA",		"",			cIniFile )
cPathS      := GetPvProfString("SETUP"+cParamSp, "PATH",		"\IMPTER",	cIniFile )
cImp        := GetPvProfString("SETUP"+cParamSp, "IMPRESSORA",	"",			cIniFile )
cPorta      := GetPvProfString("SETUP"+cParamSp, "PORTA",		"",			cIniFile )
cTam        := GetPvProfString("SETUP"+cParamSp, "FILTRO",		"",			cIniFile )
cDriveWin   := GetPvProfString("SETUP"+cParamSp, "DRIVEWIN",	"Sim",		cIniFile )
cSettings   := Padr(GetPvProfString("SETUP"+cParamSp,"SETTINGS",Space(20),	cIniFile ),20)
cLimLixeira := GetPvProfString("SETUP"+cParamSp, "LIMLIXEIRA",	"99999999",	cIniFile)

oMsgItem1:SetText( STR0006+": "+cTam )				//"Tamanho"
oMsgItem2:SetText( STR0034+": "+cPorta )			//"Porta"
oMsgItem3:SetText( STR0031+": "+cImp)				//"Impressora"
oMsgItem4:SetText( STR0032+": "+Alltrim(cFilaI) )	//"Fila"
oMsgItem1:refresh()
oMsgItem2:refresh()
oMsgItem3:refresh()
oMsgItem4:refresh()
Return


/*±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³CarregaFila ³ Autor ³ TOTVS		        ³ Data ³          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Impressora		                                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ CarregaFila(cImp)                                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC1 = Impressora		                                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function CarregaFila(cImp)
Local cPath := AllTrim(cPathS)+"\"+cImp+"\*.*"
Local aDir  := Directory(cPath,"D")
Local aFila := {}
Local nX    := 0
If	Empty(cImp)
	aFilaPar := {"          "}
	Return aFilaPar
EndIf
For nX := 1 To Len(aDir)
	If	!(AllTrim(aDir[nX,1]) $ ".ú..")
		aAdd(aFila,aDir[nX,1])
	EndIf
Next nX
aAdd(aFila,"")
aFila    := aSort(aFila)
aFilaPar := aClone(aFila)
Return aFilaPar

Static Function Prioridade()
Local cPri := " "
Local oDlgPri
Local cAntes
Local oPri
Local aPri := {STR0014,STR0015,STR0016,STR0017,STR0018,STR0019,STR0020,STR0021,STR0022} //"1-Um"###"2-Dois"###"3-Tres"###"4-Quatro"###"5-Cinco"###"6-Seis"###"7-Sete"###"8-Oito"###"9-Nove"
Local npri
Local nOpcao:=0
Local oSbr
If	Len(aItens) == 1 .and. Empty(aItens[1,1])
	Return
EndIf
cAntes := MemoRead(aItens[oMonitor:nAt,11])
nPri := Val(Subs(cAntes,62,1) )
cPri := aPri[nPri]

DEFINE MSDIALOG oDlgPri TITLE STR0023 FROM 26,43 TO 273,482 PIXEL  //"Ajuste de prioridade"
	@ 6,7 SCROLLBOX oSbr VERTICAL SIZE 94,206 OF oDlgPri BORDER
	oDlgPri:SetWallPaper("FUNDOBARRA")
	@ 06,10 Say STR0024 PIXEL of oSbr   //"Prioridade:"
	@ 05,70 MSCOMBOBOX oPri    VAR cPri    ITEMS aPri    SIZE 60,09 PIXEL OF oSbr

DEFINE SBUTTON FROM 105,147 TYPE 1 ACTION (nOpcao:=1,oDlgPri:End()) OF oDlgPri ENABLE
DEFINE SBUTTON FROM 105,180 TYPE 2 ACTION (nOpcao:=0,oDlgPri:End()) OF oDlgPri ENABLE
ACTIVATE MSDIALOG oDlgPri CENTERED
If	nOpcao ==1
	cAntes := Stuff(cAntes,62,1,Left(cPri,1))
	MemoWrite(aItens[oMonitor:nAt,11],cAntes)
	AtuTela(.t.)
EndIf
Return

Static Function Excluir()
Local cArq1:=Space(12),oArq1
Local cArq2:=Space(12),oArq2
Local oDlgExc
Local oSBr
Local nOpcao := 0
Local aImpressao
Local nX
Local cPath := Alltrim(cPathS)+"\"+Alltrim(cImp)+"\"+Alltrim(cFilaI)+"\"
If	len(aItens) == 1 .and. Empty(aItens[1,1])
	Return
EndIf
cArq1 := Left(aItens[oMonitor:nAt,9],8)
cArq2 := Left(aItens[oMonitor:nAt,9],8)

DEFINE MSDIALOG oDlgExc TITLE STR0025 FROM 26,43 TO 273,482 PIXEL  //"Exclusao de impressao "
	@ 6,7 SCROLLBOX oSbr VERTICAL SIZE 94,206 OF oDlgExc BORDER
	oDlgExc:SetWallPaper("FUNDOBARRA")
	@ 06,10 Say STR0026 PIXEL of oSbr //"Arquivo de:"
	@ 05,70 MsGet oArq1 Var cArq1 Picture "@!"  PIXEL of oSbr  SIZE 60,09
	@ 21,10 Say STR0027 PIXEL of oSbr //"Arquivo ate:"
	@ 20,70 MsGet oArq2 Var cArq2 Picture "@!"  PIXEL of oSbr  SIZE 60,09

DEFINE SBUTTON FROM 105,147 TYPE 1 ACTION (nOpcao:=1,oDlgExc:End()) OF oDlgExc ENABLE
DEFINE SBUTTON FROM 105,180 TYPE 2 ACTION (nOpcao:=0,oDlgExc:End()) OF oDlgExc ENABLE
ACTIVATE MSDIALOG oDlgExc CENTERED
If	nOpcao == 1
	If	! MsgYesNo(STR0028) //"Confirma a exclusao"
		Return
	EndIf
	aImpressao := Directory(cPath+"*.*")
	For nX := 1 to Len(aImpressao)
		If	Left(aImpressao[nX,1],8) >=Left(cArq1,8) .and.;
			Left(aImpressao[nX,1],8) <=Left(cArq2,8) .and.;
			Alltrim(Upper(aImpressao[nX,1])) # "CTRL.SEQ"
			FRename(cPath+aImpressao[nX,1],cPath+"impresso\"+aImpressao[nX,1])
		EndIf
	Next
	AtuTela(.t.)
EndIf
Return

/*±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³Parametros  ³ Autor ³ TOTVS		        ³ Data ³          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Tela de parametro                                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ Parametros()		                                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function Parametros()
Local oDlgPar
Local oSBr
Local nOpcao    := 0
Local nX

Local oPrg
Local cPrg      := ""
Local aPrg      := {"DPL","EPL","IPL","ZPL","TXT"}

Local oImp
Local cImpPar  	:= cImp
Local aImp      := {}

Local oPorta
Local cPortaPar := cPorta
Local aPorta    := aClone(RetImpWin(.F. ))//{"LPT1","LPT2","COM1","COM2","COM3","COM4"}
Local aRetPE    := {}

Local cTamPar   := Padr(cTam,15)
Local oTam

Local cPathIni  := Padr(cPathS,15)
Local oPath

Local oDrivePar
Local cDrivePar := cDriveWin
Local aDrivePar := {STR0064,STR0065} //"Sim"###"Nao"

Local oSettPar
Local cSettPar  := cSettings

Local oLimLixeira
Local cLimite   := cLimLixeira


Local cIniFile := "C:\MSCBSPOOL.INI"
Local cFilaAnt  := cFilaI

Local oFila
Local cFilaPar	:= cFilaI
Local aFilaPar	:= {""}

Static nRefresh := 0
Static cPrgAux 	:= ''    

aImp:= aSort(aImp)
If ! lPausa
	MsgInfo(STR0059) //"Para modificar os parametros e necessario desativar o processo"
	Return
EndIf

aAdd(aPorta,nil); aIns(aPorta,1); aPorta[1] := "COM4"
aAdd(aPorta,nil); aIns(aPorta,1); aPorta[1] := "COM3"
aAdd(aPorta,nil); aIns(aPorta,1); aPorta[1] := "COM2"
aAdd(aPorta,nil); aIns(aPorta,1); aPorta[1] := "COM1"
aAdd(aPorta,nil); aIns(aPorta,1); aPorta[1] := "LPT4"
aAdd(aPorta,nil); aIns(aPorta,1); aPorta[1] := "LPT3"
aAdd(aPorta,nil); aIns(aPorta,1); aPorta[1] := "LPT2"
aAdd(aPorta,nil); aIns(aPorta,1); aPorta[1] := "LPT1"
//-- Ponto de entrada para incluir saidas na var. aPorta  
If	ExistBlock("MSCBPORT")
	aRetPE := ExecBlock("MSCBPORT",.F.,.F.,{aPorta})
	aPorta := If(ValType(aRetPE)=="A",aRetPE,aPorta)
EndIf

aFilaPar := aClone(CarregaFila(cImpPar))

If U_MSCbModelo('ZPL',cImpPar)
	cPrg := 'ZPL'
ElseIf U_MSCbModelo('DPL',cImpPar)
	cPrg := 'DPL'
ElseIf U_MSCbModelo('EPL',cImpPar)
	cPrg := 'EPL'
ElseIf U_MSCbModelo('IPL',cImpPar)
	cPrg := 'IPL'
ElseIf U_MSCbModelo('TXT',cImpPar)
	cPrg := 'TXT'
EndIf
cPrgAux := cPrg
aImp 	:= TrataModelo(cPrg)
DEFINE MSDIALOG oDlgPar TITLE STR0029 FROM 26,43 TO 273,482 PIXEL  //"Parametros "

	@ 6,7 SCROLLBOX oSbr VERTICAL SIZE 94,206 OF oDlgPar BORDER
	oDlgPar:SetWallPaper("FUNDOBARRA")

	@ 06,10 Say STR0030 PIXEL of oSbr  //"Prg. Nativa"
  	@ 05,70 MSCOMBOBOX oPrg VAR cPrg ITEMS aPrg SIZE 120,09 PIXEL OF oSbr Valid (MSCBValid(cPrg,oImp,cImpPar,oFila))

	@ 21,10 Say STR0031 PIXEL of oSbr //"Impressora"
	@ 20,70 MSCOMBOBOX oImp VAR cImpPar ITEMS aImp SIZE 120,09 PIXEL OF oSbr Valid (aFilaPar:=aClone(CarregaFila(cImpPar)),oFila:SetItems(aFilaPar),oFila:Refresh(),.t.)

	@ 36,10 Say STR0032 PIXEL of oSbr	//"Fila"
	@ 35,70 MSCOMBOBOX oFila VAR cFilaPar ITEMS aFilaPar SIZE 108,09 PIXEL OF oSbr Valid (AtuTela(.t.),.t.)
	TButton():New( 35, 178, "+", oSbr,{||If(CriaFila(cImpPar),(aFilaPar:=aClone(CarregaFila(cImpPar)),oFila:SetItems(aFilaPar),oFila:Refresh(),.t.),.T.)}, 10, 11,,,,.T.,,STR0033,,{||!Empty(cPrg).And.!Empty(cImpPar)},,) //"Inclusao de Fila"

	@ 51,10 Say STR0034 PIXEL of oSbr //"Porta"
	@ 50,70 MSCOMBOBOX oPorta VAR cPortaPar ITEMS aPorta SIZE 120,09 PIXEL OF oSbr

	@ 66,10 Say STR0006 PIXEL of oSbr //"Tamanho"
	@ 65,70 MsGet oTam Var cTamPar Picture "@!" PIXEL of oSbr SIZE 120,09 

	@ 81,10 Say STR0035 PIXEL of oSbr //"Path"
	@ 80,70 MsGet oPath Var cPathIni Picture "@!" PIXEL of oSbr SIZE 120,09 

	@ 96,10 Say STR0036 PIXEL of oSbr //"Drive Windows"
	@ 95,70 MSCOMBOBOX oDrivePar VAR cDrivePar ITEMS aDrivePar SIZE 120,09 PIXEL OF oSbr

	@ 111,10 Say STR0037 PIXEL of oSbr //"Settings"
	@ 110,70 MsGet oSettPar Var cSettPar Picture "@!" PIXEL of oSbr SIZE 120,09 WHEN cDrivePar==aDrivePar[2] .And. "COM" $ cPortaPar

	@ 126,10 Say STR0038 PIXEL of oSbr //"Limite Lixeira"
	@ 125,70 MsGet oLimLixeira Var cLimite Picture "@!" PIXEL of oSbr SIZE 120,09


DEFINE SBUTTON FROM 105,147 TYPE 1 ACTION (nOpcao:=1,oDlgPar:End()) OF oDlgPar ENABLE
DEFINE SBUTTON FROM 105,180 TYPE 2 ACTION (nOpcao:=0,oDlgPar:End()) OF oDlgPar ENABLE
ACTIVATE MSDIALOG oDlgPar CENTERED
If	nOpcao == 1 .And. !Empty(cFilaPar)
	WritePProString( "SETUP"+cParamSp,"FILA",		cFilaPar,	cIniFile )
	WritePProString( "SETUP"+cParamSp,"IMPRESSORA",	cImpPar,	cIniFile )
	WritePProString( "SETUP"+cParamSp,"PORTA",		cPortaPar,	cIniFile )
	WritePProString( "SETUP"+cParamSp,"FILTRO",		cTamPar,	cIniFile )
	WritePProString( "SETUP"+cParamSp,"PATH",		cPathIni,	cIniFile )
	WritePProString( "SETUP"+cParamSp,"DRIVEWIN",	cDrivePar,	cIniFile )
	If	(cDrivePar==aDrivePar[2] .and. "COM" $ cPortaPar)
		WritePProString( "SETUP"+cParamSp,"SETTINGS",cSettPar, cIniFile )
	Else
		WritePProString( "SETUP"+cParamSp,"SETTINGS",Space(20), cIniFile )
	EndIf
	WritePProString( "SETUP"+cParamSp,"LIMLIXEIRA",cLimite, cIniFile )
	cFilaI:=cFilaPar
	cImp:=cImpPar
	cPorta:=cPortaPar
	cTam:=cTamPar
	cPathS:=cPathIni
	cSettings:= cSettPar
	cDriveWin:= cDrivePar
	cLimLixeira:=cLimite
	oMsgItem1:SetText( STR0006+": "+cTam )				//"Tamanho"
	oMsgItem2:SetText( STR0034+": "+cPorta )			//"Porta"
	oMsgItem3:SetText( STR0031+": "+cImp)				//"Impressora"
	oMsgItem4:SetText( STR0032+": "+Alltrim(cFilaI) )	//"Fila"
	oMsgItem1:refresh()
	oMsgItem2:refresh()
	oMsgItem3:refresh()
	oMsgItem4:refresh()
Else
	cFilaI:=cFilaAnt
EndIf
AtuTela(.t.)
Return

Static Function TrataModelo(cPrg)
Local aModelo := {}
Local nX:=0
Local aImp:={}
U_MSCBModelo(cPrg,,,@aModelo)
For nX:= 1 to len(aModelo)
	aadd(aImp,aModelo[nX,1])
Next
Return aClone(aImp)


Static Function CriaFila(cImp)
Local oDlg,oFila,cFila:=Space(255)
Local cPath := Alltrim(cPathS)+"\"+cImp+"\"
Local aDir
Local lRet := .F.

DEFINE MSDIALOG oDlg TITLE STR0039+cPath FROM 26,43 TO 120,482 PIXEL  //"Cria Fila em "
	oDlg:SetWallPaper("FUNDOBARRA")
	@ 06,10 Say STR0040 PIXEL of oDlg   //"Informe o Nome da Fila:"
	@ 05,70 MsGet oFila Var cFila Picture "@!"  PIXEL of oDlg SIZE 140,09 

DEFINE SBUTTON FROM 30,147 TYPE 1 ACTION (lRet := .T.,oDlg:End()) OF oDlg ENABLE WHEN(!Empty(cFila))
DEFINE SBUTTON FROM 30,180 TYPE 2 ACTION (oDlg:End()) OF oDlg ENABLE
ACTIVATE MSDIALOG oDlg CENTERED

If	lRet
	cFila := AllTrim(cFila)
	aDir:=Directory(cPath+"*.*","D")
	If	aScan(aDir,{|x| UPPER(x[1])==cFila}) > 0
		MsgAlert(STR0045+'"'+cFila+'"'+STR0046) //'A Fila '###' ja existe!'
		lRet := .F.
	EndIf
EndIf
If	lRet
	If	MAKEDIR(cPath+cFila)	== 0
		MsgAlert(STR0045+'"'+cFila+'"'+STR0047) //'A Fila '###' foi criada com sucesso!'
		lRet := .T.
	Else
		MsgAlert(STR0048+'"'+cFila+'"!') //'Problemas na criacao da Fila '
		lRet := .F.
	EndIf
EndIf
Return lRet

///------------------------------ funcoes para controle da lixeira --------------------------------------
Static Function Lixeira(nOpcao)
Local nOpca := 0
Local aStru := {}
Local cArqTrab
Local aCpos := {}
Local oMark
Local oDlg
Local cPath := Alltrim(cPathS)+"\"+Alltrim(cImp)+"\"+Alltrim(cFilaI)+"\impresso"+"\"
Local aImpressao
Local aQtde
Local nX
Local nH
Local cLinha
Local cSize
Local cDesc
Local dData
Local cHora
Local nBottom
Local aPosEnch

Private lInverte := .F.
Private cMarca := '6j'
If	lSai
	Return
EndIf
If	! lPausa
	MsgInfo(STR0060) //"Para acessar a lixeira, necessario desativar o processo"
	Return
EndIf

If	ExistBlock("MSCBLIXO")
	If	! ExecBlock("MSCBLIXO")
		Return
	EndIf
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria Arquivo de Trabalho para a escolha dos ensaios ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Aadd( aStru,{ "TB_OK",		"C",02,0} )
Aadd( aStru,{ "TB_ARQ",		"C",13,0} )
Aadd( aStru,{ "TB_DESC",	"C",15,0} )
Aadd( aStru,{ "TB_TAM",		"C",15,0} )
Aadd( aStru,{ "TB_DATA",	"D",08,0} )
Aadd( aStru,{ "TB_HORA",	"C",08,0} )
Aadd( aStru,{ "TB_QTDE",	"N",05,0} )

cArqTrab := CriaTrab(aStru)
dbUseArea(.T.,,cArqTrab,"TRB",.F.,.F.)

IndRegua("TRB",cArqTrab,"TB_ARQ",,,)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Redefinicao do aCpos para utilizar no MarkBrow ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aCpos := {	{"TB_OK",	"","Ok" },;
			{"TB_ARQ",	"",STR0010},; //"Arquivo"
			{"TB_DESC",	"",STR0007},; //"Descricao"
			{"TB_TAM",	"",STR0006},; //"Tamanho"
			{"TB_DATA",	"",STR0008},; //"Data"
			{"TB_HORA",	"",STR0009},; //"Hora"
			{"TB_QTDE",	"",STR0041}}  //"Quantidade"

aImpressao := Directory(cPath+"*.0000")
For nX := 1 to Len(aImpressao)
	nH := FOpen(cPath+aImpressao[nX,1])
	cLinha := Space(62)
	FRead(nH,@cLinha,62)
	FClose(nH)
	aQtde :=Directory(cPath+Left(aImpressao[nX,1],8)+".*")
	cSize := Subs(cLinha,22,15)
	cDesc := Subs(cLinha,37,15)
	dData := aImpressao[nX,3]
	cHora := aImpressao[nX,4]
	RecLock("TRB",.T.)
	TRB->TB_ARQ :=aImpressao[nX,1]
	TRB->TB_DESC:=cDesc
	TRB->TB_TAM	:=cSize
	TRB->TB_DATA:=dData
	TRB->TB_HORA:=cHora
	TRB->TB_QTDE:=Len(aQtde)-2
	MsUnlock()
Next
dbSelectArea("TRB")
dbGoTop()

nBottom := Int(TranslateBottom(.F.,20))
If	nBottom <=28
	nBottom := 28
ElseIf	nBottom == 34 .or. nBottom ==35	
	nBottom := 34
ElseIf	nBottom >= 45
	nBottom := 45
Else
	nBottom := 34
EndIf
SETAPILHA()
DEFINE MSDIALOG oDlg TITLE If(nOpcao==1,STR0061,STR0062) FROM 9,0 TO nBottom-3,80 OF oMainWnd //"Restauracao da Lixeira"###"Limpeza da Lixeira"
	If	nBottom == 28
		aPosEnch   := {13,1,120,316}
	ElseIf	nBottom == 34
		aPosEnch   := {13,1,167,316}
	ElseIf	nBottom == 45
		aPosEnch   := {13,1,249,316}
	Else
		aPosEnch   := {13,1,167,316}
	EndIf
oMark := MsSelect():New("TRB","TB_OK",,acpos,lInverte,cMarca,aPosEnch) //{20,1,125,250})
oMark:oBrowse:lCanAllMark:= .T.
oMark:oBrowse:lHasMark   := .T.
oMark:bMark              := {| | CBLxEscolha(cMarca,lInverte,oDlg)}
oMark:oBrowse:bAllMark   := {| | CBLxMarkAll(cMarca,oDlg)}
ACTIVATE MSDIALOG oDlg CENTERED ON INIT CBxEncBar(oDlg,nOpcao,@nOpcA)
If	nOpcA == 1
	CBLxGrava(nOpcao)
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Deleta Arquivo Temporario ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("TRB")
TRB->(dbClearFilter())
TRB->(dbCloseArea())
Ferase(cArqTrab+GetDBExtension())
FErase(cArqTrab+OrdBagExt())
Return

//-- Monta a EnchoiceBar da Lixeira
Static Function CBxEncBar(oDlg,nOpcao,nOpcA)
Local oBar
//-- Define a barra de botoes
DEFINE BUTTONBAR oBar SIZE 25,25 3D TOP OF oDlg
//-- Define botoes OK/CANCEL
DEFINE BUTTON oButton01 RESOURCE "OK"		OF oBar GROUP ACTION (If(CBLxVerMark() .And. MsgYesNo(STR0042+if(nOpcao=1,STR0043, STR0044)),(nOpcA:=1,oDlg:End()),nOpcA:=0)) //"Confirma a "###"restauracao"###"exclusao"
DEFINE BUTTON oButton02 RESOURCE "CANCEL"	OF oBar GROUP ACTION (nOpcA:=0,oDlg:End())
Return Nil

Static Function CBLxGrava(nOpcao)
Local nRecno
Local cPath := Alltrim(cPathS)+"\"+Alltrim(cImp)+"\"+Alltrim(cFilaI)+"\"
Local aImpressao
Local nX
dbSelectArea("TRB")
nRecno:=Recno()
dbGotop()
Do While !Eof()
	If	IsMark("TB_OK",ThisMark(),ThisInv()) //Esta linha verifica se o registro posicionado esta marcardo.
		aImpressao := Directory(cPath+"impresso\"+Left(TRB->TB_ARQ,8)+".*")
		For nX := 1 to Len(aImpressao)
			If	nOpcao == 1
				FRename(cPath+"impresso\"+aImpressao[nX,1],cPath+aImpressao[nX,1])
			Else
				FErase(cPath+"impresso\"+aImpressao[nX,1])
			EndIf
		Next
	EndIf
	dbSkip()
EndDo
dbGoto(nRecno)
Return .f.

Static Function CBLxVerMark()
Local nRecno
dbSelectArea("TRB")
nRecno:=Recno()
dbGotop()
Do While !Eof()
	If	IsMark("TB_OK",ThisMark(),ThisInv()) //Esta linha verifica se o registro posicionado esta marcardo.
		Return .T.
	EndIf
	dbSkip()
EndDo
dbGoto(nRecno)
MsgAlert(STR0063) //"Nao existe nenhum item selecionado"
Return .f.

Static Function CBLxMarkAll(cMarca,oDlg)
Local nRecno:=Recno()
dbGotop()
Do While !Eof()
	RecLock("TRB",.F.)
	If	Empty(TRB->TB_OK)
		TRB->TB_OK	:= cMarca
	Else
		TRB->TB_OK	:= "  "
	Endif
	MsUnlock()
	dbSkip()
EndDo
dbGoto(nRecno)
oDlg:Refresh()
Return .T.

Static Function CBLxEscolha(cMarca,lInverte,oDlg)
If	IsMark("TB_OK",cMarca,lInverte)
	RecLock("TRB",.F.)
	If	!lInverte
		TRB->TB_OK	:= cMarca
	Else
		TRB->TB_OK	:= "  "
	EndIf
	MsUnlock()
Else
	RecLock("TRB",.F.)
	If	!lInverte
		TRB->TB_OK	:= "  "
	Else
		TRB->TB_OK	:= cMarca
	EndIf
	MsUnlock()
EndIf
oDlg:Refresh()
Return .T.
///------------------------------ fim das funcoes para controle da lixeira --------------------------------------

/*±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³MSCBValid ³ Autor ³ Bruno Schmidt         ³ Data ³ 24/01/11 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Funcao para o tratamento do Refres da tela                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ MSCBValid(cPrg,oImp,cImpPar,oFila)                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC1 = Prg. Nativa 		                                  ³±±
±±³          ³ ExpO1 = Objeto das Impressoras							  ³±±
±±³          ³ ExpC2 = Impressora Selecionada                             ³±±
±±³          ³ ExpO2 = Objeto						                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SIGAACD                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/     
Static Function MSCBValid(cPrg,oImp,cImpPar,oFila)    

If AllTrim(cPrgAux) <> AllTrim(cPrg)
	nRefresh :=1  
Else
	nRefresh := 0	  
EndIF

If nRefresh == 1
	aImp:=TrataModelo(cPrg)
	oImp:SetItems(aImp)
 	oImp:Refresh()
	aFilaPar:=aClone(CarregaFila(cImpPar))
	oFila:SetItems(aFilaPar)
	oFila:Refresh()  
	CarregaFila(cImpPar)
	nRefresh:= 0
	cPrgAux	:= cPrg	
EndIF 

Return Nil
