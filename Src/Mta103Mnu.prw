#Include "Protheus.Ch"

User Function MTA103MNU
/*/f/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
<Descricao> : Ponto de Entrada para inclusão opções no menu do documento de entrada
<Data> : 28/07/2013
<Parametros> : Nenhum
<Retorno> : Nenhum
<Processo> : Endereçamento de Materiais - Valmari
<Tipo> (Menu,Trigger,Validacao,Ponto de Entrada,Genericas,Especificas ) : P
<Autor> : Wagner Mobile Costa
<Obs> :
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
*/

Aadd(aRotina, {"Imprimir Etiqueta", "U_VALXETI('SD1', .F.)", 0, 4, 0, .F.})
Aadd(aRotina, {"Reeimprimir Etiqueta", "U_VALXETI('SD1', .T.)", 0, 4, 0, .F.})

Return