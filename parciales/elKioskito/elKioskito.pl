atiende(dodain,lunes,9,15).
atiende(dodain,miercoles,9,15).
atiende(dodain,viernes,9,15).

atiende(lucas,martes,10,20).

atiende(juanC,sabado,18,22).
atiende(juanC,domingo,18,22).

atiende(juanFdS,jueves,10,20).
atiende(juanFdS,viernes,12,20).

atiende(leoC,lunes,14,18).
atiende(leoC,miercoles,14,18).

atiende(martu,miercoles,23,24).

% 1

atiendeDe(vale,Dia,HoraI,HoraF):- atiendeDe(dodain,Dia,HoraI,HoraF).
atiendeDe(vale,Dia,HoraI,HoraF):- atiendeDe(juanC,Dia,HoraI,HoraF).

% 2

quienAtiende(Dia,Hora,Persona):-
    atiende(Persona,Dia,HoraI,HoraF),
    Hora =< HoraF,
    Hora >= HoraI. 

% 3

foreverAlone(Dia,Hora,Persona):-
    quienAtiende(Dia,Hora,Persona),
    not(quienAtiende(Dia,Hora,OtraPersona)),
    OtraPersona \= Persona.

% 4

posibilidades(Dia):-
    atiende(_,Dia,_,_).

% 5

venta(dodain,fecha(10,8),[golosinas(1200),cigarrillos(jockey),golosinas(50)]).
venta(dodain,fecha(12,8),[bebida(conAlc,8),bebida(sinAlc,1),golosinas(10)]).
venta(martu,fecha(12,8),[golosinas(1000),cigarrillos(chesterfield),cigarrillos(colorado),cigarrillos(parisiennes)]).
venta(lucas,fecha(11,8),[golosinas(600)]).
venta(lucas,fecha(18,8),[bebida(sinAlc,2),cigarrilos(derby)]).

ventaImportante(golosinas(Valor)):-Valor>100.
ventaImportante(cigarrillos(Todos)):-
    length(Todos, Marcas),
    Marcas >= 2.
    
ventaImportante(bebida(conAlc,_)).
ventaImportante(bebida(_,Cantidad)):- Cantidad >= 5.