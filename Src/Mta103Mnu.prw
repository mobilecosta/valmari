#Include "Protheus.Ch"

User Function MTA103MNU
/*/f/
���������������������������������������������������������������������������������������������������������������������������������������������������
<Descricao> : Ponto de Entrada para inclus�o op��es no menu do documento de entrada
<Data> : 28/07/2013
<Parametros> : Nenhum
<Retorno> : Nenhum
<Processo> : Endere�amento de Materiais - Valmari
<Tipo> (Menu,Trigger,Validacao,Ponto de Entrada,Genericas,Especificas ) : P
<Autor> : Wagner Mobile Costa
<Obs> :
���������������������������������������������������������������������������������������������������������������������������������������������������
*/

Aadd(aRotina, {"Imprimir Etiqueta", "U_VALXETI('SD1', .F.)", 0, 4, 0, .F.})
Aadd(aRotina, {"Reeimprimir Etiqueta", "U_VALXETI('SD1', .T.)", 0, 4, 0, .F.})

Return