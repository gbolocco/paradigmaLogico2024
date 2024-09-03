% esPersonaje/1 nos permite saber qué personajes tendrá el juego
esPersonaje(aang).
esPersonaje(katara).
esPersonaje(zoka).
esPersonaje(appa).
esPersonaje(momo).
esPersonaje(toph).
esPersonaje(tayLee).
esPersonaje(zuko).
esPersonaje(azula).
esPersonaje(iroh).
esPersonaje(gianlucca).
% esElementoBasico/1 nos permite conocer los elementos básicos que pueden controlar algunos personajes
esElementoBasico(fuego).
esElementoBasico(agua).
esElementoBasico(tierra).
esElementoBasico(aire).
% elementoAvanzadoDe/2 relaciona un elemento básico con otro avanzado asociado
elementoAvanzadoDe(fuego, rayo).
elementoAvanzadoDe(agua, sangre).
elementoAvanzadoDe(tierra, metal).
% controla/2 relaciona un personaje con un elemento que controla
controla(zuko, rayo).
controla(toph, metal).
controla(katara, sangre).
controla(aang, aire).
controla(aang, agua).
controla(aang, tierra).
controla(aang, fuego).
controla(azula, rayo).
controla(iroh, rayo).

controla(gianlucca,rayo).
controla(gianlucca,sangre).
controla(gianlucca,metal).
controla(gianlucca,aire).
% visito/2 relaciona un personaje con un lugar que visitó. Los lugares son
% functores que tienen la siguiente forma:
% reinoTierra(nombreDelLugar, estructura)
% nacionDelFuego(nombreDelLugar, soldadosQueLoDefienden)
% tribuAgua(puntoCardinalDondeSeUbica)
% temploAire(puntoCardinalDondeSeUbica)
visito(aang, reinoTierra(baSingSe, [muro, zonaAgraria, sectorBajo, sectorMedio])).
visito(iroh, reinoTierra(baSingSe, [muro, zonaAgraria, sectorBajo, sectorMedio])).
visito(zuko, reinoTierra(baSingSe, [muro, zonaAgraria, sectorBajo, sectorMedio])).
visito(toph, reinoTierra(fortalezaDeGralFong, [cuartel, dormitorios, enfermeria, salaDeGuerra, templo, zonaDeRecreo])).
visito(aang, nacionDelFuego(palacioReal, 1000)).
visito(katara, tribuAgua(norte)).
visito(katara, tribuAgua(sur)).
visito(aang,temploAire(norte)).
visito(aang,temploAire(sur)).
visito(aang,temploAire(este)).
visito(aang,temploAire(oeste)).

%%%%%%%%%%%%%%%%%%%%%%%%%[1]%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
esElAvatar(Personaje):-
    controlaBasicoOAvanzado(Personaje,fuego),
    controlaBasicoOAvanzado(Personaje,agua),
    controlaBasicoOAvanzado(Personaje,tierra),
    controlaBasicoOAvanzado(Personaje,aire).

controlaBasicoOAvanzado(Personaje,Elemento):-
    controla(Personaje,Elemento).
controlaBasicoOAvanzado(Personaje,Elemento):-
    controla(Personaje,ElementoAvanzado),
    elementoAvanzadoDe(Elemento,ElementoAvanzado).

%%%%%%%%%%%%%%%%%%%%%%%%%[2]%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
noEsMaestro(Personaje):-
    esPersonaje(Personaje),
    not(controla(Personaje,_)).

esMaestroPrincipiante(Personaje):-
    controla(Personaje,_),
    not(esElAvatar(Personaje)),
    forall(controla(Personaje,Elemento),not(elementoAvanzadoDe(_,Elemento))).

esMaestroAvanzado(Personaje):-esElAvatar(Personaje).
esMaestroAvanzado(Personaje):-
    controla(Personaje,Elemento),
    elementoAvanzadoDe(_,Elemento).

%%%%%%%%%%%%%%%%%%%%%%%%%[3]%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
sigueA(zuko,aang).
sigueA(Seguido,Seguidor):-
    visito(Seguido,_),
    visito(Seguidor,_),
    Seguido \= Seguidor,
    forall(visito(Seguido,Lugar),visito(Seguidor,Lugar)).

%%%%%%%%%%%%%%%%%%%%%%%%%[4]%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% esDignoDeConocer(temploAire(_)).
% esDignoDeConocer(tribuAgua(norte)).                   No se porque esta solucion no funca :(
% esDignoDeConocer(reinoTierra(_,Estructuras)):-
%     visito(_,reinoTierra(_,Estructuras)),
%     not(member(muro, Estructuras)).

esDignoDeConocer(Lugar):-
    visito(_,Lugar),
    esDigno(Lugar).

esDigno(temploAire(_)).
esDigno(tribuAgua(norte)).
esDigno(reinoTierra(_,Estructuras)):-
    not(member(muro,Estructuras)).

%%%%%%%%%%%%%%%%%%%%%%%%%[5]%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

esPopular1(Lugar):-
    visito(Personaje1,Lugar),
    visito(Personaje2,Lugar),
    visito(Personaje3,Lugar),
    visito(Personaje4,Lugar),
    visito(Personaje5,Lugar),
    Personaje1 \= Personaje2,
    Personaje2 \= Personaje3,
    Personaje3 \= Personaje4,
    Personaje4 \= Personaje5.

esPopular2(Lugar):-
    visito(_,Lugar),
    findall(Visitante,visito(Visitante,Lugar),Visitantes),
    length(Visitantes, Cantidad),
    Cantidad > 4.
    
%%%%%%%%%%%%%%%%%%%%%%%%%[6]%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
esPersonaje(bumi).
controla(bumi,tierra).
visito(bumi,reinoTierra(baSingSe, [muro, zonaAgraria, sectorBajo, sectorMedio])).

esPersonaje(suki).
visito(suki,nacionDelFuego(prisionDeMaximaSeguridad, 200)).