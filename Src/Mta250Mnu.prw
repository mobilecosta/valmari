#Include "Protheus.ch"

User Function MTA250MNU
/*/f/
�����������������������������������������������������������������������������������������������������������������������������������������������������
<Descricao> : Ponto de entrada para inclus�o op��es de menu na tela de apontamento da produ��o
<Autor> : Wagner Mobile Costa
<Data> : 23/08/2013
<Parametros> : Nenhum
<Retorno> : Nenhum
<Processo> : Especifico Valmari - Endere�amento
<Tipo> (Menu,Trigger,Validacao,Ponto de Entrada,Genericas,Especificas ) : P
<Obs> :
�����������������������������������������������������������������������������������������������������������������������������������������������������
*/

Aadd(aRotina, {"Imprimir Etiqueta", "U_VALXETI('SD3', .F.)", 0, 2, 0, .F.})
Aadd(aRotina, {"Reeimprimir Etiqueta", "U_VALXETI('SD3', .T.)", 0, 2, 0, .F.})

Return