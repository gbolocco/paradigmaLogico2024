% vuelo(,Aerolinea, Partida,Destino,Costo).
vuelo(prlogo,aep,gru,75000).
vuelo(prolog,gru,scl,65000).
vuelo(prolog,aep,eze,1000).

% aeropuerto(Codigo,Ciudad,Pais).
aeropuerto(par,paris,francia).
aeropuerto(eze,buenosAires).
aeropuerto(aep,buenosAires).
aeropuerto(scl,santiago).
aeropuerto(gru,saoPaulo).
aeropuerto(chi,chicago).
aeropuerto(pal,palawan).

% pais(Ciudad,Pais).
pais(paris,francia).
pais(buenosAires,argentina).
pais(santiago,chile).
pais(saoPaulo,brasil).
pais(chicago,estadosUnidos).
pais(palawan,filipinas).

% Tipos de destino.
paradisiaco(palawan).
negocios(chicago).
interesCultural(paris,[torreEiffel,arcodelTriunfo,notreDame]).
interesCultural(buenosAires,[obelisco,congreso,cabildo]).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
vueloCabotaje(Partida,Destino):-
    aeropuerto(Partida,CiudadPartida),
    pais(CiudadPartida,Pais),
    aeropuerto(Destino,CiudadDestino),
    pais(CiudadDestino,Pais),
    Partida \= Destino.

cabotaje(Aerolinea):-
    vuelo(Aerolinea,_,_,_),
    forall(vuelo(Aerolinea,Partida,Destino,_),vueloCabotaje(Partida,Destino)).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
vueloDeIda(UnaCiudad):-
    aeropuerto(UnAeropuerto,UnaCiudad),
    vuelo(_,UnAeropuerto,OtroAeropuerto,_),
    not(vuelo(_,_,UnAeropuerto,_)),
    aeropuerto(OtroAeropuerto,OtraCiudad),
    UnaCiudad \= OtraCiudad.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
relativamenteDirecta(Partida,Destino):-
    vuelo(_,Partida,Destino,_).

relativamenteDirecta(Partida,Destino):-
    vuelo(Aerolinea,Partida,Escala,_),
    vuelo(Aerolinea,Escala,Destino,_),
    Escala \= Destino.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% pasajero(Nombre,Dinero,Millas)
pasajero(franco,10000,50000).

%%%


puedeViajar(Pasajero,CiudadPartida,CiudadDestino):-
    aeropuerto(AeropuertoPartida,CiudadPartida),
    aeropuerto(AeropuertoDestino,CiudadDestino),
    condicionParaViajar(Pasajero,AeropuertoPartida,AeropuertoDestino).

condicionParaViajar(Pasajero,AeropuertoPartida,AeropuertoDestino):-
    pasajero(Pasajero,Dinero,_),
    vuelo(_,AeropuertoPartida,AeropuertoDestino,Costo),
    Dinero >= Costo.

condicionParaViajar(Pasajero,Partida,Destino):-
    pasajero(Pasajero,_,Millas),
    vueloCabotaje(Partida,Destino),
    Millas >= 500.

condicionParaViajar(Pasajero,Partida,Destino):-
    pasajero(Pasajero,_,Millas),
    vuelo(_,Partida,Destino,Costo),
    not(vueloCabotaje(Partida,Destino)),
    costoVueloEnMillas(Costo,CostoEnMillas),
    Millas >= CostoEnMillas. 

costoVueloEnMillas(Costo,CostoEnMillas):-
    CostoEnMillas is Costo * 0.2.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% quireViajar(Persona,Ciudad).
quiereViajar(Persona,Ciudad):-
    pasajero(Persona,Dinero,Millas),
    Dinero > 5000,
    Millas > 100,
    condicionParaQuererViajar(Ciudad).

condicionParaQuererViajar(Ciudad):-paradisiaco(Ciudad).

condicionParaQuererViajar(Ciudad):-
    interesCultural(Ciudad,LugaresEmblematicos),
    length(LugaresEmblematicos, Cantidad),
    Cantidad >= 4.

condicionParaQuererViajar(Ciudad):-pais(Ciudad,qatar).