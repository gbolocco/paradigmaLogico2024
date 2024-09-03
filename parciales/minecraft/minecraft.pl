jugador(stuart, [piedra, piedra, piedra, piedra, piedra, piedra, piedra, piedra], 3).
jugador(tim, [madera, madera, madera, madera, madera, pan, carbon, carbon, carbon, pollo, pollo], 8).
jugador(steve, [madera, carbon, carbon, diamante, panceta, panceta, panceta], 2).

lugar(playa, [stuart, tim], 2).
lugar(mina, [steve], 8).
lugar(bosque, [], 6).

comestible(pan).
comestible(panceta).
comestible(pollo).
comestible(pescado).

%%%%%%%%%%%%%%%%%%%%[1]%%%%%%%%%%%%%%%%%%%%
tieneItem(Jugador,Item):-
    jugador(Jugador,Items,_),
    member(Item,Items).

sePreocupaPorSuSalud(Jugador):-
    jugador(Jugador,Items,_),
    member(UnItem,Items),
    member(OtroItem,Items),
    comestible(UnItem),
    comestible(OtroItem).

cantidadDeItem(Jugador,Item,Cantidad):-
    jugador(Jugador,Items,_),
    findall(1,member(Item,Items),ItemsEspecificos),
    sumlist(ItemsEspecificos, Cantidad).
    
tieneMasDe(Jugador,Item):-   %no me cierra mucho esta resolucion, pero teoricamente esta bien.
    cantidadDeItem(Jugador,Item,CantidadMaxima),
    forall((cantidadDeItem(OtroJugador,Item,Cantidad),OtroJugador \= Jugador), CantidadMaxima > Cantidad).

%%%%%%%%%%%%%%%%%%%%[2]%%%%%%%%%%%%%%%%%%%%
hayMounstros(Lugar):-
    lugar(Lugar,_,Oscuridad),
    Oscuridad > 6.

correPeligro(Jugador):-
    lugar(Lugar,JugadoresAlli,_),
    hayMounstros(Lugar),
    member(Jugador,JugadoresAlli).

correPeligro(Jugador):-
    jugador(Jugador,Inventario,_),
    tieneHambre(Jugador),
    forall(member(Comida,Inventario),not(comestible(Comida))).

tieneHambre(Jugador):-
    jugador(Jugador,_,Hambre),
    Hambre < 4.

nivelDePeligrosidad(Lugar,Nivel):-
    lugar(Lugar,_,_),
    peligrosidadSegun(Lugar,Nivel).

peligrosidadSegun(Lugar,100):-
    hayMounstros(Lugar).

peligrosidadSegun(Lugar,Nivel):-
    lugar(Lugar,Jugadores,_),
    not(hayMounstros(Lugar)),
    cantidadDeHambrientos(Jugadores,CantidadJugadoresHambrientos),
    length(Jugadores, CantidadJugadores),
    CantidadJugadores \= 0,
    Nivel is (CantidadJugadoresHambrientos * 100) / CantidadJugadores.

peligrosidadSegun(Lugar,Nivel):-
    lugar(Lugar,[],Oscuridad),
    Nivel is Oscuridad * 10.

cantidadDeHambrientos(Jugadores,CantidadJugadoresHambrientos):-
    findall(JugadorHambriento,(member(JugadorHambriento,Jugadores),tieneHambre(JugadorHambriento)),JugadoresHambrientos),
    length(JugadoresHambrientos,CantidadJugadoresHambrientos).

%%%%%%%%%%%%%%%%%%%%[3]%%%%%%%%%%%%%%%%%%%%

item(horno, [ itemSimple(piedra, 8) ]).
item(placaDeMadera, [ itemSimple(madera, 1) ]).
item(palo, [ itemCompuesto(placaDeMadera) ]).
item(antorcha, [ itemCompuesto(palo), itemSimple(carbon, 1) ]).

puedeContruir(Jugador,Item):-
    item(Item,Receta),
    jugador(Jugador,_,_),
    forall(member(Material,Receta),dispone(Jugador,Material)).

dispone(Jugador,itemSimple(Material,CantidadNecesaria)):-
    cantidadDeItem(Jugador,Material,CantidadQuePosee),
    CantidadQuePosee >= CantidadNecesaria.

dispone(Jugador,itemCompuesto(Material)):-
    jugador(Jugador,Inventario,_),
    member(Material,Inventario).

dispone(Jugador,itemCompuesto(Material)):-puedeContruir(Jugador,Material).
