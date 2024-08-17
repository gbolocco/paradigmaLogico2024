% BASE DE CONOCIMIENTO

% jugador(Jugador) Se cumple para todos los jugadores.
jugador(rojo). % atomos
jugador(verde).
jugador(azul).
jugador(amarillo).

% ubicadoEn(Pais,Continente) Relaciona un pais con un continente.
ubicadoEn(argentina,americaDelSur).
ubicadoEn(brasil,americaDelSur).
ubicadoEn(paraguay,americaDelSur).
ubicadoEn(chile,americaDelSur).
ubicadoEn(alemania,europa).
ubicadoEn(italia,europa).

% aliado(UnJugador,OtroJugador) Relaciona dis jugadores si son aliados
aliado(rojo,amarillo).
aliado(azul,verde).

% ocupa(Jugador,Pais) Relaciona un jugador con el pais que ocupa
ocupa(rojo,argentina).

%limitrofes(UnPais,OtroPais) Relaciona dos paises si son limitrofes
limitrofes(argentina,brasil).
limitrofes(argentina,chile).
limitrofes(argentina,paraguay).
limitrofes(brasil,paraguay).

% EJERCICIOS
% 1) tienePresenciaEn/2 --> Relaciona un jugador con un continente del cual ocupa, al menos, un pais.
tienePresenciaEn(Jugador,Continente):- 
    ocupa(Jugador,UnPais),
    ubicadoEn(UnPais,Continente).

% 2) puedenAtacarse/2 --> Relaciona dos jugadores si uno ocupa al mnenos un pais limitrofe que ocupa el otro.
puedenAtacarse(UnJugador,OtroJugador):-
    UnJugador \= OtroJugador,
    ocupa(UnJugador,UnPais),
    ocupa(OtroJugador,OtroPais),
    limitrofes(UnPais,OtroPais).

% 3) sinTensiones/2 --> Relaciona dos jugadores que, o bien no pueden atacarse, o son aliados.
sinTensiones(UnJugador,OtroJugador):-
    jugador(UnJugador),
    jugador(OtroJugador).
    not(puedenAtacarse(UnJugador,OtroJugador)).

sinTensiones(UnJugador,OtroJugador):-
    aliado(UnJugador,OtroJugador).

% 4) perdio/1 --> Se cumple para un jugador que no ocupa ningun pais.
perdio(Jugador):-
    jugador(Jugador),
    not(ocupa(Jugador,_)).

% 5) controla/2 --> Relaciona un jugador con un continente si ocupa todos los paises del mismo.
controla(Jugador,Continente):-
    jugador(Jugador),
    ubicadoEn(_,Continente),
    forall(ubicadoEn(Pais,Continente),ocupa(Jugador,Pais)).

% 6) renido/1 --> Se cumple para los continentes donde todos los jugadores ocupan algun pais.
renido(Continente):-
    ubicadoEn(_,Continente),
    forall(jugador(Jugador),(ocupa(Jugador,Pais),ubicadoEn(Pais,Continente))).

% 7) atrincherado/1 --> Se cumple para los jugadores que ocupan paises en un unico continente. "todos los paises de un jugador esten en un unico continente"
atrincherado(Jugador):-
    ubicadoEn(_,Continente),
    ocupa(Jugador,_),
    forall(ocupa(Jugador,Pais),ubicadoEn(Pais,Continente)).

% 8) puedeConquistar/2 --> Relaciona un jugador con un continente si no lo controla, pero todos los paises del continente que le falta ocupar son limitrofes a alguno que si ocupa y pertenecen a alguien que no es su aliado.

puedeAtacar2(Jugador,PaisAtacado):-
    jugador(Jugador),
    jugador(JugadorEnemigo),
    ocupa(Jugador,UnPais),
    limitrofes(UnPais,PaisOcupado),
    ocupa(JugadorEnemigo,PaisOcupado),
    not(aliado(Jugador,JugadorEnemigo)).

puedeAtacar(Jugador,PaisAtacado):-
    ocupa(Jugador,UnPais),
    limitrofes(UnPais,PaisOcupado),
    not((aliados(Jugador,Aliado),ocupa(Aliado,PaisAtacado))).


puedeConquistar(Jugador,Continente):-
    jugador(Jugador),
    ubicadoEn(_,Continente),
    not(controla(Jugador,Continente)),
    forall((ubicadoEn(Pais,Continente),not(ocupa(Jugador,Pais))),puedeAtacar(Jugador,Pais)).