#INCLUDE 'TBICONN.CH' 
#include "PROTHEUS.CH"
#INCLUDE "TCBROWSE.CH"
Static __oP := NIL

Static __nSem


 
/*
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北谀哪哪哪哪穆哪哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘�
北矲un噮o    矼SCBPRINTER � Autor � ALEX SANDRO VALARIO � Data �  05/98   潮�
北媚哪哪哪哪呐哪哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪幢�
北矰escri噮o � Confirgura qual a impressora e a saida utilizada           潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砅arametros� ModelPrt  = String com o modelo de impressara Zebra        潮�
北�          � cPorta    = String com a porta   ex.: "COM2:9600,e,7,2"    潮�
北�          � nDensidade= Numero com a densidade ref qtde de pixel por mm潮�
北�          � nTamanho  = Tamhado da etiqueta em mm.                     潮�
北�          � lSrv      = Se .t. imprime no server,.f. no client         潮�
北�          � nPorta    = numero da porta de outro server                潮�
北�          � cServer   = enderdeco IP de outro server                   潮�
北�          � cEnv      = enviroment do outro server                     潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北� Uso      � Impress苚 de etiquetas cigo de Barras ()                 潮�
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌�
*/
User Function MSCBPRINTER(ModelPrt,cPorta,nDensidade,nTamanho,lSrv,nPorta,cServer,cEnv,nMemoria,cFila,lDrvWin,cPathIni)
Local aArea:= GetArea()
If MSCbModelo('ZPL',ModelPrt)
   __oP:= MSCBZPL():New(ModelPrt,cPorta,nDensidade,nTamanho,lSrv,nPorta,cServer,cEnv,nMemoria,cFila,lDrvWin,cPathIni) 
ElseIf MSCbModelo('DPL',ModelPrt)
   __oP:= MSCBDPL():New(ModelPrt,cPorta,nDensidade,nTamanho,lSrv,nPorta,cServer,cEnv,nMemoria,cFila,lDrvWin,cPathIni) 
ElseIf MSCbModelo('EPL',ModelPrt)
   __oP:= MSCBEPL():New(ModelPrt,cPorta,nDensidade,nTamanho,lSrv,nPorta,cServer,cEnv,nMemoria,cFila,lDrvWin,cPathIni) 
ElseIf MSCbModelo('IPL',ModelPrt)
   __oP:= MSCBIPL():New(ModelPrt,cPorta,nDensidade,nTamanho,lSrv,nPorta,cServer,cEnv,nMemoria,cFila,lDrvWin,cPathIni) 
Else         
   // modelo nao encontado, portanto default zebra com densidade 6
	__oP:= MSCBZPL():New("S500-6",cPorta,nDensidade,nTamanho,lSrv,nPorta,cServer,cEnv,nMemoria,cFila,lDrvWin,cPathIni)    
EndIf                
__oP:Setup()
RestArea(aArea)
Return ''

/*
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北谀哪哪哪哪穆哪哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘�
北矲un噮o    � MSCBBEGIN  � Autor � ALEX SANDRO VALARIO � Data �  05/98   潮�
北媚哪哪哪哪呐哪哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪幢�
北矰escri噮o � Inicio da cria嚻o da imagem de cada etiqueta               潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砅aramentro� nQtde     = Quantidade                                     潮�
北�          � nVeloc    = Velocidade (1,2,3,4,5,6) polegada por segundo  潮�
北�          � nTamanho  = Tamhado da etiqueta em mm.                     潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砇etorno   � NIL                                                        潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北� Uso      � Impress苚 de etiquetas cigo de Barras ()                 潮�
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌�
*/
User Function MSCBBEGIN(nxQtde,nVeloc,nTamanho,lSalva)	 //ok              
__oP:CBBegin(nxQtde,nVeloc,nTamanho,lSalva)
Return ''

/*
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北谀哪哪哪哪穆哪哪哪哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘�
北矲un噮o    � MSCBCopiesSer  � Autor � ALEX SANDRO VALARIO � Data � 	02/09 潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪幢�
北矰escri噮o � Faz a copia da serie							                  潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砅aramentro� nCopias     = Copias                                     	  潮�
北�          � 																  潮�
北�          � 														      	  潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砇etorno   � NIL                          	                              潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北� Uso      � Impress苚 de etiquetas cigo de Barras ()                	  潮�
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌�
*/

User Function MSCBCopiesSer(nCopias)
__oP:CopiesSer(nCopias)
Return '' 

/*
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北谀哪哪哪哪穆哪哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘�
北矲un噮o    � MSCBEND    � Autor � ALEX SANDRO VALARIO � Data �  05/98   潮�
北媚哪哪哪哪呐哪哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪幢�
北矰escri噮o � Fim de cria嚻o da imagem de cada etiqueta                  潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砇etorno   � NIL                                                        潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北� Uso      � Impress苚 de etiquetas cigo de Barras ()                 潮�
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌�
*/
User Function MSCBEND() //ok
Return __oP:CBEnd()

/*
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北谀哪哪哪哪穆哪哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘�
北矲un噮o    � MSCBWrite  � Autor � ALEX SANDRO VALARIO � Data �  04/99   潮�
北媚哪哪哪哪呐哪哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪幢�
北矰escri噮o � Utilizado para enviar diretamente para impressora uma linha潮�
北�          � de programa nativo da impressora                           潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砅arametro � cConteudo = linha de programa na linguagem da impressora   潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砇etorno   � NIL                                                        潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北� Uso      � Impress苚 de etiquetas cigo de Barras                    潮�
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌�
*/
User Function MSCBWrite(cConteudo,cModo) //ok
cModo := If(cModo==NIL,"WRITE",cModo)
If     (cModo=="ABRE")
   __oP:cResult :=''
ElseIf (cModo=="WRITE")
   __oP:cResult +=cConteudo
ElseIf (cModo=="FECHA")
   __oP:Envia()
EndIf
Return ''

User Function MSCBIsPrinter()
If ValType(__oP) <> "O"
   Return .f.
EndIf
Return __oP:IsPrinted

User Function MSCBClosePrinter()
Return __oP:Close()

User Function MsCB128GS()
Return __oP:C128GS

User Function MsCB128A()
Return __oP:C128A

User Function MsCB128B()
Return __oP:C128B

User Function MsCB128C()
Return __oP:C128C

User Function MsCB128Shift()
Return __oP:C128S

User Function MSCBCHKStatus(lStatus)
If lStatus<>NIL
   __oP:lCHKStatus := lStatus
EndIf              
If  __oP:lDrvWin
   __oP:lCHKStatus := .f.
EndIf
If __oP:lSpool 
   MSCBGrvSpool(5,,__oP)
EndIf
Return __oP:lCHKStatus

User Function MSCBInfoEti(cDescr,cTam)
If __oP:lSpool                 
   MSCBGrvSpool(4,Padr(cTam,15)+Padr(cDescr,15),__oP)
EndIf
Return 
/*
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北谀哪哪哪哪穆哪哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘�
北矲un噮o    � MSCBSAY    � Autor � ALEX SANDRO VALARIO � Data �  05/98   潮�
北媚哪哪哪哪呐哪哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪幢�
北矰escri噮o � Imprime uma String                                         潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砅aramentro� nXmm      = Posi嚻o X em Milimetros                        潮�
北�          � nYmm      = Posi嚻o Y em Milimetros                        潮�
北�          � cTexto    = String a ser impressa                          潮�
北�          � cRota嚻o  = String com o tipo de Rota嚻o (N,R,I,B)         潮�
北�          �           = N-Normal,R-Cima p/Baixo                        潮�
北�          �           = I-Invertido B-Baixo p/ Cima                    潮�
北�          � cFonte    = String com o tipo de Fonte (A,B,C,D,E,F,G,H,0) 潮�
北�          � cTam      = String com o tamanho da Fonte                  潮�
北�          � lReverso  = logica  se imprime  em reverso quando tiver    潮�
北�          �             sobre um box preto                             潮�
北�          � lSerial   = Serializa o codigo                             潮�
北�          � cIncr     = Incrementa quando for serial posito ou negativo潮�
北�          � lZerosL   = Coloca zeros a esquerda no numero serial       潮�
北�          � lNoAlltrim= permite brancos a esquerda e direita           潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砇etorno   � NIL                                                        潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北� Uso      � Impress苚 de etiquetas cigo de Barras ()                 潮�
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌�
*/
User Function MSCBSAY(nXmm,nYmm,cTexto,cRotacao,cFonte,cTam,lReverso,lSerial,cIncr,lZerosL,lNoAlltrim)
__oP:Say(nXmm,nYmm,cTexto,cRotacao,cFonte,cTam,lReverso,lSerial,cIncr,lZerosL,lNoAlltrim)
RETURN ''

User Function MSCBVar(cVar,cDados)
__oP:Var(cVar,cDados)
RETURN ''

/*
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北谀哪哪哪哪穆哪哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘�
北矲un噮o    � MSCBSAYMEMO� Autor � ALEX SANDRO VALARIO � Data �  05/98   潮�
北媚哪哪哪哪呐哪哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪幢�
北矰escri噮o � Imprime um tipo MEMO                                       潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砅arametro � nXmm      = Posi嚻o X em Milimetros                        潮�
北�          � nYmm      = Posi嚻o Y em Milimetros                        潮�
北�          � nLMemomm  = Tamanho da 1 linha do campo memo em milimetros 潮�
北�          � nQLinhas  = Qtde de linhas                                 潮�
北�          � cTexto    = String a ser impressa                          潮�
北�          � cRota嚻o  = String com o tipo de Rota嚻o (N,R,I,B)         潮�
北�          � cFonte    = String com o tipo de Fonte (A,B,C,D,E,F,G,H,0) 潮�
北�          � cTam      = String com o tamanho da Fonte                  潮�
北�          � lReverso  = logicao se imprime  em reverso quando tiver    潮�
北�          �             sobre um box preto                             潮�
北�          � cAlign    = String com o tipo de Alinhamento do memo       潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砇etorno   � NIL                                                        潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北� Uso      � Impress苚 de etiquetas cigo de Barras ()                 潮�
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌�
*/
User Function MSCBSAYMEMO(nXmm,nYmm,nLMemomm,nQLinhas,cTexto,cRotacao,cFonte,cTam,lReverso,cAlign)
__oP:Memo(nXmm,nYmm,nLMemomm,nQLinhas,cTexto,cRotacao,cFonte,cTam,lReverso,cAlign)
Return ''
                                                                                    


/*
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北谀哪哪哪哪穆哪哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘�
北矲un噮o    � MSCBSAYBAR � Autor � ALEX SANDRO VALARIO � Data �  05/98   潮�
北媚哪哪哪哪呐哪哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪幢�
北矰escri噮o � Imprime o codigo de barras                                 潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砅aramentro� nXmm      = Posi嚻o X em Milimetros                        潮�
北�          � nYmm      = Posi嚻o Y em Milimetros                        潮�
北�          � cConteudo = String a ser impressa                          潮�
北�          � cRota嚻o  = String com o tipo de Rota嚻o                   潮�
北�          � cTypePrt  = String com o Modelo de Codigo de Barras        潮�
北�          � "2-U-9-3-8-E-C"                                            潮�
北�          � nAltura   = Altura do codigo de Barras em Milimetros       潮�
北�          � lDigver   = Se imprime digito de verifica嚻o               潮�
北�          � lLinha    = Se imprime a linha de codigo                   潮�
北�          � lLinBaixo  = Se imprime a linha de codigo acima das barras 潮�
北�          � cSubSetIni = utiliza do code 128                           潮�
北�          � nLargura   = Largura da barra mais fina em pontos default 3潮�
北�          � nRelacao   = Relacao entre as barras finas e grossas em    潮�
北�          �              pontos default 2                              潮�
北�          � lCompacta  = Compacta o codigo de barra                    潮�
北�          � lSerial   = Serializa o codigo                             潮�
北�          � cIncr     = Incrementa quando for serial posito ou negativo潮�
北�          � lZerosL   = Coloca zeros a esquerda no numero serial       潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砇etorno   � NIL                                                        潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北� Uso      � Impress苚 de etiquetas cigo de Barras ()                 潮�
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌�
Modelos de codigos de barras Zebra
2 - Interleaved 2 of 5
3 - Code 39
8 - EAN 8
E - EAN 13
U - UPC A
9 - UPC E
C - CODE 128
Modelos de codigos de barras Allegro
A  Code 39
B  UPC A		 *
C  UPC E		 *
D  Interleaved 2 of 5
E  CODE 128
F  EAN 13
G  EAN 8
H  HIBC
I  CODABAR
J  I25+CD
K  Plessey
L  CASE
M  UPC+2
N  UPC+5
O  93
V  UPC (VARIAVEL)
Q  UCC-EAN128

Modelos de codigos de barras Eltron
2   - Interleaved 2 of 5
3   - Code 39
E80 - EAN 8
E30 - EAN 13
UA0 - UPC A
UE0 - UPC E
1   - CODE 128

Modelo padrao siga
MB01 - Interleaved 2 of 5
MB02 - Code 39
MB03 - EAN 8
MB04 - EAN 13
MB05 - UPC A
MB06 - UPC E
MB07 - CODE 128


cConteudo para criacao do codigo 128
      estrutura do array 
cConteudo:= {{"01",conteudo}},; // "000010100"+ledrv("Fb)+"1"
             {"37",conteudo}}

*/
User Function MSCBSAYBAR(nXmm,nYmm,cConteudo,cRotacao,cTypePrt,nAltura,lDigVer,lLinha,lLinBaixo,cSubSetIni,nLargura,nRelacao,lCompacta,lSerial,cIncr,lZerosL)
__oP:Bar(nXmm,nYmm,cConteudo,cRotacao,cTypePrt,nAltura,lDigVer,lLinha,lLinBaixo,cSubSetIni,nLargura,nRelacao,lCompacta,lSerial,cIncr,lZerosL)
RETURN ''

/*
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北谀哪哪哪哪穆哪哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘�
北矲un噮o    � MSCBBOX    � Autor � ALEX SANDRO VALARIO � Data �  05/98   潮�
北媚哪哪哪哪呐哪哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪幢�
北矰escri噮o � Imprime um Box                                             潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砅arametro � nX1mm     = Posi嚻o X1 em Milimetros                       潮�
北�          � nY1mm     = Posi嚻o Y1 em Milimetros                       潮�
北�          � nX2mm     = Posi嚻o X2 em Milimetros                       潮�
北�          � nY2mm     = Posi嚻o Y2 em Milimetros                       潮�
北�          � nExpessura= Numero com a expessura em pixel                潮�
北�          � cCor      = String com a Cor Branco ou Preto  ("W" ou "B") 潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砇etorno   � NIL                                                        潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北� Uso      � Impress苚 de etiquetas cigo de Barras ()                 潮�
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌�
*/
User Function MSCBBOX(nX1mm,nY1mm,nX2mm,nY2mm,nExpessura,cCor)
__oP:Box(nX1mm,nY1mm,nX2mm,nY2mm,nExpessura,cCor)
Return ''
/*
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北谀哪哪哪哪穆哪哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘�
北矲un噮o    � MSCBLINEH  � Autor � ALEX SANDRO VALARIO � Data �  05/98   潮�
北媚哪哪哪哪呐哪哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪幢�
北矰escri噮o � Imprime uma linha horizontal                               潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砅arametro � nX1mm     = Posi嚻o X1 em Milimetros                       潮�
北�          � nY1mm     = Posi嚻o Y1 em Milimetros                       潮�
北�          � nX2mm     = Posi嚻o X2 em Milimetros                       潮�
北�          � nExpessura= Numero com a expessura em pixel                潮�
北�          � cCor      = String com a Cor Branco ou Preto  ("W" ou "B") 潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砇etorno   � NIL                                                        潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北� Uso      � Impress苚 de etiquetas cigo de Barras ()                 潮�
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌�
*/
User Function MSCBLineH(nX1mm,nY1mm,nX2mm,nExpessura,cCor)
__oP:LineH(nX1mm,nY1mm,nX2mm,nExpessura,cCor)
Return ''
/*
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北谀哪哪哪哪穆哪哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘�
北矲un噮o    � MSCBLINEV  � Autor � ALEX SANDRO VALARIO � Data �  05/98   潮�
北媚哪哪哪哪呐哪哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪幢�
北矰escri噮o � Imprime uma linha vertical                                 潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砅arametro � nX1mm     = Posi嚻o X1 em Milimetros                       潮�
北�          � nY1mm     = Posi嚻o Y1 em Milimetros                       潮�
北�          � nY2mm     = Posi嚻o X2 em Milimetros                       潮�
北�          � nExpessura= Numero com a expessura em pixel                潮�
北�          � cCor      = String com a Cor Branco ou Preto  ("W" ou "B") 潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砇etorno   � NIL                                                        潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北� Uso      � Impress苚 de etiquetas cigo de Barras ()                 潮�
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌�
*/
User Function MSCBLineV(nX1mm,nY1mm,nY2mm,nExpessura,cCor)
__oP:LineV(nX1mm,nY1mm,nY2mm,nExpessura,cCor)
Return ''

/*
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北谀哪哪哪哪穆哪哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘�
北矲un噮o    � MSCBGRAFIC � Autor � ALEX SANDRO VALARIO � Data �  05/98   潮�
北媚哪哪哪哪呐哪哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪幢�
北矰escri噮o � Imprime uma String                                         潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砅arametro � nXmm      = Posi嚻o X em Milimetros                        潮�
北�          � nYmm      = Posi嚻o Y em Milimetros                        潮�
北�          � cArquivo  = nome do arquivo que esta impresso na Zebra     潮�
北�          � lReverso  = logica  se imprime  em reverso quando tiver    潮�
北�          �             sobre um box preto                             潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砇etorno   � NIL                                                        潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北� Uso      � Impress苚 de etiquetas cigo de Barras ()                 潮�
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌�
*/
User Function MSCBGRAFIC(nXmm,nYmm,cArquivo,lReverso)
__oP:GRAFIC(nXmm,nYmm,cArquivo,lReverso)
Return ''

/*
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北谀哪哪哪哪穆哪哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘�
北矲un噮o    � MSCBLOADGRF� Autor � ALEX SANDRO VALARIO � Data �  05/98   潮�
北媚哪哪哪哪呐哪哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪幢�
北矰escri噮o � Carrega uma imagem na impressora Zebra                     潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砅arametro � cImagem   = nome do arquivo que esta carregado na Zebra    潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砇etorno   � NIL                                                        潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北� Uso      � Impress苚 de etiquetas cigo de Barras ()                 潮�
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌�
*/
User Function MSCBLOADGRF(cImagem)
Return __oP:LOADGRF(cImagem)



/*****************************************************************************************************/
// funcoes de tratamento da porta  LPT1,LPT2,COM1,COM2,COM3,COM4                                                                     
/*****************************************************************************************************/
User Function CBOpenPort(cPorta) //ok
Local nHdl,nX                
Local cSettings :=""
Local cPort 	 :="" //  "COM1", "COM2","LPT1" 
Local cBaudRate :="" //  "110","19200","300","38400","600","56000","1200","57600","2400","115200","4800","128000","9600","256000","14400" 
Local cParity	 :="" //  "0"- NoParity,"1"-OddParity,"2"-EvenParity,"3"-MarkParity,"4"-SpaceParity
Local cData  	 :="" //  "4","5","6","7","8" 
Local cStop		 :="" //  "0"-OneStopBit,"1"-One5StopBits,"2"-TwoStopBits
Local cTime     :="" // em milesimos de segundo
Local cChar     :=""
Local nParte    := 1

// extraindo as partes
For nX:= 1 to len(cPorta)
    cChar :=Subst(cPorta,nX,1) 
    If nParte == 1   //port
       If cChar == ":"
          nParte:= 2
       Else
          cPort +=cChar
       EndIf 
    ElseIf nParte == 2 //cBaudRate
       If cChar == ","
          nParte:= 3
       Else  
          cBaudRate +=cChar
       EndIf 
    ElseIf nParte == 3 //cParity
       If cChar == ","
          nParte:= 4
       Else  
          cParity +=cChar
       EndIf 
    ElseIf nParte == 4 //cData
       If cChar == ","
          nParte:= 5
       Else
          cData +=cChar
       EndIf 
    ElseIf nParte == 5 //cStop
       If cChar == ","
          exit
       Else
          cStop +=cChar
       EndIf 
	 EndIf
Next

cBaudRate :=If(cBaudRate =="","9600",cBaudRate)
cParity   :=If(cParity=="","N",cParity)
cData     :=If(cData=="","8",cData)             
cStop     :=If(cStop=="","1",cStop)

//tratamento da cParity
cParity :=Str(At(Upper(cParity),'NOEMS')-1,1)
//tratamento do cStop
If cStop =="1" 
   cStop := "0"
ElseIF cStop == "1.5"
   cStop := "1"
EndIf      
cTime := "00500"

cSettings:= cBaudRate+','+cParity+','+cData+','+cStop+','+cTime
If "LPT" $ cPort                          
  nHdl     := fopen(cPort,2)
Else
  nHdl     := fopenPort(cPort,cSettings,2)
EndIf  
return nHdl              


User Function CBClosePort(nHdl) //ok
Return FCLose(nHdl)

User Function CBWritePort(nHdl,cString,lVerStatus,__oP) //ok
Local nRet:= -1
Local cByte,nByte
lVerStatus := IF(lVerStatus==NIL,.F.,lVerStatus)
If lVerStatus 
    VerStatus(nHdl,__oP)
EndIf   
cString := If(cString == NIL,"",cString)
nRet:= FWrite(nHdl,cString)
If nRet >= 0
	If lVerStatus .and. __oP:cPadrao=='DPL' 
   	nByte:= 0
		While .t.
			cByte:=" "
			nByte := Fread(nHdl,@cByte,1)
			If nByte == 0
				exit
			EndIf        
			conout("Aguardando... Buffer Cheio ")                                                  
			sleep(2000)
		End	    
	EndIf		
EndIf

Return nRet

User Function CBReadPort(nHdl,cString) //ok
Local cByte:=" "
Local cStringTemp:=""
While len(cStringTemp) < len(cString) 
   cByte :=' '        
   nByte := Fread(nHdl,@cByte,1)
   If Empty(nByte)
      exit
   EndIf   
   cStringTemp +=cByte
End
cString:= cStringTemp  
Return len(cString)

User Function VerStatus(nH,__oP)  //ok
Local cText :=Space(__oP:LenChkStatus)                                         
Local nC:= 1

While empty(cText) .and. len(cText) >0 //.and. nc<10 
   nResult := -1 
   While  nResult < 0
      nResult:= CBWritePort(nH,__oP:ChkStatus,.f.)           
      If nResult < 0
         sleep(500)
      EndIf 
   End            
 	CBReadPort(nH,@cText,len(cText))                
	IF Empty(cText)
	   nC++
	EndIf                      
	IF ! Empty(cText) .and. __oP:VerStatus(cText)=='OK'
	   exit
	EndIf 
	cText :=Space(__oP:LenChkStatus)
End                                                   
Return    



/*****************************************************************************************************/
// funcoes de controle de semaforo
/*****************************************************************************************************/
User Function MSCBFSem(cPorta,cProgOpen)
Local nC:= 0
__nSem := -1
While __nSem  < 0
   __nSem  := MSFCreate("SRV_"+cPorta) 
   IF  __nSem  < 0                  
     SLeep(50)             
     nC++
     If nC == 60
        nC := 0
	     conout('Semaforo fechado ')
	  EndIf                      
  Endif
End              
FWrite(__nSem,cProgOpen)
Return

User Function MSCBASem(cPorta)
  Fclose(__nSem)
  FErase("SRV_"+cPorta)
Return

/*****************************************************************************************************/
// funcoes de tratamento de spool
/*****************************************************************************************************/
User Function MSCBGrvSpool(nModo,cTamanho,__oP)  //OK
Local cPath := __oP:PathIni
Local aDir  
Local cAntes:=""
aDir:=Directory(cPath,"D")
If Empty(aDir)
   MakeDir(cPath)
EndIf
cPath := __oP:PathIni+"\"+__oP:Modelo   
aDir:=Directory(cPath,"D")
If Empty(aDir)
   MakeDir(cPath)
EndIf                         
cPath := __oP:PathIni+"\"+__oP:Modelo+"\"+__oP:cFila   
aDir:=Directory(cPath,"D")
If Empty(aDir)
   MakeDir(cPath)
EndIf                         
cPath := __oP:PathIni+"\"+__oP:Modelo+"\"+__oP:cFila   
aDir:=Directory(cPath+"\IMPRESSO","D")
If Empty(aDir)
   MakeDir(cPath+"\IMPRESSO")
EndIf                         
If nModo == 1                              
   If ! File(cPath+"\ctrl.seq")
      MemoWrite(cPath+"\ctrl.seq","00000001")
   EndIf
   __oP:cFileSpool := MemoRead(cPath+"\ctrl.seq") 
   __oP:nSeqSpool :=0                 
   MemoWrite(cPath+"\ctrl.seq",StrZero(Val(__oP:cFileSpool)+1,8))
   If Type("__cUserID") # "C"
 		MemoWrite(cPath+"\"+__oP:cFileSpool+".0000","000000XXXXXXXXXXXXXXX"+Space(30)+"OK        9"+Padr(If(__oP:lCHKStatus,__oP:Modelo,''),20))
      //000000XXXXXXXXXXXXXXX                              OK        9status
      //12345678901234567890123456789012345678901234567890123456789012345678901234567890 		             
      //         1         2         3        4        5         6         7    
   Else 		                                           
 		MemoWrite(cPath+"\"+__oP:cFileSpool+".0000",__CUSERID+PadR(cUserName,15)+Space(30)+"OK        9"+Padr(If(__oP:lCHKStatus,__oP:Modelo,''),20))
	EndIf
ElseIf nModo == 2                                                      
   __oP:nSeqSpool++
   MemoWrite(cPath+"\"+__oP:cFileSpool+"."+StrZero(__oP:nSeqSpool,4),__oP:cResult)
ElseIf nModo == 3
   MemoWrite(cPath+"\"+__oP:cFileSpool+".End","OK")
ElseIf nModo == 4      
   // codusunome           tamanho        descricao      status    !
   // *     *              *              *              *         *
   // 12345612345678901234512345678901234512345678901234512345678901
   //         1          2         3         4         5         6  
   // 12345678901234567890123456789012345678901234567890123456789012
   cAntes := MemoRead(cPath+"\"+__oP:cFileSpool+".0000") 
   If Empty(Subs(cAntes,22,30))
	   cAntes := Stuff(cAntes,22,15,Left(cTamanho,15)) // tamanho
   	cAntes := Stuff(cAntes,37,15,Right(cTamanho,15)) // descricao
	   MemoWrite(cPath+"\"+__oP:cFileSpool+".0000",cAntes)   
	EndIf	   
ElseIf nModo == 5 // seta o chkstatus                                                      
   cAntes := MemoRead(cPath+"\"+__oP:cFileSpool+".0000") 
   cAntes := Stuff(cAntes,63,20,Padr(If(__oP:lCHKStatus,__oP:Modelo,''),20) ) // tamanho
   MemoWrite(cPath+"\"+__oP:cFileSpool+".0000",cAntes)   
EndIf
Return 

/*****************************************************************************************************/
// funcoes de teste de porta
/*****************************************************************************************************/
User Function MSCBTestePort()
Local oDlg
Local oPorta
Local oBaudRate
Local oParity
Local oData
Local oStop
Local cPorta    := "COM1"
Local cBaudRate := "9600"
Local cParity	 := "NoParity"
Local cData     := "8"
Local cStop     := "OneStopBit"
Local aPorta 	 := { "COM1", "COM2","LPT1","LPT2"}
Local aBaudRate := { "110","19200","300","38400","600","56000","1200","57600","2400","115200","4800","128000","9600","256000","14400" }
Local aParity	 := { "NoParity","OddParity","EvenParity", "MarkParity","SpaceParity" }
Local aData  	 := { "4","5","6","7","8" }
Local aStop		 := { "OneStopBit", "One5StopBits", "TwoStopBits" }
Local oAmbiente
Local nAmbiente := 1

DEFINE MSDIALOG oDlg TITLE "Teste " FROM 0,0 TO 200,200 PIXEL

@ 010, 010 MSCOMBOBOX oPorta    VAR cPorta    ITEMS aPorta    SIZE 40,09 PIXEL OF oDlg
@ 023, 010 MSCOMBOBOX oBaudRate VAR cBaudRate ITEMS aBaudRate SIZE 40,09 PIXEL OF oDlg
@ 036, 010 MSCOMBOBOX oParity   VAR cParity   ITEMS aParity   SIZE 40,09 PIXEL OF oDlg    
@ 049, 010 MSCOMBOBOX oData     VAR cData     ITEMS aData     SIZE 40,09 PIXEL OF oDlg
@ 062, 010 MSCOMBOBOX oStop     VAR cStop     ITEMS aStop     SIZE 40,09 PIXEL OF oDlg
@ 075, 010 RADIO oAmbiente VAR nAmbiente ITEMS "Servidor","Cliente" SIZE 40,10 PIXEL OF oDlg
@ 010, 070 BUTTON "Abrir" ACTION MyOpen( cPorta, cBaudRate, oParity:nAt-1, aData[oData:nAt], oStop:nAt-1, nAmbiente ) PIXEL OF oDlg

ACTIVATE MSDIALOG oDlg CENTER

Return Nil

Static Function MyOpen( cPorta, cBaudRate, nParity, cData, nStop, nAmbiente )
Local nHandle
Local cSettings := cBaudRate + "," +;
						 Alltrim(Str(nParity))+","+;
						 cData+","+;
						 Alltrim(Str(nStop))+","+;
						 "00100"
Local cResultado 

If "LPT" $ cPorta                          
   cResultado := cPorta
Else
   cResultado := cPorta+":"+cBaudRate + ","+Subs("NOEMS",nParity+1,1)+','+cData+","
	If nStop == 0
   	cResultado+="1"
	ElseIf nStop ==1  
	   cResultado+="1.5"
	ElseIf nStop ==2   
   	cResultado+="2"
	EndIf
EndIf
    
If nAmbiente == 1
	cPorta := "SERVER"+cPorta
Endif
// O par鈓etros aSettings dever ter o seguinte formato:
// aSettings := cBaudRate + "," + cParity + "," + cData + "," + cStop
// Onde:
// cBaudRate pode ser qualquer valor das constantes de velocidade
// cParity pode ser qualquer valor das contantes de paridade
// cData pode ser qualquer valor entre 4 e 8
// cStop pode ser qualquer valor das contantes de Stopbits
//OBS: Sempre searados por virgula (,) e sem espa鏾s
If "LPT" $ cPorta                          
   nHandle := fopen(cPorta,2)
Else   
   nHandle := fopenPort(cPorta,cSettings,2)
EndIF   
If nHandle <> -1
	MsgInfo("Abriu!!!!!"+chr(13)+chr(10)+chr(13)+chr(10)+cResultado )       
	fclose(nHandle)
Else
	MsgStop("N鉶 abriu !!!!!"+chr(13)+chr(10)+chr(13)+chr(10)+cResultado )   
Endif
Return Nil



/*
----------------------------------------------------------------------------------
inicio tabelas internas de auxilio                                                       
----------------------------------------------------------------------------------
*/                                                                                
//nPontoMM utilizado como referencia
//aModelo  utilizado como referencia
User Function MSCBModelo(cPadrao,cModelo,nPontoMM,aModelos)
LOCAL nPos:=0
DEFAULT aModelos:={}             
DEFAULT nPontoMM:=0
DEFAULT cModelo :=''

If cPadrao == "ZPL"
   aModelos:= {	{'S300'		,8},;
						{'S400'		,8},;
						{'S500-6'	,6},;
						{'S500-8'	,8},;
						{'Z105S-6'	,6},;
						{'Z105S-8'	,8},;
						{'Z160S-6'	,6},;
						{'Z160S-8'	,8},;
						{'Z140XI'	,8},;
						{'S600'		,8},;
						{'Z4M'		,8},;
						{'Z90XI'		,12},;
						{'Z170XI'	,12},;
						{'ZEBRA'    ,8},;
						{'QL320'    ,18}}                        
ElseIf cPadrao == "DPL"        
   aModelos:= {	{'ALLEGRO'		,.039370078},;
						{'ALLEGRO 2'	,.039370078},;
						{'PRODIGY'		,.039370078},;
						{'DMX'			,.039370078},;
						{'DESTINY'		,.039370078},;																		
						{'URANO'			,.039370078},;																				
						{'DATAMAX'		,.039370078},;																										
						{'OS 214'		,.039370078},;	 
						{'OS 314'		,.039370078},;		
						{'PRESTIGE 424',.039370078},;		
						{'ARGOX'			,.039370078}}     
	// Obs. Os modelos de Rabbit OS 214,314 e PRESTIGE 424 o default eh DPL (padrao datamax), caso a Eprom esteja como 
	// EPL (padrao Eltron) passar como modelo ELTRON
ElseIf cPadrao == "EPL"
   aModelos:= {	{'ELTRON' 		,8},;                                                        
					   {'TLP 2722'		,8},;  
					   {'TLP 2742'		,8},;  
					   {'TLP 2844'		,8},;  
					   {'TLP 3742'		,8},;
					   {'C4-8'			,8}	}  // Fabricante Intermec
ElseIf cPadrao == "IPL"
   aModelos:= {	{'INTERMEC'	,8},;
   					{'3400-8'	,8},;		
					   {'3400-16'	,16},;
						{'3600-8'	,8},;	
						{'4440-16'  ,16},;				   		
						{'7421C-8'	,8}}					   								
ElseIf cPadrao == "TXT"
   aModelos:= {	{'TEXTO'	,8}}
Else
	aModelos :={{'',0}}
EndIf
aModelos := aSort(aModelos,,,{|x,y| x[1] < y[1]})
nPos := ascan(aModelos,{|x| x[1] == Upper(Alltrim(cModelo))})
If nPos > 0 
   nPontoMM := aModelos[nPos,2]
   Return .t.
EndIf
Return .f.


/*
MB01 - Interleaved 2 of 5
MB02 - Code 39
MB03 - EAN 8
MB04 - EAN 13
MB05 - UPC A
MB06 - UPC E
MB07 - CODE 128   
MB08 - EAN 128
*/
User Function MSTabCodBar(cCodigo,__oP)       //ok
Local aSiga    :={"MB01"	,"MB02"	,"MB03"	,"MB04"	,"MB05"	,"MB06"	,"MB07"	,"MB08"}
Local aZebra   :={"2"		,"3"		,"8"		,"E"		,"U"		,"9"		,"C"		,"C"   }
Local aAllegro :={"D"		,"A"		,"G"		,"F"		,"B"		,"C"		,"E"		,"E"   }       
Local aEltron  :={"2"		,"3"		,"E80"	,"E30"	,"UA0"	,"UE0"	,"1"		,"1E"  }
Local aIntermec:={"2"		,"0"		,"7,0,1"	,"7,0,2"	,"7,0,3"	,"7,0,4"	,"6,0,1" ,"6,1,1"}
Local nPos            
If len(cCodigo) <> 4 
   Return cCodigo    
EndIf   
nPos := Ascan(aSiga,Upper(cCodigo))
If nPos ==0         
   Return cCodigo  
EndIf    
If __oP:cPadrao =='DPL'   
	cCodigo := aAllegro[nPos]
ElseIf __oP:cPadrao=='ZPL'    
	cCodigo := aZebra[nPos]   
ElseIf __oP:cPadrao=='EPL'
	cCodigo := aEltron[nPos]
ElseIf __oP:cPadrao=='IPL'
	cCodigo := aIntermec[nPos]	
EndIf      			                     
Return cCodigo   

/*                   
N-Normal
R-Cima p/baixo
I-Invertido
B-Baixo p/ Cima
*/
User Function MsTabRotacao(cCodigo,__oP)  //ok
Local aSiga   :={"N"	,"R","I"	,"B"}
Local aZebra  :={"N"	,"R","I"	,"B"}
Local aAllegro:={"1","2","3","4"}
Local aEltron :={"0","1","2","3"}
Local aIntermec :={"0","3","2","1"}
Local nPos            
nPos := Ascan(aSiga,Upper(cCodigo))
If nPos ==0         
   Return cCodigo  
EndIf    
If __oP:cPadrao =='DPL'   
	cCodigo := aAllegro[nPos]
ElseIf __oP:cPadrao=='ZPL'    
	cCodigo := aZebra[nPos]   
ElseIf __oP:cPadrao=='EPL'
	cCodigo := aEltron[nPos]
ElseIf __oP:cPadrao=='IPL'
	cCodigo := aIntermec[nPos]
EndIf      			                     
Return cCodigo   

User Function MsTrataEan(aConteudo)
Local aVetAux:=MSCBTabEAN()
Local cTemp:=""          
Local nX,nX2
For nX:= 1 to len(aConteudo)
   nX2:=Ascan(aVetAux,{|x| x[1] == aConteudo[nX,1] })
   cTemp += aVetAux[nx2,1]
   If aVetAux[nx2,4] .and. nX < len(aConteudo) // se for verdadeiro, entao o tamanho nao eh fixo
      cTemp += Alltrim(aConteudo[nX,2])+MSCB128GS()
   Else //tamanho fixo
      cTemp += Alltrim(aConteudo[nX,2])
   EndIf
Next
Return cTemp

User Function MSCBTABEAN()
Local aAI
aAI := {	{"00",2,18,.f.,"Pallet"},;	// C骴igo de s閞ie da Unidade de despacho	n2+n18
			{"01",2,14,.f.,"Cod.Barras"},;	// Numero EAN de artigo/C骴igo de embalagem de despacho	n2+n14
			{"02",2,14,.f.,"Cod.Barras"},;	// Numero EAN de artigo para bens contidos dentro de outra unidade	n2+n14
			{"10",2,20,.t.,"Lote"},;	// Numero de lote ou de batch	n2+an..20
			{"11",2,06,.f.,"Producao"},;	// Data de produ玢o (AAMMDD)	n2+n6
			{"12",2,06,.f.,"Vencimento"},;	// Data de vencimento(AAMMDD)- pagamento	n2+n6
			{"13",2,06,.f.,"Armagenzagem"},;	// Data de Acondicionamento (AAMMDD)	n2+n6
			{"15",2,06,.f.,"Validade Min."},;	// Data de durabilidade m韓ima (AAMMDD)	n2+n6
			{"17",2,06,.f.,"Validade Max."},;	// Data de durabilidade m醲ima (AAMMDD)	n2+n6
			{"20",2,02,.f.,"Variante"},;	// Variante do produto	n2+n2
			{"21",2,20,.t.,"Serie"},;	// Numero de s閞ie	n2+an..20
			{"22",2,29,.t.,"Qtde"},;	// HIBCC - quantidade, data, batch e link	n2+an..29
			{"23",2,20,.t.,"Lote"},;	// Numero do lote (uso transit髍io)	n3+n..19
			{"240",3,30,.t.,""},; 	// Identifica玢o adicional do produto	n3+an..30
			{"241",2,30,.t.,""},; 	// "Part Number" do cliente	n3+an..30
			{"250",3,30,.t.,""},; 	// Numero de s閞ie secund醨io	n3+an..30
			{"30",2,8,.t.,"Qtde"},;	 	// Quantidade vari醰el	n2+n..8
			{"31",2,8,.f.,"Medida"},;	 	// Medidas comerciais e log韘ticas	n4+n6
			{"32",2,8,.f.,"Medida"},;	 	// Medidas comerciais e log韘ticas	n4+n6
			{"33",2,8,.f.,"Medida"},;	 	// Medidas comerciais e log韘ticas	n4+n6
			{"34",2,8,.f.,"Medida"},;	 	// Medidas comerciais e log韘ticas	n4+n6
			{"35",2,8,.f.,"Medida"},;	 	// Medidas comerciais e log韘ticas	n4+n6
			{"36",2,8,.f.,"Medida"},;	 	// Medidas comerciais e log韘ticas	n4+n6
			{"37",2,8,.t.,"Quantidade"},;	 	// Quantidade	n2+n..8
			{"400",3,30,.t.,"Pedido Cliente"},; 	// Numero do pedido do cliente	n3+an..30
			{"401",3,30,.t.,"Consignacao"},; 	// Numero de consigna玢o	n3+an..30
			{"402",3,17,.f.,"Cod.Expedicao"},; 	// Numero de Identifica玢o da Expedi玢o	n3+n17
			{"403",3,30,.t.,"Rota"},; 	// Codigo de Rota	n3+an..30
			{"410",3,13,.f.,"Localizacao"},; 	// Numero de localiza玢o (despacho para) usando o EAN-13	n3+n13
         {"411",3,13,.f.,"Localizacao"},; 	// Numero de localiza玢o  (fatura para), usando o EAN-13	n3+n13
			{"412",3,13,.f.,"Localizacao"},; 	// Comprado de (n鷐ero de localiza玢o de quem vendeu as mercadorias), usando o EAN-13	n3+n13
			{"413",3,13,.f.,"Localizacao"},; 	// Entregar para (Transferir para - Despachar para) usando o n� de localiza玢o EAN-13	n3+n13
			{"414",3,13,.f.,"Localizacao"},; 	// Numero de localiza玢o EAN	n3+n13
			{"420",3,20,.t.,"Localizacao"},; 	// Codigo postal despachar para (entregar a) dentro de uma 鷑ica jurisdi玢o postal	n3+an..20
			{"421",3,12,.t.,"Localizacao"},; 	// Codigo postal despachar para (entregar a) com prefixo ISO de 3 d韌itos para pa韘	n3+n3+an..9
			{"422",3,03,.f.,"Pais origem"},; 	// Pais de origem do produto	n3+n3
			{"8001",4,14,.f.,""},;	// Produtos em rolo - largura, comprimento, di鈓etro do cilindro, dire玢o e emendas	n4+n14
			{"8002",4,20,.t.,"Serie"},;	// Numero de s閞ie eletr鬾ico para telefones celulares	n4+an..20
			{"8003",4,30,.t.,"Produto"},;	// Numero EAN/UPC e n鷐ero serial de ativo retorn醰el	n4+n14+an..16
			{"8004",4,30,.t.,"Serie"},;	// Numero de S閞ie EAN/ UCC de identifica玢o de ativo	n4 + an..30
			{"8005",4,06,.f.,"Preco Un."},;	// Preco por unidade de medida	n4+n6
			{"8006",4,18,.f.,"Cod.Barras"},;	// Componentes de um artigo	n4+n14+n2+n2
			{"8018",4,18,.f.,"SRN"},;	// Numero de Rela玢o de Servi鏾 (SRN)	n4 + n18
			{"8100",4,06,.t.,"NSC"},;	// Codigo ampliado de cupom - NSC + c骴igo de oferta	n4+n1+n5
			{"8101",4,10,.f.,"NSC"},;	// Codigo ampliado de cupom - NSC + c骴igo de oferta + c骴igo de final de oferta	n4+n1+n5+n4
			{"8102",4,02,.f.,"NSC"},;	// Codigo ampliado de cupom - NSC	n4+n1+n1
			{"90",2,30,.t.,"Uso interno"},;	// Uso interno e/ou aplicacoes de comum acordo	n2+an..30
			{"91",2,30,.t.,"Uso interno"},;	// Aplicacoes internas	n2+an..30
			{"92",2,30,.t.,"Uso interno"},;	// Aplicacoes internas	n2+an..30
			{"93",2,30,.t.,"Uso interno"},;	// Aplicacoes internas	n2+an..30
			{"94",2,30,.t.,"Uso interno"},;	// Aplicacoes internas	n2+an..30
			{"95",2,30,.t.,"Uso interno"},;	// Aplicacoes internas	n2+an..30
			{"96",2,30,.t.,"Uso interno"},;	// Aplicacoes internas	n2+an..30
			{"97",2,30,.t.,"Uso interno"},;	// Aplicacoes internas	n2+an..30
			{"98",2,30,.t.,"Uso interno"},;	// Aplicacoes internas	n2+an..30
			{"99",2,30,.t.,"Uso interno"}}		// Aplicacoes internas	n2+an..30
Return aAI


/*
----------------------------------------------------------------------------------
termino das tabelas internas de auxilio                                                       
----------------------------------------------------------------------------------
*/                                                                                
User FUNCTION MSCBSpool(cParam)
Return U_CBSpool(cParam)

/*
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北谀哪哪哪哪穆哪哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘�
北矲un噮o    � MSCBFORM   � Autor � ALEX SANDRO VALARIO � Data �  10/05   潮�
北媚哪哪哪哪呐哪哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪幢�
北矰escri噮o � Inicio da cria嚻o da imagem de cada etiqueta               潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砅aramentro� lForm   = .t./.f.. default .t.                             潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砇etorno   � NIL                                                        潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北� Uso      � propriedade criada para sanar o bug da bios antiga         潮�
北�          � de impressoras eltron                                      潮�
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌�
*/
User Function MSCBFORM(lForm)	 //ok              
DEFAULT lForm:= .t.
If __oP:cPadrao=='EPL' .and. ! lForm
	__oP:lForm := .f.
EndIf
Return ''