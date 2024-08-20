% guardia(Nombre)
guardia(bennett).
guardia(mendez).
guardia(george).

% prisionero(Nombre, Crimen)
prisionero(piper, narcotrafico([metanfetaminas])).
prisionero(alex, narcotrafico([heroina])).
prisionero(alex, homicidio(george)).
prisionero(red, homicidio(rusoMafioso)).
prisionero(suzanne, robo(450000)).
prisionero(suzanne, robo(250000)).
prisionero(suzanne, robo(2500)).
prisionero(dayanara, narcotrafico([heroina, opio])).
prisionero(dayanara, narcotrafico([metanfetaminas])).

% 1) controla/2 --> Indicar si es inversible
% controla(Controlador, Controlado)

controla(piper, alex).
controla(bennett, dayanara).
controla(Guardia, Otro):-
    guardia(Guardia), % Faltaba ligar el guardia
    prisionero(Otro,_),
    not(controla(Otro, Guardia)).

% ----------------------------------------------------------------------------------

% 2) conflictoDeIntereses/2
conflictoDeIntereses(UnaPersona,OtraPersona):-
    controla(UnaPersona,Controlado),% Las primeras dos lineas ligan las variables "UnaPersona" y "OtraPersona".
    controla(OtraPersona,Controlado),
    not(controla(UnaPersona,OtraPersona)),
    not(controla(OtraPersona,UnaPersona)),
    UnaPersona \= OtraPersona.

% ----------------------------------------------------------------------------------

% 3) peligroso/1 --> Se cumple para un preso que comitio un crimen grave.

/*
 Crimenes graves:
    - Un robo nunca es grave.
    - Un homicidio siempre es grave.
    - Un delito de narcotrafico es grave si incluye 5 o mas drogas a la vez, o incluye metanfetaminas.
*/

grave(homicidio(_)).

grave(narcotrafico(Drogas)):-
    member(metanfetaminas,Drogas).

grave(narcotrafico(Drogas)):-
    length(Drogas, Cantidad),
    Cantidad >= 5.

peligroso(Prisionero):-
    prisionero(Prisionero,Crimen),
    forall(prisionero(Prisionero,Crimen),grave(Crimen)).

% ----------------------------------------------------------------------------------

% 4) ladronDeGuanteBlanco/1 --> Se cumple para un preso qie solo cometio robos y todos fueron por mas de $100.000.

monto(robo(Monto),Monto).

ladronDeGuanteBlanco(Prisionero):-
    prisionero(Prisionero,_),
    forall(prisionero(Prisionero,Crimen),(monto(Crimen,Monto),Monto > 100000)).

% ----------------------------------------------------------------------------------

% 5) Condena/2 --> Relaciona a un prisionero con la cantidad total de años de condena que debe cumplir.

/*
    - La cantidad de dinero robado dividido 10.000.
    - 7 años por cada homicidio, mas dos años si la victima era un guardia.
    - 2 años por cada droga que haya traficado
*/

pena(robo(Monto),Pena):-
    Pena is Monto/10000.

pena(homicidio(_),7). 
pena(homicidio(Persona),2):- guardia(Persona). 

pena(narcotrafico(Drogas),Pena):-
    length(Drogas,CantidadDeDrogas),
    Pena is CantidadDeDrogas*2.

comdena(Prisionero,Condena):-
    prisionero(Prisionero,_),
    findall(Pena,(prisionero(Prisionero,Crimen),pena(Crimen,Pena)),Penas),
    sumlist(Penas,Condenas).

% ----------------------------------------------------------------------------------

% 6) capo/1 --> Se dice que un preso es el capo de todos los capos cuando nadie lo controla,
% pero todas las personas de la carcel, son controlados por el, o por alquien que el controla
% (directa o indirectamente).

persona(Persona):-prisionero(Persona,_).
persona(Persona):-guardia(Persona).

capo(Capo):-
    prisionero(Capo,_),
    not(controla(_,Capo)), %No hay nadie que lo controle a el
    forall((persona(Persona),Capo \= Persona),controlaDirectaOIndirectamente(Capo,Persona)).

controlaDirectaOIndirectamente(UnaPersona,OtraPersona):-
    controla(UnaPersona,OtraPersona).

controlaDirectaOIndirectamente(UnaPersona,OtraPersona):-
    controla(UnaPersona,TerceraPersona),
    controlaDirectaOIndirectamente(TerceraPersona,OtraPersona).

% Aprender a partir en pedacitos mas pequeños.