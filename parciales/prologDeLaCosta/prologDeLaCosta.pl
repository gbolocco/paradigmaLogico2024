comida(hamburguesas,2000).
comida(panchitos,1500).
comida(caramelos,0).

atraccion(tranquila(autitosChocadores,chicosYAdultos)).
atraccion(tranquila(laberinto,chicosYAdultos)).
atraccion(tranquila(casaEmbrujada,chicosYAdultos)).

atraccion(tranquila(calesita,soloChicos)).
atraccion(tranquila(tobogan,soloChicos)).

atraccion(intensa(barcoPirata,14)).
atraccion(intensa(tazasChinas,6)).
atraccion(intensa(simulador3D,2)).

atraccion(montaniaRusa(abismoMortalRecargada,3,134)).
atraccion(montaniaRusa(paseoPorElBosque,0,45)).

atraccion(acuatica(torpedoSalpicon)).
atraccion(acuatica(esperoQueHayasTraidoUnaMudaDeRopa)).

% visitante(Nombre, Dinero, Edad, grupoFamiliar, Hambre, aburrimiento).

visitante(eusebio,3000,80,50,0).
visitante(carmela,0,80,0,25).

perteneceA(eusebio,viejitos).
perteneceA(carmela,viejitos).

visitante(joacoMartinez,5000,90,80).
visitante(edisonCavani,10000,20,10).

%%%%%%%%%%%%%%%%%%%%%%%%%%
felicidadPlena(Visitante):- 
    visitante(Visitante,_,_,0,0),
    perteneceA(Visitante,_).

podriaEstarMejor(Visitante):-
    estadoDeAnimo(Visitante,EstadoDeAnimo),
    between(1, 50, EstadoDeAnimo).

podriaEstarMejor(Visitante):-
    visitante(Visitante,_,_,0,0),
    not(perteneceA(Visitante,_)).

necesitaEntretenerse(Visitante):-
    estadoDeAnimo(Visitante,EstadoDeAnimo),
    between(51, 99, EstadoDeAnimo).

seQuiereIrACasa(Visitante):-
    estadoDeAnimo(Visitante,EstadoDeAnimo),
    EstadoDeAnimo >= 100.

estadoDeAnimo(Visitante,EstadoDeAnimo):-
    visitante(Visitante,_,_,Hambre,Aburrimiento),
    EstadoDeAnimo is Hambre + Aburrimiento.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
puedeSatisfacerHambre(Grupo,Comida):-
    comida(Comida,_),
    perteneceA(_,Grupo),
    todosPuedenComprar(Grupo,Comida),
    todosQuedanSatisfechos(Grupo,Comida).

todosPuedenComprar(Grupo,Comida):-
    forall(perteneceA(Visitante,Grupo), puedeComprar(Visitante,Comida)).

puedeComprar(Visitante,Comida):-
    visitante(Visitante,Dinero,_,_,_),
    comida(Comida,Precio),
    Dinero >= Precio.
    
todosQuedanSatisfechos(Grupo,Comida):-
    forall(perteneceA(Visitante,Grupo), quedaSatisfecho(Visitante,Comida)).

quedaSatisfecho(Visitante,hamburguesas):-
    visitante(Visitante,_,_,Hambre,_),
    Hambre < 50.
    
quedaSatisfecho(Visitante,panchito):-
    esChico(Visitante).

quedaSatisfecho(_,lomito).

quedaSatisfecho(Visitante,caramelos):-
    noPuedePagarNingunaComida(Visitante).

esChico(Visitante):-
    visitante(Visitante,_,Edad,_,_),
    Edad < 13.

noPuedePagarNingunaComida(Visitante):-
    visitante(Visitante,Dinero,_,_,_),
    forall(comida(_,Precio),Dinero < Precio).