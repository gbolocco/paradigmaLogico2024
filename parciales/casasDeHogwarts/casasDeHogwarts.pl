%mago(Nombre,Sangre,Atributos).
mago(harry,mestiza,[amistoso,corajudo,orgulloso,inteligente]).
mago(draco,pura,[inteligente,orgulloso]).
mago(hermione,impura,[inteligente,responsable,orgulloso]).

% odia(Nombre,Casa que odia)
odia(harry, slytherin).
odia(draco, hufflepuff).

%Casa

casa(gryffindor).
casa(slytherin).
casa(ravenclaw).
casa(hufflepuff).


% esImportante(Casa, CaracteristicaImportante).
esImportante(gryffindor, coraje).

esImportante(slytherin, orgullo).
esImportante(slytherin, inteligencia).

esImportante(ravenclaw, inteligencia).
esImportante(ravenclaw, responsabilidad).

esImportante(hufflepuff, amistoso).

    %%% PARTE 1 %%%
% 1:
% permiteEntrar(Casa, Mago).
permiteEntrar(Casa, Mago) :-
    casa(Casa),
    mago(Mago,_,_),
    casa \= slytherin.

permiteEntrar(slytherin, Mago) :-
    mago(Mago, pura,_).

% 2:

tieneCaracterApropiado(Casa,Mago):-
    casa(Casa),
    mago(Mago,_,Atributos),
    forall(esImportante(Casa,Caracteristica),member(Caracteristica,Atributos)).

% 3:
puedeQuedarSeleccionado(Casa,Mago):-
    tieneCaracterApropiado(Casa,Mago),
    not(odia(Mago,Casa)),
    permiteEntrar(Casa,Mago),
    Mago \= hermione.

puedeQuedarSeleccionado(gryffindor,hermione).

% 4:
cadenaDeAmistades(Magos):-
    forall(member(Mago,Magos),esAmistoso(Mago)).

esAmistoso(Mago):-
    mago(Mago,_,Atributos),
    member(amisoso,Atributos).

% -------------------parte2-------------------

% esDe(Mago, CasaEnLaQueQuedo).
esDe(hermione, gryffindor).
esDe(ron, gryffindor).
esDe(harry, gryffindor).
esDe(draco, slytherin).
esDe(luna, ravenclaw).

lugarProhibido(bosque,-50).
lugarProhibido(biblioteca,-10).
lugarProhibido(tercerPiso,-75).

malaAccion(andarFueraDeLaCama,-50).
malaAccion(visitar(Lugar),Puntos):-
    lugarProhibido(Lugar,Puntos).

% que hizo cada una
hizo(harry, andarFueraDeCama).
hizo(hermione, visitar(tercerPiso)).
hizo(hermione, visitar(seccionRestringida)).
hizo(harry, visitar(bosque)).
hizo(harry, visitar(tercerPiso)).
hizo(draco, visitar(mazmorras)).
hizo(ron, buenaAccion(ganarAjedrez, 50)).
hizo(hermione, buenaAccion(salvarAmigos, 50)).
hizo(harry, buenaAccion(ganarAVoldemort, 60)).


% 1a

esBuenAlumno(Mago):-
    hizoAlgunaAccion(Mago),
    forall(hizo(Mago,Accion),not(malaAccion(Accion,_))).

hizoAlgunaAccion(Mago):-hizo(Mago,_).

% 1b
esRecurrente(Accion):-
    hizo(Mago,Accion),
    hizo(OtroMago,Accion),
    Mago \= OtroMago.

% 4:
% responde(Pregunta, Dificultad, Profesor).
hizo(hermione, responde(dondeViveBezoar, 20, snape)).

puntosSegunAccion(responde(_, Puntos, Profesor), Puntos) :- Profesor \= snape.
puntosSegunAccion(responde(_, Dificultad, snape), Puntos) :- Puntos is Dificultad / 2.