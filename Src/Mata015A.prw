#INCLUDE "PROTHEUS.CH"

User Function MATA015A
/*/f/
�����������������������������������������������������������������������������������������������������������������������������������������������������
<Descricao> : Rotina para impress�o da etiqueta de endere�os
<Autor> : Wagner Mobile Costa
<Data> : 24/09/2013
<Parametros> : Nenhum
<Retorno> : Nenhum
<Processo> : Especifico Valmari - Endere�amento
<Tipo> (Menu,Trigger,Validacao,Ponto de Entrada,Genericas,Especificas ) : P
<Obs> :
�����������������������������������������������������������������������������������������������������������������������������������������������������
*/

Private aRotina := MenuDef()

mBrowse( 6, 1,22,75,"SBE")

Return

Static Function MenuDef
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

Local aRotina := {}

Aadd(aRotina, {"Imprimir Etiqueta", "U_VALXETI('SBE', .F.)", 0, 4, 0, .F.})

Return aRotina